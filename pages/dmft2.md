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
As a rule-of-thumb a good guess is **nom**$$\approx 3$$**beta** to be adjusted.
Some example of how the $$\text{Im}[\Sigma(i\omega_n)]$$ should look like is given in the three figures below.

Add explanation of **nomD** (used only with HB2).

##### Setting the number of Monte Carlo steps (**M** and **warmup**)
The higher is the number of Monte Carlo steps, the lower the noise in the QMC calculation. 
The parameter **M** defines the number of MC steps per core. 
Reliable calculations easily require at least 500 millions of steps in total.
For instance, if you're running on 10 cores, you can set **M   50000000**.
You can judge the quality of your sampling by looking at the file *histogranm.dat*. The closer it looks to a Gaussian distribution, the better is the sampling.

**Note:** The variable **M** should be set keeping in mind that the high it is, the longer the calculation. This is very important when running on public clusters, where the elapsed time is computed per core. Too high values of **M** may consume your accounted hours very quickly!

During the first **warmup** steps results are not accumulated, as it is normal on Monte Carlo procedures.
You can set **warmup**=**M**/1000. 

##### Setting the cutoff expansion order (**Nmax**)
The variable **Nmax** defines the highest order accounted for in the hybrdization expansion. 
If you have chosen an excessively low values of **Nmax**, the *histogram.dat* file will be cut and $$\text{Im}[\Sigma(i\omega_n)]$$ will look weird. 

You should chose **Nmax** high enough for the Gaussian distribution of *histogram.dat* to be comfortably displayed. However note that the higher **Nmax** the longer the calculation, so stop at values just above the Guassian.
See figures for some examples.

**Note:** the value of **beta** affects the number **Nmax**, so calculations on the same material at different temperatures will require different **Nmax**.

##### Other varaibles of the PARAMS file

### Phase transition boundaries
 
### Using status files
