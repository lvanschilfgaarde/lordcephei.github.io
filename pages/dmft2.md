---
layout: page-fullwidth
title: "Second tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft2/"
sidebar: "left"
header: no
---

<hr style="height:5pt; visibility:hidden;" />
# The DMFT loop


<hr style="height:5pt; visibility:hidden;" />
### Introduction
As explained in the [introduction to QSGW+DMFT](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft0), the fundamental step of DMFT is the self-consistent solution of the local Anderson impurity problem. This is connected to the electronic structure of the material (bath) through the hybridization function, the impurity level and the effective interactions $$U$$ and $$J$$. The sequence of operations leading to the self-consistent impurity self-energy is called DMFT loop.
 
The DMFT loop is composed by the following steps:

* The lattice Green's function is projected onto the local correlated subsystem ($$G_{\rm loc}$$). This leads to the definition of the hybridization function ($$\Delta(i\omega)$$) and the impurity levels ($$E_{\rm imp}$$).
* These two quantities together with the effective interactions $$U$$ and $$J$$ are passed to the Continuous Time Quantum Monte Carlo (CTQMC) solver which computes the corresponding impurity self-energy and the impurity Greens function ($$G_{\rm imp}$$).
* The double counting is subtracted from it and the result is embedded into an updated lattice Green's function. After adjusting the chemical potential, the loop starts again from the starting point until $$G_{\rm imp}$$ is equal to $$G_{\rm loc}$$.

From a software perspective, these operations are accomplished in a four-step procedure. Each step relies on a specific software (**lmfdmft.f**{: style="color: blue"}, **atom_d.py**{: style="color: blue"}, **ctqmc.cc**{: style="color: blue"} and **broad_sig.f90**{: style="color: blue"}). The operations performed by each code and the input/output handling needed to cycle the loop are indicated schematically in the figure below

![Input/Output in DMFT loop](https://lordcephei.github.io/assets/img/inout_dmftloop.svg)

In this tutorial, we will go through all these steps and we will indicate what quantity to monitor to judge the convergence of the DMFT loop. This will be done starting from a converged QSGW of the paramagnetic phase of La$$_2$$CuO$$_4$$.

### Set up of the calculation 
First of all, you have to [download the input files](https://lordcephei.github.io/assets/download/inputfiles/dmft1.tar.gz). Some of them are actually binary files obtained from a converged QSGW calculation on the paramagnetic phase of La$$_2$$CuO$$_4$$.

After copying the relevant files in the input folders, you need to compile *broad_sig.f90*{: style="color: green"} and add a string of tokens to *ctrl.lsco*{: style="color: green"}. 

```
mkdir lmfinput qmcinput                                # prepare input folders
cp *.lsco lmfinput                                     # copy input files relevant for lmfdmft
cd lmfinput
echo 'DMFT    PROJ=2 NLOHI=11,53 BETA=50 NOMEGA=1999 KNORM=0' >> ctrl.lsco  # add a line to the ctrl file 
cd ../
cp atom_d.py broad_sig.f90 Trans.dat PARAMS qmcinput/  # copy files and programs relevant for CTQMC
cd qmcinput
gfortran -o broad_sig.x broad_sig.f90                  # compile (here with gfortran) the broadening program
```

The token **DMFT_NLOHI** defines the projection window in band index, **DMFT_BETA** is the inverse temperature in eV$$^{-1}$$ and **DMFT_NOMEGA** is the number of Matsubara frequencies in the mesh. Some detail of the projection procedure are controlled by **DMFT_PROJ** and **DMFT_KNORM**, but you are not meant to change their value.

After that, you can create an empty impurity self-energy to start the loop.

```
mkdir siginp0
cd siginp0
cp ../lmfinput/*  . 
lmfdmft lsco -vnk=4 -rs=1,0 --ldadc=82.2 -job=1  > log
```

You can check that a file called *sig.inp*{: style="color: green"} has been created. It is formatted with the first column being the Matsubara frequencies (in eV) and then a number of columns equal to twice the number of _m_ channels (e.g. ten columns for d-type impurity: five pairs of real and imaginary parts).

### Running the loop
The DMFT loop is composed by alternated runs of **lmfdmft**{: style="color: blue"} and **ctqmc**{: style="color: blue"}, the output of each run being the input for the successive. To do that, do the following steps:

* **Prepare and launch the lmfdmft run**

  First you have to copy the input files. If you have to run the first iteration then 
 
  ```
  mkdir it1_lmfrun                            
  cp lmfinput/* it1_lmfrun                    # copy standard input files 
  cp siginp0/sig.inp it1_lmfrun/sig.inp       # cppy vanishing sig.inp
  ```
  
  If you are running iteration number X>1, then
  
  ```
  mkdir itX_lmfrun                                    # X>1 number of the iteration
  cp lmfinput/* itX_lmfrun                            # copy standard input files 
  cp it(X-1)_qmcrun/Sig.out.brd  itX_lmfrun/sig.inp   # copy sigma from last CTQMC run
  ```

  Let now _U_=10 eV and _J_=0.7 eV be the Hubbard on-site interaction and Hunds coupling respectively, and _n_=9 the nominal occupancy of the correlated subsystem (_n_=9 for cuprates). Then launch **lmfdmft**{: style="color: blue"} with the command 

  ```
  lmfdmft lsco -vnk=4 --rs=1,0 --ldadc=82.2 -job=1 > log
  ```
  
  where 82.2 is the double counting term, computed according to the formula $$Edc=U(n-1/2)-J(n-1)/2$$. 
  
  At the end of the run, the hybridization function $$\Delta(i\omega)$$ is stored in *delta.lsco*{: style="color: green"} (first column are Matsubaras energies and then five d-channels with real and imaginary parts).The impurity levels $$E_{\rm imp}$$ are recorded in *eimp1.lsco*{: style="color: green"} .
  These two output files are essential to initialise the next CTQMC run.

* **Prepare and launch the ctqmc run**

  At the Xth iteration you can launch the following commands
  
  ```
  mkdir itX_qmcrun                                 # the running folder
  cp qmcinput/*   itX_qmcrun/                      # copy input files and relevant executables
  cp itX_lmfrun/delta.lsco  itX_qmcrun/Delta.inp   # copy relevant output from lmfdmft
  cp itX_lmfrun/eimp1.lsco  itX_qmcrun/Eimp.inp    # copy relevant output from lmfdmft
  ```
  
  Now there are some manual operations to do:
  
  * Copy the forth line of *Eimp.inp*{: style="color: green"} in the *PARAMS*{: style="color: green"} file (in such a way to have one line like **Ed [ ... ]**{: style="color: blue"}. 
   *Note:*{: style="color: red"} be careful in erasing the '=' sign before the brakets!
  * Change accordingly the **mu** variable in *PARAMS*{: style="color: green"}. It has to be the first value of the __Ed__ string with inverted sign.
  * Add correct values of **U**, **J**, **nf0** (equivalent of n) and beta in *PARAMS*{: style="color: green"}.
  
  The *PARAMS*{: style="color: green"} file at the end should look like that one in the dropdown box.

<div onclick="elm = document.getElementById('ParamsDmft1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example PARAMS - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ParamsDmft1">{:/}

```
Ntau  1000  
OffDiagonal  real
Sig  Sig.out
Naver  100000000
SampleGtau  1000
Gf  Gf.out
Delta  Delta.inp
cix  actqmc.cix
Nmax  200         # Maximum perturbation order allowed
nom  130          # Number of Matsubara frequency points sampled
exe  ctqmc        # Name of the executable
tsample  50       # How often to record measurements
nomD  150         # Number of Matsubara frequency points sampled
Ed [ -84.811465, -84.562847, -84.169182, -84.562583, -84.129468]     # Impurity levels updated by bash script
M  20000000.0     # Total number of Monte Carlo steps per core
Ncout  200000     # How often to print out info
PChangeOrder  0.9         # Ratio between trial steps: add-remove-a-kink / move-a-kink
CoulombF  'Ising'         # Ising Coulomb interaction
mu   84.811465  # QMC chemical potential by bash script
warmup  500000            # Warmup number of QMC steps
GlobalFlip  200000        # How often to try a global flip
OCA_G  False      # No OCA diagrams being computed - for speed
sderiv  0.02      # Maximum derivative mismatch accepted for tail concatenation
aom  3            # Number of frequency points used to determin the value of sigma at nom
HB2  False        # Should we compute self-energy with the Bullas trick?
U    10.0
J    0.7
nf0  9.0
beta 50.0
```

{::nomarkdown}</div>{:/}

  * Run **atom_d.py**{: style="color: blue"} using the command
  
  ```
  python atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "$EIMP"
  ```
  
  where the variable $EIMP is a copy of the third line of *Eimp.inp*{: style="color: green"}. More details on this part are on the dropdown box.

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example Eimp.inp - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

The command to run in this case will be 

```
python atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "Eimp=[   0.000000,   0.248617,   0.642283,   0.248882,   0.681997]"
```

**Warning:**{: style="color: red"} Pay attention to quotes and double quotes!

Except for the value of **Eimp** that will need to be changed at each iteration accordingly to the previous **lmfdmft**{: style="color: blue"} run, all the other parameters do not need to be modified.

*Note:*{: style="color: red"}If you are interesting in solving the problem with different values of the Hund's coupling $$J$$, change accordingly the first argument **J=xxxx**{: style="color: blue"}, but remember to be consistent also in the *PARAMS*{: style="color: green"} and in the calculation of the double counting $$Edc$$.

{::nomarkdown}</div>{:/}

  Running **atom_d.py**{: style="color: blue"} generates a file called *actqmc.cix*{: style="color: green"} used by the ctqmc solver.

  The ctqmc run	should now be sent using a submission script on, let's say, 20 cores. Important parameters (that may need to be adjusted during the loop) are **nom**, **Nmax** and **M**. Their explanation is reported as a comment in the *PARAMS*{: style="color: green"} file itself. In this tutorial, you can set them to **nom 130**, **Nmax 200** and  **M 20000000** (see example in the dropdown box above).

  After the run you need to broad sigma using the program **brad_sig.x**{: sytle="color: blue"}
  
  ``` 
  cd itX_qmcrun
  cp ../qmcinput/broad_sig.x .
  echo 'Sig.out 130 l "55  20  130" k "1 2 3 4 5"'| ./broad_sig.x > broad.log
  ```
  
  For a clearer explanation on how **broad_sig.x**{: style="color: blue"} works, we refer to its commented header.
  
### Converging to the SC-solution
The self-consistent condition holds when $$G_{\rm loc}$$ of iteration _N_ is equal (within a certain tolerance) to $$G_{\rm imp}$$ of iteration _N-1_. You can add the flag **--gprt**{: style="color: blue"} when running **lmfdmft**{: style="color blue"} to get $$G_{\rm loc}$$ printed on a file called *gloc.lsco*{: style="color: green"}. This can be compared with the file *Gf.out*{: style="color: green"} produced by the previous CTQMC run. However in the comparison remember that the latter is not broadened, while the former is obtained by smoothed quantities.

An easier though accurate way is to look at the convergence of the chemical potential. This can be done by typing **grep ' mu = ' it*_lmfrun/log**{: sytle="color: blue"}.

A third method is of course to visualise the convergence of each separate channel of local quantities like _Sig.out.brd_{: style="color: green"} or *Gf.out*{: style="color: green"}. 

In this tutorial, a reasonable convergence is achieved after around 10 iterations.
How to handle the converged DMFT result is the subject of the [third](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft3) and the [fourth](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft4) tutorials, while in the [second one](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft2) we will focus on possible source of errors, technical aspects to speed up the convergence and rule of thumbs to define the input parameters.
