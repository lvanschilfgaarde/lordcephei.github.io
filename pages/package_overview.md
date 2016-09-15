---
layout: page-fullwidth
title: "Package Overview"
permalink: "/docs/package_overview/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This page gives an overview of the Questaal suite, a family of codes
that use augmented-wave methods to solve the Schrodinger equation in solids and
obtain properties derived from it.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Introduction_

The Questaal suite consists of a collection of electronic structure codes based on the local-density approximation (LDA)
to density-functional theory (DFT) to solids, with extensions to _GW_ and interface to a Dynamical Mean Field theory
code (DMFT) written by K. Haule.  Most of the programs in the Questaal suite descended the LMTO methodology developed in
the 1980's by O.K. Andersen's group in Stuttgart.

[This page](https://lordcephei.github.io/about/) outlines some of
Questaal's unique features, in particular the ability to carry out
quasiparticle self-consistent calculations.

Questaal codes have been written mainly by M. van Schilfgaarde, though [many people have made important
contributions](https://lordcephei.github.io/lmf_tutorial/).  Download the package [here](https://bitbucket.org/lmto/lm)
and see [this web page](https://lordcephei.github.io/install/) to install the package.

_____________________________________________________________

### _Augmented Wave Methods_

Augmented Wave methods, originally developed by Slater, partitions
space into spheres enclosing around each atom.  Basis functions used
to solve Schrodinger's equation consist of a family of smooth envelope
functions which are "augmented" with partial waves inside each
sphere. The choice of envelope function defines the method (Linear
Muffin Tin Orbitals, Linear Augmented Plane Waves, Jigsaw Puzzle
Orbitals); while partial waves are obtained by integrating the
Schrodinger equation numerical on a radial mesh inside the
augmentation sphere.  The reason for augmentation is to enable basis
functions to vary rapidly near nuclei where they must be orthogonalized to
core states.

Augmented-wave methods consist of an "atomic" part that solves for the partial waves on a numerical mesh inside
augmentation spheres and makes the relevant matrix elements needed, e.g. for the hamiltonian or some other property
(e.g. optics) and a ``band'' part, that diagonalizes the secular matrix of the hamiltonian made by the
augmented envelope functions.

_____________________________________________________________

### _Questaal's Basis Functions_

The primary code in the density-functional package (**lmf**{: style="color: blue"}) uses atom-centered functions for
envelope functions. They are convolutions of a Hankel and Gaussian functions centred at the nucleus.  Thus 
in contrast to ordinary Hankel functions (the envelope functions of the LMTO method), which are singular at the origin,
they resemble Gaussian functions for small _r_ and are smooth there.  For large _r_ they behave like ordinary Hankel functions
and are better approxiations to the wave function than Gaussian orbitals are.  The mathematical properties of
these functions are described in some detail in [this paper](http://scitation.aip.org/content/aip/journal/jmp/39/6/10.1063/1.532437)

Such a basis has significant advantages --- basis sets are much smaller for a given level of precision, but they are
also more complex.  It is also possible to take a combination of these functions and plane waves -- another unique
feature of this package.

**Note**{: style="color: red"}: some codes in this package are based on the [Atomic Spheres Approximation](https://lordcephei.github.io/lmto_asa_doc.md/);
they use LMTO basis sets.

_____________________________________________________________

### _Augmentation_

**lmf**{: style="color: blue"} carries out augmentation in a manner different than standard augmented wave methods.  It
somewhat resembles the PAW method, though in the limit of large angular momentum cutoff it has exactly the same behavior
that standard augmented-wave methods do.  The advantage to the current scheme is that it converges more rapidly with
angular momentum cutoff.

_____________________________________________________________


### _Executable codes in the Questaal suite_

The Questaal family of executable programs share a common, elegant [input system](https://lordcephei.github.io/pages/input-file-style.html),
and has some elements of a programming language.  A reference defining the syntax of categories and tokens can be found in [this pdf file](https://lordcephei.github.io/pages/input.pdf).

The family consists of the following:

+ **blm**{: style="color: blue"}: an input file generator, given structural information.  [Many of the tutorials](https://lordcephei.github.io/lmf_pbte_tutorial/) use **blm**{: style="color: blue"}.
**cif2init**{: style="color: blue"} and **cif2site**{: style="color: blue"}: convert structural information contained in _cif_{: style="color: green"} files to a form readable by Questaal. **poscar2init**{: style="color: blue"} and **poscar2site**{: style="color: blue"}: perform a similar function, reading VASP _POSCAR_{: style="color: green"} files.

+ **lmf**{: style="color: blue"}: the standard full-potential LDA band program.  It has a companion program **lmfa**{: style="color: blue"} to calculate starting wave functions for free atoms and supply parameters for the shape of envelope functions.  See [here](https://lordcephei.github.io/lmf_tutorial/) for a basic tutorial.
There is an MPI version, **lmf-MPIK**{: style="color: blue"}.

+ **lmgw1-shot**{: style="color: blue"} and **lmgwsc**{: style="color: blue"}: scripts that perform GW calculations (one-shot or self-consistent), or properties related to GW. The interface connecting to the _GW_ code is **lmfgwd**{: style="color: blue"}.  A basic tutorial for the GW package can be found [here](https://lordcephei.github.io/lmtut/).

+ **lm**{: style="color: blue"}: a density functional band program [based on the Atomic Spheres Approximation](https://lordcephei.github.io/lmto_asa_doc/) (ASA).  It requires a companion program **lmstr**{: style="color: blue"} to make structure contants for it.  A basic tutorial can be found [here](https://lordcephei.github.io/asa-doc/).
There is an MPI version, **lm-MPIK**{: style="color: blue"}.

+ **lmgf**{: style="color: blue"}: a density functional band program based on the ASA, using a Green's function formalism.
Its unique contribution to the suite is that it permits the calculation of magnetic exchange interactions, and it 
has an implementation of the coherent potential approximation to treat chemical and/or spin disorder.
A basic tutorial can be found [here](https://lordcephei.github.io/lmgf-tutorial/).
There is an MPI version, **lmgf-MPIK**{: style="color: blue"}.

+ **lmpg**{: style="color: blue"}: a program similar to **lmgf**{: style="color: blue"}, but it is designed for layered structures with periodic boundary conditions in
 two dimensions.  It can calculate transport using the Landauer-Buttiker formalism, and has a non-equilibrium capability.  There 
[a tutorial](https://lordcephei.github.io/pages/lmpg_tutorial.v2.0.pdf/), though it is somewhat out of date.
There is an MPI version, **lmpg-MPIK**{: style="color: blue"}.

+ **lmfdmft**{: style="color: blue"}: the main interface that links to the DMFT capabilities.

+ **tbe**{: style="color: blue"}: an efficient band structure program that uses empirical tight-binding hamiltonians. One unique feature of this package is that self-consistent calculations can be done (important for polar compounds), and includes Hubbard parameters.  It is also highly parallelized, and versions can be built that work with GPU's.

+ **lmdos**{: style="color: blue"}: generates partial densities of states. It is run as a postprocessor after
     execution of **lmf**{: style="color: blue"}, **lm**{: style="color: blue"}, or **tbe**{: style="color: blue"}.

+ **lmfgws**{: style="color: blue"}: a postprocessing code run after a _GW_ calculation to analyze spectral functions.

+ **lmscell**{: style="color: blue"}: a supercell maker.

+ **lmchk**{: style="color: blue"}: a neighbor table generator and augmentation sphere overlap checker. There is an
option to automatically determine sphere radii, and another option to locate interstitial sites where empty spheres or
floating orbitals may be placed --- important for ASA and some _GW_ calculations.

+ **rdcmd**{: style="color: blue"}:  a command reader, similar to a shell, but uses Questaal's parser and programming language.

+ **lmxbs**{: style="color: blue"}: generates input for the graphics program **xbs**{: style="color: blue"} written by M. Methfessel, which draws pictures of crystals

+ **lmmc**{: style="color: blue"}: a (fast) LDA-based molecules program (not documented).

Some other auxiliary programs are also made.

### _Input System_

All executables use a common input system.  It is a unique system that parses
input in a largely format-free, tree-structured format.  There is some
programming language capability: e.g. input lines can be conditionally
read, you can declare variables and use algebraic expressions.  Thus the
input file can be [quite simple](https://lordcephei.github.io/tutorial/lmf/lmf_tutorial/),
or very detailed, even serving as a database for many materials. This [this tutorial](https://lordcephei.github.io/docs/input/inputfile/)
explains how an input file is structured, and how input is organized by _categories_ and _tokens_. 

### _Other Resources_

This book chapter describes the theory of the **lmf**{: style="color: blue"} code.
It is a bit dated but the basics are unchanged.  
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in _Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method_, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.

The mathematics of smoothed Hankel functions **lmf**{: style="color: blue"} uses
are described in this paper:  
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
_Nonsingular Hankel functions as a new basis for electronic structure calculations_,
[J. Math. Phys. 39, 3393 (1998)](http://dx.doi.org/10.1063/1.532437)

This classic paper laid out the framework for linear methods in band theory:
O. K. Andersen, "Linear methods in band theory,"
[Phys. Rev. B12, 3060 (1975)](http://dx.doi.org/10.1103/PhysRevB.12.3060)

This is paper laid out the framework for tight-binding LMTO:
O. K. Andersen and O. Jepsen,
"Explicit, First-Principles Tight-Binding Theory," 
[Phys. Rev. Lett. 53, 2571 (1984)](http://dx.doi.org/10.1103/PhysRevLett.53.2571)

This paper explains how LAPW and generalized LMTO methods can be joined:
T. Kotani and M. van Schilfgaarde,
_A fusion of the LAPW and the LMTO methods: the augmented plane wave plus muffin-tin orbital (PMT) method_,
[Phys. Rev. B81, 125117 (2010)](http://dx.doi.org/10.1103/PhysRevB.81.125117)

This paper presented the first description of an all-electron _GW_ implementation in a mixed basis set:
T. Kotani and M. van Schilfgaarde,
_All-electron <i>GW</i> approximation with the mixed basis expansion based on the full-potential LMTO method_,
 Sol. State Comm. 121, 461 (2002).

These papers laid out the framework for QuasiParticle Self-Consistent _GW_ theory:
Sergey V. Faleev, Mark van Schilfgaarde, Takao Kotani,
_All-electron self-consistent GW approximation: Application to Si, MnO, and NiO_,
[Phys. Rev. Lett. 93, 126406 (2004)](http://link.aps.org/doi/10.1103/PhysRevLett.93.126406);
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
_Quasiparticle self-consistent_ GW _theory_,
[Phys. Rev. Lett. 96, 226402 (2006)](href=http://link.aps.org/abstract/PRL/v96/e226402)

Questaal's GW implementation is based on the theory in this paper:
Takao Kotani, M. van Schilfgaarde, S. V. Faleev,
_Quasiparticle self-consistent GW  method: a basis for the independent-particle approximation_,
[Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106)

This paper shows results from LDA-based GW, and its limitations:
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
_Adequacy of Approximations in <i>GW</i> Theory_,
[Phys. Rev. B74, 245125 (2006)](A href=http://link.aps.org/abstract/PRB/v74/e245125)

This book explains the ASA-Green's function formalism, including the coherent potential approximation:
I. Turek et al., Electronic strucure of disordered alloys, surfaces and interfaces (Kluwer, Boston, 1996).

