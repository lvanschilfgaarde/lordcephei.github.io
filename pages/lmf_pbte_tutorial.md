---
layout: page-fullwidth
title: "Self-Consistent LDA calculation for PbTe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/lmf_pbte_tutorial/"
header: no
---

_____________________________________________________________

### _Purpose_

This tutorial carries out a self-consistent density-functional calculation for PbTe using the **lmf**{: style="color: blue"} code.
It has a purpose [similar to the basic tutorial](/tutorial/lmf/lmf_tutorial/) but shows some additional features.   It:

1. explains the input file's structure and illustrates some of its programming language capabilities
2. generates a self consistent potential within the LDA
3. makes neighbour tables using the **lmchk**{: style="color: blue"} tool
4. synchronizes with an [ASA tutorial](/tutorial/asa/asa-doc/) on the same system, enabling a comparison of the ASA and full potential methods.
5. forms the starting point for other tutorials on optics, a QSGW calculation of PbTe, and compares energy bands computed in different ways.

_____________________________________________________________

### _Command summary_     

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

    $ blm init.pbte                                 #makes template actrl.pbte and site.pbte
    $ cp actrl.pbte ctrl.pbte
    $ lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
    $ cp basp0.pbte basp.pbte                       #copy basp0 to recognised basp prefix   

    ... to be finished

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

_____________________________________________________________

### _Preliminaries_

Some of the basics are covered in the basic [lmf tutorial for Si](/tutorial/lmf/lmf_tutorial/), which you may wish to go through first.

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path. 

____________________________________________________________

### _Tutorial_

#### 1. _Building the input file_

PbTe crystallizes in the rocksalt structure with lattice constant _a_ = 6.428&#x212B;. You need the structural information in the box below to construct the main input file,
_ctrl.pbte_{: style="color: green"}. Start in a fresh working directory and cut and paste the box's contents to _init.pbte_{: style="color: green"}.

    LATTICE
	    ALAT=6.427916  UNITS=A
            PLAT=    0.0000000    0.5000000    0.5000000
                     0.5000000    0.0000000    0.5000000
                     0.5000000    0.5000000    0.0000000
    SITE
		ATOM=Pb   X=     0.0000000    0.0000000    0.0000000
		ATOM=Te   X=     0.5000000    0.5000000    0.5000000

The primitive lattice vectors are in row format (i.e. the first row contains the _x_, _y_ and _z_ components of the first lattice vector and so forth). In the **SITE** section, the atom type and coordinates are shown. **X=** specifies the site coordinates.  They are specified in "direct" representation, i.e., as fractional multiples of lattice vectors **PLAT**.  You can also use Cartesian coordinates; instead of **X=** you would use **POS=** (see additional exercises below).  Positions in Cartesian coordinates are in units of **ALAT**, like the lattice vectors.

Use the **blm**{: style="color: blue"} tool as in the box below to create the input file (_ctrl.pbte_{: style="color: green"}) and the site file (_site.pbte_{: style="color: green"}):

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte

#### 2. _How the input file is organized_

In this tutorial, **blm**{: style="color: blue"} is used in "standard" mode. (The [basic tutorial](/tutorial/lmf/lmf_tutorial/)
creates a simpler file with `blm --express init.si`). 
Standard mode makes limited use of the [preprocessing capabilities](/docs/input/inputfile/) of the Questaal input system : 
it uses algebraic variables which can be modified on the command line. Thus `lmf -vnit=10 ...` sets variable **nit** to 10 before doing anything else.
Generally:

* Lines which begin with '**#**' are comment lines and are ignored. (More generally, text following a `#' in any line is ignored).
* Lines beginning with '**%**' are directives to the preprocessor.  

<div onclick="elm = document.getElementById('variablesexplained'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click here
to see how variables can be set and used in the ctrl file.</div>
{::nomarkdown}<div style="display:none;padding:5px;" id="variablesexplained">{:/} 

The beginning of the ctrl file you just generated should look like the following:

~~~
# Variables entering into expressions parsed by input
% const nit=10
% const met=5
% const so=0 nsp=so?2:1
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const pwmode=0 pwemax=3          # Use pwmode=1 or 11 to add APWs
% const nkabc=0 gmax=0
~~~ 

**% const** tells the proprocessor that it is declaring one or more variables.  **nit**, **met**, etc,  used in expressions later on.  The parser interprets the contents of brackets **{...}** as algebraic expressions: The contents of **{...}** is evaluated and the numerical result is substituted for it.  Expression substitution works for input lines proper, and also in the directives.  

For example this line

    metal=  {met}                    # Management of k-point integration weights in metals

becomes

    metal=  5

because **met** is a numerical expression (admittedly a trivial one).  It evaluates to 5 because **met** is declared as an algebraic variable and assigned value 5 near the top of the ctrl file.  The advantage is that you can do algebra in the input file, and you can also re-assign values to variables from the command line, as we will see shortly.

{::nomarkdown}</div>{:/}

Lines corresponding to actual input are divided into **categories**{: style="color: red"}
and **tokens**{: style="color: blue"} within the categories.
A category begins when a character (other than **%** or **#**) occurs in the
first column.  Each token belongs to a category; for example in box below **IO**{: style="color: red"} contains three tokens, 
**SHOWMEM**{: style="color: blue"}, **IACTIV**{: style="color: blue"} and **VERBOS**{: style="color: blue"} :

    IO    SHOWMEM=f
          IACTIV=f VERBOS=35,35

(Internally, a complete identifier (aka _tag_) would be **IO_IACTIV=**, though it does not appears in that form in the ctrl file.)

[This link](/docs/input/inputfile/#input-file-structure) explains the structure of the input file in more detail.

####  3. _The **EXPRESS** category_

**blm**{: style="color: blue"} normally includes an **EXPRESS** category in _ctrl.pbte_{: style="color: green"}.

<div onclick="elm = document.getElementById('express'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click here
to see the beginning of the EXPRESS category.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="express">{:/} 

~~~
EXPRESS
# Lattice vectors and site positions
  file=   site

# Basis set
  gmax=   {gmax}                   # PW cutoff for charge density
  autobas[pnu=1 loc=1 lmto=5 mto=4 gw=0]
~~~ 

{::nomarkdown}</div>{:/}

Tags in the **EXPRESS** category are effectively
aliases for tags in other categories, e.g. **EXPRESS_gmax** corresponds to
the same input as **HAM_GMAX**.  If you put a tag into **EXPRESS**, it will
be read there and ignored in its usual location; thus in this instance adding **GMAX**
to the **HAM** category would have no effect.

The purpose of **EXPRESS** is to simplify the input file,
collecting the most commonly used tags in one place.

####  4. _Determining what input an executable seeks_

**blm**{: style="color: blue"} builds input files with only a subset of the tags an executable will try to read.
Defaults are used for the vast majority of tags.
In any case each executable reads its own particular set, though most executables share many tags in common.

Executables accept input from two primary streams : tags in the ctrl file and additional information through command-line switches.

To see what an executable looks for in the ctrl file, invoke the executable with `--input`, e.g.

    $ lmchk --input

`--input` puts **lmchk**{: style="color: blue"} in a special mode.  It doesn't attempt to read anything; instead, it prints out a (large) table of all the tags it would try to read, including a brief description of the tag, and then exits.

`$ lmchk --help` performs a similar function for the command line arguments: it prints out a brief summary of arguments effective in the executable you are using.

`$ lmchk --show` tells **lmchk**{: style="color: blue"} to print out tags as it reads them (or the defaults it uses)

The remainder of this section is not essential to this tutorial and you can safely skip to section 5.  It explains what information is printed when you use
`--input`; it is useful if you want to see how tags and categories are organized, and how missing or partial tags are handled.

<div onclick="elm = document.getElementById('input'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click 
here for a description of the `--input` function.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="input">{:/} 

Below is snippet of output from `lmchk --input`:


~~~
    Tag                    Input   cast  (size,min)
    ------------------------------------------

    ...

    --- Parameters for species data ---
    ... The next four tokens apply to the automatic sphere resizer
    SPEC_SCLWSR            opt    r8       1,  1     default = 0
      Scales sphere radii, trying to reach volume = SCLWSR * cell volume
      SCLWSR=0 turns off this option.
      Add  10  to initially scale non-ES first;
       or  20  to scale ES independently.
    SPEC_OMAX1             opt    r8v      3,  1     default = 0.16 0.18 0.2
      Limits max sphere overlaps when adjusting MT radii

    ...

    SPEC_ATOM              reqd   chr      1,  0
      Species label
    SPEC_ATOM_Z            reqd   r8       1,  1
      Atomic number
    SPEC_ATOM_R            reqd*  r8       1,  1
      Augmentation sphere radius rmax

    ...
     SPEC_ATOM_LMX          opt    i4       1,  1     (default depends on prior input)
       l-cutoff for basis
     SPEC_ATOM_LMXA         opt    i4       1,  1     (default depends on prior input)
       l-cutoff for augmentation

    ...

    BZ_NKABC               reqd   i4v      3,  1
      (Not used if data read from EXPRESS_nkabc)
      No. qp along each of 3 lattice vectors.
      Supply one number for all vectors or a separate number for each vector.
~~~ 

**lmchk**{: style="color: blue"} prints the full name of each tag, e.g. **SPEC_ATOM** and **SPEC_ATOM_Z**, 
even though components of the tag are separated in the ctrl file.  _ctrl.pbte_{: style="color: green"} contains these lines

    SPEC 
      ATOM=Pb         Z= 82  R= 3.044814  LMX=3  LMXA=4

Many tags (**SPEC_SCLWSR**, **SPEC_ATOM_LMX**, **SPEC_ATOM_LMXA**) are optional:
**lmchk**{: style="color: blue"} will substitute defaults if you don't supply them.
Those marked **reqd** (**SPEC_ATOM**, **SPEC_ATOM_Z**, **SPEC_ATOM_R**) you must supply.

The cast (real, integer, character) of each tag is indicated, and also how many numbers are to be read.
Sometimes tags will look for more than one number, but allow you to supply fewer.
For example, **BZ_NKABC** looks for three numbers to determine the k-mesh, which are the number of divisions only each of the reciprocal lattice vectors.
If you supply only one number it is copied to elements 2 and 3.

{::nomarkdown}</div>{:/}


####  4. _Initial setup_

To carry out a self-consistent calculation, we need to prepare the following:

4.1  Find any high-lying core states that should be included in the valence as local orbitals.  
4.2  Make atomic densities, which **lmf**{: style="color: blue"} will overlap to make a starting trial density  
4.3  Provide a reasonable basis set with parameters **RSMH** and **EH** defining the envelope functions  
4.4  Supply an automatic estimate for the mesh density plane wave cutoff **GMAX**.

**lmfa**{: style="color: blue"} is a tool that will provide all of this information automatically.
It will writes writes basis set information to template _basp0.pbte_{: style="color: green"},
The Questaal package reads from _basp.pbte_{: style="color: green"}, but it is written to
file basp0 to avoid overwriting a file you may want to preserve.  You can customize the 
basis set by editing the file.

As a first step, do:

~~~
$ lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
$ cp basp0.pbte basp.pbte                       #copy basp0 to recognised basp prefix   
~~~

#####  4.1 Local orbitals
{::comment}
/tutorial/lmf/lmf_pbte_tutorial/#local-orbitals/
{:/comment}


Part of **lmfa**{: style="color: blue"}'s function is to identify
_local orbitals_ that [extend the linear method](/docs/package_overview/#linear-methods-in-band-theory).
Linear methods are reliable only over a limited energy window; certain elements may require an extension
to the linear approximation for accurate calculations.  This is accomplished with
[local orbitals](/docs/package_overview/#linear-methods-in-band-theory).
**lmfa**{: style="color: blue"} will automatically look for atomic levels that
if certain criteria are satisfied (as described in "lmfa output" below) it designates as a local orbital,
and includes this information in the basp0 file.

<div onclick="elm = document.getElementById('localorbitals'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here for a description of how local orbitals are specified in the basp file.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="localorbitals">{:/} 

Inspect _basp.pbte_{: style="color: green"}.  Note in particular this text connected with the Pb atom:  

~~~
    PZ= 0 0 15.934
~~~

**lmfa**{: style="color: blue"} is suggesting that the Pb 5_d_ state is shallow enough that it be included in the valence.  Since this state
is far removed from the fermi level, we would badly cover the hilbert space spanned by Pb 6_d_ state were we to use Pb 5_d_ as the valence partial
wave. (In a linear method you are allowed to choose a single energy to construct the partial wave; it is 
usually the "valence" state, which is near the Fermi level.)

This problem is resolved with local orbitals : these are partials wave at an energy far removed from the Fermi level.
The three numbers following **PZ**
correspond to specifications for local orbitals in the _s_, _p_, and _d_ channels.  Zero indicates "no local orbital;"
there is only a _d_ orbital here.

**15.934** is actually a compound of **10** and the "[continuous principal quantum number](/docs/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers)"
**5.934**. The 10's digit tells **lmf**{: style="color: blue"}
to use an "enhanced" local orbital as opposed to the usual variety found in most
density-functional codes.  Enhanced orbitals append a tail so that the
density from the orbital spills into the interstitial. 
You can specify a "traditional" local orbital by omitting the 10, but this kind is more accurate, and there is no advantage to doing so.

The continuous principal quantum number (**5.934**) specifies the [number of nodes and boundary
condition](/docs/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers).  The large fractional part
of _P_ is [large for core states](/docs/asaoverview/#continuous-principal-quantum-number-for-core-levels-and-free-electrons), typically
around 0.93 for shallow cores.  **lmfa**{: style="color: blue"} determines the proper value for the atomic potential.  In the
self-consistency cycle the potential will change and **lmf**{: style="color: blue"} will update this value.

**lmfa**{: style="color: blue"} automatically selects the valence-core partitioning; the information is given in _basp.pbte_{: style="color: green"}.
You can set the partitioning manually by editing this file.  

_Note:_{: style="color: red"} high-lying states can also be included as local orbitals; they improve on the hilbert
space far above the Fermi level. In the LDA they are rarely needed and **lmfa**{: style="color: blue"} will not add them
to the _basp.pbte_{: style="color: green"}.  But they can sometimes be important in _GW_ calculations, since in contrast to
the LDA, unoccupied states also contribute to the potential.

{::nomarkdown}</div>{:/}

##### 4.2 Free atomic density : valence-core partitioning

After _basp.pbte_{: style="color: green"} has been modified, you must run **lmfa**{: style="color: blue"} a second time

~~~
$ lmfa ctrl.pbte                                #use lmfa to make basp file, atm file and to get gmax
~~~

This is necessary whenever the valence-core partitioning changes through the addition or removal of a local orbital.

#####  Relativistic cores

Normally **lmfa**{: style="color: blue"} determines the core levels and core density from
the scalar Dirac equation.  However there is an option to use the full Dirac equation.

<div onclick="elm = document.getElementById('diraccore'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here to see how to calculate core levels from the Dirac equation.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="diraccore">{:/} 

... to be completed

{::nomarkdown}</div>{:/}

##### 4.3 Automatic determination of basis set

**lmfa**{: style="color: blue"} automatically generates parameters for the basis set, including

+ finding estimates for parameters **RSMH** and **EH** that define the shape of envelope functions 
+ finding suitable [boundary conditions](/docs/asaoverview/#augmentation-sphere-boundary-conditions-and-continuous-principal-quantum-numbers) for linearization energies
+ deciding on which high-lying cores should be included as local orbitals

<div onclick="elm = document.getElementById('lmfaoutput'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here for an interpretation of lmfa's output, and how it determines the parameters outlined above</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="lmfaoutput">{:/} 

**lmfa**{: style="color: blue"} loops over each species, generating a 
self-consistent density from the charges given to it.  Core levels
are assumed to be filled; you supply the charges
of the valence _s_, _p_, ... orbitals.
The Pb atom, for example has  atomic configuration of $$s^2p^2d^{10}$$ 
and **lmfa**{: style="color: blue"}'s printout for Pb begins with:

~~~
 Species Pb:  Z=82  Qc=68  R=3.044814  Q=0
 mesh:   rmt=3.044814  rmax=47.629088  a=0.025  nr=497  nr(rmax)=607
  Pl=  6.5     6.5     5.5     5.5     5.5    
  Ql=  2.0     2.0     10.0    0.0     0.0    

  iter     qint         drho          vh0          rho0          vsum     beta
    1   82.000000   2.667E+04      410.0000    0.4078E+03     -164.7879   0.30
   55   82.000000   4.614E-05     1283.9616    0.3612E+08     -309.4131   0.30
~~~

The first lines show the augmentation radius and radial mesh parameters.  It uses a shifted logarithmic mesh: point _i_ has a radius

$$ r_i = b[exp^{a(i-1)}-1] $$

The **Pl** are the [continuous principal quantum numbers](/docs/asaoverview/#boundary-conditions-and-continuous-principal-quantum-numbers).
Note that because 5_d_ states are included in the valence through local orbitals, it treats the 5_d_ as valence with 10 electrons.

You can specify the charges **Ql** in the ctrl file; if you do not it has a lookup table of default values for every atom.

The **Ql** and the boundary condition (wave function decays exponentially as <i>r</i>&rarr;&infin;) are sufficient to completely determine
the charge density.

**lmfa**{: style="color: blue"} starts with a crude guessed density and after 55 iterations converges to the self-consistent one.

Next follow information about the eigenvalues of the valence and core states it finds along with some additional information, such as
what fraction of the state falls outside the augmentation radius.

~~~
 valence:      eval       node at      max at       c.t.p.   rho(r>rmt)
   6s      -0.91143         1.014       1.961       2.814     0.168779
   6p      -0.27876         1.185       2.643       4.790     0.524423
   5d      -1.56879         0.523       1.073       2.252     0.007786
...

 core:        ecore       node at      max at       c.t.p.   rho(r>rmt)
   1s   -6465.77343         0.000       0.010       0.022     0.000000
   2s   -1155.91509         0.020       0.057       0.090     0.000000
...
   5p      -6.31315         0.486       0.882       1.314     0.000052
~~~

For Pb 5_d_, **0.007786** electrons spill out: this is on the ragged edge of whether it needs to be included as a local orbital (see Additional Exercises).
_Note:_{: style="color: red"} for _GW_ calculations this state is too shallow to be treated as a core.

Next **lmfa**{: style="color: blue"} finds parameters related to the local orbitals: what shape of envelope function is needed to fit the
tail (**Eh** and **Rsm**), the "continuous principal quantum number" **Pnu**, and finally an estimate for plane wave cutoff **Gmax** that will be
needed for the density mesh.

~~~
 Fit local orbitals to sm hankels, species Pb, rmt=3.044814
 l   Rsm    Eh     Q(r>rmt)   Eval      Exact     Pnu     K.E.   fit K.E.  Gmax
 2  1.041 -1.083   0.00792  -1.56878  -1.56879   5.934  -0.8111  -0.8111    7.8
~~~

Next **lmfa**{: style="color: blue"} finds corresponding parameters for the valence envelope functions.
This constitutes a reasonable (but not optimal) guess for the shape of crystal envelope functions.

~~~
 Make LMTO basis parms for species Pb to lmxb=3, rmt=3.0448  vbar=0
 l  it    Rsm       Eh        Eval      Exact     Pnu    Ql   Gmax
 0  30   1.803   -0.706    -0.91141  -0.91143    6.89   2.00   3.9
 1  18   2.024   -0.160    -0.27825  -0.27876    6.81   2.00   3.6
 2   1   2.030+  -0.100+   -0.11512   0.01352    6.24  10.00
 3   1   2.030+  -0.100+    0.20219   0.02051    5.18   0.00
~~~

The basis data for the valence and local orbitals is later written to the basp0 file.

It searches for core states which are shallow enough to be treated as local orbitals,
using the core energy and charge spillout as criteria.

~~~
 Find local orbitals which satisfy E > -2 Ry  or  q(r>rmt) > 5e-3
 l=2  eval=-1.569  Q(r>rmt)=0.0078  PZ=5.934  Use: PZ=15.934
 l=3  eval=-9.796  Q(r>rmt)=3e-8  PZ=4.971  Use: PZ=0.000
~~~

We had already specified that the Pb 5_d_ as a local orbital, information obtained from a prior run.  **lmfa**{: style="color: blue"} uses
this information to appropriately partition the valence and core densities.

As a last step it fits the valence and core densities to a linear combination of smooth Hankel functions.
This information will be used to overlap free-atomic densities to obtain a trial starting density.

{::nomarkdown}</div>{:/}

After looping over all species **lmfa**{: style="color: blue"} writes basis information to 
_basp0.pbte_{: style="color: green"}, atomic charge density data to file
_atm.pbte_{: style="color: green"}, and exits with the following printout:

~~~
 FREEAT:  estimate HAM_GMAX from RSMH:  GMAX=4.3 (valence)  7.8 (local orbitals)
~~~

This is the G cutoff **gmax** that the ctrl file needs.  It determines the mesh spacing for the charge density.

####  5. _Self-consistency_

We are almost ready to carry out a self-consistent calculation.
It proceeds in a manner [similar to the basic tutorial](/tutorial/lmf/lmf_tutorial/#tutorial).
Try the following:

~~~
$ lmf ctrl.pbte
~~~

**lmf**{: style="color: blue"} stops with this message:

~~~
 Exit -1 bzmesh: illegal or missing k-mesh
~~~

We haven't yet specified a k mesh: 
You must supply it yourself since there are too many contexts to supply a sensible default value.
In this case a k-mesh of 6&times;6&times;6
divisions is adequate.   With your text editor change **nkabc=0** in the ctrl file
to **nkabc=6*, or alternatively assign it on the command line (which is what this tutorial will do)

We also haven't specified the G cutoff for the density mesh.
**lmfa**{: style="color: blue"} conveniently supplied that information for us,
based in the shape of envelope functions it found.  In this case the valence
G cutoff is quite small (**4.388), but the Pb 5_d_ is a much sharper function,
and requires a larger cutoff (**7.8**).  You must use use the larger of the two.

_Note:_{: style="color: red"} if you change the shape of the envelope funnctions
you must take care that the G cutoff is still adequate.  This is described in the 
lmf output below.

Change variable **gmax=0** in the ctrl file, or alternatively add a variable to the command line.
Now run

~~~
$ lmf ctrl.pbte -vnkabc=6 -vgmax=7.8
~~~

**lmf**{: style="color: blue"} should converge to self-consistency in 10 iterations.
At the end of the file it prints out

~~~
                ↓        ↓
 diffe(q)=  0.000000 (0.000005)    tol= 0.000010 (0.000030)   more=F
c nkabc=6 gmax=7.8 ehf=-55318.1620974 ehk=-55318.1620958
~~~

The first line prints out the change in Harris-Foulkes energy relative to the prior iteration and some norm of RMS change in the
(output-input) charge density (see arrows), followed by the tolerances required for self-consistency.

The last line prints out a table of variables you specify on the command line, and total
energies from the Harris-Foulkes and Kohn-Sham functionals.  Theses are different
functionals but they should approach the same value at self-consistency.
The **c** at the beginning of the line indicates that this iteration is self-consistent.

####  6. _Annotation of lmf's output_

<div onclick="elm = document.getElementById('lmfoutput'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">
Click here for a description of lmf's output.</div>
{::nomarkdown}<div style="display:none;padding:0px;" id="lmfoutput">{:/} 

**lmf**{: style="color: blue"} begins by telling you that it is reading
basis information (envelope function parmeters, _P_ parameters and information
about local orbitals) from _basp.pbte_{: style="color: green"}.

~~~
 rdctrl: reading basis parameters from file basp
 ioorbp: read species Pb        RSMH,EH RSMH2,EH2 P PZ
 ioorbp: read species Te        RSMH,EH RSMH2,EH2 P
         reset nkaph from 1 to 3
~~~

You can also supply this information in the ctrl file.
If both are present **lmf**{: style="color: blue"} decides on which to
use depending on settings in **EXPRESS_autobas**.

To see what the tokens in **autobas** do, invoke `lmf --input`
and search for autobas in the output.

Next follows some header information that presents in a condensed synopsis form some key settings that are used in this run:

~~~
 LMF:      nbas = 2  nspec = 2  vn 7.11.i  verb 35
 special:  forces
 pot:      XC:BH
 float:    float P LDA-style
 autoread: mto basis(4), pz(1), pnu(1)
 bz:       metal(5), tetra, invit 
~~~

Next follow information about the lattice vectors and settings used in Ewald summations:

~~~
                Plat                                  Qlat
   0.000000   0.500000   0.500000       -1.000000   1.000000   1.000000
   0.500000   0.000000   0.500000        1.000000  -1.000000   1.000000
   0.500000   0.500000   0.000000        1.000000   1.000000  -1.000000
   alat = 12.147006  Cell vol = 448.071898

 LATTC:  as= 2.000   tol=1.00E-08   alat=12.14701   awald= 0.261
         r1=  1.807   nkd= 87       q1=  5.403   nkg= 169
~~~

_Note:_{: style="color: red"} When long, thin cells are used, or when PAW's are added to the basis set, some attention needs to be paid to the Ewald tolerance.

The next block of output shows symmetry operations it in the 
crystal, and the irreducible k mesh given the point group:

~~~
 SGROUP: 1 symmetry operations from 0 generators
 SYMLAT: Bravais system is cubic with 48 symmetry operations.
 SYMCRY: crystal invariant under 48 symmetry operations for tol=1e-5
 GROUPG: the following are sufficient to generate the space group:
         i*r3(1,1,-1) r4x
         i*r3(1,1,-1) r4x
 MKSYM:  found 48 space group operations ... includes inversion
 BZMESH:  16 irreducible QP from 216 ( 6 6 6 )  shift= F F F
 TETIRR: sorting 1296 tetrahedra ... 35 inequivalent ones found
~~~

Notes: (see also "Additional Exercises" below)

+ You can specify symmetry operations manually.  This is particularly useful
  when magnetic symmetry must be considered.  
+ The k mesh is specifed through the number of k divisions, tag **EXPRESS_nabc**.  
  You can also specify whether the k-mesh should pass through the origin or straddle it
  through tag **BZ_BZJOB**
+ The Brillouin zone integration is using Bloechl's generalized tetrahedron method.
  You can also use the Methfessel-Paxton integration scheme or a Fermi function.

The next group of data contains a synsopsis of key parameters associated with
augmentation spheres.

~~~
 species data:  augmentation                           density
 spec       rmt   rsma lmxa kmxa      lmxl     rg   rsmv  kmxv foca   rfoca
 Pb       3.045  1.218    4    3         4  0.761  1.522    15    1   1.218
 Te       3.029  1.211    3    3         3  0.757  1.514    15    1   1.211
~~~

+ **rmt** is the augmentation radius
+ **rsma** is connected with the polynomial expansion <i>P<sub>kL</sub></i> of tails of envelope functions, needed for their one-center expansions about remote sites
+ **lmxa** is the _l_-cutoff of the augmentation.  Because of the unique way augmentation is done in this method, this value can be much lower than in standard augmented wave methods.
+ **kmxa**
+ **lmxl**
+ **rg**, **rsmv**, **kmxv**
+ **foca**, **rfoca**

{::nomarkdown}</div>{:/}



### _Other Resources_

An input file's structure, and features of the programming language capability, is explained in some detail 
[here](/docs/input/inputfile/). The full syntax of categories and tokens can be found in [this reference](input.pdf).

[This tutorial](https://lordcephei.github.io/buildingfpinput/) more fully describes some important tags the **lmf**{: style="color: blue"} reads.  It also
presents alternative ways to build input files from various sources such as the VASP _POSCAR_{: style="color: green"} file.

[This tutorial](/tutorial/lmf/lmf_bi2te3_tutorial/) more fully explains the **lmf**{: style="color: blue"} basis set.

There is a corresponding tutorial on the basics of a [self-consistent ASA calculation for PbTe](https://github.com/lordcephei/lordcephei.github.io/blob/master/pages/fptut-pbte.md).  [A tutorial on optics](/docs/properties/optics/) can be gone through after you have understood this one.

[This document](https://lordcephei.github.io/docs/lmf/overview/) gives an overview of some of **lmf**'s unique features and capabilities.

The theoretical formalism behind the **lmf**{: style="color: blue"} is described in detail in this book chapter:
M. Methfessel, M. van Schilfgaarde, and R. A. Casali, ``A full-potential LMTO method based
on smooth Hankel functions,'' in _Electronic Structure and Physical Properties of
Solids: The Uses of the LMTO Method_, Lecture Notes in Physics,
<b>535</b>, 114-147. H. Dreysse, ed. (Springer-Verlag, Berlin) 2000.

### _Additional exercises_

You can try self-consistent calculations with the Pb 5_d_ in the valence as a local orbital 

Specify symops yourself

Tetrahedron vs sampling vs fermi function
