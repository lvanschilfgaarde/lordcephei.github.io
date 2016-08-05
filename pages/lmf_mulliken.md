---
layout: page-fullwidth
title: "Full Potential (lmf) Mulliken Analysis"
permalink: "/lmf_mulliken/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This tutorial demonstrates how to perform mulliken analysis using the full potential band code _lmf_{: style="color: blue"}.

### _Preliminaries_
_____________________________________________________________
This tutorial assumes you have cloned and built the _lm_{: style="color: blue"} repository (located [here](https://bitbucket.org/lmto/lm)). For the purpose of demonstration, _lm_{: style="color: green"} will refer to the location of the cloned repository. In practice, this directory can be named differently.

All instances of commands assume the starting position is (this can be checked with the _pwd_{: style="color: blue"} command)

    $ ~/your_build_directory/

With _your\_build\_directory_{: style="color: blue"} being the directory the _lm_{: style="color: blue"} repository was built in to. Note: You will require files in the repository and those of the built suite, so it is advised to build in to the same directory as the repository itself.

It is advised that you read the Partial DOS tutorial for the _lmf_{: style="color: blue"} code located [here](/lmf_pdos/), as these tutorials are similar in both commands and results.

### _Tutorial_
_____________________________________________________________
Performing a Mulliken analysis using the _lmf_{: style="color: blue"} code is exemplified in three test cases

    fp/test/test.fp fe 2
	fp/test/test.fp cr3si6 2
	fp/test/test.fp gdn 2

Should you want a more in depth look, or a practical example, these are good places to start. You will find that the primary difference between this process and that of a standard partial DOS (see the tutorial linked in the 'Preliminaries' section) is the use of the 

    --mull

switch. 

An input file is needed for the material of which the partial DOS should be found. A tutorial detailing the steps required to generate a basic input file can be found [here](https://lordcephei.github.io/asa_inputfile/). While this tutorial concerns itself with Cr3Si6, the steps involved are applicable to most other materials.   

In this tutorial we will use the material Iron, Fe, and thus base our tutorial around the _fe 2_ test case. Our input file, created previously, will be referred to as _ctrl.fe_{: style="color: green"} and should be named as such.

We begin by running _lmfa_{: style="color: blue"} progam which needs to be run before any _lmf_{: style="color: blue"} process in order to generate the free-atom densities which, in our case, is generated in to the file _atm.fe_{: style="color: green"} with the command

    $ lmfa fe

We can now proceed with our first _lmf_{: style="color: blue"} command

    $ lmf --rs=0 --cls:1,1,2 --mull:mode=2 -vnk=6 -vnit=1 fe

Which will generate a variety of files needed to build our weights file for Mulliken analysis. Note, this command will generate a _dos.fe_{: style="color: green"} file. This file is _not_ our partial density of states but rather the full density of states file, the next command will overwrite this file.

We then run

    $ lmdos --nosym --mull:mode=2 --dos:npts=1001:window=-.7,.8 -vnk=6 fe

Which makes use of the previously generated files and generates the _dos.fe_{: style="color: green"} file which contains our Mulliken DOS. This can be plotted with your preferred plotting tool, although some manipulation of the data in the file may be required.   

A plotting tool is included in the suite, _fplot_{: style="color: blue"}, which can be used to generate a postscript file. We must first prepare the _dos.fe_{: style="color: green"} file with another program in the suite, _pldos_{: style="color: blue"}, with the command

    $ echo 20 10 -0.7 .8 | pldos -fplot -lst="1:7:2,19:31:2;9,11,15;13,17" -lst2 dos.fe

Which generates a _plot.dos_{: style="color: green"} file readable by _fplot_{: style="color: blue"}. We follow this with an _fplot_{: style="color: blue"} command

    $ fplot -disp -pr10 -f plot.dos

Which should result in a viewable image of the partial DOS.