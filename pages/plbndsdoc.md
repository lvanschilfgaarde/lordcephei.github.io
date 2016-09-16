---
layout: page-fullwidth
title: "The plbnds program"
permalink: "/docs/misc/plbnds/"
header: no
---
_____________________________________________________________


### _Purpose_
{:.no_toc}

**plbnds**{: style="color: blue"} is designed to generate data to make
figures of energy bands along specified symmetry lines.

_____________________________________________________________

### _Introduction_

Energy bands provide a great deal of information, and the Questaal codes provide a lot of flexibility in generating
them.  (Drawing bands [with color weights](xx) is a particularly useful feature.

You must choose the symmetry lines yourself but [prepackaged symmetry line
files](https://lordcephei.github.io/docs/input/symfile/) are available in the package.

Three Questaal tools can make energy bands along symmetry lines you specify: **lmf**{: style="color: blue"}, **lm**{:
style="color: blue"}, and **tbe**{: style="color: blue"}. They share a common input and output format.  Bands are
written to file _bnds.ext_{: style="color: green"}.  _bnds.ext_{: style="color: green"} is not written in a friendly
format; but it is often the case that you need only a subset of the bands or to provide extra information.
Also normally you want the data divided into panels corresponding to different symmetry lines.
**plbnds**{: style="color: blue"} provides that function in a flexible way.

In addition, **plbnds**{: style="color: blue"} synchronizes with **fplot**{: style="color: blue"}, a general-purpose plotting package.
You may use **plbnds**{: style="color: blue"} in one several contexts:

1. To provide formatting and concatenating for use with a standard graphics package such as **gnuplot**{: style="color: blue"}
2. To provide input files and a script for the Questaal general plotting program, **fplot**{: style="color: blue"}
3. To make postscript files of bands directly, without other software



### _Other resources_

The source code to **ccomp**{: style="color: blue"} can be found [here](https://bitbucket.org/lmto/lm/src/e82e155d8ce7eb808a9a6dca6d8eea5f5a095bd6/startup/ccomp.c).
