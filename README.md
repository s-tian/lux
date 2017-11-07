# lux

Lux is a work in progress tail-recursive raytracer written in Scheme.

We started with a naive ray tracing implementation. Running the initial version of the program through a Python3 scheme interpreter, we rendered a 20x20 image of the Cornell box using 4 samples/pixel in around five minutes:

![20x20 Cornell box](doc/images/20x20v1.png)

This is a 200x200 image of the same scene at 4 samples/pixel, rendered in ~7-8 hours:

![200x200 Cornell box](doc/images/200x200.png)

It became apparent that rendering images at higher resolutions with less noise would take far too long. After exploring a few optimization options, we found that [PyPy](https://pypy.org) could run the Python interpreter at far greater efficiency. Using PyPy3, this 100x100 image of the Cornell box at 10 samples/pixel took around 25 minutes to render:

![100x100 Cornell box](doc/images/100x100pypy.png)
