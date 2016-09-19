---
layout: page-fullwidth
title: "Third tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft3/"
sidebar: "left"
header: no
---

# Issues and adjustments
The aim of this tutorial is to give some indications on how to set the parameters of the DMFT calculation.
We will give some examples of how the output should look like and, more importantly, how it shouldn't.

The basic input files for the CTQMC solver are the *PARAMS*{: style="color: green"} file, the *Trans.dat*{: style="color: green"}, the *actqmc.cix*{: style="color: green"} file, the *Delta.inp*{: style="color: green"}, the *Eimp.inp*{: style="color: green"} and finally the *status*{: style="color: green"} files.
Moreover **lmfdmft**{: style="color: blue"} requires the *indmfl*{: style="color: green"} file. 
Descriptions of how to set the relevant parameters of the *PARAMS*{: style="color: green"}, and the *indmfl*{: style="color: green"} files are given below. You are not supposed to edit the other files, so we don't give an explanation of them here. 

Among the output files, the most important ones are *Sig.out*{: style="color: green"} and *histogram.dat*{: style="color: green"}. We will refer to these two to judge the quality of our calculation.

### The *indmfl*{: style="color: green"} file 

*Note:*{: style="color: red"} It is planned to change the syntax of this file. It will soon become obsolete!

This file is used by **lmfdmft**{: style="color: blue"} to define which atomic species and orbitals are mapped to the impurity. 
At the moment the file has a lot of redundant information, reminiscent of the formatting used in K. Haule's DMFT package. 
Among all the information reported, you are interested only in a couple of variables at lines three and four. 

```
1                                   # number of correlated atoms
1    1   0                           # iatom, nL, locrot
```

The first variables defines how many atoms are correlated. 
*Note:*{: style="color: red"} At the moment we are testing the code for values higher than 1. So far it hasn't been possible to treat more than one atom. 

The first variable of the second line (**iatom**=1 in the example) is the index of the correlated atom in the basis chosen. In the example, Ni has only one atom so it's index is 1. This value has to be consistent with the *site.ext*{: style="color: green"} file 

<div onclick="elm = document.getElementById('StructLSCO'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example from a more complicated structure: La2CuO4- Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="StructLSCO">{:/}

If the site file is 

```
  ATOM=La         POS=  0.5000000   0.5000000  -0.4807290
  ATOM=La         POS= -0.5000000  -0.5000000   0.4807290
  ATOM=Cu         POS=  0.0000000   0.0000000   0.0000000
  ATOM=O          POS=  0.0000000   0.5000000   0.0000000
  ATOM=O          POS=  0.0000000   0.0000000   0.6320273
  ATOM=O          POS= -0.5000000   0.0000000   0.0000000
  ATOM=O          POS=  0.0000000   0.0000000  -0.6320273
```

then **iatom=3**.

{::nomarkdown}</div>{:/}

All the other values of the file are either ignored or should not be changed. 

### The *PARAMS*{: style="color: green"} file 
This file is one of the input files read by the CTQMC sovler.

The variables contained in this file define the kind of calculation, allowing for a tuning of the Quantum Monte Carlo algorithm and details on how to treat the connection between the low-energy and the high-energy part of the self-energy. 
An example of the *PARAMS*{: style="color: green"} file is reported in a dropdown box of the [second tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1).

<div onclick="elm = document.getElementById('ParamsVariables'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">More details - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ParamsVariables">{:/}

##### _**Basic parameters (U, J, nf0 and beta)**_
Among the possible parameters are **U** and **J**, defining respectively the Hubbard in-site interaction and the Hund's coupling constant in eV. 
**Warning:**{: style="color: red"} The same value of **J** has to be passed to **atom_d.py**{: style="color: blue"} as well.

The variable **nf0** is the nominal occupancy of the correlated orbitals (e.g. **nf0    9** for $$Cu$$, **nf0    8** for Ni).

Finally **beta**{: style="color: blue"} fixes the inverse temperature in eV$$^{-1}$$.

**Warning:**{: style="color: red"} Don't forget to be consistent when you run **atom_d.py**{: style="color: blue"} (which wants **J** as an input) and **lmfdmft**{: style="color: blue"} (for which the flag **\-\-ldadc=**{: style="color: blue"} has to be consistently defined as **U*(nf0-0.5)-J*(nf0-1)*0.5**).

##### _**Setting the number of sampled frequencies (nom and nomD)**_
The CTQMC solver gives a very accurate description of the self-energy in the low frequency range (for Matsubara's frequencies close to 0), but it becomes too noisy at high frequencies.

Let $$N$$ be the total number of Matsubara's frequencies. This number has been defined through **NOMEGA** in the *ctrl*{: style="color: green"} file during the **lmfdmft**{: style="color: blue"} run. Only the first **nom** frequencies are actually sampled by the CTQMC solver, while the other points are obtained analytically through the approximated Hubbard 1 solver (high-frequency tail).

Excessively low values of **nom** will miss important features of the self-energy (e.g. a convex point in $$\text{Im}[\Sigma(i\omega_n)]$$), while too high values will give excessively noisy results.
As a rule-of-thumb, a good initial guess is **nom** $$\approx 3$$ **beta**, but this value has usually to be adjusted during the DMFT loop.
Some examples of how the $$\text{Im}[\Sigma(i\omega_n)]$$ looks like at different values of **nom** are given in the figures below.

![Setting nom](https://lordcephei.github.io/assets/img/sig-nom.png)

[//]: # (Add explanation of **nomD**{: style="color: blue"} (used only with HB2).)

##### _**Setting the number of Monte Carlo steps (M and warmup)**_
The higher is the number of Monte Carlo steps, the lower the noise in the QMC calculation. 
The parameter **M** defines the number of MC steps per core. 
Reliable calculations easily require at least 500 millions of steps in total.
For instance, if you're running on 10 cores, you can set **M   50000000**.
You can judge the quality of your sampling by looking at the file *histogram.dat*{: style="color: green"}. The closer it looks to a Gaussian distribution, the better is the sampling.

**Warning:**{: style="color: red"} The variable **M** should be set keeping in mind that the higher it is, the longer the calculation. This is crucial when running on public clusters, where the elapsed time is computed per core. Too high values of **M** may consume your accounted hours very quickly!
Moreover remember that you are supposed to broaden the output at each iteration, so you don't actually need very clean *Sig.out*{: symbol="color: green"}.

During the first **warmup** steps results are not accumulated, as it is normal on Monte Carlo procedures. This gives the 'time' to the algorithm to thermalise before the significative sampling.
You can set **warmup**=**M**/1000. 

##### _**Setting the cutoff expansion order (Nmax)**_
The variable **Nmax** defines the highest order accounted for in the hybrdization expansion. 
If you have chosen an excessively low values of **Nmax**, the *histogram.dat*{: style="color: green"} file will be cut and $$\text{Im}[\Sigma(i\omega_n)]$$ will look weird, as shown below.

You should chose **Nmax** high enough for the Gaussian distribution of *histogram.dat*{: style="color: green"} to be comfortably displayed. However note that the higher **Nmax** the longer the calculation, so chose values just above the higher Guassian tail.

![Chosing Nmax](https://lordcephei.github.io/assets/img/histogram-cut.png)

![Weird Sigma](https://lordcephei.github.io/assets/img/sig-cut.png)

**Warning:**{: style="color: red"} the value of **beta** affects the number **Nmax**, so calculations on the same material at different temperatures will require different **Nmax**. At low **beta**, the Gaussian distribution is sharper and centered on lower order terms, as shown below. Therefore lower **beta** require lower **Nmax**. 

![beta and Nmax](https://lordcephei.github.io/assets/img/beta-histogram.png)

##### _**Connecting the tail (sderiv and aom)**_
The connection between the QMC part and the Hubbard 1 part is done with a straight line starting at frequency number **nom**+1 and running until it intersect the Hubbard 1 self-energy.
You can see it by comparing the *Sig.out*{: style="color: green"} file with the *s_hb1.dat*{: style="color: green"} (Hubbrad 1 only).

The two variables controlling the connection are **sderiv**, which is related to the angle of the straight line, and **aom** related to its starting point.

The straight line connecting the low- and the high-frequncy region can easily give rise to unwanted kinks.
To broaden *Sig.out*{: style="color: green"} is necessary to smooth these kinks out as well. 

##### _**Impurity levels (Ed and mu)**_
The impurity levels reported at the fourth line of *Eimp.inp*{: style="color: green"} enters in the *PARAMS*{: style="color: green"} as the variable **Ed**. 
The variable **mu** is set as the first entry of the **Ed** with opposite sign. 

**Warning:**{: style="color: red"} These two variables change at every iteration so you have to constantly update their value throughout the DMFT loop. 

[//]: # (Actually the information about the impurity levels is already contained in the input file *actqmc.cix*{: style="color: green"} (output of **atom_d.py**{: style="color: blue"}) but they are shifted by **mu**{: style="color: blue"}. So if **Ed**{: style="color: blue"} is probably ignored in the *PARAMS*{: style="color: green"} file, **mu**{: style="color: blue"} must be correctly  defined.   )

{::nomarkdown}</div>{:/}

### Phase transition boundaries
It may happen that, despite the high number of QMC steps, the *histogram.dat*{: style="color: green"} file displays a double peak distribution simiar to the sum of two Gaussians. This is the case when the material is close to a phase transition.

<div onclick="elm = document.getElementById('PhaseTrans'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="PhaseTrans">{:/}

In this case usually one or more channels of the self-energy are very noisy. One has to run for longer times, or use the status files to restart the calculation many times until only one peaks dominate and the histogram looks like a Gaussian. 
An example is given in the boxes below.

![histogram close to transition](https://lordcephei.github.io/assets/img/transition-histo.png)

![sigma close to transition](https://lordcephei.github.io/assets/img/transition-sigma.png)

{::nomarkdown}</div>{:/}

### Using status files
During the calculation, each core generates a *status*{: style="color: green"} file.
They contain some information about the sampling and should be used as restart files for other CTQMC calculations with similar parameters. They are read authomatically if they are in the folder where **ctqmc**{: style="color: blue"} is running.

<div onclick="elm = document.getElementById('StatusFiles'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">More details - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="StatusFiles">{:/}

They can be used basically in two ways.

+ If you are performing iteration N, you should copy the *status*{: style="color: green"} files from iteration N-1 to speed up the convergence of the calculation. 
+ If you realise that in one **ctqmc**{: style="color: blue"} run, you haven't achieved a good sampling (e.g. **M** too low, or close to phase transition), than you can run again the calculation without losing the effort already done. When restarted, the **ctqmc**{: style="color: blue"} solver will automatically read the *status*{: style="color: green"} files and retrive their information.

**Warning:**{: style="color: red"} Since there is one *status*{: style="color: green"} file per core, you must pay attention to run on as many cores as *status*{: style="color: green"} files you have. It should be safe (but not recommended) to run with a smaller number of cores, while running on more cores than *status*{: style="color: green"} files gives wrong results.

{::nomarkdown}</div>{:/}
