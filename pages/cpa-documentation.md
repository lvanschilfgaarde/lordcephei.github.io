---
layout: page-fullwidth
title: "CPA Enhancement of the Green's function package"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/cpa-documentation/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Preliminaries_
_____________________________________________________________

**lmgf**{: style="color: blue"} contains an implementation of the **Coherent Potential Approximation** (CPA) and **Disordered Local Moments** (DLM) theory. It was implemented by _Kirill Belashchenko_ and questions should be directed to him (_belashchenko@unl.edu_).

The CPA implementation for substitutional alloys and for spin disorder follows the formulation explained in these articles:

* I. Turek et al., _Electronic strucure of disordered alloys, surfaces and interfaces_ (Kluwer, Boston, 1996).
* [J. Kudrnovsky and V. Drchal, Phys. Rev. B 41, 7515 (1990)](http://journals.aps.org/prb/abstract/10.1103/PhysRevB.41.7515).
* [J. Kudrnovsky, V. Drchal, and J. Masek, Phys. Rev. B 35, 2487 (1987)](http://journals.aps.org/prb/abstract/10.1103/PhysRevB.35.2487).

Particularly, see the description of the numerical implementation in Turek's book.

CPA self-consistency is based on iterating the coherent interactor Ω, which is a spin-dependent single-site matrix defined for each CPA site at each complex energy point. The linear mixing of Ω can be interleaved with charge mixing steps. However, experience shows that much faster convergence can be achieved by iterating Ω at each z-point until its misfit reaches a sufficiently low tolerance (say, 1d-3), between charge mixing steps. In addition, it is better to skip charge mixing if sufficiently accurate charge-neutrality has not been achieved (the reason being that Ω is not Pade-adjusted). There are a few parameters controlling Ω convergence, which are summarized below along with the recommended settings that work quite well in most cases. The Ω matrices are recorded in files **omegaN.ext**{: style="color: green"}, where _N_ is the number of the CPA site. A human-readable version (with fewer decimal digits) is recorded in **om-hrN.ext**{: style="color: green"}. 

### _CPA-specific input_
_____________________________________________________________

To turn on chemical and/or magnetic CPA, additons are required to the **SPEC** and **GF** categories in the ctrl file. 

#### _SPEC category_

**Chemical Disorder**{: style="color: purple"}. Additional species must be defined for chemical CPA, and their concentrations.

**SPEC ATOM CPA=** and **C=** together turn on chemical CPA for a particular species.

They specify which species are to be alloyed with this species, and the concentrations of the other species. For example,

    SPEC ATOM=Fe ... CPA=1 4 5 C=0.5 0.3 0.2 

specifies that species Fe (whenever it appears in the basis (defined in SITE category) in fact refers to a disordered site composed of three kinds of elements. Numbers following CPA= refer to indices in the SPEC category: thus "CPA=1 4 5" indicate that the three elements to be identified with sites referring to this species are the 1st, 4th, and 5th species declared in the SPEC category. C= indicates the concentrations of each species; the concentrations must sum to 1. In the example given, sites with species label Fe are composite elements with with 50% of species 1, 30% of species 4 and 20% of species 5 (up to 10 species may be given).

A CPA species may refer to itself. For example, if the Fe species above is the first species to be read from the ctrl file, then CPA=1 refers to itself. All other parameters like Z, R, will be taken from this species. 
