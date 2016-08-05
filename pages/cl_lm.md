---
layout: page-fullwidth
title: "lm CLO"
permalink: "/docs/commandline/lm/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This page serves to document the command line switches specifically applicable to the _lm_{: style="color: blue"} program.

### _Preliminaries_
_____________________________________________________________
You should familiarize yourself with the contents of the [general command line options](/docs/commandline/general/) documentation and be aware of the capabilities of the _lm_{: style="color: blue"} program in order to fully understand the options available.

It would also be wise to read up on the different input sources that _lm_{: style="color: blue"} can read as some input options will pertain to specific input data. Details on these input sources can be found in the Documentation > Input Sources tab.

### _Documentation_
_____________________________________________________________

    --rs=#1,#2       causes lm to read from a rst file.  By default the ASA
                     writes potential information, e.g. P,Q for
                     each class to a separate file.  If #1 is nonzero, data is read
                     from file rsta.ext,
                     superseding information in class files.  If #2 is nonzero, lm will write to
                     that file.
					 
    --band[~option~option...] tells lm to generate energy bands instead
                     of making a self-consistent calculation.  The energy
                     bands can be generated in one of several formats.
                     See generating-energy-bands.html
                     for a detailed description of the available options.
					 
    --pdos[:options] tells lm to generate weights for density-of-states resolved into partial waves,
                     described in this document.
					 
    --mull[:options] tells lm to generate weights for Mulliken analysis, described in this document.
	
    --mix=#          start the density mixing at rule ``#''
                     (See ITER_MIX in tokens.html
                     for a description of mixing rules).
					 
    --onesp          in the spin-polarized collinear case, tells the program that
                     the spin-up and spin-down hamiltonians are equivalent
                     (special antiferromagnetic case)
					 
    -sh=cmd          invoke the shell ``cmd'' after every iteration