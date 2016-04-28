---
layout: page-fullwidth
title: "LM Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/lmtut/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />
# Basic introduction to full-potential program lmf 

This tutorial carries out a band structure calculation for silicon. The goal is to provide a simple introduction to the input and output files and the basics of running the code. It is assumed that you have installed the executables and that they are in your path (see installing tutorial for more). The starting point is a structure file called "init.si". The init file contains basic structural information in a format that is recognised by the Questaal program (it is analogous to the POSCAR file in VASP). You can convert other standard structure files into an init file using conversion tools that are supplied as part of the suite of programs. See the /path/ page for more information on file conversion and an example of how to create a structure file manually. Below is a complete list of the commands that will be carried out.

<hr style="height:5pt; visibility:hidden;" />
### Command summary     

    $mkdir si       #test
    $cd si
    $cp path/init.si .
    $blm init.si --express
    $cp actrl.si ctrl.si
    $blm init.si --express
    $cp actrl.si ctrl.si
    $lmfa ctrl.si
    $vi ctrl.si
    $cp basp0.si basp.si
    $lmf ctrl.si
    $vi ctrl.si
    $lmf ctrl.si > out.lmfsc

<hr style="height:5pt; visibility:hidden;" />
### Tutorial summary
Brief summary of overall tutorial, to be used as recap or for very quick and basic tutorial. 

<hr style="height:5pt; visibility:hidden;" />
### Main tutorial

To get started, create a new working directory, called "si" for example, and move into it. Then copy the silicon init file "init.si" from path/ into your working directory.

    $mkdir si       #test
    $cd si
    $cp path/init.si 

Take a look at the init file using a text editor (e.g. vi) and you will see it contains only the basic structural information. The first part is the "LATTICE" section which provides the lattice constant and primitive lattice vectors. The lattice constant is displayed after the "ALAT" label and "UNITS=A" specficies that the lattice constant is in Angstroms. The primitive lattice vectors are shown after the "PLAT" variable and are in row format (i.e. the first row contains the x, y and z components of the first lattice vector and so forth). Note that the lattice vectors are given in multiples of the lattice constant. In the "SITE" section, the atom type and coordinates are shown. The "X=" label specifices that the coordinates are in fractional (or direct) representation. It is also possible to use cartesian coordinates and in this case the "X=" label would be replaced by "POS=" (an equivalent structure in cartesian format can be found at /path/).



