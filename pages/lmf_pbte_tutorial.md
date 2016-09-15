---
layout: page-fullwidth
title: "lmf tutorial: Self-Consistent LDA calculation for PbTe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/lmf_pbte_tutorial/"
header: no
---

_____________________________________________________________

### _Purpose_

This tutorial carries out a self-consistent density-functional calculation for PbTe using the **lmf**{: style="color: blue"} code.
This tutorial has a similar purpose but shows some additional features. It:

1. explains the input file's structure and illustrates some of its programming language capabilities
2. generates a self consistent potential within the LDA
3. makes neighbour tables using the **lmchk**{: style="color: blue"} tool
4. synchronizes with an [ASA tutorial](https://lordcephei.github.io/asa-doc/) on the same system, enabling a comparison of the ASA and full potential methods.
5. forms the starting point for other tutorials on optics, a QSGW calculation of PbTe, and comparing energy bands computed in different ways.

_____________________________________________________________

### _Command summary_     

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte
    ... to be finished

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

_____________________________________________________________

### _Preliminaries_

Some of the basics are covered in the [basic lmf tutorial for Si](https://lordcephei.github.io/lmf_tutorial/), which you may wish to go through first.

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmfa**{: style="color: blue"}, and **lmf**{: style="color: blue"} are required and are assumed to be in your path. 

____________________________________________________________

### _Tutorial_

##### 1. _Building the input file_

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

The primitive lattice vectors are in row format (i.e. the first row contains the x, y and z components of the first lattice vector and so forth). In the **SITE** section, the atom type and coordinates are shown. The **X=** tag specifies that the coordinates are in "direct" representation, that is, as fractional multiples of lattice vectors **PLAT**. It is also possible to use Cartesian coordinates and in this case the **X=** tag would be replaced by **POS=** (see additional exercises below).  Positions in Cartesian coordinates are in units of **ALAT**, like the lattice vectors.

Create the input file (_ctrl.pbte_{: style="color: green"}) and the site file (_site.pbte_{: style="color: green"}) with

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte

##### 2. _How the input file is organized_

Take a look at the ctrl file. 
Click on the box below to see a snippet showing the beginning of the file.
<hr style="height:5pt; visibility:hidden;" />
<div onclick="elm = document.getElementById('iors'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="iors">{:/}

~~~
# Variables entering into expressions parsed by input
% const nit=10
% const met=5
% const so=0 nsp=so?2:1
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const pwmode=0 pwemax=3          # Use pwmode=1 or 11 to add APWs
% const nkabc=0 gmax=0
~~~ 

{::nomarkdown}</div>{:/}

* Lines which begin with '**#**' are comment lines and are ignored. (More generally, text following a `#' in any line is ignored).
* Lines beginning with '**%**' are directives to the preprocessor.  Directives can perform various functions similar to a normal programming language, such as 
assigning variables, evaluating expressions, conditionally readings some lines, and repeated loops over sections of input.

Near the top of the ctrl file, beginning with **% const**, follow a series of variable declarations. **nit**, **met**, etc,  are variables used in expressions further down.  The parser interprets the contents of brackets **{...}** as algrebraic expressions:  **{...}** is evaluated and the numerical result is substituted for it.  Expression substitution works for input lines proper, and also in the directives.  

For example this line

    metal=  {met}                    # Management of k-point integration weights in metals

becomes

    metal=  5

because **met** is a numerical expression (admittedly a trivial one).  It evaluates to 5 because **met** is declared as an algebraic variable and assigned value 5 near the top of the ctrl file.  The advantage is that you can do algebra in the input file, and you can also re-assign values to variables from the command line, as we will see shortly.

Lines corresponding to actual input are divided into categories and tokens within the categories.
A category begins when a character (other than **%** or **#**) occurs in the
first column.  Each token belongs to a category; for example in this line

    IO    SHOW=f HELP=f IACTIV=f VERBOS=35,35  OUTPUT=*

**SHOW=** is a token within category; the full tag name is **IO_SHOW=**.

See "Other Resources" below to follow links with further information on the syntax of input files, and building them from different sources.

#####  3. _The **EXPRESS** category_

**blm**{: style="color: blue"} included an **EXPRESS** category in _ctrl.pbte_{: style="color: green"}.  Clock on the box below to see the beginning of it.

<div onclick="elm = document.getElementById('2'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="2">{:/}

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

#####  4. _Determining what input an executable seeks_

**blm**{: style="color: blue"} builds input files with only a subset of the tags an executable will try to read.
Defaults are used for the vast majority of tags.
In any case each executable has its own unique set of tags, though most executables share many tags in common.

Executables accept input from two primary streams : tags in the ctrl file and additional information through command-line switches.

To see what an executable tries to read from the ctrl file, invoke the executable with `--input`, e.g.

    $ lmchk --input

`--input` puts **lmchk**{: style="color: blue"} in a special mode.  It doesn't attempt to read anything; instead, it prints out a table of all the tags it would try to read, together with a brief description of the tag, and then exits.

`--help` performs a similar function for the command line arguments: it prints out a brief summary of arguments effective in the executable you are using.

`--show` tells **lmchk**{: style="color: blue"} to print out tags as it reads them (or the defaults it uses)

The remainder of this section is not essential to this tutorial and you can safely skip to section 5 or 6.  It explains what you receive when you use
`--input`; it is useful if you want to see how tags and categories are organized, and how missing or partial tags are handled.

Below is snippet of output from `lmchk --input`:

<hr style="height:5pt; visibility:hidden;" />
<div onclick="elm = document.getElementById('help1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="help1">{:/}

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
even though only components of the tag appear in the ctrl file.  In this tutorial the it contains:

    SPEC 
      ATOM=Pb         Z= 82  R= 3.044814  LMX=3  LMXA=4

Some tags (**SPEC_SCLWSR**, **SPEC_ATOM_LMX**, **SPEC_ATOM_LMXA**) are optional:
lmchk will substitute defaults if you don't supply them.
Any marked **reqd** (**SPEC_ATOM**, **SPEC_ATOM_Z**, **SPEC_ATOM_R**) you must supply.

The cast (real, integer, character) of each tag is indicated, and also how many numbers are to be read.
tags look for more than one number, but you can supply fewer.  For example, **BZ_NKABC** looks for
three numbers to fix the k-mesh, namely the number of divisions only each of the reciprocal lattice vectors.
If you supply only one, it is copied to elements 2 and 3.

{::nomarkdown}</div>{:/}

#####  5. _Features of **lmchk**{: style="color: blue"}_

**lmchk**{: style="color: blue"}'s default mode is to check sphere overlaps.  But it has several other useful options (e.g. the empty sphere finder, described in
the [sister [ASA tutorial](https://lordcephei.github.io/asa-doc/) for PbTe.)

#####  6. _Self-consistency_


### _Other Resources_

A more complete description of the structure of an input file's structure, and features of the programming language capaability, is explained in some detail 
[in this html document](https://lordcephei.github.io/pages/file-preprocessor.html). A reference defining the syntax of categories and tokens can be found in [this pdf file](input.pdf).

[This tutorial](https://lordcephei.github.io/buildingfpinput/) more fully describes some important tags the **lmf**{: style="color: blue"} reads.  It also
presents alternative ways to build input files from various sources such as the VASP _POSCAR_{: style="color: green"} file.

There is a corresponding tutorial on the basics of a [self-consistent ASA calculation for PbTe](https://github.com/lordcephei/lordcephei.github.io/blob/master/pages/fptut-pbte.md).  [A tutorial on optics](xx) can be gone through after you have understood this one.

[This document](https://lordcephei.github.io/docs/lmf/overview/) gives an overview of some of **lmf**'s unique features and capabilities.

The theoretical formalism behind the method is described in this [book chapter](xx).

###### _2.2 Self-consistency_
Before a  self consistant calculation can be preforem the real-space structure constants have to be generated.  They are made once, for a given structure, with a separate tool

       lmstr ctrl.pbte

The penultimate step is to generate the initial the multipole moments Q$_0$,Q$_1$,Q$_2$. For this we first change the nkabc variable within the control file to for (**nkabc=4**, this variable represents the k-mesh density):
change 
	
	% const nkabc=0
	
to

	% const nkabc=4


next  the  **lm**{: style="color: blue"} executable is invoked with zero number of iterations such that

    lm -vnit=0 ctrl.pbte

and lastly for a fully consistant LDA-ASA calculation **lm**{: style="color: blue"} is invoked with **-vnit**>1 so that

    lm -vnite=20 ctrl.pbte

The message at the end of the standard out put will indicate if self-consistency has been achieved, which in this case it has.
	    