---
title: "Rust Game Development"
date: 2022-01-08T12:26:04+13:00
draft: false
---

## Last year I started creating a fairly large game in Rust. ##
My background is in mostly python devops and so nearly every part of it needs careful planning.
The parts that weren't nearly all needed rewriting.
I'm learning common game dev patterns as well as nuances in Rust and I want to document it.
It's not open source at the moment.

### Why Rust? ###

One word, Elegance.
There is no garbage collection in Rust, but you can still work with the heap in a safe way. Concurrency becomes much more deterministic as a result of the move/borrow rules.
This concurrency allows breakneck speeds in many different use cases. I also find the syntax very satisfying.

There are many practical reasons not to use Rust. My productivity is slower, there are less open source examples and the engines are rapidly morphing.
None of this matters to me since it's a personal project. No one except myself is going to demand any deadlines or features.

### What tools am I using? ###

- I bought a tileset for $5, but ideally later I'll use [Aseprite](https://www.aseprite.org/) to create my own.
- [LDTK](https://ldtk.io/) is an incredible free level editor for 2d games.
- [Bevy](https://github.com/bevyengine/bevy) is my engine. It's an ECS. Some parts are still in development, but performance is through the roof. Running my game, all CPU cores are used almost equally. Bevy can ruthlessly optimise this because of Rust memory safety.
- [Rapier](https://rapier.rs/) for collision detection, bringing back elements of my math major.

### Learnings & Problems I've faced ###

Programming in an ECS is very fun. It's queries feel very familiar coming from a web background.

Tileset creation was a big one. I didn't even know level editors were a thing.
LDTK was a huge help to create maps visually. Its data format was wrong for what I needed.
I created a pipeline to convert it into game entities and assets, which was an ordeal.
What made the pipeline difficult was not just being able to iterate and chuck things in a mutable dict as I go. Instead it felt a lot like java. If theres interest, I can open source this LDTK->Bevy entities in a seperate crate.

Collision detection was largely solved by using Rapier, but it needed a fair amount of reading to understand how it works.
Using it in a 3d game requires using quaternions to represent rotations in 4d. I highly reccomend [this video](https://www.youtube.com/watch?v=d4EgbgTm0Bg) to understand quaternions, the stereographic projections in 3d blew my mind.

Another one is just general project structure and design patterns for game dev.
[Game programming patterns](https://gameprogrammingpatterns.com/) has helped in certain aspects, but it's aimed at OO rather than ECS.
I'm getting better at this after a fair amount of refactoring!

I hope to post more significant problems as I go, to help others who might have the same problems.
#### This is by far the most fun I've had in my entire career. It's also made me a better developer in general. I won't be finished any time soon though. So if you want to help, get in touch