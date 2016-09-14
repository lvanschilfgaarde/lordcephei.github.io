---
layout: page-fullwidth
title: "Package Overview"
permalink: "/package_overview/"
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
oOrbitals); while partial waves are obtained by integrating the
Schrodinger equation numerical on a radial mesh inside the
augmentation sphere.  The reason for augmentation is to allow basis
functions to vary rapidly near nuclei where they must be orthogonalized to
core states.

Augmented-wave methods consist of an "atomic" part that solves for the partial waves on a numerical mesh inside
augmentation spheres and makes the relevant matrix elements needed, e.g. for the hamiltonian or some other property
(e.g. optics) and a ``band'' part, that diagonalizes the secular matrix of the hamiltonian made by the
augmented envelope functions.

### _Questaal's Envelope Functions_

The primary code in the density-functional package (**lmf**{: style="color: blue"}) uses atom-centered functions for
envelope functions. They are convolutions of a Hankel and Gaussian centred at the nucleus.  Thus they differ from Hankel
functions (which are the envelope functions of the LMTO method): unlike Hankel functions they are smooth at the origin
but for large _r_ retain the same asymptotic dependence on _r_ as Hankel functions.  The mathematical properties of
these functions are described in some detail in [this paper](http://scitation.aip.org/content/aip/journal/jmp/39/6/10.1063/1.532437)

Such a basis has significant advantages --- basis sets are much smaller for a given level of precision, but they are
also more complex.  It is also possible to take a combination of these functions and plane waves -- another unique
feature of this package.

**Note**{: style="color: red"} The codes in this package based on the [Atomic Spheres Approximation](https://lordcephei.github.io/lmto_asa_doc.md/)
use conventional LMTO basis sets.

### _Augmentation_

**lmf**{: style="color: blue"} carries out augmentation in a different manner than standard augmented wave methods.  It
somewhat resembles the PAW method, though in the limit of large angular momentum cutoff it has exactly the same behavior
that standard augmented-wave methods do.  The advantage to the current scheme is that it converges more rapidly with
angular momentum cutoff.

<P> Several LDA codes belong to the package: the standard one is an all-electron
full-potential method; there is also a molecules-specific code, and several
codes that make the
<A href="lmto.html#section2">Atomic Spheres Approximation to the LDA
(ASA)</A>, a
<a href="#fnasa">theory</a> formulated by O. K. Andersen.  Development
of the ASA occured historically; it is still of value because, while
being less precise than what
<A href="fp.html">full-potential</A> methods offer,
it is extremely efficient and many properties can be calculated with
it, such as
<A href="optics.html">optical properties</A> and
<A href="Demo_ASA_copt.html#exchange">magnetic exchange parameters</A>
entering into the Heisenberg model.

<P> These codes use the method of
<a href="#fnasa">linear muffin-tin orbitals</a> (LMTOs) formulated by
O. K. Andersen within the ASA.  LMTO refers to a basis set; it
often is, but need not be, tied to the ASA.  There is also a
<A href="fp.html">full-potential</A> implementation in this package.
While the envelope functions (basis) are related to LMTOs, they are actually
<A href="#smhankel">convolutions of Gaussian and Hankel functions</A>,
and are more flexible and general.  They are also smooth and regular
at the origin --- important properties in the full-potential context,
but the greater flexibility also adds greater complexity.  Starting
with <i>v</i>7, the basis can be built out of a
<i>combination</i> of  Augmented Plane Waves (APWs) and LMTOs
<a href="#pmt">(the PMT method)</a>, a capability unique to this code.


<P> This package also contains <A href="gw.html">front-end</A> for <i>GW</i> calculations, an
<A href="#allelectrongw">all-electron implementation</A> of conventional <i>GW</i>
where <i>G</i> and <i>W</i> are
generated from the LDA, and also the
<A href=#qsgw> Quasiparticle Self-consistent <i>GW</i> approximation</A> (QS<i>GW</i>). The <i>GW</i> approximation is
a perturbation theory around some one-body hamiltonian
(e.g. the LDA hamiltonian), based on many-body perturbation theory.  In the
QS<i>GW</i> approximation, self-consisistency is used to minimize the explicitly
many-body parts of the hamiltonian, putting as much as possible into the
one-body part.  This makes it very accurate,
<A href="#adequacygw">much superior to conventional implementations</A>
of <i>GW</i> that usually rely on the LDA for the starting point.

<br><br>

There is also an implementation for empirical tight-binding hamiltonians ---
useful for simulations of systems too large to be easily accessible by
density-functional methods.

<h2><A name="lda"></A>Capabilities</h2>

This package has several kinds LDA-based programs designed for
different purposes, outlined below.  In the LDA (and other theories)
the effective potential electrons see is generated self-consistently
in some approximation to the exact many-body problem.  The effective
potential of a system must be determined iteratively in a
<A href="self-consistency.html">self-consistent manner</A>.  What form
self-consistency takes depends on the program used and property
considered.  After self-consistency is reached, programs can be used
to probe for a variety of physical properties, such as the
<A href="generating-energy-bands.html">energy bands</A>,
<A href="generating-density-of-states.html">density-of-states</A>,
<A href="optics.html">optical properties</A>,
<A href="Demo_ASA_copt.html#exchange">magnetic exchange interactions</A>, and
<A href="pgf.pdf">Landauer-Buttiker transport through layered
systems</A>.

Recently the ability to calculate properties alloys and disordered
spin systems in the
<A href="cpa.html">coherent potential approximation</A>
has been added.

<P> Electronic structure theory is implemented in the following forms:

<P>
<i>Atomic Spheres Approximation</i>&nbsp; There is a suite of codes based on the
<a href="#fnasa">ASA</a>.
The ASA code is very fast and efficient, and it has many extensions, e.g.
<A href="nc.html">noncollinear magnetism</A>,
<A href="optics.html">optics</A>, and a scheme to
<A href="levenberg-marquardt.html#bigbandexample">fit bands</A> or
<A href="levenberg-marquardt.html#dosexample">densities-of-states</A>
to given quantities (e.g. those generated by
QS<i>GW</i>), by adjustments to
<A href="lmto.html#section2"> ASA-LDA potential parameters</A> via a
<A href="levenberg-marquardt.html"> Levenberg-Marquardt minimization</A>
algorithm.  The user is cautioned that the
ASA is much less reliable, and must be used with some care.
For a quick look at how it works, skim through
<A href="Demo_ASA_copt.html">this demo</A> of the ferromagnet Co<sub>3</sub>Pt.

<br><A href="lmto.html">lmto.html</A> describes the capabilities of ASA code.
It contains information generic to the package as a whole, such as a description
of a number of useful
<A href="lmto.html#section3">auxiliary programs</A>, such as a supercell maker.
Even if you do not plan to use the ASA package, it is recommended that
you read this document.

<P> <i>Full-potential LDA</i>&nbsp; <A href="fp.html">fp.html</A> documents
the capabilities of the all-electron, full-potential LDA program.  It
implements standard DFT functionals, though the
<A href="#fnlmf">form of implementation</A> is novel.  It has a
three-fold representation of the charge density and has shares
elements in common with the LAPW and PAW methods, and may be thought
of as a framework that bridges the two.

<P> <i>All-Electron GW</i>&nbsp; This code is also linked to a <i>GW</i> package;
For a quick look at a practical demonstration of the LDA and GW package working together, see the
<A href="Demo_QSGW_Si.html">LDA + GW + QSGW demo</A> for Si.
The driver to the GW package is documented in <A href="gw.html">gw.html</A>,.
See <A href="GWpracticum.pdf">this page</A> for a
tutorial outlining how to construct the input to the <i>GW</i> package,
and the linkage between the LDA and GW packages.

<P><i>Molecules code</i>&nbsp; There is a program designed just for
   molecules.  It is fast and efficient, but a little unstable.  It is
   not documented.  If you want to use this package, contact Tony Paxton at
   <A HREF=MAILTO:Tony.Paxton@kcl.ac.uk><FONT size="+1"><tt>Tony.Paxton@kcl.ac.uk</tt></FONT></A>.

<P><i>Empirical tight-binding</i>&nbsp; is not density-functional
based, but implements model tight-binding hamiltonians.  The user can
specify the form of the model in one of several possible ways.  This
code has been highly tuned and it can be used to efficiently study
systems with thousands of atoms.  To use this code contact the primary
author of the current implementation, Dimitar Pashov
(<A HREF=MAILTO:dimitar.pashov@kcl.ac.uk><FONT size="+1"><tt>dimitar.pashov@kcl.ac.uk</tt></FONT></A>).

<P> These various implementations are collected in a family of executable
programs that share a common, elegant
<A href="input-file-style.html">input system</A>, which has some elements of a programming language.
The family consists of the following:

<BR>

<LI> <B><A href="lmto.html">lm</A></B>: the standard LDA band program, in the Atomic Spheres Approximation,
     and its companion <b>lmstr</b>, which makes structure constants <b>lm</b> requires to execute.
     There is a <A href="ASAtutorial.html">tutorial</A> that goes through a sample calculation,
     as well as <A href="Demo_ASA_copt.html">a demo</A> that highlights some of its features.

<LI> <b><A href="fp.html">lmf</A></B>: the standard full-potential LDA band
     program, and a companion program <b>lmfa</b> for free atoms (needed to
     start <b>lmf</b>).  Both the basis and the form of implementation of
     density-functional theory are original with this code; a reference
     describing the implementation can be found in this <A href="#fnlmf">book
     chapter</a>.  The theory for the envelope functions can be found in this
     <A href="#smhankel">J. Math Phys.</A> article. One
     <A href="FPtutorial.html">tutorial</A> explains the input and output; another shows to build input files
     <A href="Building_FP_input_file.html">automatically</A>.

<LI> <B><A href="gf.html">lmgf</A></B>: a Green's function program based on the
     ASA.  Its unique contribution to the suite is that it permits the
     calculation of magnetic exchange interactions, and (starting with v7.8) has
     an implementation of the
     <A href="cpa.html">coherent potential approximation</A> to treat
     chemical and/or spin disorder.

<LI> <B><A href="pgf.pdf">lmpg</A></B>: a layer Green's function
     program also based on the ASA that works for layered
     systems (periodic in 2D).  It can calculate transport using the
     Landauer-Buttiker formalism, and has a non-equilibrium
     capability.  There a
     <A href="lmpg_tutorial.v2.0.pdf">tutorial</A>, though it is somewhat out of date.

<LI> <B><A href="gw.html">lmfgwd</A></B>: a driver for an
     all-electron <i>GW</i> package, which has a
     highly robust product basis for the construction of the
     dielectric function and coulomb interaction.  It can be run in
     1-shot mode, or the quasiparticle self-consistent mode.

<LI> <b>lmmc</b>: a (fast) LDA-based molecules program (not documented).

<LI> <B><A href="tbe.html">tbe</A></B>: a band structure program that uses empirical
     tight-binding hamiltonians. One
     unique feature of this package is that self-consistent
     calculations can be done (important for polar compounds), and
     includes Hubbard parameters.  It is also highly parallelized, and versions can be built that work with GPU's.

</LI>

<BR>
The following executables are compiled with the basic package:

<LI> <A href="Building_FP_input_file.html"><b>blm</b></A>: an input file maker for the full-potential program <b>lmf</b>; see
     <A href="Building_FP_input_file.html">Building_FP_input_file.html</A> for a tutorial.

<LI> <B><A href="Command-line-options.html#section1lmscell">lmscell</A></B>: a supercell maker.

<LI> <B><A href="Command-line-options.html#section1lmchk">lmchk</A></B>: a neighbor
     table generator and augmentation sphere overlap checker. There is an
     option to automatically determine sphere radii. (There is another
     option to locate interstitial sites where empty spheres or
     floating orbitals may be placed --- important for ASA and some
     <i>GW</i> calculations).

<LI> <B><A href="Command-line-options.html#section1lmxbs">lmxbs</A></B>: generates
     input for the graphics program &thinsp;<FONT size="+1"><tt>xbs</tt></FONT>&thinsp; written by M. Methfessel,
     which draws pictures of crystals.

<LI> <B><A href="Command-line-options.html#section1lmdos">lmdos</A></B>: generates
     partial densities of states, run as a postprocessor after
     execution of <b>lmf</b>, <b>lm</b>, or <b>tbe</b>.

</LI>

<br>
Some other auxiliary programs are also made; see <A href="lmto.html#section3">here</A>.  To plot the bands or density-of-states
you can use your favorite package, or consider using a graphics package
(FPLOT.<I>vsn</I>.tar.gz) tailored to work with these programs.  The &thinsp;<FONT size="+1"><tt>FPLOT</tt></FONT>&thinsp;
package has a number of useful features not found in widely used packages, such as the ability to plot energy bands with
<A href="generating-energy-bands.html">color weights</A>.

<h2><A name="input"></A>Input System</h2>

All programs use a common input system.  It is a unique system that parses
input in a largely format-free, tree-structured format.  There is some
programming language capability: e.g. input lines can be conditionally
read, you can declare variables and use algebraic expressions.  Thus a
single file can serve as database (one input file for many
materials systems) and for documentation.  Look at
<A href="input-file-style.html">input-file-style.html</A> for an
easy-to-follow example illustrating how an input file is structured, and
how input is organized by categories and tokens.  It is an operational
input file, and you can see how quantities used in typical calculations are
supplied; and it hints at some of the many possibilities of this very
flexible and versatile interface.  You are advised to go through that web page before
attempting any calculations.
<A href="input.pdf">input.pdf</A> provides a somewhat dull, but
more complete description of the input syntax.  Finally see
<A href="tokens.html">tokens.html</A> for documentation of tokens
read by the various programs, and their meaning.

<P>

There is one main input file all programs use, &thinsp;<FONT size="+1"><tt>ctrl.<i>ext</i></tt></FONT>; it can be complicated as
there are many options available.
<A href="Building_FP_input_file.html">Building_FP_input_file.html</A> is a tutorial that explains options
automatically build an input file for the FP program, starting from lattice data you supply or import.

<P> A second stream of input comes through
<A href="Command-line-options.html">command-line switches</A>.  There are a few switches all programs use, and
there are also a large number of program-specific options, described
<A href="Command-line-options.html">here</A>.  You can get a listing of switches a particular program uses
by invoking the program with &thinsp;<FONT size="+1"><tt>--help</tt></FONT>, e.g. &thinsp;<FONT size="+1"><tt>lm --help</tt></FONT>.

<P> There can be many files associated with each calculation.  Most of them are made
automatically by an executable program; some files are editable so the user can
modify them.  In a few instances more than one input file is required to get
started, e.g. the <i>GW</i> code requires file
&thinsp;<FONT size="+1"><tt>GWinput</tt></FONT>.  File
&thinsp;<A href="README"><FONT size="+1"><tt>README</tt></FONT></A>&thinsp;
supplies a brief description of the contents of each file in this directory, and
the directories in the top-level directory (note: this file is a bit out of date).

<h2><A name="compatibility"></A>Backwards Compatibility</h2>

Version 7 underwent a radical internal redesign of the input system.
Externally there are only a few differences; but the <i>v</i>7 input files
are not exactly backwardly compatible with the <i>v</i>6 files.  A few tokens
were put in different categories; some default values were changed;
some tokens were merged or grouped a little differently.  Also the old
style inputs of complex numbers ("structures"), e.g.
&thinsp;<FONT size="+1"><tt>MSTAT</tt></FONT>&thinsp; and &thinsp;<FONT size="+1"><tt>SDYN</tt></FONT>,
are now rendered in a (consistent) tree format.

<P>Program <b>lm67</b> can facilitate the job of updating the
&thinsp;<FONT size="+1"><tt>ctrl</tt></FONT> file.  It will read <i>v</i>6 input files and print to standard
output changes you need to make to render a <i>v</i>6 input file compatible
with <i>v</i>7 input.  The needed changes depend to some extent on the
executable program.  By default
<b>lm67</b> looks for changes appropriate to <b>lmf</b>.  For changes
relevant to other executables, e.g. <b>lm</b>, do:
<pre>
  lm67 --prog=LM ...
</pre>

Besides rearrangements or renaming of some tokens, one or two small
differences in the computational part were made to the FP program
<b>lmf</b>, and results may be slightly different from <i>v</i>6.

<h2><A name="installation"></A>Installation</h2>

Starting with version 7.11, the installation scripts have also been radically revised.
The entire package is distributed as one tarball; executables are built
with a python script.

<h3>Old style installation</h3>

Prior to version 7.11, the package was distributed in parts:
<pre>
TB.<i>vsn</i>.tar.gz OPTICS.<i>vsn</i>.tar.gz MOL.<i>vsn</i>.tar.gz GF.<i>vsn</i>.tar.gz ASA.<i>vsn</i>.tar.gz SX.<i>vsn</i>.tar.gz PGF.<i>vsn</i>.tar.gz NC.<i>vsn</i>.tar.gz GWD.<i>vsn</i>.tar.gz  FP.<i>vsn</i>.tar.gz
</pre>
in addition to the math library &thinsp;<FONT size="+1"><tt>SLATSM.<i>vsn</i>.tar.gz</tt></FONT>
which was installed independently.

In this scheme, executables are installed from a &thinsp;<FONT size="+1"><tt>configure</tt></FONT>&thinsp; script, which creates a collection of Makefiles.
Executables are built in the top-level directory.

To make an easy transition, compatibility the old style installation
scripts are temporarily maintained.  Executables are built in the
top-level directory.  To install you must first install package
&thinsp;<FONT size="+1"><tt>SLATSM.70.tar.gz</tt></FONT>&thinsp; (or a
later version), &nbsp;a library of generic numerical, string and
functions.  The &thinsp;<FONT size="+1"><tt>SLATSM</tt></FONT>&thinsp;
library comes with its own set of installation instructions
(file <FONT size="+1"><tt>startup/README</tt></FONT>), which must be
done before installing this package.

### _Other Resources_

<FN ID=cpa><P>
I. Turek et al., Electronic strucure of disordered alloys, surfaces and interfaces (Kluwer, Boston, 1996).
</FN>

<FN ID=fnlmf><P>
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in <i>Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method</i>, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.
</FN>

<FN ID=smhankel><P>
E. Bott, M. Methfessel, W. Krabs, and P. C. Schmid,
<i>Nonsingular Hankel functions as a new basis for electronic structure calculations</i>
J. Math. Phys. 39, 3393 (1998).

<FN ID=fnasa><P> O. K. Andersen, "Linear methods in band theory,"
Phys. Rev. B12, 3060 (1975); O. K. Andersen and O. Jepsen,
"Explicit, First-Principles Tight-Binding Theory," Phys. Rev. Lett. 53, 2571 (1984)
</FN>

<FN ID=pmt><P>
T. Kotani and M. van Schilfgaarde,
``A fusion of the LAPW and the LMTO methods: the augmented plane wave plus muffin-tin orbital (PMT) method''
Phys. Rev. B81, 125117 (2010)

<FN ID=allelectrongw><P>
T. Kotani and M. van Schilfgaarde,
<i>All-electron <i>GW</i> approximation with the mixed basis expansion based on the full-potential LMTO method</i>, Sol. State Comm. 121, 461 (2002).

<FN ID=qsgw><P>
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
<i>Quasiparticle self-consistent <i>GW</i> theory</i>
<A href=http://link.aps.org/abstract/PRL/v96/e226402>Phys. Rev. Lett. 96, 226402 (2006)</A>;
Takao Kotani, M. van Schilfgaarde, S. V. Faleev,
<i>Quasiparticle self-consistent <i>GW</i> method: a basis for the independent-particle approximation</i>,
<A href=http://link.aps.org/abstract/PRB/v76/e165106>Phys. Rev. B<b>76</b>, 165106 (2007)</A>

<FN ID=adequacygw><P>
M. van Schilfgaarde, Takao Kotani, S. V. Faleev,
<i>Adequacy of Approximations in <i>GW</i> Theory</i>
<A href=http://link.aps.org/abstract/PRB/v74/e245125>Phys. Rev. B74, 245125 (2006)</A>.

<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>



</HTML>
