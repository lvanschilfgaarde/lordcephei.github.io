---
layout: page-fullwidth
title: "First tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft1/"
sidebar: "left"
header: no
---

# Setting up the DMFT loop

### The spin-polarized QSGW starting point 

This tutorial assumes you have terminated a spin-polarized QSGW calculation to be corrected with DMFT. Your QSGW calculation is supposed to be spin-polarized even for non-magnetic materials. For the purpose of this tutorial, we will refer to a QSGW calculation on ferromagnetic Nickel.

From [this link](https://lordcephei.github.io/assets/download/inputfiles/qsgw_ni.tar.gz) you can download the files you will need to continue the tutorial on Nickel, if instead you want to produce them by your own, you can follow the commands in the dropdown box.

<div onclick="elm = document.getElementById('qsgw_ni'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands to run QSGW on Ni from scratch - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="qsgw_ni">{:/}

The file *init.ni*{: style="color: green"} to start from scratch is: 

```
LATTICE
   SPCGRP=225
   A=3.524 UNITS=A
SITE
   ATOM=Ni X=0 0 0
SPEC
   ATOM=Ni MMOM=0.0 0.0 0.6
```

To run a full QSGW calculation follow the commands below:

```
blm ni --gw --wsitex --mag --nit=20 --nk=12 --nkgw=8 --gmax=8.7     # see LMF tutorial for details on these flags. --mag set up for spin-polarized calculations
mv actrl.ni ctrl.ni                                              
lmfa ni                                                             # Starting guess is the atomic density
mv basp0.ni basp.ni
lmf ni                                                              # Spin-polarized DFT calculation. At convergence mmom = 0.59
lmfgwd ni  --jobgw=-1                                               # GWinput
lmgwsc --wt --code2 --sym -maxit=20 --metal --getsigp --tol=2e-5 ni # actual QSGW loop
```
The value of the parameters are a pretty low on purpose to run a QSGW loop in a reasonable time. We recommend to run the last step on a parallel machine (use the **\-\-openmp**{: style="color: blue"} or the **\-\-mpi**{: style="color: blue"} flag). 

{::nomarkdown}</div>{:/}

*Note:*{: style="color: red"} Of course you can also do LDA+DMFT. The procedure is basically the same, but you can ignore all reference to any *sigm*{: style="color: green"} file.

### Input folders, files and programs

Once you have a converged spin-polarized QSGW calculation you still need some additional file to run **lmfdmft**{: style="color: blue"} and **ctqmc**{: style="color: blue"}. You can download them at [this link](https://lordcephei.github.io/assets/download/inputfiles/dmft-input.tar.gz).

Let *qsgw*{: style="color: green"} the folder with the QSGW calculation and *dmft-input*{: style="color: green"} the one where you extracted the content of the .tar.gz file linked above, then you dispatch relevant input files into two folders:

```
mkdir lmfinput qmcinput                                             # input folders
cp qsgw/{ctrl,basp,site,rst}.ni lmfinput                            # copy relevant QSGW output files
cp qsgw/sigm.ni lmfinput/sigm_old                                   # you will actually need a spin-averaged version of this file
cp dmft-input/indmfl_input lmfinput/indmfl.ni                       # the indmfl file has to have the right extension 
cp dmft-input/{atom_d.py,broad_sig.f90,Trans.dat,PARAMS} qmcinput/  # copy files and programs for CTQMC runs
```

##### **Edit the ctrl file** 
You need to add some tokens to *ctrl.ni*{: style="color: green"}. 

```
cd lmfinput
echo 'DMFT    PROJ=2 NLOHI=1,8 BETA=50 NOMEGA=2000 KNORM=0' >> ctrl.ni  # add tokens at the end of ctrl.ni
```

The token **DMFT_NLOHI** defines the projection window in band index, **DMFT_BETA** is the inverse temperature in eV$$^{-1}$$ and **DMFT_NOMEGA** is the number of Matsubara frequencies in the mesh. Some details of the projection procedure are controlled by **DMFT_PROJ** and **DMFT_KNORM**, but you are not meant to change their value.

Moreover we recommend to add **% const bxc0=0** and **BXC0={bxc0}** in the **HAM** section of *ctrl.ni*{: style="color: green"} file. Setting **HAM_BXC0** to **TRUE**, tells **lmf**{: style="color: blue"} to construct $$V_{\rm xc}^{\rm LDA}$$ from the spin-averaged charge density. The reason for this will be clarified in the [fourth tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft4).

At the end, you can see how your *ctrl.ni*{: style="color: green"} should look like by clicking on the dropdown box.
<div onclick="elm = document.getElementById('ctrl-4dmft'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Example of ctrl.ni - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ctrl-4dmft">{:/}

```
# Autogenerated from init.ni using:
# blm ni --gw --wsitex --mag --nit=20 --nk=12 --nkgw=8 --gmax=8.7

# Variables entering into expressions parsed by input
% const nit=20
% const met=5
% const nsp=2 so=0
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const pwmode=0 pwemax=3          # Use pwmode=1 or 11 to add APWs
% const sig=12 gwemax=2 gcutb=3.3 gcutx=2.7  # GW-specific
% const nkabc=12 nkgw=8 gmax=8.7
% const bxc0=0

VERS  LM:7 FP:7 # ASA:7
IO    SHOW=f HELP=f IACTIV=f VERBOS=35,35  OUTPUT=*
EXPRESS
# Lattice vectors and site positions
  file=   site

# Basis set
  gmax=   {gmax}                   # PW cutoff for charge density
  autobas[pnu=1 loc=1 lmto=5 mto=4 gw=1 pfloat=2]

# Self-consistency
  nit=    {nit}                    # Maximum number of iterations
  mix=    B2,b=.3,k=7              # Charge density mixing parameters
  conv=   1e-5                     # Convergence tolerance (energy)
  convc=  3e-5                     # tolerance in RMS (output-input) density

# Brillouin zone
  nkabc=  {nkabc}                  # 1 to 3 values.  Use n1<0 => |n1| ~ total number
  metal=  {met}                    # Management of k-point integration weights in metals

# Potential
  nspin=  {nsp}                    # 2 for spin polarized calculations
  so=     {so}                     # 1 turns on spin-orbit coupling
  xcfun=  {lxcf},{lxcf1},{lxcf2}   # set lxcf=0 for libxc functionals

#SYMGRP i r4x r3d
HAM
      PWMODE={pwmode} PWEMIN=0 PWEMAX={pwemax}  # For APW addition to basis
      FORCES={so==0} ELIND=-0.7 
      RDSIG={sig} SIGP[EMAX={gwemax}]  # Add self-energy to LDA
      BXC0={bxc0}
GW    NKABC={nkgw} GCUTB={gcutb} GCUTX={gcutx} DELRE=.01 .1 
      GSMEAR=0.003 PBTOL=1e-3
SPEC 
  ATOM=Ni         Z= 28  R= 2.354453  LMX=3  LMXA=4  MMOM=0 0 0.6
DMFT    PROJ=2 NLOHI=1,8 BETA=50 NOMEGA=2000 KNORM=0
```
{::nomarkdown}</div>{:/}

#####  **Prepare spin-averaged self-energy**
Although you have done a spin-polarized calculation, the starting point of the DMFT loop has to be non-magnetic. To do that you have to produce a spin-averaged *sigm.ni*{: style="color: green"}. 

```
cp sigm_old  sigm.ni
lmf --rsig~spinav --wsig -vbxc0=1 ni > log  # read sigm, make spin-average, write it down, and quit
mv sigm2.ni sigm.ni                         # rename sigm2: you will work with this spin-averaged sigm 
cd ..
```

Check that at among the last lines of the *log*{: style="color: green"}  you find
```
 replace sigma with spin average ...
```
and 
```
 Exit 0 done writing sigma, file sigm2
```.

##### **Compile the broadening program**
The statistical noise of Quantum Monte Carlo calculations can be source of instabilities. Because of this, you need to broad the output of the **ctqmc**{: style="color: blue"} software at the end of each iteration.

In the file *dmft-input.tar.gz*{: style="color: green"} you should have downloaded, you will find *broad_sig.f90*{: style="color: green"} which has precisely this purpose. 
However you can use whatever method you prefer (but be careful in not spoiling the low- and the high-frequency limits).

```
cd qmcinput
gfortran -o broad_sig.x broad_sig.f90                  # compile (here with gfortran) the broadening program
cd ..
```
The tutorial will continue assuming you are using **broad_sig.x**{: style="color: blue"} to broaden the impurity self-energy.

### Prepare a vanishing impurity self-energy 
You start the loop from scratch by creating an empty impurity self-energy: 

```
mkdir siginp0
cd siginp0
cp ../lmfinput/*  . 
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1 > log
cd ..
```

You can check that the line 
```
Missing sigma file : create it and exit ...
```
 is written at the end of the *log*{: style="color: green"}.

The calculation has stopped just after reading the *indmfl.ni*{: style="color: green"}. A text file called *sig.inp*{: style="color: green"} has been created. It is formatted with the first column being the Matsubara frequencies (in eV) and then 0.0 repeated for a number of columns equal to twice the number of _m_ channels (e.g. ten columns for _d_-type impurity grouped in real and imaginary parts).

Of course, if you want you can start from non-vanishing *sig.inp* files (e.g. from a previously converged DMFT loop).

### ...Ready to go!
<div onclick="elm = document.getElementById('inputfolders'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> Required content of input folders - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="inputfolders">{:/}

The list of relevant files in the two input directories is

```
 $ ls -l lmfinput 
basp.ni           # basis set used in the QSGW calculation
ctrl.ni           # amended ctrl.ni file with DMFT category and HAM_BXC0={bxc0} token 
indmfl.ni         # instructions for the correlated subsystem
rst.ni            # electronic density of the spin-polarized QSGW loop
sigm.ni           # spin-averaged sigm.ni from converged QSGW loop
site.ni 

 $ ls -l qmcinput 
atom_d.py         # initialise the atomic problem in a d-electron system  
broad_sig.x       # broadens Sig.out at the end of each ctqmc run
PARAMS            # main parameters for the ctqmc calculation
Trans.dat         # translation table needed by atom_d.py
```

{::nomarkdown}</div>{:/}

You are now ready to start the DMFT loop, following the link to the [next tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft2).
