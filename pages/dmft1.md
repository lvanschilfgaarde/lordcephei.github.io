---
layout: page-fullwidth
title: "First tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft1/"
sidebar: "left"
header: no
---

<hr style="height:5pt; visibility:hidden;" />
# The DMFT loop


<hr style="height:5pt; visibility:hidden;" />
### Introduction
As explained in the [introduction to QSGW+DMFT](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft0), the fundamental step of DMFT is the self-consistent solution of the (local) Anderson impurity problem. This is connected to the electronic structure of the material (bath) through the hybridization function, the impurity level and the effective interactions $$U$$ and $$J$$. The loop of operations leading to the self-consistent result of the DMFT, is called DMFT loop.
 
The DMFT loop is composed by the following steps:

* The lattice Green's function is projected onto the local correlated subsystem ($$G_{\rm loc}$$). This leads to the definition of the hybridization function ($$\Delta(i\omega)$$) and the impurity levels ($$E_{\rm imp}$$).
* These two quantities together with the effective interactions $$U$$ and $$J$$ are passed to the Continuous Time Quantum Monte Carlo (CTQMC) solver which computes the corresponding impurity self-energy and the impurity Greens function ($$G_{\rm imp}$$).
* The double counting is subtracted from it and the result is embedded into an updated lattice Green's function. After adjusting the chemical potential, the loop starts again from the starting point until $$G_{\rm imp}$$ is equal to $$G_{\rm loc}$$.

From a software perspective, these operations are accomplished in a four-step procedure. Each step relies on a specific software (**lmfdmft.f**, **atom_d.py**, **ctqmc.cc** and **broad_sig.f90**). The operations performed by each code and the input/output handling needed to cycle the loop are indicated schematically in the figure.

![Input/Output in DMFT loop](https://lordcephei.github.io/assets/img/inout_dmftloop.png)

In this tutorial, we will go through all these steps and we will indicate what quantity to monitor to judge the convergence of the DMFT loop. This will be done starting from a converged QSGW of the paramagnetic phase of La$$_2$$CuO$$_4$$.

### Set up of the calculation 
First of all, you have to [download the input files](https://lordcephei.github.io/assets/download/inputfiles/dmft1.tar.gz). Some of them are actually binary files obtained from a converged QSGW calculation on the paramagnetic phase of La$$_2$$CuO$$_4$$.

After copying the relevant files in the input folders, you need to compile *broad_sig.f90* and add a command line to the *ctrl.lsco* file. 

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

The token **DMFT_NLOHI** defines the projection window in band index, **DMFT_BETA** is the inverse temperature in eV^{-1} and **DMFT_NOMEGA** is the number of Matsubara frequencies in the mesh. 

After that, you can create an empty impurity self-energy to start the loop.

```
mkdir siginp0
cd siginp0
cp ../lmfinput/*  . 
lmfdmft lsco -vnk=4 -rs=1,0 --ldadc=82.2 -job=1 --gprt
```

You can check that a file called *sig.inp* has been created. It is formatted with the first column being the Matsubara frequencies (in eV) and then a number of columns equal to twice the number of m channels (ten columns for d-type impurity: real and imaginary parts).

### Running the loop
The DMFT loop is composed by alternated runs of **lmfdmft** and **ctqmc**, the output of each run being the input for the successive. To do that, do the following steps:

* **Prepare and launch the lmfdmft run**

  First you have to copy the standard input files:
 
  ```
  mkdir itX_lmfrun                            # with X=iteration , X=1 if first run
  cp lmfinput/* itX_lmfrun                    # copy standard input files 
  ```
  
  If you are running the first iteration, you have to copy the vanishing impurity self-energy:
  
  ```
  cp siginp0/sig.inp it1_lmfrun/sig.inp
  ```
  
  Otherwhise, you have to copy the (broadened) impurity self-energy of the previous CTQMC step. 
  If you are running an iteration X>1 then type:
  
  ```
  cp it(X1)_qmcrun/Sig.out.brd  itX_lmfrun/sig.inp
  cp it(X-1)_qmcrun/g_qmc.dat   itX_lmfrun/gimp.prev.lsco
  ```

  Let now _U_=10 eV and _J_=0.7 eV be the Hubbard on-site interaction and Hunds coupling respectively, and _n_=9 the nominal occupancy (_n_=9 for cuprates). Then launch **lmfdmft** with the command 

  ```
  lmfdmft lsco -vnk=4 --rs=1,0 --ldadc=82.2 -job=1 --gprt
  ```
  
  where 82.2 is the double counting according to the formula $$Edc=U(n-1/2)-J(n-1)/2$$. The hybridization function $$\Delta(i\omega)$$ is stored in *delta.lsco* (first column are Matsubaras energies and then five d-channels with real and imaginary parts).The impurity levels $$E_{\rm imp}$$ are recorded in *eimp1.lsco* .
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
  
  * Copy the forth line of *Eimp.inp* in the *PARAMS* file (in such a way to have one line like Ed=[ ... ] ) 
  * Change accordingly the mu variable in *PARAMS*. It has to be the first value of the Ed string with inverted sign.
  * Add correct values of U, J, nf0 (equivalent of n) and beta in *PARAMS*.
  
  The Params file at the end should look like that one in the dropdown box.

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
Ed=[ -84.811465, -84.562847, -84.169182, -84.562583, -84.129468]     # Impurity levels updated by bash script
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

  * Run **atom_d.py** using the command
  
  ```
  python atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "$EIMP"
  ```
  
  where the variable $EIMP is a copy of the third line of *Eimp.inp*. At the end the command has to look like that one in the dropdown box.

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example Eimp.inp - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

```
python atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "Eimp=[ ........]"
```

Pay attention to quotes and double quotes!

{::nomarkdown}</div>{:/}

  Running **atom_d.py** generates a file called *actqmc.cix* used by the ctqmc solver.

  The ctqmc run	should now be sent using a submission script on, let's say, 20 cores. Important parameters (that may need to be adjusted during the loop) are **nom**, **Nmax** and **M**. Their explanation is reported as a comment in the *PARAMS* file itself. To start with, we can set them to **nom 130**, **Nmax 200** and  **M 20000000** as shown above.

  After the run you need to broad sigma using the program **brad_sig.x**
  
  ``` 
  cd itX_qmcrun
  cp ../qmcinput/broad_sig.x .
  echo 'Sig.out 130 l "55  20  130" k "1 2 3 4 5"'| ./broad_sig.x > broad.log
  ```
  
  For a clearer explanation on how **broad_sig** works, we refer to its commented header.
  
### Converging to the SC-solution
The self-consistent condition holds when $$G_{\rm loc}$$ of iteration _N_ is equal (within a certain tolerance) to $$G_{\rm imp}$$ of iteration _N-1_. The flag '--gprt' tells **lmfdmft** to print $$G_{\rm loc}$$ on a file called *gloc* that can be compared with the file **g_qmc.dat** produced by the previous CTQMC run. 

An other easy way to estimate convergence (and pretty accurate too) is to look at the convergence of $$E_{\rm imp}$$. This can be done by keeping track of how the third line of _eimp1_ file changes from one iteration to the next.

A third method is of course to visualise the convergence of each separate channel of local quantities like _Sig.out.brd_ or *g_qmc.dat* 

In this tutorial, a reasonable convergence is achieved after around 10 iterations.
How to handle the converged DMFT result is the subject of the [third](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft3) and the [fourth](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft4) tutorials, while in the [second one](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft2) we will focus on possible source of errors, technical aspects to speed up the convergence and rule of thumbs to define the input parameters.
