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
A description of how to set the relevant parameters of the *PARAMS* file is given below. You are not supposed to edit the other files, so we don't give an explanation of them here. 

Among the output files, the more important ones are *Sig.out* and *histogram.dat*.

### The PARAMS file 
This file is one of the input files read by the CTQMC sovler.

The variables contained in this file define the kind of calculation, allowing for a tuning of the Quantum Monte Carlo algorithm and details on how to treat the connection between the low-energy and the high-energy part of the self-energy. 
An example of the PARAMS file is reported in the [first tutorial](https://lordcephei.github.io/dmft1) (box-like botton).

<div onclick="elm = document.getElementById('ParamsDmft1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">More details - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ParamsDmft1">{:/}

##### _**Basic parameters (U, J, nf0 and beta)**_
Among the possible parameters are **U** and **J** defining respectively the Hubbard in-site interaction and the Hund's coupling constant in eV. 
**Note:** The same **J** has also to be passed to **atom_d.py**.

The variable **nf0** is the nominal occupancy of the correlated orbitals (e.g. **nf0    9** for $$Cu$$).  

Finally **beta** fixes the inverse temperature in eV$$^{-1}$$.

##### _**Setting the number of sampled frequencies (nom and nomD)**_
The CTQMC solver gives a very accurate description of the self-energy in the low frequency range (for Matsubara's frequencies close to 0), but it becomes too noisy at high frequencies.

Let $$N$$ be the total number of Matsubara's frequencies. This number has been defined through **NOMEGA** in the *ctrl* file during the **lmfdmft** run. Only the first **nom** frequencies are actually sampled by the CTQMC solver, while the other points (high-frequency range) are obtained through the approximated Hubbard 1 solver (high-frequency tail).

Excessively low values of **nom** will miss important features of the self-energy (e.g. a convex point in $$\text{Im}[\Sigma(i\omega_n)]$$), while too high values will give excessively noisy results.
As a rule-of-thumb, a good initial guess is **nom** $$\approx 3$$ **beta**, to be adjusted.
Some examples of how the $$\text{Im}[\Sigma(i\omega_n)]$$ looks like at different values of **nom** are given in the figures below.

![Setting nom](https://lordcephei.github.io/assets/img/sig-nom.png)

Add explanation of **nomD** (used only with HB2).

##### _**Setting the number of Monte Carlo steps (M and warmup)**_
The higher is the number of Monte Carlo steps, the lower the noise in the QMC calculation. 
The parameter **M** defines the number of MC steps per core. 
Reliable calculations easily require at least 500 millions of steps in total.
For instance, if you're running on 10 cores, you can set **M   50000000**.
You can judge the quality of your sampling by looking at the file *histogranm.dat*. The closer it looks to a Gaussian distribution, the better is the sampling.

**Note:** The variable **M** should be set keeping in mind that the higher it is, the longer the calculation. This is crucial when running on public clusters, where the elapsed time is computed per core. Too high values of **M** may consume your accounted hours very quickly!

During the first **warmup** steps results are not accumulated, as it is normal on Monte Carlo procedures. This gives the 'time' to the algorithm to thermalise before the significative sampling.
You can set **warmup**=**M**/1000. 

##### _**Setting the cutoff expansion order (Nmax)**_
The variable **Nmax** defines the highest order accounted for in the hybrdization expansion. 
If you have chosen an excessively low values of **Nmax**, the *histogram.dat* file will be cut and $$\text{Im}[\Sigma(i\omega_n)]$$ will look weird, as shown below.

You should chose **Nmax** high enough for the Gaussian distribution of *histogram.dat* to be comfortably displayed. However note that the higher **Nmax** the longer the calculation, so chose values just above the higher Guassian tail.

![Chosing Nmax](https://lordcephei.github.io/assets/img/histogram-cut.png)

![Weird Sigma](https://lordcephei.github.io/assets/img/sig-cut.png)

**Note:** the value of **beta** affects the number **Nmax**, so calculations on the same material at different temperatures will require different **Nmax**. At low **beta**, the Gaussian distribution is sharper and centered on lower order terms, as shown below. Therefore lower **Nmax** correspond to lower **beta**. 

![beta and Nmax](https://lordcephei.github.io/assets/img/beta-histogram.png)

##### _**Connecting the tail (sderiv and aom)**_
The connection between the QMC part and the Hubbard 1 part is done with a straight line starting at frequency number (**nom+1**) and running until it intersect the Hubbard 1 self-energy.
You can see it by comparing the *Sig.out* file with the *s_hb1.dat* (Hubbrad 1 only).
The two variables controlling the connection are **sderiv**, which is related to the angle of the straight line, and **aom** related to its starting point.

##### _**Impurity levels (Ed and mu)**_
The impurity levels as reported at the fourth line of *Eimp.inp* enters in the PARAMS as **Ed**. 

The potential **mu** is set as the first entry of the **Ed** variable with inverse sign. 

Actually the information about the impurity levels is already contained in the input file *actqmc.cix* (output of **atom_d.py**) but they are shifted by **mu**. So if **Ed** is probably ignored in the PARAMS file, **mu** must be correctly  defined.   

{::nomarkdown}</div>{:/}

### Phase transition boundaries
It may happen that, despite the high number of QMC steps, the *histogram.dat* file displays a double peak distribution simiar to the sum of two Gaussians. This is the case when the material is close to a phase transition.

In this case usually one or more channels of the self-energy are very noisy. One has to run for longer time, or use the status files to restart the calculation many times until only one peaks dominate and the histogram looks like a Gaussian. 
An example is given in the boxes below.

![histogram close to transition](https://lordcephei.github.io/assets/img/transition-histo.png)

![sigma close to transition](https://lordcephei.github.io/assets/img/transition-sigma.png)

### Using status files
During the calculation, each core generates a *status* file.
They contain some information about the sampling and should be used as restart files for other CTQMC calculations with similar parameters. They are read authomatically if they are in the folder where **ctqmc** is running.

They can be used basically in two ways.

+ If you are performing iteration N, you can copy the *status* files from iteration N-1 to speed up the convergence of the calculation. 
+ If you realise that in one ctqmc run, you haven't achieved a good sampling (e.g. **M** too low, or close to phase transition), than you can run again the calculation.

Since there is one *status* file per processor, you must pay attention to run on as many cores as *status* files you have. It should be safe to run with a smaller number of cores, while running on more cores than *status* files gives wrong results.
