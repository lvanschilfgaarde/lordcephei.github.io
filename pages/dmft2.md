---
layout: page-fullwidth
title: "Second tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft2/"
sidebar: "left"
header: no
---

<hr style="height:5pt; visibility:hidden;" />
# Running the DMFT loop


<hr style="height:5pt; visibility:hidden;" />
### Introduction
As explained in the [introduction to QSGW+DMFT](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft0), the fundamental step of DMFT is the self-consistent solution of the local Anderson impurity problem. This is connected to the electronic structure of the material (bath) through the hybridization function, the impurity level and the effective interactions $$U$$ and $$J$$. The sequence of operations leading to the self-consistent impurity self-energy is called DMFT loop.
 
The DMFT loop is composed by the following steps:

* The lattice Green's function is projected onto the local correlated subsystem ($$G_{\rm loc}(i\omega_n)$$), where $$\omega_n=(2n-1)\pi/\beta$$ are the fermionic Matsubara's frequencies. This leads to the definition of the hybridization function ($$\Delta(i\omega_n)$$) and the impurity levels ($$E_{\rm imp}$$).
* These two quantities together with the effective interactions $$U$$ and $$J$$ are passed to the Continuous Time Quantum Monte Carlo (CTQMC) solver which computes the corresponding impurity self-energy and the impurity Green's function ($$G_{\rm imp}(i\omega_n)$$).
* The double-counting self-energy is subtracted from it and the result is embedded into an updated lattice Green's function. After adjusting the chemical potential, the loop starts again from the starting point until the self-consistent relation $$G_{\rm imp}(i\omega_n)=G_{\rm loc}(i\omega_n)$$ is met.

From a software perspective, these operations are accomplished in a four-step procedure. Each step relies on a specific program (**lmfdmft**{: style="color: blue"}, **atom_d.py**{: style="color: blue"}, **ctqmc**{: style="color: blue"} and **broad_sig.x**{: style="color: blue"}). The operations performed by each code and the input/output handling needed to cycle the loop are indicated schematically in the figure below.

![Input/Output in DMFT loop](https://lordcephei.github.io/assets/img/inout_dmftloop.svg)

In this tutorial, we will go through all these steps and we will indicate what quantity to monitor to judge the convergence of the DMFT loop. We will assume that you followed all the steps of the [previous tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1).


### Running the loop
The DMFT loop is composed by alternated runs of **lmfdmft**{: style="color: blue"} and **ctqmc**{: style="color: blue"}, the output of each run being the input for the successive. To do that, do the following steps:

##### _**(1) Prepare and launch the lmfdmft run**_
First you have to copy the input files. If you are going to run the first iteration then 
 
```
mkdir it1_lmfrun                            
cp lmfinput/*.ni it1_lmfrun                 # copy standard input files 
cp siginp0/sig.inp it1_lmfrun/sig.inp       # copy vanishing sig.inp
```
 
Otherwise you are going to run iteration number X>1, then

```
mkdir itX_lmfrun                                    # X>1 number of the iteration
cp lmfinput/*.ni itX_lmfrun                         # copy standard input files 
cp it(X-1)_qmcrun/Sig.out.brd  itX_lmfrun/sig.inp   # copy sigma from last CTQMC run
```

Let now _U_=10 eV and _J_=0.9 eV be the Hubbard on-site interaction and Hunds coupling respectively, and _n_=8 the nominal occupancy of the correlated subsystem (_n_=8 for Ni). Then launch **lmfdmft**{: style="color: blue"} with the command 

```
cd it1_lmfrun
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1 > log
cd ..
```

where 71.85 is the double-counting self-energy, computed according to the formula $$Edc=U(n-1/2)-J(n-1)/2$$.

At the end of the run, the hybridization function $$\Delta(i\omega_n)$$ is stored in *delta.ni*{: style="color: green"} (first column are Matsubara's energies and then five _d_-channels with real and imaginary parts).The impurity levels $$E_{\rm imp}$$ are recorded in *eimp1.ni*{: style="color: green"}.
These two output files are essential to initialise the corresponding CTQMC run.

##### _**(2) Prepare and launch the ctqmc run**_
At the Xth iteration you can launch the following commands

```
mkdir itX_qmcrun                                 # the running folder
cp qmcinput/*   itX_qmcrun/                      # copy input files and relevant executables
cp itX_lmfrun/delta.ni  itX_qmcrun/Delta.inp     # copy hybridization function output from lmfdmft
cp itX_lmfrun/eimp1.ni  itX_qmcrun/Eimp.inp      # copy impurity levels from lmfdmft
```

Now there are some manual operations to do:

+ Look for '????' in the *PARAMS*{: style="color: green"} file provided. Assign the **Ed** variable the values reported in the forth line of *Eimp.inp*{: style="color: green"}. **Warning: be careful in erasing the '=' sign before the brakets!**{: style="color: red"}. Then change **mu** accordingly as the first value of **Ed** with opposite sign. Finally add the correct values of **U**, **J**, **beta** and **nf0** (equivalent of n: nominal occupation of correlated orbitals). **Warning: Be careful in being consistent with the values in the ctrl.ni and the double counting used in the lmfdfmt run.**{: style="color: red"}

  <div onclick="elm = document.getElementById('ParamsDmft1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example of PARAMS - Click to show.</button></div>
  {::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ParamsDmft1">{:/}
  
  At this point the PARAMS file should look like this

  ```
  Ntau  1000  
  OffDiagonal  real
  Sig  Sig.out
  Naver  100000000
  SampleGtau  1000
  Gf  Gf.out
  Delta  Delta.inp
  cix  actqmc.cix
  Nmax  700         # Maximum perturbation order allowed
  nom  150          # Number of Matsubara frequency points sampled
  exe  ctqmc        # Name of the executable
  tsample  50       # How often to record measurements
  nomD  150         # Number of Matsubara frequency points sampled
  Ed [ -71.710134, -71.710132, -71.796795, -71.710130, -71.796792, -71.732934, -71.732932, -71.820596, -71.732930, -71.820593 ]     # Impurity levels
  M  20000000.0     # Total number of Monte Carlo steps per core
  Ncout  200000     # How often to print out info
  PChangeOrder  0.9         # Ratio between trial steps: add-remove-a-kink / move-a-kink
  CoulombF  'Ising'         # Ising Coulomb interaction
  mu   71.710134            # QMC chemical potential
  warmup  500000            # Warmup number of QMC steps
  GlobalFlip  200000        # How often to try a global flip
  OCA_G  False      # No OCA diagrams being computed - for speed
  sderiv  0.02      # Maximum derivative mismatch accepted for tail concatenation
  aom  3            # Number of frequency points used to determin the value of sigma at nom
  HB2  False        # Should we compute self-energy with the Bullas trick?
  U    10.0
  J    0.9
  nf0  8.0
  beta 50.0
  ```

  {::nomarkdown}</div>{:/}

+ Run **atom_d.py**{: style="color: blue"} using the command

  ```
  python atom_d.py J=0.9 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "Eimp=[   0.000000,   0.000002,  -0.086661,   0.000004,  -0.086658,  -0.022800,  -0.022798,  -0.110462,  -0.022796,  -0.110459]"
  ```

  where the argument **Eimp** is a copy of the third line of *Eimp.inp*{: style="color: green"} (to be changed at each iteration accordingly to the previous **lmfdmft**{: style="color: blue"} run) and the argument **J** is the Hund's coupling. All other argument should not be changed.
  **Warning: Pay attention to quotes and double quotes!**{: style="color: red"} 

  Running **atom_d.py**{: style="color: blue"} generates a file called *actqmc.cix*{: style="color: green"} used by the ctqmc solver.

+ Run **ctqmc**{: style="color: blue"} using a submission script on, let's say, 20 cores. Important parameters (that may need to be adjusted during the loop) are **nom**, **Nmax** and **M**. Their explanation is reported as a comment in the *PARAMS*{: style="color: green"} file itself but further information is available in the [next tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft3). For this tutorial, you can set them to **nom 150**, **Nmax 700** and  **M 20000000** (as illustrated in one dropdown box above).

  At the end of the run (it will take a while...) a series of files have been produced. Among them we are especially interested in *Sig.out*{: style="color: green"}, *histogram.dat*{: style="color: green"} and the *status*{: style="color: green"} files. To learn how to use them to judge on the quality of the QMC calculation we refer to the [third tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft3).

+ You now must broad *Sig.out*{: style="color: green"} to smooth out the noise. If you use the program **brad_sig.x**{: style="color: blue"} you will run it with following commands
 
  ``` 
  cd itX_qmcrun
  cp ../qmcinput/broad_sig.x .
  echo 'Sig.out 150 l "55  20  150" k "1 2 3 4 5"'| ./broad_sig.x > broad.log
  ```

  For a clearer explanation of how to use **broad_sig.x**{: style="color: blue"}, we refer to its commented header.
  

##### _**(3) Cycling the loop**_
 
At this point you have a new self-energy to be fed to **lmfdmft**{: style="color: blue"}. You can go back to the point _**(1)**_ and repeat all the operations with a higher iteration number X.

As you have noticed the procedure is based on an alternated utilisation of **lmfdmft**{: style="color: blue} and **ctqmc**{: style="color: blue}. The input/output that makes the loop possible is not automatised though.
Once you have familiarised with the procedure, we strongly recommend you to write a script that handles the input/output. 
However be careful that (at least during the first three/four iterations) some variables of *PARAMS*{: style="color: green"} could need to be adjusted on the fly (e.g. **nom**, **Nmax**).
 
### Converging to the SC-solution
The self-consistent condition holds when $$G_{\rm loc}(i\omega_n)$$ of iteration _N_ is equal (within a certain tolerance) to $$G_{\rm imp}(i\omega_n)$$ of iteration _N-1_. You can add the flag **\-\-gprt**{: style="color: blue"} when running **lmfdmft**{: style="color: blue"} to get $$G_{\rm loc}(i\omega_n)$$ printed on a file called *gloc.ni*{: style="color: green"}. This can be compared with the file *Gf.out*{: style="color: green"} produced by the previous CTQMC run. However in the comparison remember that the latter is not broadened, while the former is obtained by smoothened quantities.

An easier though accurate way is to look at the convergence of the chemical potential. This can be done by typing **grep ' mu = ' it*_lmfrun/log**{: style="color: blue"}.

A third method is of course to visualise the convergence of each separate channel of local quantities like _Sig.out.brd_{: style="color: green"} or *Gf.out*{: style="color: green"}. 

In this tutorial, a reasonable convergence is achieved after around 10 iterations.
How to handle the converged DMFT result is the subject of the [fourth](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft4) and the [fifth](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft5) tutorials, while in the [third one](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft3) we will focus on possible source of errors, technical aspects to speed up the convergence and rule of thumbs to define the input parameters.
