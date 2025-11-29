---
title: "Copy on Write"
date: 2025-10-27T14:48:14+13:00
draft: false
tags: ["storage", "optimisation", "filesystem", "concurrency", "copy on write"]
---

---
When I first encountered ZFS it felt like black magic with its instant snapshots AND self healing checksums. I was told it's all thanks to **Copy-on-Write (CoW)**. Years later, I'm writing this post to explain this strategy, as it's one of my favorite optimisation techniques. By the end, you'll see how CoW is more than just a trick; it's the fundamental design choice that solves some of the trickiest problems in performance, concurrency, memory usage, and data integrity, all while keeping things blazing fast.

<!--more-->

To truly understand Copy on Write, I'm going to use a different example than the traditional `fork`+`exec`. Lets look at the dark side of mutability.

### Naive Bank Account Analogy
Imagine a simple, naive bank account that stores the balance in a single, updatable field: `balance`. No over drafts.

Whenever you need to make a withdrawal, you will need to check if the balance is sufficient, then subtract it.
A withdrawal function might look something like:
```
Class Bank():
    ...
    def withdraw(self, account, withdrawal):
        if self.balance[account] >= withdrawal:
            self.balance[account] -= withdrawal
            return True
        return False
```
#### What are the downsides of this simple implementation?

- This works for a single-threaded app, but it's not thread safe. A race condition can occur where the balance changes after the initial `if self.balance[account] >= withdrawal:` check but before the `-=`, potentially allowing an overdraft and corrupting the state. To fix this, you'd need locks, leading on to the next problem.
- We'd need to lock the accounts balance for the entire function. If we go further and consider a transfer operation from one account to another, we'd need a lock on both accounts. We'd also need to carefully order the lock acquisition to avoid deadlocks.

- If the process or power crashed while overwriting the value you can end up with a permanently corrupted balance.
- Theres also no audit/history by default, so you need to implement that seperately.
- A process updating multiple different accounts will be doing "Random Access Writes". Disk writes prefer to be sequential, *especially* if it's a spinning HDD

### Copy on Write Bank Account

Lets implement the bank account with an analogy to how Copy on Write works.

```
#( amount, type, version, previous_id, post_balance) - immutable data block
TransactionEvent = (...)

...
Class Bank():
    ...
    def withdraw(self, account, withdrawal):
        # 1. READ: get the pointer to the latest state
        current_tx_tuple, currrent_tx_id = self.get_latest_event(account)
        current_version = current_tx_tuple[2]
        current_balance = current_tx_tuple[4]

        if current_balance < withdrawal:
                return False

        # 2. COPY: calculate the new immutable block
        new_event: TransactionEvent = (
            -withdrawal,
            "WITHDRAW",
            current_version + 1,
            current_tx_id,
            current_balance - money
        )
        new_tx_id = f"{account}_{new_version}_{uuid.uuid4().hex[:6]}"

        # 3. WRITE/COMMIT: atomic phase. Often a Compare-and-Swap primitive can happen here instead.
        with self.account_locks[account]:
            if self.accounts[account] == old_tx_id:
                self.history[new_tx_id] = new_event
                self.accounts[account] = new_tx_id
                return True

        #.. otherwise the version was different so we retry (optimistic locks)
```
Notice the shift: we're not updating the balance in place. Instead, we calculate a new, immutable state based on the old state and commit that new state. The `self.accounts[account]` value is simply a pointer to the very latest transaction block. This achieves several benefits.

Instead of directly updating values, we treat the previous data as immutable, copy it, and write the difference we've made.
- The writing of the data is done as a single atomic operation that updates the root pointer. The transaction either completes entirely or fails and retries.
- This has much better data integrity, if a crash happens we just reboot and follow the original correct pointer.
- We get full audit history and verify data integrity by default.
- Writes to disk are also "Sequential Writes" since every new line will just be added after the previous line in the log structure. These are significantly faster than random writes on physical storage.
- we only briefly lock the single state pointer when commiting a new version, leading to higher scalability with minimal locking bottlenecks.

So what are the downsides? The CoW-like approach fundamentally uses a lot more storage space than in-place overwrites because it preserves old data. In a true CoW file system like ZFS, the storage space concern is mitigated because the system reclaims the original blocks once no snapshots or other references point to them. However, in our simple bank ledger, those old versions are kept forever for auditing.

You can also see to sum the balance to verify the entire history, it will be O(N). We stored the balance as part of the immutable data block to mitigate this, but we will likely still want periodic checks to make sure it balances.


### Memory Maps

The bank analogy is used as a learning tool, but the model above is done purely in memory, which is not durable and vulnerable to the process crashing.
In production storage systems like LMDB or bbolt, Copy-on-Write is the key to both durability and performance.
These systems often use memory-mapped files (mmap). Reading and writing small sections of a file to disk constantly would be expensive. Intead the file is mapped directly into the process's virtual memory. This uses some neat OS tricks like page faults for reading and dirty pages for writing.

The core of CoW in these databases revolves around the Root Pointer.
1. READ: Follow the root pointer to the latest B-Tree structure.
2. COPY: When you change a value, you don't modify the existing B-Tree node (or data block). Instead, you copy the modified page(s) to a new, unused location in the memory-mapped file.
3. WRITE: The change only becomes permanent when the database atomically updates the Root Pointer to reference the new B-Tree structure. This is often a single, atomic write operation to the disk. The operation here could be a mmap `flush` to rewrite a dirty page back to disk.

If the power dies before the pointer is updated, the system simply reboots and follows the original, correct root pointer, and the new, incomplete pages are treated as garbage guaranteeing consistency without needing a journal or a crash recovery step. This is the magic of CoW.

### Real Uses
Container images are one. Hopefully we're familiar with dockerfile layers by now. Each of those is CoW. It makes our builds, pulls and container processes efficient, as long as we've engineered the layer order nicely.

Process creation. `fork` creating a new process is CoW. `exec` after fork changes the whole program space, which cuts out most of the stuff that would have needed to be copied making it lightning fast.

ZFS has instant snapshotting and first class checksumming and healing. Thanks to transactional writes.

Databases (LMDB, bbolt). These are blazing fast read-optimised KV stores. They use CoW and memory mapping to achieve high performance and consitency with minimal locking overhead.

Distributed systems (etcd). The bbolt KV store is the foundation for etcd, which provides the consitent, distributed configuration that is the heart of Kubernetes.