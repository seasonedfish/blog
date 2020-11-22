---
layout: default
title:  "First Steps Again"
date:   2020-05-29
categories: energize
---

Today, I started following the Flask-Ask + Zappa guide. I'm using Ubuntu 18 on
Windows Subsystem for Linux (WSL) to hopefully ease development.

I had an issue where I couldn't install virtualenv with pip. This was fixed by
passing the `--user` argument. With this fixed, I created my virtual
environment to install my dependencies, but I ran into another error: I
couldn't install flask-ask. I received `ModuleNotFoundError: No module named
'pip.req'`. Looking this up, I found this related issue: 
[Flask-ask using Python 3.7
image](https://github.com/tiangolo/uwsgi-nginx-flask-docker/issues/133). I
realized that the guide is written for Python 2.7; I could run into more issues
later if I continue to use Python 3.x. However, I really don't want to use 2.7
because it's not supported anymore.

I found the solution in [this Stack Overflow
question](https://stackoverflow.com/questions/51273969/virtutalenv-command-python-setup-py-egg-info-failed-with-error-code-1).
Downgrading pip to 9.x with `pip install --upgrade "pip<10"` fixed my issue.
