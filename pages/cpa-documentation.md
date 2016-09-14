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
_____________________________________________________________

**Chemical Disorder**{: style="color: orange"}. Additional species must be defined for chemical CPA, and their concentrations.

    SPEC ATOM CPA= and C= together turn on chemical CPA for a particular species.

They specify which species are to be alloyed with this species, and the concentrations of the other species. For example,

    SPEC ATOM=Fe ... CPA=1 4 5 C=0.5 0.3 0.2 

specifies that species Fe (whenever it appears in the basis (defined in **SITE** category) in fact refers to a disordered site composed of three kinds of elements. Numbers following **CPA=** refer to indices in the **SPEC** category: thus "**CPA=1 4 5**" indicate that the three elements to be identified with sites referring to this species are the 1st, 4th, and 5th species declared in the **SPEC** category. **C=** indicates the concentrations of each species; the concentrations must sum to 1. In the example given, sites with species label Fe are composite elements with with 50% of species 1, 30% of species 4 and 20% of species 5 (up to 10 species may be given).

A CPA species may refer to itself. For example, if the Fe species above is the first species to be read from the ctrl file, then **CPA=1** refers to itself. All other parameters like _Z_, _R_, will be taken from this species. 

**Spin Disorder**{: style="color: orange"}. No additional species are required, but the number of orientations must be specified.

    SPEC ATOM NTHET= turns on spin disorder for a particular atom type.

A species with non-zero **NTHET** can be listed as a CPA component, and it will be included as NTHET components with different directions of the local moment.

**NTHET=2** specifies that there will be two CPA-DLM components with polar angles 0 and π. **NTHET=N** with $$N>2$$ specifies a vector-DLM model, for which N polar angles for the local moment direction are selected using the Gaussian quadrature for the sphere. (Axial symmetry is always assumed and the integral over the azimuthal angle is taken analytically.)

**Combined Chemical and Spin Disorder**{: style="color: orange"}. Either spin or chemical disorder may be specified; they may also be included simultaneously. If only **CPA=** is chosen, that species will be treated with chemical, not spin, disorder. If only **NTHET=** is chosen, that species be treated with spin disorder only. Specifying both means that the CPA will include both chemical and spin disorder. For example, in the above example for CPA, if **SPEC ATOM=Fe** includes a tag **NTHET=2** (while species 4 and 5 have **NTHET=0**), species Fe describes a CPA site with 4 components: 25% Fe, 25% Fe with a reversed local moment, 30% species 4 and 20% species 5. 

####_ GF category_
_____________________________________________________________

The following token turns on the CPA and/or DLM:

    GF DLM= controls what is being calculated. 

At present, these values are supported:

    DLM=12: normal CPA calculation; both charges and Ω's are iterated
    DLM=32: no charge self-consistency; only CPA it iterated until Ω reaches
            prescribed tolerance for each z-point.
    DLM=112: special-purpose experimental branch (not documented)

The following are optional inputs:

    GF BXY=1 turns on the self-consistent determination of the
       constraining fields for vector DLM calculations.

    GF TEMP= supplies the spin temperature (not implemented yet)

Self-consistency in Ω is controlled by the following tags supplied in GF GFOPTS:

    lotf    if present, Ω is iterated at each z-point until converged to omgtol (recommended)
    nitmax= maximum number of Ω iterations (30 is usually sufficient)
    omgmix= linear mixing parameter for Ω (0.4 works well in most cases)
    omgtol= tolerance for Ω
    padtol= same meaning as usual, but note that Ω is not mixed unless padtol is reached (1d-3 is recommended for all CPA calculations)
    dz=     special branch, in which z-points are shifted by dz along the real axis (experimental)

Recommended options:

    GF GFOPTS=[...];omgmix=0.4;padtol=1d-3;omgtol=1d-3;lotf;nitmax=30

