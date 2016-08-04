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

### General introduction to the QSGW+DMFT algorithm
The basic idea of Dynamical Mean Field Theory is to treat the electronic properties of highly localised electronic levels (d- or f-electrons) in interaction with the other itinerant electrons of the system as local impurities in interaction with an external bath. 
This approach requires a partitioning of the system into a correlated subspace and the rest.
The correlated subspace is mapped onto an equivalent Anderson impurity model and solved with dedicated techniques able to account for all local correlations (beyond the Random Phase Approximation). 
The rest is treated at a lower level of theory (in our case QSGW) and it plays the role of the bath. 

This partitioning brings also a conceptual distinction between the lattice problem and the impurity problem. Lattice quantities are defined in the actual material. Relevant lattice quantities can be the Green's function, the Self-energy or the chemical potential. Moreover they can be non-local (as in QSGW) or they can be projected to a local subspace. They will still belong to the lattice problem. 

The impurity problem instead is related to the Anderson model. The impurity Green's function (local by definition) depends on quantities like the impurity level, the impurity Self-energy, the effective interactions U and J and the hybridization function Delta, which accounts for the coupling between the impurity and the bath.

These two in principle unrelated pictures are actually linked by the hybridization function that in the present framework is constructed from the QSGW electronic structure.


1. First you converge the QSGW description of the material.
2. bal bal

### Projection and Embedding
