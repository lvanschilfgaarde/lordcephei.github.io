---
layout: page-fullwidth
title: "Second tutorial on QSGW+DMFT"
permalink: "/dmft2/"
sidebar: "left"
header: no
---

# Set up and errors
The aim of this tutorial is to give some indications on how to set the parameters of the DMFT calculation.
We will give some examples of how the output should look like and, more importantly, how it shouldn't.

The basic input files for the CTQMC solver are the *PARAMS* file, the *actqmc.cix* file, the *Delta.inp*, the *Eimp.inp* and finally the *status* files.
Below there is a section for each of these files. 

Among the output files, the more important ones are *Sig.out*, *Gf.out* and *histogram.dat*.

### The PARAMS file 
This file is one of the input files read by the CTQMC sovler.

The variables contained in this file define the kind of calculation, allowing for a tuning of the Quantum Monte Carlo algorithm and details on how to treat the connection between the low-energy and the high-energy part of the self-energy. 
An example of the PARAMS file is reported in the [first tutorial](https://lordcephei.github.io/dmft1) (box-like botton). 

##### Basic parameters (**U**, **J**, **nf0** and **beta**)
Among the possible parameters are **U** and **J** defining respectively the Hubbard in-site interaction and the Hund's coupling constant in eV. 
**Note:** The same **J** has also to be passed to **atom_d.py*.

The variable **nf0** is the nominal occupancy of the correlated orbitals (e.g. **nf0 9** for $$Cu$$).  

Finally **beta** fixes the inverse temperature in eV$$^{-1}$$.

##### Setting the number of frequencies sampled (**nom** and **nomD**)
The CTQMC gives a very accurate description of the self-energy in the low frequency range (for Matsubara's frequencies close to 0), but it becomes too noisy at high frequencies.

Let $$N$$ be the total number of Matsubara's frequencies. This number is defined through **NOMEGA** in the *ctrl.* file during the **lmfdmft** run. Only the first **nom** frequencies are actually sampled by the CTQMC solver, while the other points (high-frequency range) are obtained through the approximated Hubbard 1 solver.

Too low values of **nom** will not be able to get the important features of the self-energy (e.g. a convex point in $$\text{Im}[\Sigma(i\omega_n)]$$) while too high values will be excessively noisy.
As a rule-of-thumb a good guess is **nom**$$\approx 4$$**beta** to be adjusted.
Some example of how the $$\text{Im}[\Sigma(i\omega_n)]$$ should look like is given in the figure below.


##### Setting the number of Monte Carlo steps (**M**)

##### Setting the cutoff expansion order (**Nmax**)

##### Other varaibles of the PARAMS file

### Phase transition boundaries
 
### Using status files
