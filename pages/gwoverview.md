---
layout: page-fullwidth
title: "Implementation of the _GW_ Approximation"
permalink: "/docs/gwoverview/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

This tutorial explains how Questaal implements the _GW_ approximation, and the Quasiparticle Self-Consistent _GW_ approximation

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Introduction_

The _GW_ approximation is implemented in two forms: as a 1-shot perturbation to the LDA and as quasiparticle self-consistent _GW_.

In 1-shot mode, the diagonal part of &Sigma; is evaluated at the
one-particle (usually LDA) energies, yielding a corrections to the
quasiparticle levels in 1st order perturbation theory.

In QSGW mode, the full &Sigma; matrix is calculated and
"quasiparticlized:" $$\Sigma_{ij}(\omega)$ coupling one-electron
states _i_ and _j_, is evaluated at the one-particle energies
$$\varepsilon_{i}$$ and $$\varepsilon_{j}$$, and the average value is
taken.  This results in a static but orbital-dependent potential, a
"quasiparticlized" $$\Sigma^0_{ij}$$ derived from $$\Sigma_{ij}(\omega)$,
and defines a one-particle hamiltonian $$H_0$$ which is the
LDA one-particle hamiltonian with $$\Sigma^0_{ij}$$ substituting for $$V^{LDA}_{xc}$$.

The new $$H_0$$ is used to mke a new $$\Sigma_{ij}(\omega)$, and the process is iterted until 
$$H_0$$ stops changing (quasiparticle self-consistency).

QS<i>GW</i> theory is an elegant way to choose the optimum noninteracting hamiltonian $H_0$ for <i>GW</i> calculations, rather than using
the LDA for $$H_0$$, as is customary.  A particularly valuable property of this optimum starting point is that the (real part) of the peaks
of the interacting Green's function <i>G</i> and the poles of $$G_0$$ coincide.  The eigenfunctions of $$G_0$$ are as close as possible to
those of <i>G</i>, by construction.  But what are poles in $$G_0$$ get broadened in <i>G</i> so quasiparticles lose weight.  Thus the
density-of-states, or spectral function, is composed of a superposition of &delta;-functions for $$G_0$$, but are broadened for <i>G</i>.
Also the eigenvalues acquire an imaginary part, making the QP lifetime finite.

In QS<i>GW</i> theory $$G_0$$ and <i>G</i> are closely linked.  Associated with the two kinds of <i>G</i> are two kinds of density-of-states
(DOS).  There is "noninteracting" or "coherent" DOS, the spectral function of $$G_0$$ which is what is usually associated with DOS, and what
is typically calculated by a band program such as **lmf**{: style="color: blue"} .  There is also the true DOS (spectral function of <i>G</i>) which is what is
approximately measured by e.g.  a photoemission experiment.  The <i>GW</i> package has a facility to generate both kinds of DOS; through the
normal **lmf**{: style="color: blue"} process for the noninteracting DOS or by analyzing the spectral functions for the interacting case.

A detailed description of QSGW theory and the way in which Questaal implements it
can be found in the references in "Other Resources" below.

### _How the 1-particle and many-particle codes synchronise_

The _GW_ package comprise a separate set of codes from the density-functional code, **lmf**{: style="color: blue"}.  It uses the
single-particle basis set of **lmf**{: style="color: blue"} to calculate the screened coulomb interaction _W_ and the self-energy,
&Sigma;=_iGW_.

Thus the _GW_ package handles the many-body part on **lmf**{: style="color: blue"} the the 1-body part.  The two connect through special
purpose interfaces: **lmfgwd**{: style="color: blue"} sets up the inputs needed by GW, supplying information about the wave functions in the
augmentation spheres and in the interstitial.  The _GW_ part generates QP levels and the quasiparticlized $$V^{GW}_{xc}$$.
Apart from these linkages, the <i>GW</i> package is completely separate from the FP-LMTO program.  The <i>GW</i> package does not depend on
the ctrl file **lmf**{: style="color: blue"} and **lmfgwd**{: style="color: blue"} use, only on the eigenfunctions they generate.
It has a separate input file, **GWinput**.

In reality the _GW_ package makes $$\Sigma^0{-}V^{LDA}_{xc}$$.  **lmf**{: style="color: blue"} reads this potential and adds it to the LDA hamiltonian.
This construction enables **lmf**{: style="color: green"} to do the same kinds of calculations as it performs with the LDA potential.

#### _Operation of **lmfgwd**{: style="color: blue"}_

**lmfgwd**{: style="color: blue"}  initially operates in the same manner as **lmf**{: style="color: blue"}.  After setting up the potoential
it prompts for a job, which tells **lmfgwd**{: style="color: blue"}  what to do.

+ Job &minus;1' generates _GWinput{: style="color: green"}  and exits
+ Job 0'&nbsp; is an 'initializer' mode.  It creates several input files the <i>GW</i> package requires: **SYMOPS**, **LATTC**, **CLASS**, **NLAindx**, **ldima**
+ Job 1'&nbsp; generates files required by the <i>GW</i> package (e.g. eigenfunctions, eigenvalues, and wave function information)
+ Job &minus;2' performs sanity checks on the _GWinput{: style="color: green"}  file.

Even while the _GW_ package is independent of **lmf**{: style="color: blue"},
the _GWinput{: style="color: green"} file is complicated and
in practice almost always generated by **lmfgwd**{: style="color: blue"}.
What **lmfgwd**{: style="color: blue"} writes to 
_GWinput{: style="color: green"} is affected by the ctrl file.
There is a special **GW** category **lmfgwd**{: style="color: blue"} 
reads from the ctrl file; you can set some of the parameters it writes into
_GWinput{: style="color: green"} through tags in this category.

#### _Analysis of many-body spectral functions_

A pair of executables **spectral**{: style="color: blue"} and **lmfgws**{: style="color: blue"} 
are included with in the Questaal suite.  They generate spectral functions, derived either
individual QP levels or integrated over the Brillouin zone to make the interacting density-of-states.

### _Other Resources_

See [this tutorial](https://lordcephei.github.io/lmtut/) for a basic introduction to doing a QSGW calculation.

This paper presents the first description of an all-electron _GW_ implementation in a mixed basis set:  
T. Kotani and M. van Schilfgaarde,
_All-electron <i>GW</i> approximation with the mixed basis expansion based on the full-potential LMTO method_,
 Sol. State Comm. 121, 461 (2002).

These papers established the framework for QuasiParticle Self-Consistent _GW_ theory:  
Sergey V. Faleev, Mark van Schilfgaarde, Takao Kotani,
_All-electron self-consistent GW approximation: Application to Si, MnO, and NiO_,
[Phys. Rev. Lett. 93, 126406 (2004)](http://link.aps.org/doi/10.1103/PhysRevLett.93.126406);  
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
_Quasiparticle self-consistent_ GW _theory_,
[Phys. Rev. Lett. 96, 226402 (2006)](href=http://link.aps.org/abstract/PRL/v96/e226402)

Questaal's GW implementation is based on this paper:  
Takao Kotani, M. van Schilfgaarde, S. V. Faleev,
_Quasiparticle self-consistent GW  method: a basis for the independent-particle approximation_,
[Phys. Rev. B76, 165106 (2007)](http://link.aps.org/abstract/PRB/v76/e165106)

This paper shows results from LDA-based GW, and its limitations:  
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
_Adequacy of Approximations in <i>GW</i> Theory_,
[Phys. Rev. B74, 245125 (2006)](A href=http://link.aps.org/abstract/PRB/v74/e245125)





