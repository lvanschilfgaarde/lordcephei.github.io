---
layout: page-fullwidth
title: "Functionalities Of The Suite By Physical Application"
permalink: "/functionality/application/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
_____________________________________________________________
This page serves as a list of the capabilities of the suite sorted by physical application. A detailed explanation of the capabilities of each package within the suite can be found on the [package page](https://lordcephei.github.io/codefunc/).

### _Physical Applications_
_____________________________________________________________

##### _Drawing Energy Bands_
Energy bands can be drawn with the _lmf_{: style="color: blue"}, _lm_{: style="color: blue"}, _tbe_{: style="color: blue"}, _lmgf_{: style="color: blue"} and _lumpy_{: style="color: blue"} codes.   

<div onclick="elm = document.getElementById('lmf_energybands'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show/hide lmf instructions.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="lmf_energybands">{:/}
	
The _lmf_{: style="color: blue"} code can generate energy bands as shown in the test

    $ fp/test/test.fp co

And an accompanying tutorial can be found [here](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/generating-energy-bands.html) [Please note, this is an old-style tutorial and will not be supported in future. It will eventually be ported over but for now this is the main source.]

{::nomarkdown}</div>{:/}

##### _Drawing Fermi Surfaces_
Fermi surfaces can be drawn with the _lmf_{: style="color: blue"} and _lm_{: style="color: blue"} codes.

<div onclick="elm = document.getElementById('lm_fermisurfaces'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show/hide lm instructions.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="lm_fermisurfaces">{:/}
	
The _lm_{: style="color: blue"} code can generate energy bands as shown in [this](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/FStutorial.html) tutorial. [Please note, this is an old-style tutorial and will not be supported in future. It will eventually be ported over but for now this is the main source.]

{::nomarkdown}</div>{:/}

<div onclick="elm = document.getElementById('lmf_fermisurfaces'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show/hide lmf instructions.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="lmf_fermisurfaces">{:/}

The _lmf_{: style="color: blue"} code can draw fermi surfaces as shown in this test

    $ fp/test/test.fp fe

{::nomarkdown}</div>{:/}

##### _Density Of States_
All of the codes have some ability to generate either full or partial Density of States (DOS).

###### _lmf_
The _lmf_{: style="color: blue"} code can generate a partial DOS as detailed in [this tutorial](https://lordcephei.github.io/tutorial/lmf/lmf_pdos/). A quick rundown of the process consists of (using _GaS_ as our example material):

    lmfa gas
	lmf gas -vpdos=t --pdos~lcut=2,2,1,1~mode=1 --rs=1,0 -vnit=1
	lmdos gas -vpdos=t --pdos~lcut=2,2,1,1~mode=1 --dos:npts=1001:window=-1.2,.7

From these commands you can then plot the resultant _dos.gas_{: style="color: green"} file with your desired plotting program, although some extra manipulation of the data file to get it in to the correct format may be required.

The _lmf_{: style="color: blue"} package can also perform Mulliken analysis or Core-Level Spectroscopy (CLS) using the switches

    --mull
	--cls

For Mulliken analysis and CLS respectively, these should be used with the _lmf_ command. A full usage guide for Mulliken analysis, including how the switch is actually used, can be found [here](https://lordcephei.github.io/tutorial/lmf/lmf_mulliken/). A usage guide for the _cls_ switch will be created shortly.

###### _lm_
A detailed tutorial for _lm_{: style="color: blue"} partial DOS can be found [here](https://lordcephei.github.io/asa_dos/)

{::nomarkdown}</div>{:/}

Density of states relates heavily to other topics. You may want to take a look at

*   Core Level Spectroscopy:
    This is exemplified in the test:
	
	    $ fp/test/test.fp fe 2

*   Mulliken analysis:
    This is exemplified in the test:
	
	    $ fp/test/test.fp fe 2
	
*   k-resolved DoS

##### _Obtaining quasipartice energy bands from 1-shot GW_
The test case

    $ gwd/test/test.gwd fe 1

Demonstrates the method to obtain results for a metallic system

##### _Obtaining a self-energy in Dynamiccal Mean Field Theory_

##### _Dielectric Response and Optics_

##### _Spin Susceptibility and Magnetic Exchange Interactions_

##### _Spectral Functions_

##### _Molecular Statics_

##### _Molecular Dynamics_

##### _Noncollinear Magnetism_

##### _Spin Statistics: Relaxation of Spin Quantization Axis_

##### _Spin Orbit Coupling_

##### _Fully Relativistic Dirac Equation_

##### _Coherent Potential Approximation_

##### _Application of External Scalar Potential_

##### _Application of External Zeeman B Field_

##### _Using Functionals Other Than LDA_

##### _LDA+U_

##### _Techniques for Brillouin Zone Integration_

##### _Adding a Homogenous Background_

##### _Building a Supercell_

##### _Band Edge Finder_

##### _Point Defects in Large Supercells_

##### _Rotate The Crystal Coordinates_

##### _Special Quasirandom Structures_

##### _Spin Dynamics_

##### _How The Code Defines Integer Lists in Various Contexts_

##### _How The Code Defines Rotations in Various Contexts_

##### _How Site Positions are Read by the Input File_

##### _Ordering of m Quantum Numbers for a given l_
