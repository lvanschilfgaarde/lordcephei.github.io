---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA Input"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/fpinputfile/"
header:
    image_fullwidth: "header_drop.jpg"
---

To go back to the preliminaries click [here](/fpnew/).

Start in the top-level directory. This sample helps you create a complete input file for elemental Al, including optimizing the parameters for the basis set. The file is then used to compute a shear constant. You may create some or all of your own input file from scratch; or you can just copy file [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) to the top-level directory.

Many categories are nearly identical to those in the [ASA tutorial](/asadoc/):

*   create category [VERS](tokens.html#VERScat). **lmf** requires token FP:7  

*   (optional) create the [HEADER](tokens.html#HEADERcat) category.  

*   Set up the crystal structure, categories [STRUC](tokens.html#STRUCcat) and [SITE](tokens.html#SITEcat).

    Al is fcc, with a lattice constant 7.606 a.u. at 0K. The input file could have read

              STRUC ALAT=7.606  

    but instead the template [doc/FPsamples](FPsamples/ctrl.al) declares a symbolic variable  `a'  in the [CONST](tokens.html#CONSTcat) category and uses

              STRUC ALAT=a  

    Doing it this way enables you to alter the lattice constant via the command-line, e.g. with switch  -va=7.1.
*   Build the [SPEC](tokens.html#SPECcat) to supply chemical species information. [STRUC](tokens.html#STRUCcat), [SITE](tokens.html#SITEcat), [SPEC](tokens.html#SPECcat) are all described in the [ASA tutorial](ASAtutorial.html#STRUC); see [SPEC](ASAtutorial.html#SPEC) there for a discussion of the choice muffin tin radius. In the present case, we choose RMT=0.91*avw  (avw=space-filling radius appropriate to the ASA). This makes sphere overlaps ~0.6%, as can be verified with [**lmchk**](#preliminaries). Strictly speaking spheres should not overlap (geometry violation), but because of the special way the local densites are handled, overlaps of up to 10% or so make negligible errors. The main drawback is that [self-consistency](#selfconsistency) tends to be more difficult when overlaps extend to 10%.

    The principal complication **lmf** has over the ASA is the need to specify the shape of the [smoothed Hankel envelope functions](fp.html#smoothH) which define the basis. (A smoothed Hankel is a [convolution of a Gaussian and a Hankel function](nfp-doc.ps)). Each _s_, _p_, _d_,... orbital has [two independent parameters](fp.html#spec) (Gaussian smoothing radius and Hankel energy), which you are free to choose. The extra freedom is advantageous in that they offer more flexibility than do ordinary Hankel functions; also they are smoother and regular at the origin. On the flip side, there is no obvious _a priori_ way to choose these parameters, which make it cumbersome to find an optimal basis. The simplest way is to choose these parameters is to follow the automatic procedure described [on this page](Building_FP_input_file.html#autobas).

    When choosing parameters by hand, a reasonable default is to set the smoothing radius (see RSMH below) to 2/3 of the augmentation radius for _s_ and _p_ orbitals, and about 1 or so for transition metal _d_ orbtals. To improve on the basis it is recommended you avail yourself of the basis optimizer. See [here](FPoptbas.html) for a (somewhat outdated) tutorial; it is also covered [later in the present tutorial](/fpbasisset/).

    doc/FPsamples/ctrl.al  uses by default a minimal basis of _spd_ orbitals, defined in the following lines:

               % const rsm1=1.8 rsmd1=1.8 ed1=-.1                 ← The const directive is described in the [preprocessor documentation](file-preprocessor.html#constdef)
             RSMH={rsm1},{rsm1},{rsmd1} EH=-.1,-.1,{ed1}      ← The contents of curly brackets are [evaluated as expressions](file-preprocessor.html#expressions)
        

    1.8 is 2/3 of the MT radius, 2.7. Al is an easy case: all states are nearly free electron-like. When we optimize the basis later, we will see that it is good choice. The choice of EH is usually less important (unless a state is very deep, such as the Oxygen _s_ state); typically choose a small negative number, e.g. −0.1.

    Note the additional lines in doc/FPsamples/ctrl.al:

               %ifdef bigbas
           % const rsm2=1.8
             RSMH2={rsm2},0,{rsmd1} EH2=-1,-1,-1
           %endif
        

    If  bigbas  is nonzero (either by changing ctrl.al or by invoking **lmf** with -vbigbas=1), the basis set is enlarged from _spd_ to _spdsd_.   
    RSMH2 has nonzero values in the _s_ and _d_ channels only; channels for which RSMH2=0 are excluded from the basis.

    When you use RSMH2 you should set EH2 to about 0.8 or 1 Ry deeper than EH1; otherwise the basis becomes too linearly dependent.  
    

*   create the [HAM](tokens.html#HAMcat) category. Most important here is GMAX, which specifies the cutoff in **G** vectors for the interstitial density. A uniform mesh of G vectors is generated; it keeps those for which G. This number is important because execution efficiency depends on it (though for one atom/cell, efficiency isn't important). It is exactly analogous to GMAX you must specify when using a plane-wave (pseudopotential or augmented plane wave) basis, except that here it is used for the density only, not both density and basis.

    You must specify one of GMAX or FTMESH. **lmf** first looks for GMAX; if it isn't found, FTMESH is sought. If _neither_ is found, **lmf** stops. Both are present in [doc/FPsamples/ctrl.al](FPsamples/ctrl.al), but only GMAX is used since it is sought first. It turns out that both modes will specify a mesh with 10 divisions along each axis: FTMESH=10 10 10.

    

*   Create the [OPTIONS](tokens.html#OPTIONScat) category. Of note here is this text: HF={hf}.   `hf'  is an algebraic variable set by the [const preprocessor directive](file-preprocessor.html#constdef):

               % const hf=f
        

    This will create  hf  and initialize it to zero. However, if you assign  hf  in some prior directive on the command line (using e.g. -vhf=1), the  `const'  will not override its value. Note that [doc/FPsamples/ctrl.al](FPsamples/ctrl.al), uses  hf  in this line

               OPTIONS NSPIN=1 REL=t XCFUN=2 HF={hf}
        

    With a command-line switch  -vhf=1  we can make non self-consistent calculations, which yield approximate energies via the [Harris-Foulkes functional](http://link.aps.org/doi/10.1103/PhysRevB.39.12520). We will use this feature to optimize the basis set (see discussion of [basis optimization](#basisoptimization) below).  

*   create the [BZ](tokens.html#BZcat) category. Note the following:  

    1.  NKABC and BJOB specify the _k_-point mesh.  

    2.  SAVDOS, NPTS, and DOS specify that the total density-of-states is to be created each time the Fermi level is determined.  

    3.  W=.002 EF0=0 DELEF=.1 are only relevant for sampling, so they aren't used in this tutorial, which uses tetrahedron integration (TETRA=t).  

    4.  when HF=t, we also use NEVMX=-1 to suppress generation of the output density through this construct:

                    % ifdef hf
                  NEVMX=-1
                % endif
                

        The preprocessor will include the line `NEVMX=-1' in the input file only when hf is nonzero.  

    5.  We choose METAL=2; see documentation for the [BZ category](tokens.html#BZcat).   
        _*Note_  METAL=5 is usually a better choice, provided you are not limited by memory.  

*   The [EWALD](tokens.html#EWALDcat) category is optional is included here only for pedagogical purposes.  

*   The [ITER](tokens.html#ITERcat) category controls the number of iterations, convergence citeria, and the how earlier densities are mixed with the current one, which you can set through MIX. See [here](tokens.html#mixing) for a description. This input file uses MIX=A3, which tells **lmf** to use Anderson mixing with up to three prior pairs of (input,output) density. But there are [many possible modifications](tokens.html#mixing). Unfortunately there is no good general prescription for MIX: cases with combined "hard" and "soft" degrees of freedom can be hard to stabilize (magnetic systems are often that way). Broyden mixing tends to work best, but like a racehorse it can be jittery. In the **lmf** context, MIX is best used in conjunction with ELIND; see discussion of ELIND in [HAM](tokens.html#HAMcat).   
    For examples run these scripts:

               testing/test.lm mix    (for the ASA program **lm**) 

               fp/test/test.fp copt   (for the FP program **lmf**) 

    [CONV](tokens.html#ITERcat) and [CONVC](tokens.html#ITERcat) control the convergence criteria in energy and charge, respectively. (You can use one or the other or both.) In [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) both are set to very strict values, because the shear constant which we are going to calculate involves small energy changes.  

This completes the creation of the input file, except that so far we just took a guess at the selection of basis set.

To go back to the preliminaries click [here](/fpnew/).

