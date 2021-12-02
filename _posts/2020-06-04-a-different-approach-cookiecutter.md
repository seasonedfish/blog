---
layout: post
title:  "A Different Approach: Cookiecutter"
date:   2020-06-04
categories: energize
---

I didn't make any progress with Zappa in the last few days, so today I tried a
different approach. I researched [Cookiecutter], a CLI utility that creates
projects from templates. I found [this flask-ask template] for Cookiecutter
that should be helpful.

I switched to PyCharm on Windows (because I miss GUI) and set up the project
structure with the template. However, I ran into a problem installing certain
dependencies. Installing cffi raises `IndexError: list index out of range`.
Installing cryptography also failed. I saw that newer versions were already
installed, so I changed the condition in `requirements.txt` from `==` to `>=`.
This seemed to fix the issues.

I also researched Python virtual environments. Here are articles and
discussions that I read:
- [Pipenv & Virtual Environments]
- [What is the difference between venv, pyvenv, pyenv, virtualenv, virtualenvwrapper, pipenv, etc?]
- [Should I use pipenv or virtualenv?]
- [Pipenv vs virtualenv vs conda environment]

From my reading, it seems that there is no clear consensus on the recommended
Python virtual environment currently. `venv` is part of the Python standard
library, but it has less features than the other options. `pipenv` is a higher
level, third party tool. However, it's not as reliable. `virtualenv`is also a
third party tool, but it's lower level than `pipenv`. I chose `virtualenv`
because it's recommended for beginners.

  [Cookiecutter]: https://cookiecutter.readthedocs.io/en/1.7.2/README.html
  [this flask-ask template]: https://github.com/chrisvoncsefalvay/cookiecutter-flask-ask
  [Pipenv & Virtual Environments]: https://docs.python-guide.org/dev/virtualenvs/
  [What is the difference between venv, pyvenv, pyenv, virtualenv, virtualenvwrapper, pipenv, etc?]: https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe
  [Should I use pipenv or virtualenv?]: https://www.reddit.com/r/learnpython/comments/9lrcee/should_i_use_pipenv_or_virtualenv/
  [Pipenv vs virtualenv vs conda environment]: https://medium.com/@krishnaregmi/pipenv-vs-virtualenv-vs-conda-environment-3dde3f6869ed
