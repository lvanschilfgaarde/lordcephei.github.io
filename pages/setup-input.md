---
layout: page-fullwidth
title: "Set up input files"
permalink: "/tutorial/qsgw_dmft/setup-input/"
sidebar: "left"
header: no
---
This tutorial assumes you have terminated a QSGW calculation and you want to start a DMFT calculation.
Unless you want to try with your own data, you can downlad the outcome of a converged QSGW calculation from [this link](https://lordcephei.github.io/assets/download/inputfiles/dmft1.tar.gz). They have been obtained from a converged QSGW calculation on the paramagnetic phase of La$$_2$$CuO$$_4$$. Every example will be done assuming you are using the provided files.

### Prepare folders

Relevant files are dispatched into two folders.

```
mkdir lmfinput qmcinput                                # prepare input folders
cp *.lsco lmfinput                                     # copy input files relevant for lmfdmft
cp atom_d.py broad_sig.f90 Trans.dat PARAMS qmcinput/  # copy files and programs relevant for CTQMC
```

### Prepare the *ctrl*{: style="color: green"} file

After copying the relevant files in the input folders, you need to compile *broad_sig.f90*{: style="color: green"} and add a string of tokens to *ctrl.lsco*{: style="color: green"}. 

```
cd lmfinput
echo 'DMFT    PROJ=2 NLOHI=11,53 BETA=50 NOMEGA=1999 KNORM=0' >> ctrl.lsco  # add a line to the ctrl file 
cd ..
```
The token **DMFT_NLOHI** defines the projection window in band index, **DMFT_BETA** is the inverse temperature in eV$$^{-1}$$ and **DMFT_NOMEGA** is the number of Matsubara frequencies in the mesh. Some detail of the projection procedure are controlled by **DMFT_PROJ** and **DMFT_KNORM**, but you are not meant to change their value.

Moreover we suggest you to add **BXC0={bxc0}**{: style="color: blue"} in the **HAM**{: style="color: blue"} section of the *ctrl*{: style="color: green"} file together with **const {bxc0=0}**{: style="color: blue"}.

You can see how it should look like by clicking on the dropdown box.


### Compile **broad_sig.f90**{: style="color: blue"}

```
cd qmcinput
gfortran -o broad_sig.x broad_sig.f90                  # compile (here with gfortran) the broadening program
cd ..
```

### Prepare spin-averaged self-energy

### Prepare a vanishing impurity self-energy 
Unless you want to rely on some previous calculation, you start the loop from scratch by creating an empty impurity self-energy. 

```
mkdir siginp0
cd siginp0
cp ../lmfinput/*  . 
lmfdmft lsco -vnk=4 -rs=1,0 --ldadc=82.2 -job=1  > log
```

You can check that a file called *sig.inp*{: style="color: green"} has been created. It is formatted with the first column being the Matsubara frequencies (in eV) and then a number of columns equal to twice the number of _m_ channels (e.g. ten columns for d-type impurity: five pairs of real and imaginary parts).


