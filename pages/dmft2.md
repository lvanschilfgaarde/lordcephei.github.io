---
layout: page-fullwidth
title: "Second tutorial on QSGW+DMFT"
permalink: "/dmft2/"
sidebar: "left"
header: no
---

# Set up and errors
The aim of this tutorial is to give some indications on how to set the parameters of the dmft calculation, giving examples of how the output should look like and, more importantly, how it shouldn't.

The basic input files for the CTQMC solver are the *PARAMS* file, the *actqmc.cix* file, the *Delta.inp*, the *Eimp.inp* and finally the *status* files.
Below there is a section for each of these files. 

Basic output files to monitor are *Sig.out* and *histogram*

### The PARAMS file 
This file is the main input file for the CTQMC sovler.

The variables contained in this file define the kind of calculation, allowing for a tuning of the Quantum Monte Carlo algorithm and details on how to treat the connection between the low-energy and the high-energy part of the self-energy.   

##### Setting the number of frequencies sampled (**NOM**)

##### Setting the number of Monte Carlo steps (**M**)

##### Setting the cutoff expansion order (**Nmax**)

##### Other varaibles of the PARAMS file

### Phase transition boundaries
 
### Using status files
