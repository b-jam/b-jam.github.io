---
title: "A colophon for wattie.dev"
date: 2021-11-12T20:33:47+13:00
draft: false
---

---

### The colophon is a fancy way of saying, this is who I am and this is what I'm publishing on.

I wanted to write some stuff. And I want to do it easily.
So naturally, I needed a blog. But I'm quite picky

 - I don't want to pay at all. If I have to pay even a small amount, then its likely per GB or request. That means I should probably have a CDN in front. The only free CDN I know of is cloudflare. That means giving them my DNS. My DNS hosts other things. I'm also just cheap
 - I'd like to minimize javascript. The more I have to write, the less likely any of my words see a single GET request.

 - I need automated deployments.
 - I want to minimize ads for other software where possible.

This essentially leaves me with a static site. Static sites are great. You don't have to do dependency upgrades because CVE-69420 just came out. The threat window is much smaller than traditional websites.
No database needed. Its also simple to add a CDN in front, making them very fast and scalable.

So I need a static site generator. There are lots of javascript ones, like , [gatsby](https://www.gatsbyjs.com/), [next.js](https://nextjs.org/) and [jekyll](https://jekyllrb.com/).
None of them meet my requirements though.

I landed on [hugo](https://gohugo.io/). Its written in Go, that means its a single binary. phew. In 5 minutes I was writing this post.

### Hosting
There are a bunch of cloud services that can do object storage. AWS/GCP are pretty cheap, but not free.

I explored Catalyst Cloud, a NZ hosting provider. They currently offer $300 credit, which I expected to last long enough. Utilising local providers is also appealing.
However, their API is whitelisted, so I can't easily call it from a github actions pipeline. Not to mention my home IP uses CGNAT, and paying for a static IP defeats the purpose.

Github pages is free, so thats where I'll be hosting this. I'll also use github actions to do the deploying.

**Stay a while and listen.** 
