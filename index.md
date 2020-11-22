{% comment %} 
    The following block loops though the posts in _posts/
    to display all of them.
    Source: https://stackoverflow.com/a/43121111
{% endcomment %}
    
<ul>
    {% for post in site.posts %}
    <article>
        <h2>
            <a href="{{ post.url }}">
                {{ post.title }}
            </a>
        </h2>
        <time datetime="{{ post.date | date: '%Y-%m-%d'}}">{{ post.date | date_to_long_string }}</time>
        {{ post.content }}
    </article>
    {% endfor %}
</ul>## A Different Approach: Cookiecutter
*2020-06-04*

I didn't make any progress with Zappa in the last few days, so today I tried a different approach. I 
researched [Cookiecutter](https://cookiecutter.readthedocs.io/en/1.7.2/README.html), a CLI utility that creates projects from templates. I found 
[this flask-ask template](https://github.com/chrisvoncsefalvay/cookiecutter-flask-ask)
for Cookiecutter that should be helpful.

I switched to PyCharm on Windows and set up the project structure with the template. However, I ran 
into a problem installing certain dependencies. Installing cffi raises `IndexError: list index out of 
range`. Installing cryptography also failed. I saw that newer versions were already installed, so I 
changed the condition in `requirements.txt` from `==` to `>=`. This seemed to fix the issues.

I researched Python virtual environments. Here are articles and discussions that I read:
- [Pipenv & Virtual Environments](https://docs.python-guide.org/dev/virtualenvs/)
- [What is the difference between venv, pyvenv, pyenv, virtualenv, virtualenvwrapper, pipenv, etc?](https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe)
- [Should I use pipenv or virtualenv?](https://www.reddit.com/r/learnpython/comments/9lrcee/should_i_use_pipenv_or_virtualenv/)
- [Pipenv vs virtualenv vs conda environment](https://medium.com/@krishnaregmi/pipenv-vs-virtualenv-vs-conda-environment-3dde3f6869ed)

From my reading, it seems that there is no clear consensus on the recommended Python virtual 
environment currently. `venv` is part of the Python standard library, but it has less features than
the other options. `pipenv` is a higher level, third party tool. However, it's not as reliable. `virtualenv`is also a third party tool, but it's lower level than `pipenv`. I chose `virtualenv` because it's recommmended for beginners.

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
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzA3NDA1NDUzXX0=
-->