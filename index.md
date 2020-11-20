## Working on Windows Makes Me Sad
*2020-06-06*

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
GalliumOS on) to get both library compatibility and PyCharm. During setup, I had an issue installing cryptography, 
but I was successful after just [installing a few dependencies](https://stackoverflow.com/a/22210069).

## Getting Started with Ngrok
*2020-06-05*

I started working with ngrok in the last two days to set up my Alexa Skill testing. I installed ngrok using Chocolatey 
and watched a [Flask-ask + ngrok start guide](https://www.youtube.com/watch?v=eC2zi4WIFX0). I followed the guide to 
connect a basic Python script to Alexa.

However, I received the error `There was a problem with the requested skill's response` again. ngrok displayed 
`POST / 500 INTERNAL SERVER ERROR`. I'm too tired to work this out tonight; I'll take a look tomorrow.

## A Different Approach: Cookiecutter
*2020-06-04*

I didn't make any progress with Zappa in the last few days, so today I tried a different approach. I researched 
[Cookiecutter](https://cookiecutter.readthedocs.io/en/1.7.2/README.html), a CLI utility that creates projects from 
templates. I found 
[this flask-ask template](https://github.com/chrisvoncsefalvay/cookiecutter-flask-ask)
for Cookiecutter that should be helpful.

I switched to PyCharm on Windows (because I miss GUI) and set up the project structure with the template. However, I 
ran into a problem installing certain dependencies. Installing cffi raises `IndexError: list index out of range`. 
Installing cryptography also failed. I saw that newer versions were already installed, so I changed the condition in 
`requirements.txt` from `==` to `>=`. This seemed to fix the issues.

I researched Python virtual environments. Here are articles and discussions that I read:
- [Pipenv & Virtual Environments](https://docs.python-guide.org/dev/virtualenvs/)
- [What is the difference between venv, pyvenv, pyenv, virtualenv, virtualenvwrapper, pipenv, etc?](https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe)
- [Should I use pipenv or virtualenv?](https://www.reddit.com/r/learnpython/comments/9lrcee/should_i_use_pipenv_or_virtualenv/)
- [Pipenv vs virtualenv vs conda environment](https://medium.com/@krishnaregmi/pipenv-vs-virtualenv-vs-conda-environment-3dde3f6869ed)

From my reading, it seems that there is no clear consensus on the recommended Python virtual environment currently. 
`venv` is part of the Python standard library, but it has less features than the other options. `pipenv` is a higher 
level, third party tool. However, it's not as reliable. `virtualenv`is also a third party tool, but it's lower level 
than `pipenv`. I chose `virtualenv` because it's recommended for beginners.

## Zappa Setup and Confusion
*2020-05-30*

I continued the guide today. I created an IAM User for zappa-deploy on AWS, configured the 
credentials locally, deployed the Skill with Zappa, and configured the skill in the Alexa developer 
console.

Testing the skill showed an error though, `There was a problem with the requested skill's response`. 
I replaced my Python code with a simple one-line response in case it's version incompatibility, but 
it still didn't work. This is really strange because I followed the guide pretty well; the only 
exception is that I'm using Python 3 (flask-ask and Zappa currently support it).

## First Steps Again
*2020-05-29*

Today, I started following the Flask-Ask + Zappa guide. I'm using Ubuntu 18 on Windows Subsystem for 
Linux (WSL) to hopefully ease development.

I had an issue where I couldn't install virtualenv with pip. This was fixed by passing the 
`--user` argument. With this fixed, I created my virtual environment to install my dependencies, but I 
ran into another error: I couldn't install flask-ask. I received `ModuleNotFoundError: No module named 
'pip.req'`. Looking this up, I found this related issue:
[Flask-ask using Python 3.7 image](https://github.com/tiangolo/uwsgi-nginx-flask-docker/issues/133). 
I realized that the guide is written for Python 2.7; I could run into more issues later if I continue to 
use Python 3.x. However, I really don't want to use 2.7 because it's not supported anymore.

I found the solution in 
[this Stack Overflow question](https://stackoverflow.com/questions/51273969/virtutalenv-command-python-setup-py-egg-info-failed-with-error-code-1).
Downgrading pip to 9.x with `pip install --upgrade "pip<10"` fixed my issue.

## A New Hope
*2020-05-28*

Trying to figure out serverless has been fruitless in the last few weeks. I've asked Mr. Navkal and fellow Energize 
Andover members about my issue, but we haven't found any success.

Today, I researched some alternatives for deploying code. [Zappa](https://github.com/Miserlou/Zappa) is a python 
specific tool for building and deploying event-drive software on AWS Lambda. However, it's less popular than 
serverless. 
[Flask-Ask](https://flask-ask.readthedocs.io/en/latest/index.html) is a framework that makes it easier to develop 
Skills with Python. I found 
[this guide](https://developer.amazon.com/blogs/post/Tx14R0IYYGH3SKT/Flask-Ask-A-New-Python-Framework-for-Rapid-Alexa-Skills-Kit-Development) 
for getting started with it. Also, I found 
[this guide](https://developer.amazon.com/blogs/alexa/post/8e8ad73a-99e9-4c0f-a7b3-60f92287b0bf/new-alexa-tutorial-deploy-flask-ask-skills-to-aws-lambda-with-zappa) 
for using it in conjunction with Zappa.

I decided on using the Flask-Ask + Zappa guide for this project. It should spare me some headache, hopefully.

## Legacy Blog
Posts prior to May 2020 can be found on my old site, [energize-fs.weebly.com](https://energize-fs.weebly.com/).
