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

CPA self-consistency is based on iterating the coherent interactor Ω, which is a spin-dependent single-site matrix defined for each CPA site at each complex energy point. The linear mixing of Ω can be interleaved with charge mixing steps. However, experience shows that much faster convergence can be achieved by iterating Ω at each z-point until its misfit reaches a sufficiently low tolerance (say, 1d-3), between charge mixing steps. In addition, it is better to skip charge mixing if sufficiently accurate charge-neutrality has not been achieved (the reason being that Ω is not Pade-adjusted). There are a few parameters controlling Ω convergence, which are summarized below along with the recommended settings that work quite well in most cases. The Ω matrices are recorded in files omegaN.ext, where N is the number of the CPA site. A human-readable version (with fewer decimal digits) is recorded in om-hrN.ext. 
