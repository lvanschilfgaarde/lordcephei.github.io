---
layout: page-fullwidth
title: "ASA (lm) Partial DOS"
permalink: "/tutorial/asa/lm_pdos/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
_____________________________________________________________
This tutorial demonstrates how to obtain and plot a partial density of states (DOS) using the ASA band code _lm_{: style="color: blue"}.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the _lm_{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _lm_{: style="color: green"} will refer to the location of the cloned repository. In practice, this directory can be named differently.

All instances of commands assume the starting position is (this can be checked with the _pwd_{: style="color: blue"} command)

    $ ~/your_build_directory/

With _your\_build\_directory_{: style="color: blue"} being the directory the _lm_{: style="color: blue"} repository was built in to. Note: You will require files in the repository and those of the built suite, so it is advised to build in to the same directory as the repository itself.

### _Tutorial_
_____________________________________________________________
For the purpose of the demonstration, we will use the Cr3Si6 input file generated in [this tutorial](https://lordcephei.github.io/asa_inputfile/), _ctrl.cr3si6_{: style="color: green"}.  

Placing the _ctrl.cr3si6_{: style="color: green"} file in the same directory as the _lm_{: style="color: blue"} program, we can run the command

    $ lm cr3si6 -vnsph=1 -vnit=0 --pr30,31
	$ lmdos cr3si6 -vnk=16 -vmet=1 --iactiv --pr30

The latter command will prompt you, to which you should enter

    $ 1001 -1 .3

And then hit RETURN. This will create a _dos.cr3si6_{: style="color: green"} file.  

This file can then be used with _pldos_{: style="color: blue"} and the plotting package _fplot_{: style="color: blue"} to plot the partial DOS. To do this, execute the command

    $ echo 8 7 / | pldos -fplot '-lst=1,2,3;4,5,6' dos.si 

Which creates _dosp.dat_{: style="color: green"} and a _plot.pldos_{: style="color: green"} file. The _plot.pldos_{: style="color: green"} file holds the commands that _fplot_{: style="color: blue"} requires to plot. These can be used with

    $ fplot -disp -pr10 -f plot.dos

Generating a _ps.dat_{: style="color: green"} file -- your partial DOS plotting.