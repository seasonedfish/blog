---
layout: post
title:  "ECIS Project Setup"
date:   2020-07-10
categories: ecis
---

I had chosen to use `virtualenv` for my last Python project
because all the guides that I had found for Alexa development used it.
Since I feel more comfortable working with virtual environments now,
I felt that this was a good chance to explore a new tool that I had head about.
Called [Poetry](https://python-poetry.org/),
it offered an intuitive CLI for managing project dependencies, building,
and publishing to PyPI.
Reading Poetry's [basic usage commands](https://python-poetry.org/docs/basic-usage/),
I was amazed by its ease of use;
I installed it and used it to set up my project.

I also set up PyCharm on my freshly-installed Manjaro system.
However, I ran into a strange issue: I couldn't open .md or .rst files.
Looking up the error message, I found
[this article](https://medium.com/@julianvargkim/how-to-fix-tried-to-user-preview-panel-provider-javafx-webview-error-on-linux-manjaro-ac5b6326ee1a)
that had my exact problem.
Following its advice, I built PyCharm with a bundled JRE from the AUR,
and it worked.
