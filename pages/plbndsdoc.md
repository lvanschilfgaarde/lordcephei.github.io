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

### 1. _Introduction_

Energy bands provide a great deal of information, and the Questaal codes provide a lot of flexibility in generating
them.  (Drawing bands [with color weights](xx) is a particularly useful feature.

You must choose the symmetry lines yourself but [prepackaged symmetry line
files](https://lordcephei.github.io/docs/input/symfile/) are available that greatly facilitate the selection and labelling.

Three Questaal tools can make energy bands along symmetry lines you specify: **lmf**{: style="color: blue"}, **lm**{:
style="color: blue"}, and **tbe**{: style="color: blue"}. They share a common input and output format.  Bands are
written to file _bnds.ext_{: style="color: green"}.  _bnds.ext_{: style="color: green"} is not written in a friendly
format; but it is often the case that you need only a subset of the bands or to provide extra information such as data for color weights,
which **plbnds**{: style="color: blue"} can do efficiently.  
It also divides the data corresponding to different symmetry lines into panels.

**plbnds**{: style="color: blue"} may be used in one several contexts:

1. To make postscript files of bands directly, without other software.
2. To select and formatting data for use with **gnuplot**{: style="color: blue"} or other standard graphics package
3. Same as 2, but generate a script for [**fplot**{: style="color: blue"}](/docs/misc/fplot), a plotting package built into Questaaal.

Tutorials show how to draw figures with either **gnuplot**{: style="color: blue"} or **fplot**{: style="color: blue"}.

**plbnds**{: style="color: blue"} will print information about its usage by typing

    $ plbnds --h

Section 2 explains how to use **plbnds**{: style="color: blue"} by an example.

Section 3 is an operations manual.

_____________________________________________________________


### 2. _Examples_

To make this plot you will need to copy [this bands file](/assets/download/inputfiles/bnds.co) to your working directory


### 3. _plbnds manual_

**plbnds**{: style="color: blue"} will print information about its usage by typing

    $ plbnds --h

_____________________________________________________________

### 4. _Other resources_

See the documentation for [**fplot**{: style="color: blue"}](/fplot/).

