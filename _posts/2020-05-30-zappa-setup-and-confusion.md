---
layout: post
title:  "Zappa Setup and Confusion"
date:   2020-05-30
categories: energize
---

I continued the guide today. I created an IAM User for zappa-deploy on AWS,
configured the credentials locally, deployed the Skill with Zappa, and
configured the skill in the Alexa developer console.

Testing the skill showed an error though,
`There was a problem with the requested skill's response`. I replaced my Python
code with a simple one-line response in case the problem is version
incompatibility, but I still received the same error. This is really strange
because I followed the guide pretty well; the only exception is that I'm using
Python 3 (flask-ask and Zappa currently support it).
