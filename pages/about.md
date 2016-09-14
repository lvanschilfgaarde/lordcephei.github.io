---
layout: page-fullwidth
title: "About"
permalink: "/about/"
header:
    image_nologo: "banner_grey.jpg"
---

The *Questaal* Suite offers a range of electronic structure programs that can be used to model different materials and nanoscale structures.  Most of the codes use an all-electron implementation of density-functional theory. This includes several forms (hamiltonian and Green's function) that serve different purposes.  There is additionally an all-electron implementation of GW theory, including a quasiparticle self-consistent form of it.  Finally there is package that enables tight-binding calculations based on user-supplied empirical hamiltonians.

These codes share in common a basis set of atom-centred functions.  The basis has its genesis in the Linear Muffin Tin Orbitals (LMTO) method of O. K. Andersen, who formulated the theory of [linear methods in band theory](http://dx.doi.org/10.1103/PhysRevB.12.3060).  The LMTO and LAPW (Linear Augmented Plane Wave) methods are the most common direct forms of the linear methods, though most approaches (including those based on pseudopotentials) depend on a linearization as well.  The present code is a descendent of the "tight binding linear method" that formed the mainstay of Andersen's group in Stuttgart for many years.

Applications include modeling electronic structure, magnetic properties of materials, Landauer-Buttiker formulation of electronic transport, impurity effects in solids, and linear response.

Packages distributed in the Questaal suite include:

+ **Full Potential LMTO:**   This is an all-electron implementation of density-functional theory using convolutions of Hankel functions and Gaussian orbitals as a basis set.  This code also provides an interface to a GW package. It is a fairly accurate basis, and has been benchmarked against other all-electron schemes [XXX ... check with Jerome].  You can also use Augmented Plane Waves as a basis, or a combination of the two, as described in
[this paper](http://link.aps.org/doi/10.1103/PhysRevB.81.125117).
A new, highly accurate tight-binding basis will soon be available, with the moniker "Jigsaw Puzzle Orbitals" (JPO's).
[This page](https://lordcephei.github.io/fpintrotut.md) presents a basic tutorial
for the main program **lmf.**{: style="color: blue"}.

+ **GW:** A separate package contains an all-electron implementation of the _GW_
approximation, using the full-potential package to supply a front end with single particle
quantities GW requires. The _GW_ packages also a "product basis" set for two-particle
quantities such as the bare and screened coulomb interaction.  Its primary
function is to calculate quasiparticle levels (or more generally
energy band structure) within _GW_ theory.  Also part of this package is the
ability to calculate optical and spin response functions, and spectral
functions. See [this paper](http://link.aps.org/abstract/PRB/v76/e165106) for the theory corresponding to
the present implementation.  The present code is a descendent of the original
[original ecalj package](github.com/tkotani/ecalj) developed by Kotani, Faleev and van Schilfgaarde.

The _GW_ package also has the ability to carry out quasiparticle
self-consistency (QSGW).  _GW_ is usually implemented as an extension
to the LDA, i.e. _G_ and _W_ are generated from the LDA.
QS<i>GW</i> may be thought of as an
optimised form of the <i>GW</i> approximation of Hedin.
Self-consistent calculations are more expensive than usual
formulations of _GW_ based on a perturbation of density functional
theory, but it is [much more accurate and
systematic](http://link.aps.org/abstract/PRL/v96/e226402).
Self-consistency also removes dependence on the starting point and
also makes it possible to generate ground state properties that are
sensitive to self-consistency, such as the magnetic moment.

Both _GW_ and self-consistent _GW_ are executed through a family of scripts.  The
script for self-consistent calculations is called **lmgwsc**{: style="color:
blue"}; one-shot _GW_ calculations use **lmgw1-shot**{: style="color: blue"}; and
other parts such as the dielectric function calculator and self-energy maker use
**lmgw**{: style="color: blue"}.  **lmfgws**{: style="color: blue"} carries out
post-processing analysis of the dynamical self energy.

+ **LMTO-ASA:** The original formulation of the LMTO method included
the Atomic Spheres Approximation (ASA). Crystals are divided up into
overlapping spheres, and only the l=0 component of the potential
inside each sphere is kept.  This approximation is very efficient ---
speeds rival those found in empirical tight-binding approaches, but
its range of validity is limited.  This is because sphere must fill
space; hence there is a geometry violation that becomes severe if the
spheres overlap too much. It works best for close-packed systems, and
still remains today one of the best and most highly efficient approach
to studying magnetic properties of reasonably close-packed systems.
The ASA package can be used in a non-collinear framework.  The executable
binary is called **lm.**{: style="color: blue"}

+ **Green's Function LMTO :** An ASA based density-functional Green's
function formulation.  The program, **lmgf**{: style="color: blue"}, calculates the Green’s
function for a periodic system, and is a Green's function counterpart
to the lm code.  It can be used to determine a range of properties
including the density of states, energy band structure, and magnetic
moment.  It also has the ability to calculate magnetic exchange
interactions and some other properties of linear response.  This code
can include spin-orbit coupling perturbatively, and it also has a
fully relativistic Dirac formulation.  It also implements the
Coherent Potential Approximation, for the study of alloys, or for
disordered local moments, re a combination of the two.

+ **Principal Layer Green's Function :** This code, **lmpg**{: style="color: blue"}, is an analog of
**lmgf**{: style="color: blue"} for layered systems.  Periodic boundary conditions are used in two
dimensions.  A Principal layer technique is used for the dimension.  This is
advantageous because (1) periodic boundary conditions in this dimension are not
needed and (2) the computation time scales only linearly in the number of
principal layers.  It can be used in a self-consistent framework, and also to
calculation transmission using Landauer-Buttiker theory.  There is a
non-equilibrium Keldysh formulation of the ASA hamiltonian of the theory
described in [this paper](http://link.aps.org/doi/10.1103/PhysRevB.71.195422).

+ **QSGW + DMFT :** When localised electronic orbitals (*d-* or *f-* type)
participate to the valence region, the effect of electronic correlation can not
be included as a small perturbation (RPA) and more accurate methods have to be
invoked. The Questaal code has been interfaced with the Continuous Time Quantum
Monte Carlo solver
[developed](http://journals.aps.org/prb/abstract/10.1103/PhysRevB.75.155113) by
K. Haule and coworkers. This couples the QSGW description of the lattice with
state-of-the-art Dynamical Mean Field Theory approaches.  This code requires
that Haule's CTQMC be installed.  The interface to that code is **lmfdmft**{: style="color: blue"}.

+ **Empirical Tight-Binding :** The **tbe**{: style="color: blue"} code evaluates properties of the
electronic structure from an empirical hamiltonian.  The user supplies rules
that defines the matrix elements of an atom-centred, tight-binding hamiltonian.
It has various features, including self-consistency for ionic systems, molecular
dynamics, and implementation on GPU cards for fast execution.
