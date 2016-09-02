---
layout: page-fullwidth
title: "About"
permalink: "/about/"
header:
    image_nologo: "banner_grey.jpg"
---

The *Questaal* Suite offers a range of electronic structure programs that can be used to model different materials and nanoscale structures.  Most of the codes use an all-electron implementation of density-functional theory. there is additionally an all-electron implementation of GW theory, including a quasiparticle self-consistent form of it.  Additionally there is package that enables tight-binding calculations based on user-supplied empirical hamiltonians.

These codes share in common a basis set of atom-centred functions.  These functions have their genesis in the Linear Muffin Tin Orbitals basis of O. K. Andersen, who formulated the theory of linear methods in band theory [Phys. Rev. B12, 3060 (1975)].  The LMTO and LAPW methods are the most common direct forms of the linear methods, though other schemes such as pseudopotentials depend on a linearization as well.  The present code is a descendent of the "tight binding linear method" that formed the mainstay of Andersen's group in Stuttgart for many years.

Applications include modeling electronic structure, magnetic properties of materials, Landauer-Buttiker formulation of electronic transport, impurity effects in solids, and linear response.

Packages distributed in the Questaal package include:

+ **Full Potential LMTO:**   This is an all-electron implementation of density-functional theory using convolutions of Hankel functions and Gaussian orbitals as a basis set.  Th
is code also provides an interface to a GW package. It is a fairly accurate basis, and has been benchmarked against other all-electron schemes [XXX ... check with Jerome].  You can also use Augmented Plane Waves as a basis, or a combination of the two, as described in 
[this paper](http://link.aps.org/doi/10.1103/PhysRevB.81.125117).
A highly accurate tight-binding form will soon be available, with the moniker "Jigsaw Puzzle Orbitals" or JPO's.
The main executable code is called **lmf.**{: style="color: blue"}

+ **GW:** A separate package contains an all-electron implementation of the GW
approximation, using the full-potential package to set up the single particle
basis, and provide an interface, and a "product basis" set for two-particle
quantities such as the bare and screened coulomb interaction.  The primary
function of this package is to calculate quasiparticle levels (or more generally
energy band structure) within GW theory.  Also part of this package is the
ability to calculate optical and spin response functions, and spectral
functions. See Phys. Rev. B76, 165106 (2007) for the theory corresponding to
this implementation.  The present package is a descendent of the original
[original ecalj package](github.com/tkotani/ecalj) developed by Kotani, Faleev and van Schilfgaarde.

The GW package also has the ability to carry out quasiparticle self-consistency. It is more expensive than usual formulations of GW based on a perturbation of density functional theory, but vastly more accurate and more systematic; see Phys. Rev. Lett. 96, 226402 (2006).  Self-consistency removes dependence on the starting point and also makes it possible to generate ground state properties that are sensitive to self-consistency, such as the magnetic moment.

Both GW and self-consistent GW are executed through a family of scripts.
The script for one-shot calculations is called **lmgwsc**{: style="color: blue"}; one-shot GW calculations use **lmgw1-shot**{: style="color: blue"}; and other parts such as the dielectric function calculator and self-energy maker use **lmgw**{: style="color: blue"}.

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

In more detail, the system is divided up into three regions, two contacts and a
central device region. The two contact regions are taken to extend to infinity
in the third dimension. The device region is divided up into a series of layers
where only nearest neighbor interactions between layers are considered. Green’s
function approaches are a natural choice for transport calculations since the
information on the contacts can be incorporated into the Hamiltonian for the
device region through an additional self energy term. **lmpg**{: style="color: blue"} has been used to
examine transport in devices ranging from magnetic tunnel junctions to atomic
point contacts.

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

