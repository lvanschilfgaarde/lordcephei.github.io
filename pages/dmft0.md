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

# Introduction to the QSGW+DMFT tutorials

### General introduction to the QSGW+DMFT idea 
[comment]: # (The basic idea of Dynamical Mean Field Theory is to treat the electronic properties of highly localised) [comment]: # (electronic levels (d- or f-electrons) interacting with the other electrons of the system as local impurities in) [comment]: # (interaction with an external bath.)
[comment]: # (This approach requires a partitioning of the system into a correlated subspace and the rest.)
[comment]: # (The correlated subspace is mapped onto an equivalent Anderson impurity model and solved with dedicated) [comment:] # (techniques able to account for all local correlations (beyond the Random Phase Approximation). )
[comment]: # (The rest is treated at a lower level of theory (in our case QSGW).  )

[comment]: # (This partitioning brings also a conceptual distinction between the lattice problem and the impurity problem.) [comment]: # (Lattice quantities are defined in the actual material. Relevant lattice quantities can be the Green's function,) [comment]: # (the Self-energy or the chemical potential. Moreover they can be non-local (for instance the Green's function G) [comment]: # (as in QSGW) or they can be projected to a local subspace. In the latter case we will refer to the local Green's) [comment]: # (function as Gloc.)

[comment]: # (The impurity problem instead is related to the Anderson model. The impurity Green's function (Gimp, local by) definition) depends on quantities like the impurity level, the impurity Self-energy, the effective interactions U and J and the hybridization function Delta, which accounts for the coupling between the impurity and the bath.

[comment]: # (These two in principle unrelated pictures are actually linked by the hybridization function that in the present framework is constructed from the QSGW electronic structure. The full picture is self-consistent whenever the local part of the lattice Green's function equals the impurity Green's function. Namely, the self-consistent relation reads Gloc=Gimp)

### General introduction to the QSGW+DMFT algorithm 
The general framework of the QSGW+DMFT (but also LDA+DMFT) precisely reflects this separation in two pictures. The solution of the joint problem is then found by repeatedly hoping from one picture to the other, each time using the output of one calculation to improve the input of the successive. All transitions between the two pictures are done by exploiting the self-consisten relation above.  

The solution of each picture relies on a self-consisten procedure. For the lattice problem it is the QSGW loop (see tutorial ...), for the impurity picture we speak about the DMFT loop. The two loops are closed in a larger loop (density or self-energy loop) that allows for a fully self-consistent description. A pictorial representation is depicted in the figure below.
![alt text][qsgwdmft-loop]

[qsgwdmft-loop]: https://github.com/lorenzo-sponza/lordcephei.github.io/pages/qsgwdmft-loop.png "QSGW+DMFT loop"

### Structure of this tuotrial section
1. The first tutorial (_dmft1_) is about how to perform a DMFT loop until convergence.
2. The second one (_dmft2_) is about possible errors and some indications and rules-of-thumb to adjust parameters in performing a DMFT loop.
3. The third tutorial (_dmft3_) is about how to close the density loop by means of the static spin-averaged+spin-flip self-energy approach.
4. The forth tutorial (_dmft4_) is about how to close the density loop by updating the density with the dynamical approach (standard method).
