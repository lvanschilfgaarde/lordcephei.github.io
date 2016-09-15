---
layout: page-fullwidth
title: "Building Input files"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/buildingfpinput/"
header: no
---

### _Purpose_

This tutorial shows how to construct input files, receiving structural information from various sources.

_____________________________________________________________

### _Command summary_

The tutorial starts under the heading "Tutorial"; you can see a synopsis of the commands by clicking on the box below.

<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte
    $ cp testing/cif2cell.batio3 .
    $ cif2init cif2cell.batio3        # creates an init file from 
    $ poscar2init                     # creates an init file from a VASP POSCAR file
    $ poscar2site                     # creates a  site file from a VASP POSCAR file
    $ testing/test.blm 2
    $ poscar2init > init.zn3as2
    $ blm zn3as2 --fixpos:tol=1e-6 > out.zn3as2
    $ testing/test.blm 3
        $ blm bi2te3
    $ cp actrl.bi2te3 ctrl.bi2te3
    $ lmchk bi2te3
    $ cp actrl.bi2te3 ctrl.bi2te3
    $ lmfa bi2te3
            $ cp basp0.bi2te3 basp.bi2te3
            $ lmfa bi2te3
    $ blm --gw bi2te3

    ... to be finished

{::nomarkdown}</div>{:/}

_____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}

_____________________________________________________________

### _Preliminaries_

The materials system in this tutorial is Bi2Te3; you will build an input file _ctrl.bi2te3_{: style="color: green"} by one of several possible paths.

The input file structure is briefly described in [this lmf tutorial for Pbte](https://lordcephei.github.io/lmf_tutorial/), which you may wish to go through first.

This tutorial assumes you have **blm**{: style="color: blue"} installed. Additionally, **poscar2init**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmscell**{: style="color: blue"}, **poscar2site**{: style="color: blue"} and **cif2site**{: style="color: blue"} may be required for some sections.

_____________________________________________________________

### _Tutorial_

**blm**{: style="color: blue"} is an input file generator. You can use it autogenerate an input file (_ctrl.ext_{: style="color: green"}); or you can build it yourself.
**blm**{: style="color: blue"} usually writes the structural data to a site file (_site.bi2te3_{: style="color: green"}).  Site files are a primary way structural
data is kept in a form the Questaal programs can read.

In either case, you need structural information to get started.  In default mode **blm**{: style="color: blue"} reads structural data from a file
_init.ext_{: style="color: green"}, and writes a ctrl file and a site file.  It can read structural data from a site file.

#### 1. _Importing Crystal Structure_

##### 1.1 _Supplying Crystal Structure by hand_

Typically you have structural information about your material, e.g. _space group number_ (e.g. number 99 or name P4_mm_) and _lattice parameters_ related to the space group (_a_ and _b_ in the P4_mm_ case). This page will use Bi2Te3 as an example, which belongs to space group R3m with lattice constants _a_ and _c_. (See Wykoff, [_Structure of Crystals_](https://archive.org/stream/structureofcryst030914mbp#page/n107/mode/2up/search/Bi), to obtain this information.) You also need information about the chemical species and positions of the atoms in the basis. The minimum information for Bi2Te3 is:

    ATOM=Te X=0     0    0
    ATOM=Te X=0     0   .788
    ATOM=Bi X=0     0   .4

There are five atoms in the basis; the positions of the remaining two follow from the symmetry of the space group (R3m).

Symbols Te and Bi tell **blm**{: style="color: blue"} that the atoms are Tellurium and Bismuth, with atomic numbers 52 and 83. You can use any symbol for the species name, but if you don't use a standard one you must specify the atomic number, e.g. write ATOM=A Z=52.

The three coordinates e.g. (0 0 0.788) correspond to fractions of the first, second, and third lattice vectors. This is a standard way of representing site coordinates. Alternatively, you can specify Cartesian coordinates; use POS= in place of X=. In the Bi2Te3 case, substituting the above 3 lines with

    ATOM=Te POS= 0.0000000   0.0000000   0.0000000
    ATOM=Te POS=-0.5000000  -0.8660254   1.4616199
    ATOM=Bi POS= 0.5000000   0.8660254   0.8030878

creates the same input template.

##### 1.2 _Importing a CIF file_

[Crystallographic Information Files](http://en.wikipedia.org/wiki/Crystallographic_Information_File) (CIF files for short) is a standard text file format for representing crystallographic information, whose standards are set by the International Union of Crystallography. If you have a CIF file, you can automatically make _either_ an _init.ext_{: style="color: green"} file, _or_ a _site.ext_{: style="color: green"} file. The tools in this package do not read CIF files directly, but parse the output of the **cif2cell**{: style="color: blue"} program (version 1.1.0). **cif2cell**{: style="color: blue"} is a very versatile tool, [freely available on the web](http://sourceforge.net/projects/cif2cell).

To import data from a CIF file you need **cif2cell**{: style="color: blue"} installed and **cif2init**{: style="color: blue"} in your path (**cif2init**{: style="color: blue"} should be automatically compiled with this package). The steps are:

1\. Run **cif2cell** (without any special switches) and capture the output in a file, e.g.         cif2cell.out        .
2\. Run **cif2init** to generate an         init         file (called simply `        init        ').
3\. Rename         init         to         init._ext_         and use the [blm](#run) tool.

_Example_  : create an init file for the orthorhombic form of BaTiO3:

    $ cp testing/cif2cell.batio3 .
    $ cif2init cif2cell.batio3

*Note:*{: style="color: red"} _cif2cell.batio3_{: style="color: green"} was obtained by running **cif2cell**{: style="color: blue"} on the CIF file supplied with the cif2cell-1.1.0 distribution: _cif2cell-1.1.0/cifs/BaTiO3_orthorhombic.cif_{: style="color: green"}.

The following init file should be generated:

    HEADER Ba (Ti O3) (Barium titanate - nanocrystalline)
    LATTICE
    #       SPCGRP=38
    #       A=4.0094  B=5.6214  C=5.6386   ALPHA=90  BETA=90  GAMMA=90
    % const a=4.0094
            ALAT={a}  UNITS=A
            PLAT=    1.0000000    0.0000000    0.0000000
                     0.0000000    0.7010276   -0.7031725
                     0.0000000    0.7010276    0.7031725
    SITE
         ATOM=Ba       X=     0.0000000    0.0000000    0.0000000
         ATOM=Ti       X=     0.5000000    0.4900000    0.5100000
         ATOM=O        X=     0.5000000    0.0100000    0.9900000
         ATOM=O        X=     0.5000000    0.0129000    0.4921000
         ATOM=O        X=     0.5000000    0.5079000    0.9871000

If you prefer to make your own input file but import structure information via a site file, use **cif2site**{: style="color: blue"} in place of **cif2init**{: style="color: blue"}. To summarize:

cif2init     creates an init file from the output of **cif2cell**
cif2site     creates a  site file from the output of **cif2cell**

##### 1.3 _Importing a POSCAR file_

[VASP](http://www.vasp.at) is a very popular electronic structure program which can store structural information in the POSCAR files. If you want to import data from such a file in a form suitable for this program suite, use one of the following commands:

    $ poscar2init     creates an init file from a VASP POSCAR file
    $ poscar2site     creates a  site file from a VASP POSCAR file

If you already have an input file, use **poscar2site**{: style="color: blue"} to translate structural data from a POSCAR file into _site.ext_{: style="color: green"}. If you want an input file instead, use **poscar2init**{: style="color: blue"}; then run **blm**{: style="color: blue"}.

_Example:_{: style="color: red"} create an input file for Zn3As2 from a POSCAR file:

    $ testing/test.blm 2

The script has the following steps

    $ poscar2init > init.zn3as2
    $ blm zn3as2 --fixpos:tol=1e-6 > out.zn3as2

which creates an input file template (_actrl.zn3as2_{: style="color: green"}) from a POSCAR file in two steps.

_Example:_{: style="color: red"} create a site file for the Kesterite Cu2ZnSnS4:

    $ testing/test.blm 3

It creates file _site_{: style="color: green"} from file _POSCAR_{: style="color: green"}.

#### 2. _Running blm_

**blm**{: style="color: blue"} will create a template file for the main input file of the Questaal package, _ctrl.ext_{: style="color: green"}.
ext_{: style="color: green"} is a name you select; we will use _bi2te3_{: style="color: green"} corresponding to the material.  **blm**{: style="color: blue"} actually generates _actrl.ext_{: style="color: green"}, prepending the _a_ so as not to overwrite any file named _ctrl.ext_{: style="color: green"}.

Almost all programs in this package require the input file _ctrl.ext_{: style="color: green"}.  You can do an entire calculation starting only with this file; but often you supply other files.  For example, symmetry line points for plotting energy bands are read from a separate file (e.g. _syml.bi2te3_{: style="color: green"}).
Structural data is typically split off into a separate file (_site.bi2te3_{: style="color: green"} in this tutorial); **blm**{: style="color: blue"} will create a site file by default.

##### 2.1 _init_{: style="color: green"} file

Create a file named _init.bi2te3_{: style="color: green"} containing the following lines:

        # from http://cst-www.nrl.navy.mil/lattice/struk/c33.html
        # Bi2Te3 from Wyckoff
        % const a=4.3835 c=30.487 uTe=0.788 uBi=0.40
        LATTICE
           SPCGRP=R-3M
           UNITS=A
           A={a} C={c}
        SITE
            ATOM=Te X=0     0    0
            ATOM=Te X=0     0   {uTe}
            ATOM=Bi X=0     0   {uBi}

**Note**{: style="color: red"}

+ Lines which begin with ‘#’ are comment lines and are ignored. (More generally, text following a `#’ in any line is ignored).
+ Lines beginning with ‘%’ are directives to the preprocessor. Directives can perform various functions similar to a normal programming language, such as assigning variables, evaluating expressions, conditionally readings some lines, and repeated loops over sections of input.
+ Quantities in brackets **{...}** are algebraic expressions parsed by the preprocessor, evaluated and the result the contents of brackets replaced by the result.

_init_ files and _ctrl_ files are styled the same way: data is divided into _categories_ (**LATTICE** and **SITE**) --- tags which begin in the first column,
and _tokens_ (e.g. **SPCGRP=**, **A=**, **X=**) --- tags belonging to a particular category.

[This tutorial](https://lordcephei.github.io/docs/inputfile) explains how the input files _init.ext_{: style="color: green"} and _ctrl.ext_{: style="color: green"} are structured, and the tags the various programs can read.

##### 2.2 _ctrl_{: style="color: green"} file

To create a template input file invoke **blm**{: style="color: blue"}:

    $ blm bi2te3

Now take a look at the standard output. 
**blm**{: style="color: blue"} finds the lattice vectors from the crystal symmetry (if you had supplied the lattice vectors, it would have found the symmetry).
In this case, the symmetry is given; the corresponding point group has 12 symmetry operations, and two extra atoms had to be added to make the basis compatible with the group.   The output snippet below indicates what **blm**{: style="color: blue"} found.

<div onclick="elm = document.getElementById('bz'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show basis enlargement</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="bz">{:/}

~~~
 SGROUP: 12 symmetry operations from 3 generators
 ADDBAS: The basis was enlarged from 3 to 5 sites
         The additional sites are: 

        ATOM=Te       POS=   0.0000000   0.0000000   2.5538193
        ATOM=Bi       POS=   0.0000000   0.0000000  -4.8185270
~~~ 

{::nomarkdown}</div>{:/}


**blm**{: style="color: blue"} automatically determined [augmentation sphere radii](FPsamples/out.bi2te3.blm#rmt), which it accomplishes by attempting to find spheres with equal potentials on each sphere surfaces (as well as it can). If you already have an input file, you can run **lmchk**{: style="color: blue"} with _--getwsr_ to determine radii for you (it uses the same algorithm as **blm**{: style="color: blue"}). Particularly in polar compounds, this algorithm probably does a better job than you can do by hand, and it is recommended that you use the radii it finds, or some scaled version of them.

    **blm**{: style="color: blue"} creates the file _actrl.bi2te3_{: style="color: green"} with these contents:

        # Autogenerated from init.bi2te3
        VERS    LM:7 FP:7
        IO      SHOW=f HELP=f WKP=F IACTIV=f VERBOS=31
        % const pwmode=0 pwemax=3 # Use pwmode=1 or 11 to add APWs
        HAM     AUTOBAS[PNU=1 LOC=1 LMTO=4 MTO=4 GW=0]  GMAX=  # set GMAX by hand
        #       AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=3 GW=0]  GMAX=  # LMTO=3 for minimal basis
                PWMODE={pwmode} PWEMIN=0 PWEMAX={pwemax} OVEPS=0
        %const nsp=1 so=0 elind=-.7
                NSPIN={nsp} SO={so} FORCES={so==0} ELIND={elind}
        %const lxcf=2 lxcf2=-1 # PBE functional: lxcf=101 lxcf2=130
        %ifdef lxcf & lxcf2>0
                XCFUN=0,{lxcf},{lxcf2}
        %else
                XCFUN={lxcf}
        %endif
        % const nit=1
        ITER    MIX=B2,b=.3  NIT={nit}  CONVC=1e-5
        % const met=5 nk=0
        BZ      NKABC={nk}  METAL={met}  # NKABC requires 1 to 3 positive numbers
        #SYMGRP i r3z my
        % const a=4.782549
        STRUC
          NSPEC=2  NBAS=5  NL=5
          ALAT={a}
          PLAT= 1  0  4.0154392  -0.5  0.8660254  4.0154392  -0.5  -0.8660254  4.0154392
        SPEC
          ATOM=Te         Z= 52  R= 2.870279  LMX=3  LMXA=3
          ATOM=Bi         Z= 83  R= 2.856141  LMX=3  LMXA=4
        SITE
          ATOM=Te         POS=  0.0000000   0.0000000   0.0000000
          ATOM=Te         POS= -0.5000000  -0.8660254   1.4616199
          ATOM=Te         POS=  0.5000000   0.8660254  -1.4616199
          ATOM=Bi         POS=  0.5000000   0.8660254   0.8030878
          ATOM=Bi         POS= -0.5000000  -0.8660254  -0.8030878


*Note:*{: style="color: red"} The following applies to the FP code **lmf**{: style="color: blue"}. For ASA calculations, ignore the remainder of this section.

This template will not work as is; three essential pieces of information which **blm**{: style="color: blue"} does not supply are missing, to rectify this :

*   You must specify plane-wave cutoff GMAX; see [here](#gmax).
*   You must specify a valid **k** mesh for Brillouin zone integration; see [here](#bz).
*   You must define a basis set which can be done manually or automatically, as described next.

**blm**{: style="color: blue"} creates a family of tags belonging to AUTOBAS to enbable other programs to automatically find a basis set for you. We will use this tag, which sets up a standard minimal basis:

    AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=3 GW=0]

(Note that you must modify _actrl.bi2te3_{: style="color: green"} a little; the default gives [.. LMTO=4 MTO=4], which makes a [double kappa basis](#multikappa).

**lmfa**{: style="color: blue"} calculates wave functions and atomic densities for free atoms. It also has a mode that automatically generates information for basis sets, using tokens in AUTOBAS to guide it. This information is written to a file _basp0.ext_{: style="color: green"}. AUTOBAS specifies set of conditions that enable **lmfa**{: style="color: blue"} to automatically build the basis set for you, including specification of envelope function parameters [RSMH and EH](fp.html#spec). Alternatively you can define parameters such as EH and RSMH basis by hand, as described [in this tutorial](FPtutorial.html#basis).

Tokens in AUTOBAS tell **lmfa**{: style="color: blue"} to do the following:

    PNU=1    Calculate [logarithmic derivative](lmto.html#logderivative) parameter for the free atom; save P parameters in file         basp0._ext_        .
             Nothing about P is written if         PNU=0        .

    LOC=1    Look for shallow cores to be explicitly treated as valence electrons, using [local orbitals](fp.html#localorbitals).
             Shallow cores that meet specific criteria are identified and written to         basp0._ext_         as PZ=.
             No search is made if         LOC=0        .

    LMTO=3   Pick a default choice about the size of basis.  LMTO=3 is a standard minimal basis.
             Run lmfa --input and look for HAM_AUTOBAS_LMTO to see what other choices there are.

             Note that **lmfa** will pick some defaults for the _l_-cutoff
             e.g. _spd_ or _spdf_ depending on the value of LMTO.

    MTO=1    Choose 1-kappa basis set (single orbital per _l_ channel).
             For better quality calculations, it is recommended you use MTO=2.

    GW=0     If GW=1, tailor basis for a GW calculation, e.g. changing the
             criteria for including shallow cores as valence, and the size of basis.

These tokens thus define some reasonable default basis for you. **lmfa**{: style="color: blue"} _writes_ _basp0.ext_{: style="color: green"}. This file is never read, but **lmf**{: style="color: blue"} will _read_ _basp.ext_{: style="color: green"} and use this information when assembling the basis set. The two files have the same structure and you can copy _basp0.ext_{: style="color: green"} to _basp.ext_{: style="color: green"}. What **lmfa**{: style="color: blue"} generates is not cast in concrete. You are free to adjust the parameters to your liking, e.g. add a local orbital or remove one from the basis.

The AUTOBAS tokens tell **lmf**{: style="color: blue"} what to read from _basp.ext_{: style="color: green"}. It uses tokens in a manner similar, but not identical, to the way **lmfa**{: style="color: blue"} uses them:

    PNU=1    Read parameters P for all species present in         basp._ext_

    LOC=1    LOC=1 or 2 tell **lmf** to read local orbital parameters PZ.
             Since these parameters may also be specified by the input file,
             LOC=1 tells lmf to give precedence to parameters specified by ctrl file
             LOC=2 tells lmf to give precedence to parameters specified by basp.

    LMTO=    is not used by **lmf**.

    MTO=1    RSMH and EH may also be specified by the input file
             LMTO=1 or 3 tells lmf to read 1-kappa parameters specified by basp
             LMTO=2 or 4 tells lmf to read 2-kappa parameters specified by basp
             LMTO=1 or 2 tells lmf that parameters in the ctrl file take precedence
             LMTO=2 or 4 tells lmf that parameters in the basp file take precedence

    GW=0     If GW=1, tune basis for a GW calculation: log derivative parameters P
             are floated a little differently in the self-consistency cycle.
             They are weighted to better represent unoccupied states, at a slight cost
             to their representation of occupied states.

#### 3. _Checking sphere overlaps_

Sphere overlaps can be checked using **lmchk**{: style="color: blue"}. To do this copy the template _actrl.bi2te3_{: style="color: green"} to the input file and run **lmchk**{: style="color: blue"}:

    $ cp actrl.bi2te3 ctrl.bi2te3
    $ lmchk bi2te3

By default, **blm**{: style="color: blue"} makes the spheres as large as possible without overlapping, as the [output](FPsamples/out.bi2te3.lmchk) shows. In this case the Bi and Te radii are nearly the same.

#### 4. _Making the atomic density_

Make the free atom density. If you did not do so already copy _actrl.bi2te3_{: style="color: green"} to the input file (changing [.. LMTO=4 MTO=4] to [.. LMTO=3 MTO=3]) and invoke **lmfa**{: style="color: blue"}:

    $ cp actrl.bi2te3 ctrl.bi2te3
    $ lmfa bi2te3

The primary purpose of **lmfa**{: style="color: blue"} is to generate a free atom density. A secondary purpose is to supply additional information about the basis set in an automatic way. All of this information can be supplied manually in the input file, but the autogenerated input file supplies a minimum amount of information. **lmfa**{: style="color: blue"} generates _basp0.bi2te3_{: style="color: green"} which contains

    BASIS:
    Te RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
    Bi RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 5.089 PZ= 0 0 15.936

Every species gets one line. This file specifies a basis set consisting of _spdf_ orbitals on Te sites, and _spdf_ orbitals on Bi sites, and a local _5d_ orbital on Bi. The contents of this file are explained [above](#autobas); see also [RSMH and EH](fp.html#spec), [P](lmto.html#pbasp), and [PZ](fp.html#localorbitals).

*Note:*{: style="color: red"} Remember that **lmf**{: style="color: blue"} reads from _basp.ext_{: style="color: green"}, not _basp0.ext_{: style="color: green"}.

##### 3.1 _Automatically finding deep states to include as valence electrons_ 

The partitioning between valence and core states is something that requires a judgement call. **lmfa**{: style="color: blue"} has made a default choice for you: the [output](FPsamples/out.bi2te3.lmfa1#bihead) shows that for Bi, **lmfa**{: style="color: blue"} selected the 6_s_, 6_p_, 6_d_, 5_f_ states, populating them with charges   2, 3, 0, 0. Note that the total sphere charge is Q=0. You can override the default, e.g. choose the 5_d_ over the 6_d_ with SPEC_ATOM_P; override the _l_ channel charges with SPEC_ATOM_Q.

As was explained [earlier](#autobas), when HAM_AUTOBAS_QLOC is set **lmfa**{: style="color: blue"} will look for shallow core levels below 6_s_, 6_p_, 6_d_, 5_f_ states, and as [this table](FPsamples/out.bi2te3.lmfa1#localorbital) shows **lmfa**{: style="color: blue"} selected the 5_d_ orbital which is normally a core state, to be included as a [local orbital](fp.html#localorbitals) so that the usual 6_d_ state and the 5_d_ state are simultaneously included in the basis. Even though the 5_d_ state is fairly deep (the [output](FPsamples/out.bi2te3.lmfa1#bicore) shows it lies at −2 Ry), the criterion of having a charge density outside the smoothing radius greater than 3×10−3 was met. (Use HAM_AUTOBAS_ELOC and HAM_AUTOBAS_QLOC to change these criteria.) **lmfa**{: style="color: blue"} supplies information about this to _basp0.bi2te3_{: style="color: green"}, in the form  PZ=0 0 15.936 (no local orbitals for _s_ or _p_ states). The 0.936 is significant: it tells **lmf**{: style="color: blue"} what boundary condition to use for the 5_d_ radial function.

##### 3.2 _Automatically finding linearization energies_

Because HAM_AUTOBAS_P is set, **lmfa**{: style="color: blue"} save estimates for logarithmic derivative parameters P into basp0._ext_. As is well known from elementary quantum mechanics, and as described [here](lmto.html#pbasp), there is a relation between the energy of a wave function and its logaritmic derivative at some radius. This information is supplied through the parameters P.

**lmfa**{: style="color: blue"} calculates P for the free-atom potential. Since this potential is not so far removed from the crystal potential, these parameters can find the "band center" reasonably well for each partial wave _l_. In any case, these are only estimates; they normally get "floated" in the self-consistency cycle.

##### 3.3 _Automatically finding envelope function parameters_

Finally, the input file contains AUTOBAS[MTO=1]. This causes **lmfa**{: style="color: blue"} to envelope function parameters [RSMH and EH](fp.html#spec) (RSMH is the [most important](FPtutorial.html#optimizebasis) of the two) that fit the free atom wave functions well, and save the result in _basp0.bi2te3_{: style="color: green"}. Unfortunately, what is optimum for the free atom is not optimum for the crystal, but the parameters are a reasonable starting point. These parameters are important, as they determine the quality of the basis. Later we discuss ways to optimize them, or improve the basis quality by adding APWs. **blm** cannot automatically determine every required input from the structural data. But for the following reasons: **lmf**{: style="color: blue"} will not run properly as the situation now stands



1.   The [basis set](fp.html) has to be specified. **lmfa**{: style="color: blue"} autogenerated parameters for a basis set, and saved the result to _basp0.bi2te3_{: style="color: green"}. A decision must be made whether to use **lmfa**{: style="color: blue"}'s choices for RSMH, EH, P, and PZ, to supply your own, or to modify **lmfa**{: style="color: blue"}'s choice. In any case, you can do it in one of two ways:

    *   With your text editor pick up the lines in _basp0.bi2te3_{: style="color: green"} for Te and Bi, and paste them into _ctrl.bi2te3_{: style="color: green"}, e.g.

            ATOM=Te Z= 52  R= 2.870279
            RSMH= 1.615 1.681 1.914 1.914 EH= -0.888 -0.288 -0.1 -0.1 P= 5.901 5.853 5.419 4.187
            ATOM=Bi Z= 83  R= 2.856141
            RSMH= 1.674 1.867 1.904 1.904 EH= -0.842 -0.21 -0.1 -0.1 P= 6.896 6.817 6.267 5.199 PZ= 0 0 15.936

    *   Copy _basp0.bi2te3_{: style="color: green"} to _basp.bi2te3_{: style="color: green"}, and modify it as you like. File basp._ext_ is read after the main input file is read. If basp._ext_ exists, and one or more of the following tokens is present, their corresponding parameters _may_ be read from basp._ext_:
    *   AUTOBAS[MTO]: read RSMH,EH (also possibly RSMH2,EH2)
    *   AUTOBAS[P]: read P
    *   AUTOBAS[PZ]: read PZ

    If some this information is given in both the ctrl file and the basp file, the AUTOBAS settings tell **lmf**{: style="color: blue"} which to use, as described [here](#basprules).

2.  The atm file was created by **lmfa**{: style="color: blue"} without prior knowledge that the 5_d_ local orbital is to be included as a valence state (via a local orbital). Thus it incorrectly partitioned the core and valence charge. You must do one of the following:

    *   Remove **PZ=0 0 15.936** from _basp.bi2te3_{: style="color: green"}. It will no longer be treated as a valence state. Removing it means the remaining envelope functions are much smoother, which allows you to get away with a coarser mesh density, as described [below](#gmax). Whether you need it or not depends on the context.

    *   Copy _basp0.bi2te3_{: style="color: green"} to _basp.bi2te3_{: style="color: green"} and run **lmfa**{: style="color: blue"} over again:

            $ cp basp0.bi2te3 basp.bi2te3
            $ lmfa bi2te3

    With the latter choice **lmfa**{: style="color: blue"} operates a little differently from before as can be seen by comparing [new output](FPsamples/out.bi2te3.lmfa2) with the old. Initially the Bi 5_d_ was part of the [core](FPsamples/out.bi2te3.lmfa1#bicore); now is included as part of the [valence](FPsamples/out.bi2te3.lmfa2#xxx2).

3.  **blm** does not by default assign any value to the plane wave cutoff for the interstitial density. **lmf**{: style="color: blue"} reads this information through [HAM_GMAX](FPtutorial.html#GMAX). It is a required input; but **blm** does not pick a value because its [proper choice](FPtutorial.html#meshdensity) depends on the smoothness of the basis. **lmfa**{: style="color: blue"} will determine a suggested value for HAM_GMAX for you. In the present instance, when the usual 6_s_, 6_p_, 6_d_, 5_f_ states are included **lmfa**{: style="color: blue"} recommends GMAX=4.4 as can be seen by inspecting the [first **lmfa**{: style="color: blue"} run](FPsamples/out.bi2te3.lmfa1#gmax). In the second run it recommends GMAX=4.1 from the valence states alone (as before), but because of the 5_d_ state **lmfa**{: style="color: blue"} recommends that [GMAX=8.1](FPsamples/out.bi2te3.lmfa2#gmax). The 5_d_ state is strongly peaked at around the atom, and requires more plane waves to represent reasonably, even a smoothed version of it, than the other states. The difference between 8.1 and 4.4 is substantial, and it reflects the additional computational cost of including deep core-like states in the valence. This is the all-electron analog of the "hardness" of the pseudopotential in pseudopotential schemes. If you want high-accuracy calculations (especially in the _GW_ context), you will need to include these states as valence. This particular choice of local orbital is rather overkill for LDA calculations however. If you eliminate the Bi 5_d_ local orbital you can set GMAX=4.4 and significantly speed up the execution time.

4.  **blm** assigns the initial _k_-point mesh to zero. Note the following lines in _actrl.bi2te3_{: style="color: green"}:

        % const met=5 nk=0
        BZ      NKABC={nk}  METAL={met}  # NKABC requires 1 to 3 positive numbers

    BZ_NKABC governs the mesh of _k_-points. An appropriate choice will depend strongly on the context of the calculation and the sytem of interest; the density-of-states at the Fermi level; whether Fermi surface properties are important; whether you want optical properties as well as total energies well described; the precision you need; the integration method, and so on. Any automatic formula can be dangerous, so **blm** will not choose a default for you. In this case, a 4×4×4 mesh works well. Use your text editor to change nk=0 to nk=4. Alternatively, supply --nk=.. to **blm** on the command line, as was done in [this tutorial](Demo_QSGW_Si.html#nk).

    Note that as generated, _ctrl.bi2te3_{: style="color: green"} will reflect METAL=5. Using METAL=5 with the tetrahedron integration is the recommended way to handle Fermi surface integration in metals. See [this tutorial](FPtutorial.html#metal) for some discussion.

#### _Input files for GW_

_GW_ calculations demand more of the basis set because unuoccupied states are important. To set up a job in preparation for a _GW_ calculation, invoke **blm** as :

    $ blm --gw bi2te3

Compare _actrl.bi2te3_{: style="color: green"} generated with the --gw switch to one without. One important difference will be that the default basis parameters are modified because AUTOBAS becomes:

    AUTOBAS[PNU=1 LOC=1 LMTO=5 MTO=4 GW=1]

The basis is similar to LMTO=4 but EH has been set a little deeper. This helps the QS_GW_ implementation interpolate between _k_-points. The larger basis makes a minor difference to the valence bands; but the conduction bands change, especially the higher in energy you go.

Look also at this [QS_GW_ demo for Silicon](Demo_QSGW_Si.html).

_*Note_  The GW implementation allows you to use plane waves, but the QS_GW_ part of it does not, as yet.
