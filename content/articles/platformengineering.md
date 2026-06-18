---
title: "Now that we no longer need devops we can agree on what it means."
date: 2026-06-18T00:00:00+12:00
draft: false
tags: ["platform engineering", "devops", "developer experience", "infrastructure", "internal developer platform"]
---

---
The best time to define DevOps was 2015. The second best time is now that we can move on.
<!--more-->

### My first job.

For the first 3 years of my career I was the god sysadmin. I built 15 django websites and was the sole owner of a single server, which ran all of these alongside nginx, postgres, redis, uwsgi, celery worker, a queue, and various cron jobs.

This was ops. I was the system administrator who had god mode access to everything, said no a lot, but if prod was down, I got a call. It was broken, I would fix it. I’d do some feature work before it broke again, and then I’d fix it again. My job security was being the person who knew everything.

This gave me the ability to drive manual if I ever need to, which is an important skill.. sometimes. But Kelsey Hightower said it best when he said that ops leads to 20 years of 1 year experience, and you are just getting better at broken processes.

I reached a ceiling and moved into a DevOps role.


### My first devops job.
So devops was like, the attempt to define these broken processes as something tangible and versioned.

Terraform, HCL, Yaml pipelines, Containers. These are all things we can define and reason about which was a huge improvement.

I had no idea of any of the above in 2015, and I just shoved containers, terraform, docker swarm, packer, ansible, haproxy and ALL the yaml at anything that needed it. Kubernetes wasn't even around yet.

I wouldn't recommend ansible or docker/swarm today, but a lot of the other stuff has stood the test of time, and is completley sufficient for businesses of a small to moderate size.

Remember how much I could run on a single server? With a good system architecture, you can do an incredible amount with a small handful of servers.

### So whats the issue with devops
Companies that scaled up past a moderate size, and ended up with their own set of devops tools to manage their teams own microservices.

And I did that too. Each team did that. Every engineering team reached for the same tools, built the same abstractions, and wired it up with a slightly different API.

The knowledge scaled within teams, but not across them.

### Platform engineering

Platform engineering is about asking: can we, as a company, do that devops thing but just once?

When I joined large tech companies, I finally learned what platform engineering is.

I'd never needed it before but I needed it now.

HCL isn't a good enough API to solve devops at scale. Neither is yaml.

Platform engineering is about building a better API with those tools underneath. What does that API look like?

If I were onboarding your application onto my platform, I'd ask you: wheres your container, what version, what CPU and memory, and what are your scaling requirements? Is that all I'd ask? Yeah, probably.

So that's all platform engineering should expose - an API to leverage your DevOps improvements across an entire company, rather than having each team reinvent it.

Behind that, you can run kubernetes and all your infra. But your dev teams will love it because they don't have to care about any of it.

### When Does This Make Sense?
Just a closing note - if you're not seeing the issue with devops unfold yet, your company isn't large enough to care about platform engineering yet, so focus on getting to that size first.

Otherwise, if you are large enough, stop solving slightly different problems with the same tools and a linearly increasing number of engineers.
