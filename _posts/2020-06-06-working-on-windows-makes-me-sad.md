---
layout: default
title:  "Working on Windows Makes Me Sad"
date:   2020-06-06
categories: energize
---

Troubleshooting yesterday's error, I found 
[this Github issue](https://github.com/3SpheresRoboticsProject/flask_ask_ros/issues/3). On it, a contributor 
recommended to test the connection by running ngrok without a service. I tried this, and ngrok reported a connection 
successfully established. The contributor and this [Stack Overflow answer](https://stackoverflow.com/a/49466811) then 
recommended to downgrade cryptography < 2.2.

However, downgrading cryptography < 2.2 resulted in an error, `Failed building wheel for cryptography`. I couldn't
find anything helpful for this, so I suspected that it was due to using Python 3. I then tried switching to Python 2.
I installed Python 2, but somehow `pip` and `python` commands didn't work. They just opened the Windows Store page for 
Python. Looking this up, I found 
[a relevant Stack Overflow question](https://stackoverflow.com/questions/58754860/cmd-opens-window-store-when-i-type-python). 
I followed both answers, adding Python to PATH on re-installation and removing aliases, but they still didn't work.

I felt that it wasn't worth this headache to continue using Windows. I switched to my Chromebook (that I had installed 
GalliumOS on) to get both library compatibility and PyCharm. I had not previously used it for development because its 
CPU and RAM were weaker than my Windows laptop, but I'm getting desperate. I just want things to work.

During setup, I had an issue installing cryptography, but I was successful after just 
[installing a few dependencies](https://stackoverflow.com/a/22210069).
