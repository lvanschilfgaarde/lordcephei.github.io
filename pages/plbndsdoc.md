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

### _Preliminaries_

The input file structure is briefly described in [this lmf tutorial for Pbte](https://lordcephei.github.io/lmf_tutorial/), which you may wish to go through first.

Executables **plbnds**{: style="color: blue"} and **fplot**{: style="color: blue"}, are required and are assumed to be in your path. 
You will also need a postscript viewer.  This document assumes you are using the apple-style **open**{: style="color: blue"} command to view postscript files.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}


### 1. _Introduction_

Energy bands provide a great deal of information, and the Questaal codes provide a fair amount of flexibility in generating
them.  Drawing bands with color weights is a particularly useful feature,
as shown in Section 2

You must choose the symmetry lines yourself but [prepackaged symmetry line
files](https://lordcephei.github.io/docs/input/symfile/) are available that greatly facilitate the selection and labelling.

Three Questaal tools can make energy bands along symmetry lines you specify: **lmf**{: style="color: blue"}, **lm**{:
style="color: blue"}, and **tbe**{: style="color: blue"}. They share a common input and output format.  Bands are
written to file _bnds.ext_{: style="color: green"}.  _bnds.ext_{: style="color: green"} is not written in a friendly
format; but it is often the case that you need only a subset of the bands or to provide extra information such as data for color weights,
which **plbnds**{: style="color: blue"} can do efficiently.
Data for each symmetry line is kept in a separate file.

**plbnds**{: style="color: blue"} may be used in one several contexts:

1. To make postscript files of bands directly, without other software.  Very quick but there is no easy way to modify the figure.
2. To select and formatting data for use with **gnuplot**{: style="color: blue"} or other standard graphics package
3. Same as 2, but generate a script for [**fplot**{: style="color: blue"}](/docs/misc/fplot), a plotting package built into Questaaal.

**plbnds**{: style="color: blue"} and **fplot**{: style="color: blue"} write postscript files to _fplot.ps_{: style="color: green"}.

Tutorials show how to draw figures with either **gnuplot**{: style="color: blue"} or **fplot**{: style="color: blue"}.

**plbnds**{: style="color: blue"} will print information about its usage by typing

    $ plbnds --h

Section 2 gives you an intuitive feel of how **plbnds**{: style="color: blue"} works by using an example: the energy bands of Co.

Section 3 is an operations manual.

_____________________________________________________________


### 2. _Examples_

Copy [this bands file](/assets/download/inputfiles/bnds.co) to your working directory.
It contains energy bands for Co joining the symmetry lines M, &Gamma;, A, L, &Gamma;, K.
Bands were computed in the LDA with spin-orbit coupling, so both spin-up and spin-down bands are present.

The first line of the file

    36  -0.02136     2  col= 5:9,14:18  col2= 23:27,32:36

contains essential information about the file contents.  It says that:

+ the file contains 36 bands
+ The Fermi level is -0.02136 Ry
+ The file contains two sets of color weights

The strings following with **col=** are not needed; they are there for record-keeping.

Enter the following to make and view the postscript file:

    $ echo -0.8,0.6,10,15 | plbnds -lbl=M,G,A,L,G,K bnds.co
    $ open fplot.ps

Note the following:

+ The energy bands are plotted in an energy window `-0.8,0.6` Ry, in 5 panels
+ Arguments `10,15` specify the width and height of the entire figure (approximately in cm).
+ The symmetry labels M, &Gamma;, A, L, &Gamma;, K, were extracted from `-lbl=M,G,A,L,G,K`.
  **plbnds**{: style="color: blue"} maps G into &Gamma;.
+ Energy bands are in Ry
+ The Fermi level is drawn as a dashed line at -0.02136 Ry
+ Bands are plotted as dots at the points where they are generated
+ It is easy to distinguish the dense tangle of flat _d_ bands approximately between -0.3 and +0.1.  
  The _sp_ bands are highly dispersive and approximately quadratic; see particularly below -0.4 and above +0.1

Run **plbnds**{: style="color: blue"} again with:

    $ echo -10,8 / | plbnds -fplot -ef=0 -scl=13.6 -nocol -lbl=M,G,A,L,G,K bnds.co

<div onclick="elm = document.getElementById('plbndsstdout'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click to show plbnds output</div>
{::nomarkdown}<div style="display:none;padding:25px;" id="plbndsstdout">{:/} 

~~~
 plbnds : bands file contains two sets of color weights
 plbnds: 36 bands  fermi=-0.02136  scaled by 13.6  shifted to 0
 panel 1  nq=25  ebot=-9.232224  etop=33.866176  delta q=0.577353
 panel 2  nq=21  ebot=-9.232224  etop=33.235136  delta q=0.30619
 panel 3  nq=41  ebot=-7.005904  etop=29.214976  delta q=0.57735
 panel 4  nq=45  ebot=-9.232224  etop=33.503056  delta q=0.653518
 panel 5  nq=41  ebot=-9.232224  etop=33.603696  delta q=0.666665
 nq=173  npan=5  emin=-9.232224  ef=0  emax=33.866176  sum dq=2.781075
 emin, emax, width(cm), height(cm) ?
 write file bnd1.dat, bands 1 - 26
 write file bnd2.dat, bands 1 - 26
 write file bnd3.dat, bands 1 - 26
 write file bnd4.dat, bands 1 - 26
 write file bnd5.dat, bands 1 - 26
  ... to plot, invoke:
  fplot -disp -f plot.plbnds
~~~

{::nomarkdown}</div>{:/}


+ `-fplot` tells **plbnds**{: style="color: blue"} to prepare data files (_bnd[1-5].dat_{: style="color: green"}) and a script for the [fplot](/docs/misc/fplot) tool.
+ An fplot script was generated, _plot.plbnds_{: style="color: green"}.  The arguments in the script are documented in the [fplot manual](/docs/misc/fplot).
+ The energy window is now `-10,8` eV. The last two arguments (formerly `10,15`) are not used with **fplot**{: style="color: blue"}
+ Data files are written in a standard Questaal format, which is easily read by other packages.  
  The first column is a fractional distance along the symmetry line (0 for starting point, 1 for ending point).  
  Remaining columns (about 26) comprise all energy bands in the window (-10,8) eV.  
  Data was scaled from Ry to eV (`-scl=13.6`) and the Fermi level shifted to 0 (`-ef=0`).
+ `-nocol` tells **plbnds**{: style="color: blue"} to ignore information about color weights.

Make and view a postscript file with

    $ fplot -f plot.plbnds
    $ open fplot.ps 

The figure is much closer to publication quality.  You can of course customize _plot.plbnds_{: style="color: green"}.

The last example uses the color weights to distinguish spin-up and spin-down bands.
_bnds.co_{: style="color: green"} was generated from one of the validation scripts in the Questaal source directory.
Assuming your source directory is **~/lm**), you can make _bnds.co_{: style="color: green"} yourself with this script

    $ ~/lm/fp/test/test.fp co 1

The first color selects out the the majority _d_ bands; the second the minority _d_ bands.


Run plbnds without `-nocol` but adding a line type 

    $ echo -10,8 / | plbnds -fplot -ef=0 -scl=13.6 -lt=1,bold=3,col=0,0,0,colw=.7,0,0,colw2=0,.7,0 -lbl=M,G,A,L,G,K bnds.co
    $ fplot -f plot.plbnds
    $ open fplot.ps 

The line type specifes the line thickness `(bold=3)`; the color of the background (`col=0,0,0`) --- i.e. the color in
the absence of projection from the first and second weights; colors of the first and second weights (`colw=.7,0,0` and `colw2=0,.7,0`).
The three numbers correspond to fractions of (red, green, blue).

The figure shows clearly which bands have majority and minority  _d_ character.  Note that the highly dispersive band between &Gamma; and A, in the window (-2,0) eV, is black.

### 3. _plbnds manual_

**plbnds**{: style="color: blue"} will print information about its usage by typing

    $ plbnds --h

_____________________________________________________________

### 4. _Other resources_

See the documentation for [fplot](/plbnds/) and [pldos](/pldos/).

