---
layout: post
title:  "Towards Python 3 and More Windows Issues"
date:   2020-06-26
categories: energize
---

Since moving to Python 3 meant setting up my project again, I thought that I 
might as well give Windows a try again. Little did I know the horrors I would 
face!

The first problem, although frustrating, was not Windows' fault. Trying to
install Flask-ask in my Python 3.8 virtual environment gave me an error:
`ModuleNotFoundError: No module named 'pip.req'`. After some searching, I found
[a Stack Overflow question with my exact problem]. It turns out, this issue was
on Flask-Ask's side, and it was fixed two years ago. However, the patch was
never released to PyPi. To resolve it, I needed to install Flask-Ask from
Github.

When I installed Flask-Ask from Github, I received the message,
`error:  Microsoft Visual C++ 14.0 is required. Get it with "Build Tools for Visual  Studio"`.
I found the Build Tools [here], under All Downloads: Tools for Visual
Studio 2019. This was a 4GB download! I was quite baffled that I needed to
download something so large just to get my Python libraries working.

I installed the Build Tools for Visual Studio and tried again. This time, I
received the message,
`fatal error C1083: Cannot open include file:  'openssl/opensslv.h': No such file or directory'`.
I checked [cryptography's docs]. I found that because I'm using Windows, I
needed to set the LIB and INCLUDE environment variables.

I set the environment variables and tried again. This time, I received hundreds
of error messages that repeated
`_openssl.obj : error LNK2001:  unresolved external symbol` with slight
variations. I searched for some time, but the only relevant article or
discussion I found for this issue was [this unanswered Stack Overflow
question]. The original poster solved the problem by downgrading their Python
to 3.4. This isn't something I'm interested in trying because 3.4 is not
supported anymore, so using it would have made moving from Python 2 pointless.

The alternative would be trying to build OpenSSL from source, but at this point
I've gotten too tired of working on Windows. I really miss the smooth
installation processes of libraries for Linux; I'm not going to leave Linux
again.

  [a Stack Overflow question with my exact problem]: https://stackoverflow.com/questions/60284354/pip-installing-flask-ask-raises-modulenotfound-pip-req
  [here]: https://visualstudio.microsoft.com/downloads/#
  [cryptography's docs]: https://cryptography.io/en/latest/installation.html#building-cryptography-on-windows
  [this unanswered Stack Overflow question]: https://stackoverflow.com/questions/30159358/pip-install-cryptography-error-failed-with-exit-status-1120
