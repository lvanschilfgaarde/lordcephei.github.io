---
layout: page-fullwidth
title: "First tutorial on QSGW+DMFT"
permalink: "/dmft0/"
sidebar: "left"
header: no
---

# Introduction to the QSGW+DMFT tutorials

[comment]: # (### General introduction to the QSGW+DMFT idea )
[comment]: # (The basic idea of Dynamical Mean Field Theory is to treat the electronic properties of highly localised electronic levels (d- or f-electrons) interacting with the other electrons of the system as local impurities in interaction with an external bath. This approach requires a partitioning of the system into a correlated subspace and the rest. The correlated subspace is mapped onto an equivalent Anderson impurity model and solved with dedicated techniques able to account for all local correlations (beyond the Random Phase Approximation). The rest is treated at a lower level of theory (in our case QSGW).  )

[comment]: # (This partitioning brings also a conceptual distinction between the lattice problem and the impurity problem. Lattice quantities are defined in the actual material. Relevant lattice quantities can be the Green's function, the Self-energy or the chemical potential. Moreover they can be non-local (for instance the Green's function G as in QSGW) or they can be projected to a local subspace. In the latter case we will refer to the local Green's function as $$G_{\rm loc}$$.)

[comment]: # (The impurity problem instead is related to the Anderson model. The impurity Green's function ($$G_{\rm imp}$$, local by definition) depends on quantities like the impurity level, the impurity Self-energy, the effective interactions U and J and the hybridization function Delta, which accounts for the coupling between the impurity and the bath.)

[comment]: # (These two in principle unrelated pictures are actually linked by the hybridization function that in the present framework is constructed from the QSGW electronic structure. The full picture is self-consistent whenever the local part of the lattice Green's function equals the impurity Green's function. Namely, the self-consistent relation reads $$G_{\rm loc}=G_{\rm imp}$$)

[comment]: # ( ### General introduction to the QSGW+DMFT algorithm )
The general framework of the QSGW+DMFT method (true also for LDA+DMFT) relies on a separation of the whole problem into a lattice and an impurity problem (see theoretical details). The solution of the joint problem is found by repeatedly hopping from one picture to the other, each time using the output of one calculation to improve the input of the successive. Projection and embedding operations allow for transitions from one picture to the other.

The solution of each of the two pictures relies on a self-consisten procedure. For the lattice problem it is the QSGW loop (see dedicated tutorials), whereas for the impurity picture we speak of the DMFT loop. The two loops are closed in a larger loop (density or self-energy loop) that allows for a fully self-consistent description. A schematic representation is depicted in the figure below.

![alt text][qsgwdmft-loop]

[qsgwdmft-loop]: assets/img/qsgwdmft-loop.png "QSGW+DMFT loop"

### Structure of this tuotrial section
1. The first tutorial (_dmft1_) is about how to perform a DMFT loop until convergence.
2. The second one (_dmft2_) is about possible errors and some indications and rules-of-thumb to adjust parameters in performing a DMFT loop.
3. The third tutorial (_dmft3_) is about how to close the density loop by means of the static spin-averaged+spin-flip approach.
4. The forth tutorial (_dmft4_) is about how to close the density loop by updating the density with the dynamical approach (standard method).