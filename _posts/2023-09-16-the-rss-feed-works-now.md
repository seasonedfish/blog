---
layout: post
title:  "The RSS Feed Works Now"
date:   2023-09-16
---

Last month, I was showing my friend the RSS feature of this website,
only to realize none of the links worked when I imported the feed into a reader.

I finally got around to looking into it today.
After reading the jekyll-feed readme,
I realized I'd forgotten to add `url` to my `_config.yml`.

![A screenshot of the jekyll-feed readme, showing the `url` key](assets/img/jekyll-feed-url.png)

After the simple fix, it works. Go ahead, [give it a try](feed.xml)!

(If you don't know about RSS, [Lifewire has a good guide](https://www.lifewire.com/what-is-an-rss-feed-4684568) explaining what it is and how to get started.)

Sigh, I can't believe I didn't notice it was broken for [two years](https://github.com/seasonedfish/blog/commit/4c13dd00627d746168759d6db33256c517158157#diff-ecec67b0e1d7e17a83587c6d27b6baaaa133f42482b07bd3685c77f34b62d883).
