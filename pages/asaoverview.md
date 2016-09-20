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

The ASA is like other [augmented wave methods](/docs/package_overview/#augmented-wave-methods) which divide into an
``atomic'' part which makes matrix elements and and a ``band'' part which generates bands, densities-of-states, etc.
The ASA makes two simplifications to the atomic part that make the method highlty efficient:

1. The nonspherical part of the density and potential are neglected.
2. The spheres are overlapped so that they fill space.  
   The interstitial volume is zero on average, and in the pure ASA it is neglected all together

Both atomic and band parts become simpler than in full potential methods.  Matrix elements of the potential become quite
simple and reduce to a few parameters (the "potential parameters").  The band part need only generate energy moments
$$Q_0$$, $$Q_1$$, and $$Q_2$$ of the density; this is sufficient for the atomic part to construct a density and make
potential parameters, as described below.  In the self-consistency cycle the atomic part takes moments and generates
potential parameters; the band part takes potential parameters and generates moments.

Self-consistency proceeds by alternating between the solid part and atomic part, generating moments, then potential
parameters, then moments again until the process converges.  The program can be started either with the band part,
specifying potential parameters, or with the atomic part, specifying the moments.

### _Augentation sphere boundary conditions and continuous principal quantum numbers_

Linear augmented wave methods almost invariably construct the basis set 
inside augmentation spheres from the spherical part of the potential.
For a fixed spherical potential, the solution to the radial
Schrodinger equation (aka "partial wave") <i>&phi;<sub>l</sub></i> of
quantum number _l_ and its energy are uniquely determined by the
boundary condition at the augmentation radius _s_.  More precisely,
<i>&phi;</i> is called a <i>partial wave</i> since it is only a
partial solution to the full Schrodinger equation.  Partial waves must
be matched to the envelope function at the augmentation sphere radius;
the condition that all partial waves match smoothly and differentiably
at all surfaces is the quantization condition that determines allowed
eigenvalues.  [Linear method](/docs/package_overview/#linear-methods-in-band-theory)
in fact require the partial wave $\phi$ and its energy derivative $\dot\phi$
(or, sometimes, $\phi$ at two different linearization energies).


This is normally given through the "logarithmic derivative function"

$$ D_l(\varepsilon) \equiv D\{\phi_l(\varepsilon)\} 
   = \left({\frac{d\ln\phi_l(\varepsilon,r)}{d\ln r}} \right)_{s}
   = \left( {\frac{r}{\phi_l(\varepsilon,r)}}
           {\frac{d\phi_l(\varepsilon,r)}{dr}} \right)_{s} . $$

Since _D_ does not specify the principal quantum number, it is convenient to define a
"continuous principal quantum number"

$$P_l = 0.5 - \arctan(D_l)/\pi + \hbox{(principal quantum number)} $$

A core state is exponentially decaying as it approaches _s_; therefore
its logarithmic derivative
<i>D<sub>l</sub></i> is approximately <i>s</i>/<i>&epsilon;<sub>l</sub></i>, which
is large and negative.  Using the fact that arctan(<i>x&rarr;-&infin;)/&pi;</i>&rarr;-1/2,
the fractional part of <i>P<sub>l</sub></i> must approach 1 as <i>&epsilon;<sub>l</sub></i>&rarr;-&infin;.
Thus the fractional part of <i>P<sub>l</sub></i> is close to 1 for deep or core states;
for states far above the Fermi level it is small.
As <i>&epsilon;</i> increases from -<i>&infin;</i> to <i>&infin;</i>, _P_ changes
in a continous way, acquiring an extra integer each time a new node appears.

This construction (due to Michael Methfessel) is called a "continuous principal quantum number."

### _Generation of the sphere potential and energy moments Q_

Because the method is a linear one, and because the density is
(assumed to be) spherical, only three functions can carry charge
inside a sphere per <i>l</i> channel 
(<i>&phi;<sub>l</sub></i><sup>2</sup>,
<i>&phi;<sub>l</sub></i>&times;(<i>d&phi;<sub>l</sub></i>/<i>dE</i>),
(<i>d&phi;<sub>l</sub></i> /<i>dE</i>)<sup>2</sup>) and therefore the properties of a
sphere, for a spherical potential and a linear method are completely
determined by the first three energy moments <i>Q</i><sub>0</sub>,
<i>Q</i><sub>1</sub>, and <i>Q</i><sub>2</sub> of the density of states for each <i>l</i>
channel, which are called the atomic number and the boundary
conditions at the surface of the sphere.  In some sense these numbers
are ``fundamental'' to a sphere; the atomic program will generate a
self-consistent potential for a specified set of <i>Q</i><sub>0</sub>,
<i>Q</i><sub>1</sub>, <i>Q</i><sub>2</sub> and boundary conditions.

This is a generalization of the free-atom 
case where the atomic density is determined by the zeroth moment
$$Q_0$$ in each _l_ channel and the boundary condition
that <i>&phi;<sub>l</sub></i> decay as <i>r</i>&rarr;&infin;.
Only $$Q_0$$ is needed because the atomic level is sharp,
having no energy dispersion.

<A name="logderivative"></A>
<p>
These codes (both ASA and full-potential codes) use "logarithmic
derivative parameters" <i>P<sub>l</sub></i> to fix boundary
conditions at the sphere surface; they are described <A href="lmto.html#pbasp">here</A>.
<BR><FONT color="#33bb00"><I>*Note</I>&nbsp;</FONT>
<i>P<sub>l</sub></i> should not be confused with the "potential
functions" O.K. Andersen defines in his ASA theory and described on p49 of
<A href="Lecture1.pdf">this lecture</A>.
(It is unfortunate that these distinct but related functions have the same symbol.)

The above description of <i>P<sub>l</sub></i> applies to both ASA and
FP codes.  But in the ASA <i>P<sub>l</sub></i>
and <i>Q</i><sub>0..2,<i>l</i></sub>,
<A href="lmto.html#pbasp2">completely specifiy the ASA potential</A>.
This simplification depends on assumption of spherical densities, and is
unique to the ASA.  Information about the potential is carried compactly in (<FONT size="+1"><tt>P,Q</tt></FONT>).

<P> Also the free atom code <b>lmfa</b>, requires
only <i>P<sub>l</sub></i> and <i>Q<sub>l</sub></i>, where
 <i>Q<sub>l</sub></i> is the 0<sup>th</sup> moment (charge) in orbital <i>l</i>, completely determine
the density and potential of the free atom.

<h3><A name="sectionpp"></A>Potential Parameters</h3>
Once a potential is specified (implicitly through <FONT size="+1"><tt>P,Q</tt></FONT>
in this code), "potential parameters" can be generated.
"Potential parameters" are a compact representation of information needed in
a linear method to specify the hamiltonian.  A description of how the
parameters are generated and their significance is too involved to be
described here; but see these <A href="Lecture1.pdf">lecture notes</A>
given to the 2013
<A href=http://mml.materials.ox.ac.uk/Support/GraduateSchool2013>
Psi-k/CECAM/CCP9 Biennial Graduate School in Electronic-Structure Methods</A>.
The 2<sup>nd</sup> generation potential parameters this package uses are particularly
helpful because they refer to conceptually accessible quantities, such as
the band-center parameter <i>C</i>, and the bandwidth parameter &Delta;,
as the lecture notes briefly describe.
Beyond this informal introduction, see the following references:

<pre>
  O.K. Andersen, A.V. Postnikov, and S. Yu. Savrasov, in "Applications of
  Multiple Scattering Theory to Materials Science," eds. W.H. Butler,
  P.H. Dederichs, A. Gonis, and R.L. Weaver, MRS Symposia Proceedings
  No. 253 (Materials Research Society, Pittsburgh, 1992) pp 37-70.

  O.K. Andersen, O. Jepsen and M. Sob, in Lecture Notes in Physics:
  Electronic Band Structure and Its Applications, eds.  M. Yussouff
  (Springer-Verlag, Berlin, 1987).
</pre>

and later descriptions, evolving beyond 2nd generation LMTO:

<pre>
  O.K. Andersen, O. Jepsen, and G. Krier in Lectures on Methods of
  Electronic Structure Calculations, edited by V. Kumar, O. K. Andersen,
  and A. Mookerjee (World Scientific Publishing Co., Singapore, 1994),
  pp. 63-124.

  O.K. Andersen, C. Arcangeli, R.W. Tank, T. Saha-Dasgupta, G.  Krier,
  O. Jepsen, and I. Dasgupta in Tight-Binding Approach to Computational
  Materials Science, Eds. L. Colombo, A. Gonis, P. Turchi, Mat.
  Res. Soc. Symp. Proc. Vol. 491 (Materials Research Society, Pittsburgh,
  1998) pp 3-34.
</pre>

From the point of view of the bands, the ASA Hamiltonian is completely
specified by the potential parameters.  These are fundamental to the
band program; it will generate moments <i>Q</i><sub>0</sub>,<i>Q</i><sub>1</sub>,<i>Q</i><sub>2</sub>
from the eigenvectors of the Hamiltonian.  (Alternatively, they may be
generated via a Green's function, using programs <b>lmgf</b> or
<b>lmpg</b>).  Full self-consistency is achieved when the ``input
moments'' coincide with the ``output moments'', or equivalently when
the input potential parameters coincide with the output potential
parameters.  It is merely a matter of preference to whether to
consider the moments as fundamental or the potential parameters.

<BR><BR>

Unless performing some special-purpose function such as generating
<A href="generating-energy-bands.html">energy bands</A>,
<b>lm</b> works by iterating to
<A href="self-consistency.html">self-consistency</A>, ASA style.  By
virtue of the moments properties just described in the ASA, the self
consistency procedure is a little different from the standard one.
<b>lm</b> can start equally as well from either potential parameters or
moments, though it is generally customary to start from the moments, mainly
because one can usually begin with a very simple starting guess (choosing
the zeroth moment to be the charge of the free atom, the first and second
to be zero) that is usually good enough to iterate to self-consistency.
Actually, you don't need to specify a guess at all.  Programs <b>lm</b>,
<b>lmgf</b>, and
<b>lmpg</b> will assume defaults values if none are supplied.

<BR><BR>

If you have potential parameters at your disposal, you may choose to begin
directly with a band calculation and need not worry about the moments.  You
will need to put the potential parameters in the proper atom file,
described below.  If you wish to make a self-consistent calculation, you
must also supply the boundary condition for each <i>l</i> channel.  In these programs,
the boundary conditions is encapsulated in the "continuously variable"
principal quantum <i>P</i> described in the following paragraphs.
<BR><BR>
To make a sphere self-consistent one needs the moments and also to specify
the boundary condition on the wave function at the sphere radius, or what
is essentially equivalent, the <i>E</i><sub>&nu;</sub> of the wave function <i>&phi;</i>.  For a given
potential, there is a unique correspondence between the logarithmic
derivative <i>D</i><sub>&nu;</sub> at the sphere radius and <i>E</i><sub>&nu;</sub>, so in principle, it is
possible to specify either one.  As a practical matter, however, it is only
straightforward to make the sphere self- consistent by specifying the
logarithmic derivative (since the potential changes while the sphere is
made self-consistent).

<h3><A name="pbasp"></A>Definition of <FONT size="+1"><tt>P</tt></FONT> in terms of the Logarithmic Derivative</h3>

In an augmented wave method, there is the boundary condition on the
wave function &phi; at the augmentation sphere radius. More precisely,
&phi; is called a <i>partial wave</i> since it is only a partial
solution to the full Schrodinger equation.  Partial waves must be
matched to the envelope function at the augmentation sphere radius;
the condition that all partial waves match smoothly and differentiably
at all surfaces is the quantization condition that determines allowed
eigenvalues.  In the augmentation sphere we work in spherical
coordinates. For the purposes of constructing &phi;, (both in the ASA
and FP methods) a spherical potential is assumed which means that the
angular solutions are spherical harmonics and the radial solutions are
partial waves &phi;<sub><i>l</i></sub>, with <i>l</i> the usual
angular momentum number.

In a <i>linear method</i>, &phi;<sub><i>l</i></sub> is assumed to vary
smoothly with energy, and we take a Taylor series around some linearization
energy <i>E<sub>l</sub></i>, so that  <br>

    &nbsp&nbsp&nbsp;&phi;<sub><i>l</i></sub>(<i>E</i>) &asymp;
    &phi;<sub><i>l</i></sub>(<i>E</i><sub><i>l</i></sub>) &nbsp;+&nbsp;
    (<i>d</i>&phi;<sub><i>l</i></sub> /<i>dE</i>)<sub><i>E</i><sub><i>l</i></sub></sub>
    &times;
    [&phi;<sub><i>l</i></sub>(<i>E</i>)-&phi;<sub><i>l</i></sub>(<i>E</i><sub><i>l</i></sub>)]
<br>

It is this linearization of &phi; that simplifies the complicated
matching conditions in augmentated wave methods, rendering the
(nonlinear) matching conditions to into a linear algebraic eigenvalue
problem.  Any linear method must specify a linearization energy
<i>E<sub>l</sub></i>.  Alternatively equivalent information is
contained in the logarithmic derivative
<i>D<sub>l</sub></i>.  For a given potential, there is a unique
correspondence between the logarithmic derivative <i>D<sub>l</sub></i>
of &phi;,
<i>D<sub>l</sub></i>=<i>d</i>ln&phi;<sub><i>l</i></sub>/<i>d</i>ln<i>E</i>
at the sphere radius and <i>E<sub>l</sub></i>, so in principle, it is
possible to specify either one.
<i>D<sub>l</sub></i> is a cotangent-like function, varying between +&infin; and -&infin;:
it decreases monotonically with energy varying between (+&infin;,&minus;&infin;)
over a finite window of energy. There is thus a <i>multiplicity</i> of energies for
a given <i>D<sub>l</sub></i>, one branch for each principal quantum number.
For that reason we define a <i>smooth</i> quantity
<i>P<sub>l</sub></i>, which may be thought of as a smooth version of
<i>D<sub>l</sub></i>, and which also contains
information about both the principal quantum number and
the logarithmic derivative.  <i>P<sub>l</sub></i> is defined as

    <br>
    &nbsp&nbsp&nbsp;
    <i>P<sub>l</sub></i> = 0.5 &minus; arctan(<i>D<sub>l</sub></i>)/&pi; + (princ.quant.number)
    <br>

Its integer part is the principal quantum number; its fractional part
varies smoothly from 0 (for the bottom extreme of the band for that
principal quantum number) to 1 (the top extreme of the band), and can be
thought of in some sense as a "continuously variable" principal quantum
number.

<FONT color="#33bb00"><I>*Note</I>&nbsp;</FONT>
Remember this <i>P</i> should not be confused with the "potential
functions" O.K. Andersen defines in his ASA theory.

<P> The above description of <i>P<sub>l</sub></i> applies to both ASA and FP codes.  In the
free atom code <b>lmfa</b>, <i>P<sub>l</sub></i> and <i>Q<sub>l</sub></i>, where
 <i>Q<sub>l</sub></i> is the charge in orbital <i>l</i>, completely determine
the density and potential of the free atom.  (As noted, another
boundary condition can be used in place of <i>P<sub>l</sub></i>, but as a practical
matter, however, it is only straightforward to make the sphere self-
consistent by specifying the logarithmic derivative (since the
potential changes while the sphere is made self-consistent).

<h3><A name="pbasp2"></A>Potential functions in the ASA</h3>

In the ASA codes (<b>lm</b>, <b>lmgf</b>, <b>lmpg</b>), <i>P<sub>l</sub></i> together with
the moments <i>Q</i><sub>0..2,<i>l</i></sub>&thinsp;, completely determine the potential in the crystal.
Both must be supplied for <b>lm</b> to work.  <i>P<sub>l</sub></i> and
<i>Q</i><sub>0..2,<i>l</i></sub> are typically input directly through the
<A href="tokens.html#STARTcat"><FONT size="+1"><tt>START</tt></FONT> category</A>
in the <FONT size="+1"><tt>ctrl</tt></FONT> file.
<br><FONT color="#33bb00"><I>*Note</I>&nbsp;</FONT>
Because <FONT size="+1"><tt>P,Q</tt></FONT> play a central role,
the ASA codes can read them in various ways, as described by
<A href="tokens.html#STARTcatPQ">this link</A>.

<P> Once you  make a band pass, the fractional part
of <i>P<sub>l</sub></i> will be automatically updated by the output of
the band calculation (provided
<FONT size="+1"><tt>IDMOD</tt></FONT> is not 1; see
<A href="tokens.html#SPECcat"><FONT size="+1"><tt>SPEC_ATOM_IDMOD</tt></FONT></A>
documentation)
but <i>P<sub>l</sub></i> must be supplied (in addition to the moments Q)
if you choose to begin with moments.  A word on choices for the
fractional part of <i>P<sub>l</sub></i>: 0.3 is quite free- electron-like and suitable for
free-electron like l channels such as Si d electrons, while 0.8 is
quite tight-binding like and suitable for deep states like Cu <i>d</i>
orbitals.  To be safe, and probably avoid ghost bands, choose 0.5 for
all l channels.  In awkward cases, it is best to set the <FONT size="+1"><tt>ADNF</tt></FONT> switch
(see below) in the first few iterations; especially for heavier
elements like Hf or <i>f</i>-electron elements like Gd.

<br><FONT color="#33bb00"><I>*Note</I>&nbsp;</FONT>
In
the case of spin-polarized calculations, the moments should all be
half of what they are in non-spin polarized calculations.


<P> When iterating to self-consistency, you have a choice, through the
parameter <FONT size="+1"><tt>IDMOD</tt></FONT>, regarding the related pair of
parameters <i>P<sub>l</sub></i> and <i>E<sub>l</sub></i>.  You may let <i>P<sub>l</sub></i> and <i>E<sub>l</sub></i> float to the center of
gravity of the occupied part of the band (most accurate for
self-consistent calculations); this is the default.  You may also
freeze alternatively <i>P<sub>l</sub></i> or <i>E<sub>l</sub></i> in the self-consistency cycle.  This is
more stable, and is preferable if there is difficulty in achieving
convergence or if problems with ghost bands arise.  <BR><BR> The
program iterates towards self-consistency by mixing the moments and
the parameters <i>P<sub>l</sub></i> as come out of the next iteration.  A choice of
Broyden, Anderson, or linear mixing is available; as
documented in the <A href="tokens.html#ITERcat"><FONT size="+1"><tt>ITER</tt></FONT></A>
category.

<h2><A name="section3"></A>Executable programs</h2>

There are a number of executable programs in the basic package, all of
which are created from the same source file <b>lmv7.f</b>, using
preprocessor <b>ccomp</b> described <A href="#section10">below</A>.
The most useful ones are:

<pre>
  lm     the self-consistent band program for the ASA

  lmstr  generates the real-space structure constants for the ASA
         It must be invoked prior to invoking `lm'.

  <A href="Command-line-options.html#section1lmchk"><B>lmchk</B></A>  displays neighbor tables and augmentation sphere overlaps, among other things.  Much
         of the functionality is activated through command-line
         options described <A
         href="Command-line-options.html#section1lmchk"><B>here</B></A>.

  lmctl  writes out moments (to the log file) in the style of the
         input file, so that a complete calculation can be
         retained within a single file.  See <A href="ASAtutorial.html#lmctl">here</A>
         for an example.

  <A href="Command-line-options.html#section1lmdos"><B>lmdos</B></A>  generates the electron density-of-states (DOS) and
         related quantities as a function of energy for plotting
         or other analysis.  It can generate the total DOS (or
         DOS-related quantities), or resolve the total into
         partial contributions DOS-related quantities lmdos is
         equipped to deal with are, for example the ballistic conductivity and described
         <A href="Command-line-options.html#section1lmdos"><B>here</B></A>.

  catdos concatenates density-of-states generated from different
         files into a single file.

  <A href="Command-line-options.html#section1lmscell"><B>lmscell</B></A> generates supercells from smaller unit cells.


  <A href="Command-line-options.html#section1lmxbs"><B>lmxbs</B></A>  generates an input file for Methfessel's ball-and-stick
         program xbs, which creates a 3D visual display of
         molecules.  You can create an input to his program to
         view the crystal structure specified in the ctrl file.

  <A href="Command-line-options.html#section1lmplan"><B>lmplan</B></A> is a special-purpose program oriented to analysis of layer
         calculations.

  <A href="Command-line-options.html#section1lmimp"><B>lmimp</B></A>  imports potential data from other inputs to create
         trial potentials or densities.
         It can also import data from older versions,
         and Stuttgart versions, of the ASA package.

</pre>

With extension packages, there are also the following programs or extensions:

<pre>
  <A href="fp.html"><B>lmf</B></A>    the self-consistent full-potential LDA program

  <A href="fp.html"><B>lmfa</B></A>   computes the free-atom densities and related information.
         lmfa must be invoked prior to invoking lmf.

  lm     may be extended in the following ways.
         (NC) enables noncollinear extensions to the usual LSDA
         (OPTICS) calculates epsilon(omega) from LDA bands
         (SX) an ASA screened exchange, originally designed to correct
              bandgaps in semiconductors in an ab initio way.
              This latter is not well documented.

  <A href="gf.html"><B>lmgf</B></A>   an ASA Green's function program.  This program uses Green's
         functions to perform an function approximately similar to program
         lm.  Also a branch to compute magnetic exchange interactions.

  <A href="gf.html"><B>lmpg</B></A>   an ASA layer Green's function program.  It is similar to
         lmgf, but uses a layer technique (real-space GF in one dimension,
         k-space in the other two)

  <A href="tbe.html"><B>tbe</B></A>    empirical tight-binding energy, forces, and dynamics.
         User specifies form of hamiltonian.

  <A href="gw.html"><B>lmfgwd</B></A> a driver for all-electron GW packages.

</pre>
Additionally there are the following executables:

<pre>
  rdcmd  a program with a function approximately similar to a shell script
         that reads commands and executes them.  It is used extensively
         in the test suites.

  <A href="#section10"><B>ccomp</B></A>  a program written in C which provides a fortran-compatible
         functionality approximately similar to that of the unix
         preprocessor, cpp.
</pre>

<BR>


<FONT color="#bb3300"><I>Generating and plotting energy bands</I>&nbsp;</FONT></A>
See <A href="generating-energy-bands.html">generating-energy-bands.html</A>.

There is a plotting package available, FPLOT.<i>vsn</i>.tar.gz, with a
collection of programs suitable for plotting density-of-states
(<b>pldos</b>), bands (<b>plbnds</b>) and other x-y plots.  In includes a
general-purpose plotting program,
<b>fplot</b>, which creates x-y and contour plots, in postscript format.
(As of this writing, the most recent package is <FONT size="+1"><tt>FPLOT.3.39.tar.gz</tt></FONT>.)

Run <b>lm</b> or some other band program to generate energy bands
<A href="generating-energy-bands.html#symmetrylinemode">along symmetry lines</A> you choose.
Program <b>plbnds</b> reads this file and can either (1) generate a postscript file
directly, or (2) generate input and a script to be read by the
<b>fplot</b> program.  In this way you can tailor a figure to taste.
You can also generate bands <A
href="generating-energy-bands.html#contourmode">on a uniform mesh in a
plane,</A> for contour plots of constant energy surfaces, such as the
Fermi surface in a plane.  There is also a general-purpose <A
href="generating-energy-bands.html#listmode">list mode</A> for
generating states at any desired list of <i>k</i>-points, e.g. for
plotting Fermi surfaces in 3D.


<P> <FONT color="#bb3300"><I>Generating and plotting densities-of-states</I>&nbsp;</FONT></A>
See <A href="generating-density-of-states.html">generating-density-of-states.html</A>.

For generating and plotting total or partial densities of states (DOS), there are several modes,
depending on which executable you use.

<h2><A name="section4"></A>Input files</h2>

The control file, called <FONT size="+1"><tt>ctrl.<I>extension</I></tt></FONT> is the main input file for
all programs.  It together with command line arguments (see section
"Command-line switches") that affect some program execution flow, are the
two principal (often sole) input streams needed to run these packages.  The
string <FONT size="+1"><tt><I>extension</I></tt></FONT>, or (<FONT size="+1"><tt>ctrl.<i>extension</i></tt></FONT>) is supplied as a command-line argument.  If no
extension is supplied on the command-line, `<FONT size="+1"><tt>ctrl.dat</tt></FONT>' is used as the input file.
<BR><FONT color="#33bb00"><I>*Note</I>&nbsp;</FONT>
The programs cannot read a <FONT size="+1"><tt>ctrl</tt></FONT> file containing unreadable characters.

<P> Thus the invocation of any program has a form
<pre>
  program-name [-switches] [file-extension]
</pre>

For a description of the generic structure of input files and its
organization into categories and tokens, see
<A href="input-file-style.html">input-file-style.html</A>
and <A href="input.pdf">input.pdf</A></B>.

<FONT size="+1"><tt>ctrl.<i>ext</i></tt></FONT>
is the main (and typically only, at least initially) input file.
Its free format enables you to document what you are doing.
A sample is given <A href="input-file-style.html#sampleinput">here</A>.

The categories and tokens are documented in
<A href="tokens.html">tokens.html</A>.


Nearly all files associated with the input file have the same
extension appended to them as does the <FONT size="+1"><tt>ctrl</tt></FONT> file.  Thus if the
<FONT size="+1"><tt>ctrl</tt></FONT> file is called
&nbsp;<FONT size="+1"><tt>ctrl.cr3si6</tt></FONT>, the <A href="#section5">log file</A> is called
&nbsp;<FONT size="+1"><tt>log.cr3si6</tt></FONT>.

Command-line switches are documented <A href="Command-line-options.html#section1">here</A>.
<P>
Other input files are:
<pre>
 k-points file (default name qp.<i>ext</i>): input file to specify <i>k</i>-points,
    mainly for plotting energy bands or Fermi surfaces.
    It is used when the <A href="Command-line-options.html#section1">--band</A> switch is passed. See <A href="generating-energy-bands.html#symmetrylinemode">here</A>
    for description of the options available with the --band plotting mode.
    The k-points file can take one of several forms; see
    <A href="generating-energy-bands.html#symmetrylinemode">generating-energy-bands.html</A> for details.

 site file : Normally site data is read through the ctrl file.
    However you may choose to read structural and site data
    through a separate file.  It is intended that this file
    accommodate any of several formats.  To date there is a
    format `standard' to this program, and one specified by
    Kotani.  See <A href="../subs/iosite.f">subs/iosite.f</A> for syntax of file structure.

    You specify this option, and the file name using the `FILE='
    token in the ctrl file, described in
    <A href="tokens.html#SITEcat">tokens.html</A>.
    Supercell generator `lmscell' has the capability to write a site
    file suitable for reading by other programs.

 positions file : similar to the site file, but limited to
    specification of site positions.  File is read (and named) by
    command-line switch --rpos=`filename'; and some programs (eg
    lmctl) will create this file when command-line switch
    --wpos=`filename' is supplied.

 qpts file : Programs needing to loop over the Brillouin zone
    normally generate their own table of q-points.  However, you
    may specify your own set of points (with certain
    restrictions; see description of token GETQP= in
    "<A href="tokens.html#BZcat">tokens.html</A>").  Here is a sample
    q-points file:

            8    4    4    4       0
            1    0.00    0.00    0.00    0.03125
            2   -0.25    0.25    0.25    0.25000
            3   -0.50    0.50    0.50    0.12500
            4    0.00    0.00    0.50    0.18750
            5   -0.25    0.25    0.75    0.75000
            6   -0.50    0.50    1.00    0.37500
            7    0.00    0.00    1.00    0.09375
            8    0.00    0.50    1.00    0.18750

    The first line specifies the total number of qp; the next
    three numbers are not used; the last should be zero.  Next
    follows lines, one line per qpt, each line with 5 numbers.
    The first merely labels the qp index; the next three are the
    qp in Cartesian coordinates.  The last is the qp weighting
    factor, and the weights should sum to 2.
</pre>

<H2><A name="section5"></A>Generated files</H2>

The executables above generate many kinds of derivative files,
briefly described below.  The file extension is suppressed in the
following table.

<pre>
  File  (creator), and description
  ---   --------------
  ctrl  the main input for all programs.
        It is never altered by any program in the package.

  log   (*) records a log of the most important output in
        abbreviated form.

  str   (lmstr;binary) real-space structure constant file
  sdot  (lmstr;binary) file containing energy derivative of str.

  moms (lm,lmf;binary) partial weights of overlap matrix
        decomposed into <I>Rl</I> or <I>Rlm</I> channels.  Used in two
        contexts: (1) to save information needed to the energy
        moments after the sampling weights are known, and (2)
        this is the data needed resolve density-of-states
        information into into <I>Rl</I> (or <I>Rlm</I>) channels.  For large
        systems, this file can become large, particularly if the
        dos need to be m-resolved.  See also the <A href="#Command-line-options.html#section1lm">--pdos</A>
        command-line option.  See file <A href="../subs/asaddq.f">asaddq.f</A> for the
        generation of the dos weights and their storage;
        program <A href="#Command-line-options.html#section1lmdos">lmdos</A> reads this or a similar file to
        create a the partial DOS.

  qpp   (lm;binary) information similar to moms, but intended for
        retaining information for nonspherical density inside MT
        spheres.

  wkp   (lm,lmf;binary) table of band weights needed to find Fermi
        level, and corresponding fermi level.

  mixm  (lm,lmgf,lmpg,lmf;binary) retains prior iterations of sets
        of input and output moments.  Used by the Anderson or
        Broyden mixing scheme to accelerate convergence towards
        self-consistency.  Usually you should delete these when
        starting a new calculation (such as changing the lattice
        constant) so it doesn't get used in subsequent runs.  NB
        mixm is the default name of the mixing file, but this
        name may be set by the user.

  tmp   (*,binary) used for virtual memory or temporary storage

  atom-files (ASA) one file is assigned for each inequivalent
        atom in a calculation.  Its name is fixed by the species
        label ATOM= in the SPEC category of the control file, as
        described in <A href="tokens.html#SPECcat">tokens.html</A>.  A complete file contains some
        general information, the moments, potential parameters, or
        other parameters such as matrix elements for needed for
        spin-orbit coupling or matrix elements of the gradient
        operator needed for optics calculations, and the ASA potential
        within the sphere, or some subset of this information.  The
        moments and potential parameters are most read from this file
        if they are available; but it is possible to input the moments
        instead from the control file or the restart file as well.
        Data in the atomic file is grouped into categories delineated
        by a nonblank character in the first column.  Examples of
        categories are: GEN: a table of miscellaneous data, such as
        the site atomic number MOMNTS: the "log derivatives" <i>P<sub>l</sub></i> and
        moments Q PPAR: the potential parameters.  POT: the potential


  bnds  (lm,lmf,lmbnd,tbbnd) energy bands, in a tabular form. See
        description of plotting package FPLOT.*.gz for plotting
        bands.

  dos   (lmdos,tbdos) density-of-states, in tabular
        form. See description of plotting package FPLOT.*.gz for
        plotting dos.

  sv    (lm,lmgf,lmpg) records the total energy deviation from
        self-consistency for each iteration.

  save  (lm,lmgf,lmpg,lmf) outputs the magnetization and total
        energy each iteration in the self-consistency cycle,
        together with some variables assigned by the user.  Used
        in conjunction with script startup/vextract, the total
        energy as a function of some user-specified parameters
        can be conveniently extracted in tabular form.

  atm   (lmfa) free-atom densities and related information, needed
        to start full-potential programs

  rst   (lmf,binary) restart file, containing density and related
        information.  Together with the ctrl file, this file contains
        all information needed for a calculation
  rsta  (lmf) same information as rst, but file is formatted, and
        therefore both portable across machines and amenable to
        editing.

  eula  (noncollinear package) holds a table of Euler angles.

  jr    (lmgf) table of pairwise exchange interaction parameters

  qpts  (lm,lmgf,lmpg,lmf) table of q-points, if user chooses to
        specify them.

  hssn  (lm,lmgf,lmpg,lmf) hessian matrix, containing densities of
        prior iterations, used for charge mixing in the
        self-consistency cycle.

  gfqp  (lmgf;binary) temporary file holding Green's functions for
        each q-point in the BZ at one energy.  Used in branches
        where the GF over the entire zone is need at once,
        (e.g. linear-response branches).  For large systems or
        many k-points, this file can become extremely large.

  psta  (lm,lmgf) bare ASA response function for e->0, q->0.
        See <A href="linear-response-asa.html">linear-response-asa.html</A>.

  sigm  (lm:sx) ASA self-energy, generated using sx branch

  vshft (lmgf,lmpg) a list of site potential shifts
</pre>

<h2><A name="section8"></A>Selection of Sphere Radii</h2>

One of the biggest nuisances for augmented-wave programs is the choice
of sphere radius.  Results are much more sensitive to choice of
spheres in the ASA than in the full-potential case, in part because
the energy functional (and potential) change with MT radii, whereas in
the FP case, this only weakly so.  Either for the ASA or FP, the radii
are chosen by balancing the following competing needs:

<DL>
<DT><I>MT potentials are exactly solvable</I>
<DD>
  The KKR method is essentially exact for a MT potential, i.e. one
  that is spherical inside augmentation spheres and flat in the
  interstitial.  The LMTO basis starts from the KKR basis; thus a
  partitioning of space which best resembles a MT potential is the
  best choice.  This is particularly true for the ASA.

</DD>
<DT><I>Geometry violation of overlapping spheres</I>
<DD>
Overlapping spheres count some parts of space twice and others not at
all.  In the ASA, the "combined correction" term partially undoes this
error, but not completely.  The full-potential hamiltonian is
constructed so that the sphere contributions vanish quadratically for
radii approaching the MT radius.  Errors tend to be small until
overlaps reach about 10% of the internuclear distance.

</DD>
<DT><I>ASA Requirement for space-filling spheres</I>
<DD>
The ASA functional pretty much requires that the sum-of-sphere volumes
equals the cell volume.  More precisely, the density is carried by the
spheres (superposition of spherically symmetrical sphere densities).

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
than in the ASA, shallow semicore states can be an issue.

</DL>

This program suite helps you set sphere radii in several ways.  Programs
using already-chosen (or guessed) sphere radii can <A href="#section8.1">rescale
sphere radii</A> up to a specified volume within constraints you supply.
Also program <A href="Command-line-options.html#section1lmchk">lmchk</A> can
supply intelligent <A href="#section8.2">values</B></A>
for sphere radii (usually better than you can guess on your own).

<h3><A name="section8.1"></A>Automatic scaling of sphere radii</h3>

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

<h3><A name="section8.2"></A>Choosing initial values of sphere radii</h3>

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

<h3><A name="section8.3"></A>Finding empty spheres</h3>

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

<H2><A name="section10"></A>Program ccomp</h2>

<pre>

*A preprocessor, ccomp, provides a simplified, FORTRAN compatible
 version of C conditional compilation.  FORTRAN statements
 beginning with C# are preprocessor directives; the ones
 implemented now are C#ifdef, C#ifndef, C#else, C#elseif, C#endif
 (also C#define defines a name).  Directives C#ifdef, C#ifndef,
 C#elseif, and C#endif are followed by a name, eg C#ifdef CRAY.
 when C#ifdef is false (either name is not defined or it lies
 within an #if/#endif block that is false), ccomp comments out
 until a change of state (new C#ifdef, C#ifndef, C#else,
 C#elseif, C#endif encountered); C#ifdef is true, ccomp
 uncomments lines following until another conditional compilation
 directive is encountered.

*Conditional compilation blocks may be nested.  As with C, ccomp
 distinguishes case.  Output is to standard out.

*There is a primitive facility to make logical expressions using
 the AND (&) and OR (|) operators, such C#ifdef john & bill, or
 C#ifdef john | bill, is provided.  Precedence of operators is
 strictly left to right, so that john | bill & mike is equivalent
 to (john | bill) & mike, whereas john & bill | mike is
 equivalent to (john & bill) | mike

*How ccomp determines whether to modify code (i.e. add comments,
 or delete comments from a code segment)

 Whether the lines following a C#ifdef, C#ifndef, C#else,
 C#elseif, C#endif need to be commented out or uncommented
 depends on whether they have been commented out in a previous
 pass.  This information is contained in a `C' following the
 directive, eg C#ifdefC, C#ifndefC, C#elseC, C#elseifC, C#endifC.
 The preprocessor will set this, it is best advised to create any
 new blocks uncommented and let the preprocessor do the
 commenting.

 Programs <b>lm</b>, <b>lmstr</b>, <b>lmdos</b>, <b>lmchk</b>, etc..
 are in fact the same source code, the only difference being that one
 is run through ccomp with different keywords defined.  ccomp is used
 extensively by `configure' both to create new branches code, to and
 customize code specific to certain compilers, either for optimization
 purposes or to avoid compiler bugs.

</pre>

<h2><A name="section11"></A>2nd generation Orbital Downfolding</h2>

<pre>
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

</pre>


<h2><A name="references"></A>References</h2>

<FN ID=fnasa><P> O. K. Andersen, "Linear methods in band theory,"
Phys. Rev. B12, 3060 (1975); O. K. Andersen and O. Jepsen,
"Explicit, First-Principles Tight-Binding Theory," Phys. Rev. Lett. 53, 2571 (1984)
</FN>

<FN ID=nmto><P>
O. K. Andersen, T. Saha-Dasgupta, R. W. Tank, and G. K. C. Arcangeli O. Jepsen,
"Developing the MTO Formalism," in <i>Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method</i>, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.
</FN>

<FN ID=fnlmf><P>
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in <i>Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method</i>, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.
</FN>


<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>

</HTML>
