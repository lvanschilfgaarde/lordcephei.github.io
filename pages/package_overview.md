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

### _Questaal's Envelope Functions_

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

+ **lmf**{: style="color: blue"}: the standard full-potential LDA band program.  It has a companion program **lmfa**{: style="color: blue"} to calculate starting wave functions for free atoms and set up trial envelope functions.  See [this page] for a basic tutorial
     start <b>lmf</b>).  Both the basis and the form of implementation of
     density-functional theory are original with this code; a reference
     describing the implementation can be found in this <A href="#fnlmf">book
     chapter</a>.  The theory for the envelope functions can be found in this
     <A href="#smhankel">J. Math Phys.</A> article. One
     <A href="FPtutorial.html">tutorial</A> explains the input and output; another shows to build input files
     <A href="Building_FP_input_file.html">automatically</A>.


<LI> <B><A href="lmto.html">lm</A></B>: the standard LDA band program, in the Atomic Spheres Approximation,
     and its companion <b>lmstr</b>, which makes structure constants <b>lm</b> requires to execute.
     There is a <A href="ASAtutorial.html">tutorial</A> that goes through a sample calculation,
     as well as <A href="Demo_ASA_copt.html">a demo</A> that highlights some of its features.

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
