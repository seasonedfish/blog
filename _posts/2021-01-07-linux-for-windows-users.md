---
layout: default
title:  "Linux for Windows Users"
date:   2021-01-07
categories: energize
---

In the past month,
I invited a few computer science students to join the Energize Andover club.
Most of them used Windows.
Remembering how frustrating development had been for me on Windows,
I shuddered at the thought of returning to that hell with them
if I were to guide them through working with pandas.

I needed to find a way for them to access a Linux environment on Windows.
I had used (and currently use) Windows Subsystem for Linux,
and it works quite well.
However, the installation process is fairly time-consuming,
and installing an entire distribution (about 2G of disk space) seemed like overkill
for students who were unsure about joining.

I then remembered that my trial AWS EC2 server is still running,
and Windows has the OpenSSH Client installed by default.
I created an "energize" user on the server,
and I modified the server's configuration to allow password login for that user[^1].
Students could now access a Linux environment by simply running a command in Command Prompt—
no installation required.

This was quite convenient,
and there were also some added bonuses.
They would have quick access to any dev tools I install
because they wouldn't need to also go through the installation processes themselves.
And, any issues that come up should be easier to investigate
because I can access the exact files or software in which they occur.

However, on the first meeting that we tried using the server,
we came across two big problems.
First, everything was very slow.
Resolving the dependencies of a Python project using Poetry,
a process that took under 30 seconds locally,
took over 8 minutes on the server.
Even connecting to the server and sending commands seemed slow.
Second, installing pandas didn't even work.
The server had Python 3.6.9 running;
this was supposed to be supported.
But, trying to install pandas in a virtual environment failed due to version incompatibilities.

To solve the first problem, I viewed the server's running processes.
I found that I had left some services running from when I was trying out EC2 for the first time,
so I stopped them and uninstalled them.
This made the server much faster.

To fix the second problem, I tried installing [pyenv](https://github.com/pyenv/pyenv).
This is a tool that Dan recommended me;
it helps install and switch between multiple Python versions.
I read [this article](https://realpython.com/intro-to-pyenv/)
to refresh my knowledge on pyenv and its commands.
Then, I used pyenv to install the latest version of Python (3.9.1).
Installing pandas in Python 3.9.1 worked!

To switch from the system Python to Python 3.9.1, I can use:
```bash
pyenv shell 3.9.1
```
This will only change my shell's Python;
other people logged in are not affected.
Now I can create a project in 3.9.1 (named demo1 in this example) using Poetry:
```bash
poetry new demo1
cd demo1
poetry add pandas
poetry install
```
To switch back to the system Python, I can use:
```bash
pyenv shell --unset
```

With the performance and compatibility problems taken care of,
the server is ready for our new members to try pandas!

[^1]: I realize that passwords are much less secure than keys, but I don't understand keys well enough right now to explain how they work or how to add one to a server. For now, I've made the password strong, but I'll definitely learn more about SSH keys in the future.
