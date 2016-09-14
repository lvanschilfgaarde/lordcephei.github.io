---
layout: page-fullwidth
title: "Full Potential Overview"
permalink: "/poverview/"
header: no
---

The **lmf** program is an all-electron implementation of the local-density approximation, with a basis consisting of generalized linear muffin tin orbitals, or **LAPWs**, or some combination of the two.

<hr style="height:5pt; visibility:hidden;" />
##### *Overview of the full-potential method*
_____________________________________________

The full-potential program **lmf** was originally adapted from a program **nfp** written by M. Methfessel and M. van Schilfgaarde. The method is described in some detail in the following reference :

M. Methfessel, Mark van Schilfgaarde, and R. A. Casali, “A full-potential **LMTO** method based on smooth Hankel functions,” in Electronic Structure and Physical Properties of Solids: The Uses of the **LMTO** Method, *Lecture Notes in Physics 535. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000*.

There is also a manual written for the original 1997 code. The present code is a descendant of it with many new features and with a different input system. But the underlying mathematical formalism, the novel augmentation method in particular, is basically the same.

*The following features are unique to this method:*

<hr style="height:5pt; visibility:hidden;" />
##### *Smoothed Hankel functions*
_____________________________________________

The envelope functions are smoothed generalizations of Hankel functions that are found in **LMTO** programs. Unlike the normal Hankel functions, the smoothed versions — convolutions of ordinary Hankel functions and Gaussian functions — are regular at the origin. They are a significantly better choice of basis than the customary **LMTO** basis set. However, the smoothing introduces complications because the augmentation of a smoothed Hankel function is less straightforward than of a normal Hankel. The envelope functions are not screened into a tight-binding representation, as in the second-generation and later generation **LMTO** methods; thus wave functions are evaluated by Ewald summation. A real-space version using screened envelope functions is in progress.

<hr style="height:5pt; visibility:hidden;" />
##### *Local Orbitals*
_____________________________________________

This package extends the linear method through the use of local orbitals. Augmented methods substitute radial solutions of the Schrödinger equation with combinations of partial waves of angular quantum number *l* inside the augmentation region. Linear methods used a fixed radial function (more precisely, pair of functions), which has validity over only a certain energy window. With local orbitals, a third radial function is added to the basis, which greatly extends the energy window over which energy eigenvalues can be calculated. It is necessary, for example, to obtain the reliable **LDA** band gap in GaAs, as the Ga *3d* and *4d* partial waves are both important. To include local orbitals in the basis, see  [here](/fpoptbas/) for documentation.

<hr style="height:5pt; visibility:hidden;" />
##### *Augmented Plane Waves*
_____________________________________________

In July 2008 Takao Kotani added **APW**s as additional envelope functions, which can increase the flexibility of the basis. One can view this package as an extension of a conventional **LAPW** method, enabling through the use of a few **MTO**s a much faster convergence in energy cutoff of **APW**s. Alternatively, it can be viewed as an extension of the original **MTO** method, A principal advantage of the **APW**s basis is that it easier to make complete. Thus **APW**s offer a systematic way of converging the combined **MTO** + **APW** basis systematic and reliable manner, to almost arbitrarily high accuracy. This is particularly important when reliable eigenvalues far above the Fermi level are needed, and to check the accuracy of a given **MTO** basis. To include **APW**s in the basis, see here for documentation.

<hr style="height:5pt; visibility:hidden;" />
##### *Augmentation and Representation of the charge density*
_____________________________________________

The charge density representation is unique to this method. It consists of three parts: a smooth density n<sub>0</sub> carried on a uniform mesh, defined everywhere in space (n<sub>0</sub> is not augmented, as occurs with conventional augmentation), the true density n<sub>1</sub> expressed in terms of spherical harmonics Ylm inside each augmentation sphere, and a one-center expansion of the smooth density n<sub>2</sub>, also expanded in terms of harmonics Ylm inside each augmentation sphere. The total density is expressed as in the “threefold representation” n = n<sub>0</sub> + n<sub>1</sub> – n<sub>2</sub>.

This turns out to be an extremely useful way to carry out the augmentation procedure. Quantities converge much more rapidly in the *l*-truncation in the augmentation sphere than occurs in conventional augmented wave constructions. (The analysis is a little subtle; see the reference at the start of this document.)

The full-potential program builds on the basic package (documented in this [file](/lmtut/)) which contains an implementation of a tight-binding **LMTO** program in the Atomic Spheres Approximation (**ASA**), and shares most things in common with it, including a number of auxiliary programs useful to both **ASA** and **FP**. For example, both methods are linear augmented-wave methods, and the wave functions inside the augmentation spheres are equivalent in the two cases. The reader is strongly advised to review that documentation before proceeding with this one. There are some differences in input between the two programs. A description of tokens available to this method are documented [here](/inputguide/); which specifies which tokens can and cannot be used with this and other methods within the package. There is also a description of tokens specific to this method located in Section 3. See the [input file tutorial](/inputguide/) or the [FP tutorial](/fpnew/) for a tutorial that helps you build an input file, and explains the output, and the [**ASA** tutorial](/asadoc/) for a corresponding tutorial for the **ASA** programs.

One important difference between the **ASA** and **FP** methods is that the **FP** method has no neat parametrization of total density in terms of the **ASA** energy moments Q<sub>0</sub>, Q<sub>1</sub>, Q<sub>2</sub>, or the representation of the potential by a few potential parameters, as in the **ASA** (see **ASA** overview in [here](/asadoc/)). However, the basis within the augmentation spheres is defined from the spherical average of the potential, just as in the **ASA**, and the linearization proceeds in the same way. Program **lmf** uses the same “continuously variable principal quantum numbers” *P* described to establish a mapping between the linearization energy and logarithmic derivative at the **MT** boundary, and to float the linearization energy to band center-of-gravity. Thus, the description of *P* and **IDMOD** equally apply to the **ASA** and this program.

A second important difference is that the basis set is more complicated, and in its current form, the user must choose parameters defining the basis. This complication is the most onerous part of the present method, and there are plans for redesign; but at present it is necessary to treat the interstitial region reliably. The inputs are described below; see also [this](/fpoptbas/) for a tutorial about choosing the basis optimally. Note also with the incorporation of the **APW** basis, other options are available.

<hr style="height:5pt; visibility:hidden;" />
##### *The FP package adds two executable programs to the basic one:*
_____________________________________________

+ Program **lmf** is the program used for self-consistent full-potential calculations. It requires a starting density, which it obtains either from a binary restart file *rst.ext*{: style="color: blue"} (typically generated by a prior invocation of **lmf**) or an (almost) equivalent version *rsta.ext*{: style="color: blue"} in **ASCII** format, from a superposition of free-atom densities (*file atm.ext*{: style="color: blue"}), which is created as follows

+ Program **lmfa** makes each species self-consistent for the free atom and writes the local density, plus a fit to the tail beyond the **MT** radius (fit as a linear combination of smooth Hankel functions) to file "atm". Also appended to file "atm" is a fit to the free-atom wave functions for r>rmt. In version 6.9n, this is where the envelope wave functions are specified, and as the functions are an excellent choice for a free atom, they are not tailored to the solid, and you are encouraged to tinker with the basis (described in the next Section) before proceeding to carry out full calculations.
