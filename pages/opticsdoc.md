---
layout: page-fullwidth
title: "Optics Documentation"
permalink: "/docs/misc/optics/"
header: no
---
_____________________________________________________________

The LM-suite allows for the calculation of the following parameters:

1.   Im $$\epsilon(\omega)$$, without local-field effects

2.   Joint Density of States (JDOS$$(\omega)$$), the joint DOS between unoccupied conduction band states c and occupied valence band states v, JDOS $$= \sum_{c,v}\delta (\epsilon_c−\epsilon_v−\hbar\omega)$$.  
     In the spin polarized case, c and v belong to the same spin. JDOS$$(\omega)$$ and Im$$(\epsilon(\omega))$$ are very similar; except the latter has a matrix element of the momentum operator. One important difference is that the gradient operator has 3 components for xyz polarizations, whereas JDOS has only 1.
	 
3.   JDOS$$^{+−}(\omega)$$ the joint DOS between majority-spin unoccupied conduction band states c and minority spin occupied valence band states v (only relevant for spin polarized calculations); alternatively, JDOS$$^{−+}(\omega)$$. JDOS$$^{+−}$$; is to the transverse spin susceptiblity as DOS is to Im $$(\epsilon)$$.

4.   DOS$$(\omega)$$: defined in the conventional form, D$$(\omega) = \sum_i\delta(\epsilon_i−\hbar\omega)$$.

5.   Non-equilibrium absorption, JDOS is scaled with appropiate Fermi-Dirac functions with quasi Fermi levels which simulate occupied (empty) conduction (valence band edge).

6.   Non-equilibrium emission, reverse of the previous mode. Here only emission with field (and empty) conduction (valence) band edge are considered.

The corresponding parameters for the modes outlined above are presented in the tokens and tutorial sections.  

The calculated quantities from the modes above can be decomposed in a number of ways:

1.   By wave number $$\vec{k}$$;

2.   Into individual contributions from (occ,unnoc) pairs,

3.   By both k and (occ,unnoc) pairs,

4.   project out the Mulliken decomposition to JDOS from a particular orbital, or group of orbitals.

**lm**{: style="color: blue"} and **lmf**{: style="color: blue"} differ only in how the optical matrix elements are calculated: they use the same input system and call the same optics routines. Thus the input, output and this documentation apply to both **lm**{: style="color: blue"} and **lmf**{: style="color: blue"}.  

Several Brillouin zone integration methods are provided within the package. The fastest, but least accurate, is a sampling method (**OPTICS_LTET_=0**). There is a plain tetrahedron integrator (**OPTICS_LTET_=1** or **OPTICS_LTET_=2** below). But its applicability is restricted to only a few of the options listed above). There is also a sophisticated tetrahedron integration (**OPTICS_LTET_=3**), adapted from a GW package. It is the most memory intensive but offers all the options available. Unless you want k-resolved or Mulliken-resolved output, and you are working with an insulator, **OPTICS_LTET_=1** is recommended as it takes less memory, runs faster, and seems to be slightly more accurate than the **OPTICS_LTET_=3** integrator.  

There is a significant cost to calculate the dielectric function, even just the bulk Im $$\epsilon(\omega)$$. This is because the number of (occ,unocc) pairs scales quadratically with system size. Thus while the cost of a normal band calculation scales as $$N^4$$, the cost to calculate Im$$\epsilon(\omega)$$ scales as $$N^4$$, with N the number of states in the unit cell. Moreover, to obtain good resolution in Im $$\epsilon(\omega)$$, you need a rather fine k-mesh.

It should be noted that the contribution to the dielectric function can also be restricted to certain bands, this may be desirable where only certain transitions are important; in this way memory and calculation time can be significantly reduced.
