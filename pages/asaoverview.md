---
layout: page-fullwidth
title: "The Atomic Spheres Approximation"
permalink: "/docs/asaoverview/"
sidebar: "left"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}

To describe Questaal's implementation of the LMTO method in the Atomic Spheres Approximation.

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Introduction_

The Questaal package has three codes that implement DFT in the Atomic
Spheres Approximation (ASA).  Formulated by O. K. Andersen in the
1970's to handle transition metals, the ASA overlaps the augmentation
spheres so that the interstitial volume is zero (there is a geometry
violation).  Moreover, the potential is assumed to be spherically
symmetric inside the spheres.

The ASA is very efficient, but its range of validity is limited.  This
is because the interstitial is omitted so spheres must fill space.
Hence there is a geometry violation that becomes severe if the spheres
overlap too much. It works best for close-packed systems, and still
remains today one of the best and most highly efficient approach to
studying magnetic properties of transition metals and their alloys.  The
ASA package has a non-collinear framework and a fully relativistic Dirac branch.

Questaal's implementation present uses the "tight-binding" form of
LMTO, sometimes called "second generation," a [linear
transformation](http://dx.doi.org/10.1103/PhysRevLett.53.2571)" of the
original basis set that makes Hankel functions short ranged.

**Note**{: style="color: red"} There is also a non self-consistent
implementation of Anderen's most recent basis, the `NMTO'.  This code
should largely be regarded as experimental, as there are practical
pitfalls associated that haven't been fully worked out.

### _The ASA Suite_

Questaal has three implementations of the ASA:

+ **lm**{: style="color: blue"}: a band method whose function is
similar to the full-potential program **lmf**{: style="color: blue"}.
It is interesting to compare the ASA band structure to the FP one, e.g. [in PbTe](xx).

+ **lmgf**{: style="color: blue"}: is a crystal code similar to
**lm**{: style="color: blue"}, but it uses a Green's function
formalism.  An extra energy integration (in addition to the k
integration) is required, which makes the program somewhat slower.
However it has features **lm**{: style="color: blue"} does not: it can
calculate magnetic exchange interactions and some other properties of
linear response.  This code can include spin-orbit coupling
perturbatively, and it also has a fully relativistic Dirac
formulation.  It also implements the Coherent Potential Approximation,
either for the study of alloys, or for disordered local moments, or a
combination of the two.

+ **lmpg**{: style="color: blue"}: is an analog of
**lmgf**{: style="color: blue"} for layered systems.  Periodic boundary conditions are used in two
dimensions, and a Principal Layer technique is used for the third dimension.  This is
advantageous because (1) boundary conditions in this dimension semi-infinite leads,
corresponding to layered systems and (2) the computation time scales only linearly in the number of
principal layers.  It can be used in a self-consistent framework, and also to
calculation transmission using Landauer-Buttiker theory.  There is a
non-equilibrium Keldysh formulation of the ASA hamiltonian of the theory
described in [this paper](http://link.aps.org/doi/10.1103/PhysRevB.71.195422).

In more detail, the system is divided up into three regions, two
contacts and a central device region. The two contact regions are
taken to extend to infinity in the third dimension. The device region
is divided up into a series of layers where only nearest neighbor
interactions between layers are considered. Green’s function
approaches are a natural choice for transport calculations since the
information on the contacts can be incorporated into the Hamiltonian
for the device region through an additional self energy
term. **lmpg**{: style="color: blue"} has been used to examine
transport in devices ranging from magnetic tunnel junctions to atomic
point contacts.

### _Structure of the ASA_
{::comment}
/docs/asaoverview/#structure-of-the-asa/
{:/comment}

The ASA is like other [augmented wave methods](/docs/package_overview/#augmented-wave-methods) which divide into an
"atomic'' part which makes matrix elements and a "band'' part which generates bands, densities-of-states, etc.
The ASA makes two simplifications to the atomic part that make the method highlty efficient:

1. The nonspherical part of the density and potential are neglected.
2. The spheres are overlapped so that they fill space.  
   The net interstitial volume is zero, and in the pure ASA it is neglected all together.

Both atomic and band parts become simpler than in full potential methods.  Matrix elements of the potential become quite
simple and reduce to a few parameters (the "potential parameters").  The band part need only generate the lowest three energy moments
$$Q_0$$, $$Q_1$$, and $$Q_2$$ of the density as described below; this is sufficient for the atomic part to construct a density and make
potential parameters.  In the self-consistency cycle the atomic part takes moments and generates
potential parameters; the band part takes potential parameters and generates moments.

Self-consistency proceeds by alternating between the solid part and atomic part, generating moments, then potential
parameters, then moments again until the process converges.  The program can be started either with the band part,
specifying potential parameters, or with the atomic part, specifying the moments.

### _Augmentation sphere boundary conditions and continuous principal quantum numbers_
{::comment}
/docs/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers/
{:/comment}

[Linear augmented wave](/docs/package_overview/#linear-methods-in-band-theory) methods almost invariably construct the basis set inside
augmentation spheres from the spherical part of the potential.  (In the ASA the potential is spherical anyway).
For a fixed spherical potential, the Schrodinger equation separates into an angular part
(whose solutions are spherical harmonics) and a radial part with quantum number _l_.  Solution to the radial Schrodinger
equation (aka "partial wave") <i>&phi;<sub>l</sub></i> and its energy are uniquely determined by the boundary
condition at the augmentation radius _s_.  More precisely, <i>&phi;<sub>l</sub></i> is called a <i>partial wave</i> since it is only a partial solution
to the full Schrodinger equation.  Partial waves must be matched to the envelope function at the augmentation sphere radius; the condition
that all partial waves match smoothly and differentiably at all surfaces is the quantization condition that determines allowed eigenvalues.
[Linear methods](/docs/package_overview/#linear-methods-in-band-theory) in fact require the partial wave $$\phi$$ and its energy derivative
$$\dot\phi$$ (or possibly $$\phi$$ at two different linearization energies).

The boundary condition can be given through the "logarithmic derivative function"

$$ D_l(\varepsilon) \equiv D\{\phi_l(\varepsilon)\} 
   = \left({\frac{d\ln\phi_l(\varepsilon,r)}{d\ln r}} \right)_{s}
   = \left( {\frac{r}{\phi_l(\varepsilon,r)}}
           {\frac{d\phi_l(\varepsilon,r)}{dr}} \right)_{s} . $$

The energy <i>&epsilon;</i> fixes _D_, or alternatively _D_ can be specified which fixes <i>&epsilon;</i>.
<i>D<sub>l</sub></i> is a cotangent-like function: it decreases monotonically from (+&infin;,&minus;&infin;)
over a finite window of energy, after which it starts again at +&infin;.
There is thus a multiplicity of energies for a given <i>D<sub>l</sub></i>, one branch for each principal quantum number.

For that reason the Questaal package uses a "continuous principal quantum number" defined as

$$P_l = 0.5 - \arctan(D_l)/\pi + \hbox{(principal quantum number)} $$

<i>P<sub>l</sub></i> increases smoothly and monotically with energy, acquiring an extra integer each time a new node appears.
This construction is due to Michael Methfessel. <i>P<sub>l</sub></i> called a "continuous principal quantum number."

_Note:_{: style="color: red"} <i>P<sub>l</sub></i> should not be confused with O.K. Andersen's "Potential function."
It is unfortunate that these distinct but related functions have the same symbol.

##### _Continuous principal quantum number for core levels and free electrons_
{::comment}
/docs/asaoverview/#continuous-principal-quantum-number-for-core-levels-and-free-electrons/
{:/comment}


<div onclick="elm = document.getElementById('corep'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here for a description of P for two limite cases; core levels and free electrons.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="corep">{:/} 

_Core levels_

A core state is exponentially decaying as it approaches _s_; therefore its logarithmic derivative <i>D<sub>l</sub></i> is approximately
<i>s</i>/<i>&epsilon;<sub>l</sub></i>, which is large and negative.  Using the fact that arctan(<i>x&rarr;-&infin;</i>)/<i>&pi;</i>&rarr;-1/2,
the fractional part of <i>P<sub>l</sub></i> is large and close to one.

_Free electrons_

In the absence of a potential the partial wave has the shape <i>r<sup>l</sup></i>.
Thus for free electrons, $${\rm frac}[P_l^{\rm free}] = 0.5 - \arctan(l)/\pi$$.
This sets a lower bound to $$P_l$$. For _l_=0, $$P_l^{\rm free}{=}1/2$$; for large _l_,
$$P_l^{\rm free}$$ is small (0.15 for _d_ waves and 0.10 for _f_ waves).

In summary, the fractional part of <i>P<sub>l</sub></i> is close to one for
for deep states far below the Fermi level, for states far above the Fermi level it is small, at least for 
_l_>0.  As <i>&epsilon;</i> increases from -<i>&infin;</i> to <i>&infin;</i>, _P_ changes
in a continous way, acquiring an extra integer each time a new node appears.

{::nomarkdown}</div>{:/}


### _Generation of the sphere potential and energy moments Q_
{::comment}
/docs/asaoverview/#generation-of-the-sphere-potential-and-energy-moments-q/
{:/comment}


Because the method is a linear one, and because the density is
constrained to be spherical, only three functions can carry charge
inside a sphere per <i>l</i> channel 
(<i>&phi;<sub>l</sub></i><sup>2</sup>,
<i>&phi;<sub>l</sub></i>&times;(<i>d&phi;<sub>l</sub></i>/<i>d&epsilon;</i>),
(<i>d&phi;<sub>l</sub></i> /<i>d&epsilon;</i>)<sup>2</sup>) and therefore the properties of a
sphere, for a spherical potential and a linear method are completely
determined by the first three energy moments <i>Q</i><sub>0</sub>,
<i>Q</i><sub>1</sub>, and <i>Q</i><sub>2</sub> of the density of states for each <i>l</i>
channel, which are called the atomic number and the boundary
conditions at the surface of the sphere.  In some sense these numbers
are ``fundamental'' to a sphere; the atomic program will generate a
self-consistent potential for a specified set of <i>Q</i><sub>0</sub>,
<i>Q</i><sub>1</sub>, <i>Q</i><sub>2</sub> and boundary conditions, specified 
in the Questaal package through the continuous principal quantum number <i>P</i>
described in the previous section.  
This simplification depends on assumption of spherical densities, and is
unique to the ASA.  Information spcifying the potential is carried compactly in
the four numbers <i>P,&nbsp; Q<sub>0...2</sub></i> in each _l_ channel.

This is a generalization of the free-atom case where the atomic
density is determined by the zeroth moment <i>Q</i><sub>0</sub> in each _l_ channel
and the boundary condition that <i>&phi;<sub>l</sub></i> decay as
<i>r</i>&rarr;&infin;.  Only <i>Q</i><sub>0</sub> is needed because the atomic
level is sharp, having no energy dispersion. Also the boundary condition is fixed
by the requirement that <i>&phi;</i> is integrable.

_Potential Parameters_
{::comment}
/docs/asaoverview/#potential-parameters/
{:/comment}

Once a potential is specified (implicitly through <i>P, Q</i><sub>0,1,2</sub>),
"potential parameters" can be generated.  They
are a compact representation of information needed 
specify the hamiltonian.  A description of how the
parameters are generated and their significance is too involved to be
described in this overview, but see 'Other Resources" below.
The most important parameters are the "band center of gravity" <i>C<sub>l</sub></i>
and the bandwidth &Delta;<i><sub>l</sub></i>.

+ <i>C<sub>l</sub></i> describes the band center, and is the analog of the on-site matrix element (or atomic level in the free atom)
+ &Delta;<i><sub>l</sub></i> characterises the width of the partial, i.e. approximately the maximum and minimum values a partial wave would take in the absence of hybridization with other atoms.

To generate bands and an output charge density (in the form of moments <i>Q</i><sub>0,1,2</sub>), only potential parameters are required.
Nevertheless it is more common to start from the moments because rough values for them can easily be guessed.  The ASA codes will assume default
values (<i>Q</i><sub>0</sub> = occupation of the free atom, <i>Q</i><sub>1</sub> = <i>Q</i><sub>2</sub> = 0), which most of the time is good
enough to reach self-consistency.  These codes also have a lookup table for default values of _P_ described
[above](/docs/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers)

### _Selection of Sphere Radii_
{::comment}
/docs/asaoverview/#selection-of-sphere-radii/
{:/comment}

One of the biggest nuisances for augmented-wave programs is the choice
of sphere radius.  Results are much more sensitive to choice of
spheres in the ASA than in the full-potential case, in part because
the energy functional (and potential) change with MT radii, whereas in
the FP case, this only weakly so.  The ASA also has the additional constraint
that the sum-of-sphere volumes equals the unit cell volume, so the
criteria in selecting them is somewhat different.

Either for the ASA or FP, the Questaal package has tools to select radii for you automatically.  It is relatively straightforward in the FP
case; the ASA can be tricky because of the space-filling requirement.

<div onclick="elm = document.getElementById('sphereradii'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here for for a discussion of the (in part competing) criteria for the selection of sphere radii.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="sphereradii">{:/} 

{::comment}

<DL>
<DT><I>Geometry violation of overlapping spheres</I>
<DD>
Overlapping spheres count some parts of space twice and others not at all.  The full-potential code is has a unique augmentation,
constructed so that the sphere contributions vanish quadratically for radii approaching the MT radius.  Errors tend to be small until
overlaps reach about 10% of the internuclear distance.  It has been found empirically, however, that self-consistency proceeds more slowly
when spheres overlap.

The ASA band code **lm**{: style="color: blue"}, has a "combined correction" term that partially undoes this
error, but not completely.  This term is only available to **lm**{: style="color: blue"}, not **lmgf**{: style="color: blue"}
or **lmpg**{: style="color: blue"}.

</DD>
<DT><I>ASA Requirement for space-filling spheres</I>
<DD>

The ASA functional requires that the sum-of-sphere volumes equals the cell volume.  More precisely, the density is carried by
the spheres (superposition of spherically symmetrical sphere densities).   This crition mitigates directly against the preceding one.
The more closely packed a system is the better suited the ASA.  For open systems, you must add "empty spheres:" fictitious atoms of zero atomic number that
enable space to be filled without too large a geometry violation.

</DD>
<DT><I>Large sphere radii assign more volume to augmented functions</I>
<DD>
  Augmented wave functions are very accurate, and the more space covered
  by them the more reliable the basis set.

</DD>
<DT><I>l-convergence is most rapid for small sphere radii</I>
<DD>
The larger the sphere radius, the more <I>l's</I> are required for convergence

</DD>
<DT><I>Larger spheres better contain shallow semicore states</I>
<DD>
Ideally the core is completely localized within augmentation spheres.
Particularly in the full-potential case where spheres overlap less
than in the ASA, shallow semicore states can be an issue.  In the FP case, 
you can always add 
[a local orbital](/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals/)
to address this problem.

</DD>
<DT><I>MT potentials are exactly solvable</I>
<DD>
  The KKR method is essentially exact for a MT potential, i.e. one
  that is spherical inside augmentation spheres and flat in the
  interstitial.  The LMTO basis starts from the KKR basis; thus a
  partitioning of space which best resembles a MT potential is the
  best choice.  The automatic sphere radii algorithms try to select
  radii that make the intersitial potential flat.

</DD>
</DL>

{:/comment}

x

{::nomarkdown}</div>{:/}

This program suite helps you set sphere radii in several ways.  Programs
using already-chosen (or guessed) sphere radii can <A href="#section8.1">rescale
sphere radii</A> up to a specified volume within constraints you supply.
Also program <A href="Command-line-options.html#section1lmchk">lmchk</A> can
supply intelligent <A href="#section8.2">values</B></A>
for sphere radii (usually better than you can guess on your own).

### _Automatic scaling of sphere radii_

Programs needing sphere radii can <A href="#section8.1">scale sphere
radii</A> as large as possible within constraints you supply.  This
option iteratively adjusts sphere radii as large as possible (or until
the combined sphere volumes equals the cell volume) within certain
constraints.  To set this option, set SPEC token SCLWSR=1.  (Actually,
the number 1 is just the target sphere volume as a fraction of the
cell volume.  You can choose any number SCLWSR=n with n between 0 and
1.  Usually you just choose n=1.  recall that the ASA expects the
sphere volumes to add to the cell volume), in which case n should be
1.  In the FP case, you still want good sphere packing, so again
usually you choose n=1.

The constraints come in three flavors (all of them are imposed):

<DL>
<DT><I>Constraints on sphere overlaps</I>
<DD>
  There are two constraints OMAX1 and OMAX2 on sphere overlaps.  If we
  call ri the radius for sphere i and rij the distance between sites i
  and j:
<DL>
<DD>
  ri+rj-rij is constrained to be less than OMAX1 <S>x</S> rij
<DD>
  ri+rj-rij is constrained to be less than OMAX2 <S>x</S> min(si,sj)
</DL>
 Set OMAX1 and OMAX2 in category <A href="#SPEC">SPEC</A>.
<BR><BR>

</DD>
<DT><I>Maximum sphere radius</I>
<DD>
  No sphere radius is allowed to exceed WSRMAX (set in the
  <A href="#SPEC">SPEC</A> category).
<BR><BR>

</DD>
<DT><I>Lock sphere radii of specific species</I>
<DD>
You can "lock down" the sphere radii of specific species.  You set it
using token CSTRMX= in the <A
href="#SPEC">SPEC</A> category for species you want to lock.

</DD>

</DL>

### _Choosing initial values of sphere radii_

The ideal choice of sphere radii best approximates a potential that is
spherical within the MT spheres and flat outside.  Program <A
href="Command-line-options.html#section1lmchk"><B>lmchk</B></A> has implemented one algorithm that
makes a reasonable initial choice for MT radii.  The algorithm works by
computing the (electrostatic) potential obtained from overlapping free-atom
densities along all connecting vectors between a given site and its
relatively near neighbors.  The MT radius is taken as the first potential
maximum along any ray.  This choice is a pretty reasonable estimate for the
potential being approximately spherical inside.  Also, note that for a
completely symmetric bond, the potential maximum will fall exactly midway
between the bond, so for that case the two sphere radii will exactly touch
and have equal potentials.  To tell <A
href="Command-line-options.html#section1lmchk"><B>lmchk</B></A> to find these radii, invoke lmchk as
<pre>lmchk --getwsr</pre> Once lmchk determines these radii, you must enter
them in (by hand) to the input file using <A href="#SPEC">SPEC</A> token
RMAX=.  There is at present no automatic way to use the radii generated by lmchk.

### _Finding empty spheres_

You can use "empty spheres" as a device to fill space.  The ASA
requires the sum of sphere volumes to match the cell volume; however
this can only be done with reasonable sphere overlaps (<15%) for
fairly close-packed systems.

The solution, in the ASA, is to pack the volume with "atoms" with
atomic number zero ("empty spheres").  This is tedious but quite often
necessary.  <A href="Command-line-options.html#section1lmchk">lmchk</A> has an
automatic "empty sphere" finder that can greatly facilitate this step.

</DD>
<DT><I>Assigning lower priority to resizing empty spheres</I>
<DD>

Particularly in the ASA, empty spheres are often needed to get
reasonable sphere packing.  However, it is reasonable that their radii
should be scaled after the real spheres are rescaled.  You can tell
the resizer to do this through the 10's digit of token SCLWSR.  The
10's digit behaves like a flag to cause the resizer to treat empty spheres
on a different footing from all the other spheres.

<pre>
   Add  10 to SCLWSR to initially scale real atoms (those with Z>0) first.
   The scaling is done using radii of size zero for all empty spheres.
   After this initial scaling, the resizer will proceed rescaling
   all the spheres.

  Add 20 to SCLWSR is similar to adding 10.  However, The final
  rescaling applies only to the empty spheres; the real atoms' spheres
  change only in the first scaling, without reference to the empty
  spheres.
</pre>
</DD>

### _Second generation Orbital Downfolding_

This is a procedure for constructing minimal basis sets and for
avoiding ghost bands. The best description is in Ole Andersen's
Varenna Notes (section 4.12), and for the stout-hearted, there is
a full account in Lambrecht and Andersen, Phys. Rev. B, 34, 2439
(1986).  It is implemented here including combined correction
which is described in Ole Andersen's unpublished notes,
"Transformation to a minimal LMTO set; downfolding" Aug 15, 1988.
We include in this documentation a plain TeX source file of notes
<A href="dnfpap.tex">dnfpap.tex</A> which may be of some use, and
which concerns our implementation directly (2nd generation lmto
only)

One way to look at the scheme is the following. When an electron
encounters an atomic sphere, the scattering it experiences can be
described in terms of its phase shift, eta_l.  The tangent of the
phase shift is a property of the scattering potential and the
angular momentum of the electron, l, and is a function of energy.
Some electrons are weakly scattered, while others (for example
d-electrons in transition metals) may scatter strongly,
especially when their energy is close to the resonant energy E_l.
In a linear method, the phase shift is parameterized:

    tan eta_l(E) = W_l / ( E_l  -  E)

so that one can construct an energy-independent hamiltonian. In
LMTO, it is customary to use the kappa=0 KKR phase shift in the
following parameterization:

    1 / P_l(E) = Delta / ( E  -  C )   +   gamma         (1)

which is correct to second order in (E - C); Delta is the width W
of the resonance, and C is the band center (analogous to E_l in
KKR theory). gamma is the second order distortion parameter. (In
practice one also includes third order terms using the small
parameter p (see Varenna notes)). 1/P is called the inverse
potential function, and is the LMTO analogue of the tangent of
the phase shift in multiple scattering and KKR theories.

For electrons that scatter only weakly, one can further
approximate the hyperbola (1) by a linear function. This is
exactly what happens if one throws away orbitals from the
basis---one approximates 1/P for these "high" partial waves by a
tangent drawn through the hyperbola (1) at the energy V^0, which
is the depth of a square well pseudopotential with the same
scattering properties as the atomic sphere for energy <i>E<sub>l</sub></i>. (If
the structure constants have been screened in these channels then
the tangent goes through the potential parameter V^alpha.)

The best possible way to treat weakly scattered electrons is to
make the tangent at <i>E<sub>l</sub></i> since then the eigenvalues are exact at
<i>E<sub>l</sub></i>, and the wavefunctions are correct to zeroth order. The way
to do this, is to change the representation of the hamiltonian
before discarding the orbitals. The effect of using a
representation beta is to shift the inverse potential function
(1) rigidly by the amount beta. This is done by choosing a beta
such that V^beta = <i>E<sub>l</sub></i> so that when the orbitals are then
discarded from the basis, this amounts to approximating their
scattering by a linear tangent to 1/P at <i>E<sub>l</sub></i>. This is called
folding down about 1/P(<i>E<sub>l</sub></i>).

If one merely wants to avoid ghost bands, then set the ADNF
switch and keep an eye on which orbitals are being folded down.
The automatic switch will choose to fold down about 1/P(<i>E<sub>l</sub></i>) or
about alpha depending on how weakly they are scattering. It is
often useful to set the switches manually as the criteria in the
automatic mode are set to cause no loss of accuracy. Very often
one can fold down orbitals and save a lot of time with only a
small error in the eigenvalues. Examples are p-orbitals in
transition metals and d-orbitals in Al. In Fe, the f-orbitals
must be folded down to avoid a ghost band. Another application is
in constructing minimal basis sets. As an exercise try folding
down orbitals in Si right down to s and p on the atoms and s in
the empty spheres (these are the analogues of Vogl's sp^3s*
basis). Now try folding down the empty sphere s as well: any
worse than Harrison's minimal basis? (Try the deformation
potentials!)


### _Other Resources_

For an overview of linear methods, and their connection to pseudopotentials,
see these [lecture notes](xx) given at at CECAM workshop at Oxford in 2013.
The 2<sup>nd</sup> generation potential parameters this package uses are particularly
helpful because they refer to conceptually accessible quantities, such as
the band-center parameter <i>C</i>, and the bandwidth parameter &Delta;,
as the lecture notes briefly describe.

[These unpublished notes](xx) develop the ASA, and the relation between band and Green's function methods.

This classic paper established the framework for linear methods in band theory:  
O. K. Andersen, "Linear methods in band theory,"
[Phys. Rev. B12, 3060 (1975)](http://dx.doi.org/10.1103/PhysRevB.12.3060)

This paper lays out the framework for screening the LMTO basis into a tight-binding form:  
O. K. Andersen and O. Jepsen,
"Explicit, First-Principles Tight-Binding Theory," 
[Phys. Rev. Lett. 53, 2571 (1984)](http://dx.doi.org/10.1103/PhysRevLett.53.2571)

This book explains the ASA-Green's function formalism, with some description of potential parameters:  
I. Turek et al., Electronic strucure of disordered alloys, surfaces and interfaces (Kluwer, Boston, 1996).

These papers lay the foundation for the Green's function theory in the ASA:  
O. Gunnarsson, O. Jepsen, and O. K. Andersen, Phys. Rev B27, 7144;
O. K. Andersen, Z. Pawlowska, and O. Jepsen, Phys. Rev. B 34, 5253 (1986)

These notes explain the "second generation" LMTO and the screening transformation

  O.K. Andersen, A.V. Postnikov, and S. Yu. Savrasov, in "Applications of
  Multiple Scattering Theory to Materials Science," eds. W.H. Butler,
  P.H. Dederichs, A. Gonis, and R.L. Weaver, MRS Symposia Proceedings
  No. 253 (Materials Research Society, Pittsburgh, 1992) pp 37-70.

  O.K. Andersen, O. Jepsen and M. Sob, in Lecture Notes in Physics:
  Electronic Band Structure and Its Applications, eds.  M. Yussouff
  (Springer-Verlag, Berlin, 1987).

These papers go beyond the 2nd generation LMTO, still within the ASA:

  O.K. Andersen, O. Jepsen, and G. Krier in Lectures on Methods of
  Electronic Structure Calculations, edited by V. Kumar, O. K. Andersen,
  and A. Mookerjee (World Scientific Publishing Co., Singapore, 1994),
  pp. 63-124.

  O.K. Andersen, C. Arcangeli, R.W. Tank, T. Saha-Dasgupta, G.  Krier,
  O. Jepsen, and I. Dasgupta in Tight-Binding Approach to Computational
  Materials Science, Eds. L. Colombo, A. Gonis, P. Turchi, Mat.
  Res. Soc. Symp. Proc. Vol. 491 (Materials Research Society, Pittsburgh,
  1998) pp 3-34.
