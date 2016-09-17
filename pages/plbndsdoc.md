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
files](https://lordcephei.github.io/docs/input/symfile/) are available that greatly facilitate the selection and labelling.

Three Questaal tools can make energy bands along symmetry lines you specify: **lmf**{: style="color: blue"}, **lm**{:
style="color: blue"}, and **tbe**{: style="color: blue"}. They share a common input and output format.  Bands are
written to file _bnds.ext_{: style="color: green"}.  _bnds.ext_{: style="color: green"} is not written in a friendly
format; but it is often the case that you need only a subset of the bands or to provide extra information.
Also normally you want the data divided into panels corresponding to different symmetry lines.
**plbnds**{: style="color: blue"} provides that function in a flexible way.

**plbnds**{: style="color: blue"} may be used in one several contexts:

1. To make postscript files of bands directly, without other software.
2. To select and formatting data for use with **gnuplot**{: style="color: blue"} or other standard graphics package
3. To format data and provide a script for [**fplot**{: style="color: blue"}](fplot/), a plotting package built into Questaaal.

Tutorials show how to draw figures with either **gnuplot**{: style="color: blue"} or **fplot**{: style="color: blue"}.

### _Other resources_

See the documentation for [**fplot**{: style="color: blue"}](/fplot/).

