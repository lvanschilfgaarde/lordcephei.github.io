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
 
The self-consistent DMFT loop is composed by the following steps:

1  The lattice Green's function is projected onto the local correlated subsystem ($$G_{\rm loc}$$) to define the hybridization function ($$\Delta$$) and the impurity levels ($$E_{\rm imp}$$).
2  These two quantities together with the effective interactions $$U$$ and $$J$$ are passed to the Continuous Time Quantum Monte Carlo (CTQMC) solver which computes the corresponding impurity self-energy and the impurity Greens function ($$G_{\rm imp}$$).
3  The double counting is subtracted from it and result is embedded into an updated lattice Green's function. The loop then starts again from point 1. untill $$G_{imp}$$ is equal to $$G_{\rm loc}$$.

In this tutorial, we will go through the steps needed to run the DMFT loop until convergence. 
This will be done starting from a converged QSGW of the paramagnetic phase of La$$_2$$CuO$$_4$$.

In tutorial dmft2 we will highlight some possible source of error and how to prevent them.
---

<hr style="height:5pt; visibility:hidden;" />
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
cd siginp0
cp ../lmfinput/*  . 
lmfdmft lsco -vnk=4 -rs=1,0 --ldadc=82.2 -job=1
</div>
You can check that a file called sig.inp has been created. It is formatted with the first column being the Matsubara frequencies and then a number of columns equal to twice the number of $$m$$ channels (ten columns for d-type impurity: real and imaginary parts).
---

<hr style="height:5pt; visibility:hidden;" />
### Running the loop:
The DMFT loop is composed by alternated runs of lmfdmft and ctqmc, the output of each run being the input for the successive. To do that, do the following steps 

1  Prepare and launch the lmfdmft run
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
mkdir itX_lmfrun                            # with X=iteration , X=1 if first run
cp lmfinput/* itX_lmfrun                    # copy standard input files 
</div>
You also have to copy the (broadened) impurity self-energy then :
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
cp it(X1)_qmcrun/Sig.out.brd  itX_lmfrun/sig.inp
cp it(X-1)_qmcrun/g_qmc.dat   itX_lmfrun/gimp.prev.lsco
</div> if you are not running the first iteration, or 
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
cp siginp0/sig.inp it1_lmfrun/sig.inp
</div> if you are running the first iteration.

Let now $$U$$=10 eV and $$J$$=0.7 eV be the Hubbard on-site interaction and Hunds coupling respectively, and $$n$$ the nominal occupancy ($$n$$=9 for cuprates). Then launch lmfdmft with the command 
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
lmfdmft lsco -vnk=4 --rs=1,0 --ldadc=82.2 -job=1 
</div>
where 82.2 is the double counting according to the formula $$E_{\rm DC}=U(n-\frac{1}{2})-J\frac{n-1}{2}$$. The hybridization function $$\Delta(i\omega)$$ is stored in delta.lsco (first column are Matsubaras energies and then five d-channels with real and imaginary parts).The impurity levels are recorded in eimp1.lsco 

2  Prepare and launch the ctqmc run 
At the X iteration you can launch the following commands
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
mkdir itX_qmcrun                                 # the running folder
cp qmcinput/*   itX_qmcrun/                      # copy input files and relevant executables
cp itX_lmfrun/delta.lsco  itX_qmcrun/Delta.inp   # copy relevant output from lmfdmft
cp itX_lmfrun/eimp1.lsco  itX_qmcrun/Eimp.inp    # copy relevant output from lmfdmft
</div>

Now there is some manual operation to do:
1  Copy the forth line of Eimp.inp in the PARAMS file (in such a way to have one line like Ed=[ ..... ) 
2  Change accordingly the mu variable in PARAMS. It has to be the first value of the Ed string with inverted sign.
3  Run atom_d.py using the command
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
python atom_d.py J=0.7 l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False $EIMP
</div> where the variable $EIMP is a copy of the third line of Eimp.inp. This generates a file called actqmc.cix used by the solver.
4  Add correct values of U, J, nf0 (equivalent of $$n$$) and beta in PARAMS. The Params file at the end should look like the following 
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
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
</div>
The run	should now be send using a submission script on, let's say 20 cores. Important parameters (that may need to be adjusted during the loop) are nom, Nmax and M. To start with, we can set them to nom 130 Nmax 200 and M 20000000.

After the run you need to broad sigma using the program brad_sig.x
<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">
cd itX_qmcrun
cp ../qmcinput/broad_sig.x .
echo 'Sig.out 130 l "55  20  130" k "1 2 3 4 5"'| ./broad_sig.x > broad.log
</div> For a clearer explanation on how broad_six.f90 works, we refer to its commented header.


EXPLAIN WHAT ARE THE STATUS FILES


