---
layout: page-fullwidth
title: "The ccomp processor"
permalink: "/docs/misc/ccomp/"
header: no
---
_____________________________________________________________


### _Introduction_
{:.no_toc}

Questaal's codes are compiled with a source code preprocessor, 
**ccomp**{: style="color: blue"}.  This tool, written in C,
performs a similar function to the conditional compilation

~~~
# if expr
# else
# endif
~~~

found in modern programming languages.  It was necessary when the
package was first written because conditional compilation was not part
of FORTRAN.  

Questaal still uses it in part because of backwards compatibility,
but also becasue it retains some advantages over conditional compilation.

_____________________________________________________________

### _The **ccomp**{: style="color: blue"}  processor_

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
