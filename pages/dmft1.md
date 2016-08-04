---
layout: page-fullwidth
title: "First tutorial on QSGW+DMFT"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/dmft1/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />
# First tutorial on QSGW+DMFT calculation: The DMFT loop


<hr style="height:5pt; visibility:hidden;" />
### Introduction

As explained in the introduction to QSGW+DMFT (tutorial dmft0 TO BE DONE), the fundamental step of DMFT is the self-consistent solution of the (local) Anderson impurity problem. This is connected to the electronic structure of the material (bath) through the hybridization function, the impurity level and the effective interactions U and J.
 
The self-consistent DMFT loop is composed by the following steps:\\
1. The lattice Green's function is projected onto the local correlated subsystem (G~loc~) to define the hybridization function (Delta) and the impurity levels (Eimp).\\ 
2. These two quantities together with the effective interactions U and J are passed to the Continuous Time Quantum Monte Carlo (CTQMC) solver which computes the corresponding impurity self-energy and the impurity Greens function (G~imp~).\\
3. The double counting is subtracted from it and result is embedded into an updated lattice Green's function. The loop then starts again from point 1. untill G~imp~ is equal to G~loc~.

In this tutorial, we will go through the steps needed to run the DMFT loop until convergence. 
This will be done starting from a converged QSGW of the paramagnetic phase of La~2~CuO~4~.

In tutorial dmft2 we will highlight some possible source of error and how to prevent them.


### Set up of the calculation 
After copying the relevant files in the input folders, you need to compile broad_sig.f90 and add a command line to the ctrl file. 
You can type the following commands:
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
mkdir lmfinput qmcinput                              # prepare input folders
cp *.lsco lmfinput                                   # copy input files relevant for lmfdmft
gfortran -o broad_sig.x broad_sig.f90                # compile (here with gfortran) the broadening program
cp atom_d.py broad_sig.x Trans.dat PARAMS qmcinput/  # copy files and programs relevant for CTQMC
echo 'DMFT    PROJ=2 NLOHI=11,53 BETA=50 NOMEGA=1999 KNORM=0' >> lmfinput/ctrl.lsco  # add a line to the ctrl file 
</div>
The token NLOHI defines the projection window in band index, BETA is the inverse temperature in eV^{-1} and NOMEGA is the number of Matsubara frequencies in the mesh. 

After that, you can create an empty impurity self-energy to start the loop.
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
mkdir sigfreq0
cd sigfreq0
cp ../lmfinput/*  . 
lmfdmft lsco -vnk=4 -rs=1,0 --ldadc=82.2 -job=1
</div>


THE LOOP:
The loop is composed by alternated runs of lmfdmft and ctqmc, the output of each run being the input for the successive.
1. Prepare an lmfdmft run 
mkdir it#_lmfrun (with #=iteration , #=1 if first run)  
cp lmfinput/* it#_lmfrun  ; cd it#_lmfrun
if #/=1, then :
 cp it(#-1)_qmcrun/Sig.out.brd it#_lmfrun/sig.inp
 cp it(#-1)_qmcrun/g_qmc.dat   it#_lmfrun/gimp.prev.lsco
else if #==1 then:
 cp siginp0/sig.inp it1_lmfrun/sig.inp
Then launch lmfdmft lsco -vnk=4 --rs=1,0 --ldadc=$Edc -job=1 where $Edc=U(n-1/2)-J(n/2-1/2) with U and J Hubbard on-site interaction and Hunds coupling nand n nominal occupancy (n=9 for cuprates). A reasonable value for this tutorial are U=10 eV and J=0.7 eV, leading to $Edc=82.2
The hybridization function is stored in delta.lsco (first column are Matsubaras energies and then five d-channels (each real and imaginary).The impurity levels are recorded in eimp1.lsco 

2. Prepare a ctqmc run 
mkdir it#_qmcrun/run1 (with #=iteration)
cp qmcinput/Trans.dat     it#_qmcrun/
cp qmcinput/PARAMS        it#_qmcrun/
cp qmcinput/atom_d.py     it#_qmcrun/
cp it#_lmfrun/delta.lsco  it#_qmcrun/Delta.inp
cp it#_lmfrun/eimp1.lsco  it#_qmcrun/Eimp.inp
copy the forth line of Eimp.inp in the PARAMS file (in such a way to have only one line like Ed=[ ..... ) and change accordingly the mu variable in PARAMS (it has to be the first value of the Ed string with inverted sign).
run atom_d.py using the command
atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False Eimp=[   0.000000,   0.248617,   0.642283,   0.248882,   0.681997] where the last command is copied from the third line of Eimp.inp
Add correct values of U, J, nf0 and beta in PARAMS. The Params file at the end should look like the following ... 

The run	should now be send using a submission script. 
Important parameters (that may need to be adjusted during the loop) are 
nom
Nmax 
M 

to start we can set them to nom 120 Nmax 200 and M 75000000
After the run you need to broad sigma using the program brad_sig.f90 
EXPLAIN WHAT ARE THE STATUS FILES


