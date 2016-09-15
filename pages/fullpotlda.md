---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/fullpotlda/"
header: no
---

### Table of Contents
*  Auto generated table of contents
{:toc}

# **Tutorial for the full-potential LDA program lmf (v7.10)**

## 1. Purpose

This tutorial demonstrates the all-electron, full-potential LDA program **lmf**. It

+ describes how to build the input file, by [categories](input-file-style.html). You can [build input files automatically](Building_FP_input_file.html) from structural data, but this section is worth going through nevertheless.

+ Some checks are made and a band pass is explained.

+ The basis set is tuned.

+ explains the output of a self-consistent calculation, and how to create energy bands and density-of-states

+ shows how to compute shear constants _c_<sub>11</sub>− _c_<sub>12</sub> and _c_<sub>44</sub> in Al.

A corresponding tutorial for the ASA program **lm** is found in the [ASA tutorial](/asadoc/).

*Note* This tutorial assumes that you installed the executables (e.g. **lmchk**, **lmfa**, **lmf**) and that they are in your path.  

It also assumes you have read the [ASA documentation](lmto.html) and the [FP documentation](/fpnew/), how the [input file is structured](/inputguide/) and that you have already gone through the [ASA tutorial](ASAtutorial.html), and that you understand how the [file preprocessor]() works. In this tutorial two of the three elastic constants in Al are calculated. Output files are in [doc/FPsamples](FPsamples/ctrl.al). [Build the input file yourself](/inputguide/), or copy ctrl.al from [doc/FPsamples](FPsamples/ctrl.al) and skip immediately to the [electronic structure calculations](/fpoptbas/).

**lmf** has many other useful features not described in this tutorial. Look at [this page](#othersamples) for information about other tools and kinds of calculations available.

## 2. Building the input file

Start in the top-level directory. This sample helps you create a complete input file for elemental Al, including optimizing the parameters for the basis set. The file is then used to compute a shear constant. You may create some or all of your own input file from scratch; or you can just copy file [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) to the top-level directory.

Many categories are nearly identical to those in the [ASA tutorial](/asadoc/):

+ create category [VERS](tokens.html#VERScat). **lmf** requires token FP:7

+ (optional) create the [HEADER](tokens.html#HEADERcat) category.  

+ Set up the crystal structure, categories [STRUC](tokens.html#STRUCcat) and [SITE](tokens.html#SITEcat).

    Al is fcc, with a lattice constant 7.606 a.u. at 0K. The input file could have read

      `STRUC ALAT=7.606`  

    but instead the template [doc/FPsamples](FPsamples/ctrl.al) declares a symbolic variable 'a' in the [CONST](tokens.html#CONSTcat) category and uses

      `STRUC ALAT=a`  

    Doing it this way enables you to alter the lattice constant via the command-line, e.g. with switch  -va=7.1.

+ Build the [SPEC](tokens.html#SPECcat) to supply chemical species information. [STRUC](tokens.html#STRUCcat), [SITE](tokens.html#SITEcat), [SPEC](tokens.html#SPECcat) are all described in the [ASA tutorial](ASAtutorial.html#STRUC); see [SPEC](ASAtutorial.html#SPEC) there for a discussion of the choice muffin tin radius. In the present case, we choose RMT=0.91avw (avw = space-filling radius appropriate to the ASA). This makes sphere overlaps ~0.6%, as can be verified with [**lmchk**](#preliminaries). Strictly speaking spheres should not overlap (geometry violation), but because of the special way the local densites are handled, overlaps of up to 10% or so make negligible errors. The main drawback is that [self-consistency](#selfconsistency) tends to be more difficult when overlaps extend to 10%.

    The principal complication **lmf** has over the ASA is the need to specify the shape of the [smoothed Hankel envelope functions](fp.html#smoothH) which define the basis. (A smoothed Hankel is a [convolution of a Gaussian and a Hankel function](nfp-doc.ps)). Each *s*, *p*, *d*,... orbital has [two independent parameters](fp.html#spec) (Gaussian smoothing radius and Hankel energy), which you are free to choose. The extra freedom is advantageous in that they offer more flexibility than do ordinary Hankel functions; also they are smoother and regular at the origin. On the flip side, there is no obvious *a priori* way to choose these parameters, which make it cumbersome to find an optimal basis. The simplest way is to choose these parameters is to follow the automatic procedure described [on this page](Building_FP_input_file.html#autobas).

    When choosing parameters by hand, a reasonable default is to set the smoothing radius (see RSMH below) to 2/3 of the augmentation radius for *s* and *p* orbitals, and about 1 or so for transition metal *d* orbtals. To improve on the basis it is recommended you avail yourself of the basis optimizer. See [here](FPoptbas.html) for a (somewhat outdated) tutorial; it is also covered [later in the present tutorial](#optimizebasis).

    `doc/FPsamples/ctrl.al` uses by default a minimal basis of *spd* orbitals, defined in the following lines:

    `% const rsm1=1.8 rsmd1=1.8 ed1=-.1`

    The const directive is described in the [preprocessor documentation](file-preprocessor.html#constdef)

    `RSMH={rsm1},{rsm1},{rsmd1} EH=-.1,-.1,{ed1}`

    The contents of curly brackets are [evaluated as expressions](file-preprocessor.html#expressions)

    1.8 is 2/3 of the MT radius, 2.7. Al is an easy case: all states are nearly free electron-like. When we optimize the basis later, we will see that it is good choice. The choice of EH is usually less important (unless a state is very deep, such as the Oxygen *s* state); typically choose a small negative number, e.g. −0.1.

    Note the additional lines in `doc/FPsamples/ctrl.al`:

    ```
      %ifdef bigbas
       % const rsm2=1.8
         RSMH2={rsm2},0,{rsmd1} EH2=-1,-1,-1
       %endif
    ```

    If  bigbas is nonzero (either by changing ctrl.al or by invoking **lmf** with -vbigbas=), the basis set is enlarged from *spd* to *spdsd*.   
    RSMH2 has nonzero values in the *s* and *d* channels only; channels for which RSMH2=0 are excluded from the basis.

    When you use RSMH2 you should set EH2 to about 0.8 or 1 Ry deeper than EH1; otherwise the basis becomes too linearly dependent.  


*   create the [HAM](tokens.html#HAMcat) category. Most important here is GMAX, which specifies the cutoff in **G** vectors for the interstitial density. A uniform mesh of G vectors is generated; it keeps those for which G. This number is important because execution efficiency depends on it (though for one atom/cell, efficiency isn't important). It is exactly analogous to GMAX you must specify when using a plane-wave (pseudopotential or augmented plane wave) basis, except that here it is used for the density only, not both density and basis.

    You must specify one of or. **lmf** first looks for GMAX; if it isn't found, FTMESH is sought. If *neither* is found, **lmf** stops. Both are present in [doc/FPsamples/ctrl.al](FPsamples/ctrl.al), but only GMAX is used since it is sought first. It turns out that both modes will specify a mesh with 10 divisions along each axis: FTMESH=10 10 10.


*   Create the [OPTIONS](tokens.html#OPTIONScat) category. Of note here is this text: HF={hf}. 'hf' is an algebraic variable set by the [const preprocessor directive](file-preprocessor.html#constdef):

      % const hf=f

    This will create hf and initialize it to zero. However, if you assign hf in some prior directive on the command line (using e.g. -vhf=1), the 'const'  will not override its value. Note that [doc/FPsamples/ctrl.al](FPsamples/ctrl.al), uses hf in this line

      OPTIONS NSPIN=1 REL=t XCFUN=2 HF={hf}

    With a command-line switch -vhf=1 we can make non self-consistent calculations, which yield approximate energies via the [Harris-Foulkes functional](http://link.aps.org/doi/10.1103/PhysRevB.39.12520). We will use this feature to optimize the basis set (see discussion of [basis optimization](#basisoptimization) below).  

*   create the [BZ](tokens.html#BZcat) category. Note the following:  

    1.  NKABC and BJOB specify the *k*-point mesh.  

    2.  SAVDOS, NPTS, and DOS specify that the total density-of-states is to be created each time the Fermi level is determined.  

    3.  W=.002 EF0=0 DELEF=.1 are only relevant for sampling, so they aren't used in this tutorial, which uses tetrahedron integration (TETRA=t).  

    4.  when HF=t, we also use NEVMX=-1 to suppress generation of the output density through this construct:

        ```
           % ifdef hf
              NEVMX=-1
            % endif
        ```  

        The preprocessor will include the line 'NEVMX=-1' in the input file only when hf is nonzero.  

    5.  We choose METAL=2; see documentation for the [BZ category](tokens.html#BZcat).   
        *Note METAL=5 is usually a better choice, provided you are not limited by memory.  

*   The [EWALD](tokens.html#EWALDcat) category is optional is included here only for pedagogical purposes.  

*   The [ITER](tokens.html#ITERcat) category controls the number of iterations, convergence citeria, and the how earlier densities are mixed with the current one, which you can set through MIX. See [here](tokens.html#mixing) for a description. This input file uses MIX=A3, which tells **lmf** to use Anderson mixing with up to three prior pairs of (input,output) density. But there are [many possible modifications](tokens.html#mixing). Unfortunately there is no good general prescription for MIX: cases with combined "hard" and "soft" degrees of freedom can be hard to stabilize (magnetic systems are often that way). Broyden mixing tends to work best, but like a racehorse it can be jittery. In the **lmf** context, MIX is best used in conjunction with ELIND; see discussion of ELIND in [HAM](tokens.html#HAMcat).   
    For examples run these scripts:

      testing/test.lm mix    (for the ASA program **lm**) </pre>

      fp/test/test.fp copt   (for the FP program **lmf**) </pre>

    [CONV](tokens.html#ITERcat) and [CONVC](tokens.html#ITERcat) control the convergence criteria in energy and charge, respectively. (You can use one or the other or both.) In [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) both are set to very strict values, because the shear constant which we are going to calculate involves small energy changes.  

This completes the creation of the input file, except that so far we just took a guess at the selection of basis set.

## 3. Getting Started : Analyzing the results of a Band Pass

Start with **lmchk** just to verify some things.

*   Verify that the preprocessor works as advertised: try

       lmchk al --showp

    For example, the line containing  RSMH=  should have been turned into

       RSMH=1.8,1.8,1.8 EH=-.1,-.1,-.1

*   Invoke

       lmchk al

    and verify from the [output](FPsamples/out.al.lmchk) that the sphere overlaps about 0.6% (a safe number) and that sum-of-sphere volumes equals about 75% of the total. That is a pretty large packing fraction, as a consequence of the close packing of the fcc structure.

*   Invoke **lmfa** to generate densities for the free atom. Atomic densities will be overlapped to make a first trial density for the solid (Mattheis construction).

       lmfa al

    **lmfa**'s main function is to generate atomic densities and store them in atm.*ext*. Look at the [standard output](FPsamples/out.al.lmfa):
    1.  The atomic density is represented inside the MT spheres on a shifted logarithmic radial mesh: the *ith* mesh point is *ri* = _b_[exp(_a_(_i_−1)−1]. The mesh is determined by the MT radius, mesh spacing parameter and number of points ([<font size="+1"><tt>rmt, a, and nr</tt></font>](FPsamples/out.al.lmfa#species)).
    2.  The atomic density is completely determined by the charges in each _l_ channel (2,1,0 for *spd*). These are automatically supplied from an internal default; alternatively you can specify them with [SPEC_ATOM_Q](tokens.html#SPECcat). Self-consistency is reach after 47 iterations; then [total energies and atomic levels](FPsamples/out.al.lmfa#energies) and other information about the atomic wave functions are printed out, e.g. the charge spilling outside the MT radius. Total energy is needed to compute the heat formation of a crystal from the free-atom constituents.   
        *Note* When calculating cohesive energies (the change in energy on forming a solid from separate atoms), the proper reference energy must be computed for the spin polarized case. That is how the number in the input file (EREF=-483.5463) was computed. It is slightly lower than what **lmfa** generates here for the nonmagnetic atom (-483.5325 Ry).
    3.  Optimal values for envelope parameters [RSMH and EH](FPsamples/out.al.lmfa#rsmh) were detemined numerically by minimizing the total energy with respect to them. They are optimal, unfortunately, for the free atom only; but the choices are not bad and you can use the optimizer to improve them.   
        Also you can have the **lmfa** save these parameters and **lmf** read them, and save the trouble of estimating them yourself. This is accomplished with tokens in [HAM_AUTOBAS](tokens.html#HAMcat). See [this tutorial](Building_FP_input_file.html#autobas) for an example.
    4.  The density for rmt is fit to a linear combination of smoothed Hankels of various energies with a fixed smoothing radius specified by [SPEC_RSMFA](fp.html#spec). Coefficients are stored in file atm.al.
    5.  In this setup the core is allowed to spill into the interstitial (interstitial charge q=3.59e-4). The core tails are fit to a single smoothed Hankel with smoothing radius specified by [SPEC_RFOCA](fp.html#spec). Its contribution to the interstitial density will be included.

*   Invoke **lmf** in a [non self-consistent mode](#OPTIONS)

      lmf al -vhf=1

    *Note You can change how much text is output with token [IO_VERBOSE](IOcat). The default verbosity (31) is relatively terse.  

     Note the following points in the output file (it was doctored slightly to incorporate some hyperlinks)
    1.  The [first stages](FPsamples/out.al.lmf.hf#start) of the output (symmetry group, k-points) follow the [ASA tutorial](ASAtutorial.html#lm).   
        XC:BH &larr means the Barth Hedin exchange correlation functional is used.   
        Autoread:none &larr the basis set is taken from the input file. This line looks different if you [read basis information from a file](Building_FP_input_file.html#autobas).   
        bz: metal(2), tetra, invit &larr the system is to be treated as a metal using [tetrahedron integration](bzintegration.html).  

    2.  Lattice data and symmetry operations are printed next. In this case no symmetry was specified and 48 operations were found automatically.  

    3.  Next follows a [table](FPsamples/out.al.lmf.hf#specparm) of important species data. It is advisable to pay some attention to these parameters, as they can affect the results. In general, apart from the MT radius, and the augmentation lmxa which you must supply, most parameters have good internal defaults.
        *   The augmentation *l*-cutoff lmxa can be set very low in this FP program. The reason for this is is rather subtle and is connected with the special way augmentation is done; see the [manual](nfp-doc.ps) describing this method. It has some elements in common with what amounts to augmentation in the PAW method: this form offers a justification for the *a posteriori* fact that pseudopotential *l*-cutoffs can be much lower than corresponding cutoffs in usual all-electron implementations. Try seeing what happens by increasing lmxa to 3 or 4. lmxa=2 is acceptable here; a more typical value is 3; it should be 4 for transition metal elements and 6 for *f* elements.
        *   The choice of rmt was mentioned [previously](#spec) and is discussed in the [ASA tutorial](ASAtutorial.html#SPEC).  

        *   See the [FP documentation](fp.html#spec) for a discussion of augmentation smoothing radius  rsma, and the polynomial cutoff kmxa connected with it.   
            *Note* The internal default for kmxa is usually adequate for the LMTO basis set. If you include plane waves in the basis, this number should increase (the internal default increases). Even so this cutoff should be monitored especially if you use a relatively high PW cutoff, e.g. 5 Ry.
        *   Although the density *l*-cutoff lmxl is distinct from the augmentation *l*-cutoff lmxa, usually you just choose lmxl=lmxa. That's the default unless you specify otherwise.
        *   Parameter rg corresponds to token [RSMG](fp.html#spec).
        *   Parameters rsmv and kmxv are connected with how the program manages the electrostatic interaction between spheres and interstitial. They not usually of interest.
        *   foca corresponds to token [LFOCA](fp.html#spec). LFOCA=1 is safest; LFOCA=2 is a perturbative approximation and is more efficient, and corresponds approximately to the "nonlinear core correction" common in pseudopotential programs. The difference can be important if the atom has shallow core states. In this case, choosing LFOCA=1 or 2 changes the total energy by less than 10<sup>−6</sup> Ry.
        *   For either choice of lfoca there is a corresponding smoothing radius rfoca, specified by [RFOCA](fp.html#spec). Choosing rfoca large makes the density smoother and easier to manage, but degrades the quality of fit of the core density, which in turn will affect the total energy somewhat. For example it will create some dependence of the total energy on choice of MT radius. Choosing rfoca more sharply peaks the (smoothed) core density, and puts greater demands on the quality of the interstitial mesh density, which slows down the calculation.  

    4.  Next follows the setting of the [mesh density](FPsamples/out.al.lmf.hf#meshparm) which you do by one of the tokens [GMAX](tokens.html#HAMcat) or [FTMESH](tokens.html#HAMcat) in HAM. Finer meshes are more accurate, but the computation time scales in proportion to the total number of points. Column "last term" is an estimate of the error in the envelope function when expanded in plane waves. It should not be too large: 10<sup>−5</sup> is usually quite acceptable. If it is too large, the FT mesh should be increased (larger GMAX or FTMESH). If the numbers in the "cutoff" column are all small compared to the total number of **G** vectors in the the mesh, you can safely reduce the fineness of the mesh. This particular choice of gmax=7 is extremely conservative: a.u. generated 10×10×10 divisions, or 609 G vectors. The cutoff column of the table show many G vectors are needed for each orbital to be converged with the specified tolerance (you specify tolerance with [TOL](tokens.html#HAMcat)). It is evident from the table that the most G vectors any orbital needs is less than 200, far less than the 609 possible with gmax=7. In this case, reducing gmax to as low as 4 reduces the maximum number of G vectors to 113, and changes the total energy by ~10<sup>−5</sup> Ry. In general the mesh density must be fine as the most strongly peaked orbital in the basis. [This tutorial](Building_FP_input_file.html#gmax) shows how mesh requirements are strongly affected by the character of states entering into the basis, and how you can use **lmfa** to select a reasonable value for you.  

    5.  The lines around [Makidx](FPsamples/out.al.lmf.hf#meshparm) show the dimensions of the hamiltonian. In the present FP context, the only meaningful number is the 'Low' dimension. This calculation uses a standard minimal basis of 9 *spd* orbitals.  

    6.  Next **lmf** looks for an [input density](fp.html#programs). It can start from free-atom files or from a restart file. Unless you specify with command-line switch [--rs=](Command-line-options.html#section1lmf), **lmf** will:
        *   try to read from (binary) restart file rst.*ext*.
        *   If this fails, it will to read [atm.*ext*](#lmfa) and create a density by overlapping free-atom charges. That is what is done [here](FPsamples/out.al.lmf.hf#startingrho) as no rst file is yet available.
        *   If this also fails, **lmf** aborts.  

    7.  Next **lmf** begins the [iterations cycle](FPsamples/out.al.lmf.hf#iteration1). First the interstitial potential is created, followed by local potentials and potential parameters for each site in the lattice (there is only one site in this example).  

    8.  Next follows a [table](FPsamples/out.al.lmf.hf#iteration1table1) summarizing the charge, magnetic moment (in the spin polarized case) and all parameters needed to compute the total energy, except the eigenvalue sum, which it determines after a band pass.  

    9.  Next follows the [Brillouin zone](FPsamples/out.al.lmf.hf#bzint) integration over k-points. Because the input file chose tetrahedron integration with [METAL=2](tokens.html#BZcat), **lmf** tries to read k-point weights from the 'wkp' file, so that it can *use weights from a prior iteration* for the present band pass. Since the file doesn't have the right number of k-points, **lmf** makes a special band pass to create the weights. Use [METAL=3](tokens.html#BZcat) if you want **lmf** to create the weights every band pass. This is safer, because there is a guaranteed connection between the weights and the eigenvalues, but slower because two passes are required each iteration. The recommended choice is METAL=5: it combines the best of METAL=2 and METAL=3. But this mode keeps eigenvectors in memory, and is more memory intensive, so don't use METAL=5 for large systems.  

    10.  The determination of the [Fermi level](FPsamples/out.al.lmf.hf#efermi) proceeds in the same way as in the ASA; see the [ASA tutorial](ASAtutorial.html#efermi), and also [this page](bzintegration.html) for a detailed discussion of the tetrahedron method for Brillouin zone integration. Note that the total density-of-states was made. This is because BZ_SAVDOS=t. Setting this token causes the DOS to be generated and written to dos.*ext*.  

    11.  The Harris-Foulkes total energy is calculated (it requires only the input density and band energy to evaluate). This is a [non self-consistent](#OPTIONS) calculation, so no output density is generated and the program stops.

## 4. Optimizing the Basis Set

*   You can make the basis most optimal by minimizing the total energy with respect to all parameters RSMH and EH. You can in fact do so as explained in [this tutorial](FPoptbas.html). But experience has shown that energies are usually rather insensitive to EH and anyway, for theoretical reasons, EH should not be too negative. In practice you can optimize RSMH efficiently, and it is not necessary to to more. Do this with:

       lmf al --optbas

    You should find that the optimization reduced the Harris Foulkes energy from ehf=-0.2924 to ehf=-0.2926 Ry. This difference is too small to bother with. Usually the improvement is subtsantially larger, and you take the result of the optimized calculation (saved in basp2.*ext*) and copy them to your input file. Or, you can have lmf automatically read these parameters from file basp; tokens in HAM_AUTOBAS control what **lmf** reads from this file, and what **lmfa** writes to it. See [this tutorial](Building_FP_input_file.html#autobas) for an example.

    We might consider the effect of enlarging the basis, which as we noted we can do from the commmand line with -vbigbas=1. Do this:

       lmf al -vbigbas=1 -vhf=1

    and you will see that the HF energy is now ehf=-.2943: the additional basis improves the energy by 1.9mRy in this case, again probably too small to worry about.  

    ## 5. Self-consistent LDA calculation

    In the [preliminaries](#preliminaries) we built a trial density with a Mattheis construction, and made a band pass with it. Now we can do a self-consistent calculation

       lmf al > out

    Up to the calculation of the Fermi level [Fermi level](FPsamples/out.al.lmf#efermi) the output will be essentially the same.

    Now the [output density](FPsamples/out.al.lmf#outrho) is generated. With the output density, the HKS energy functional can be evaluated. Also the log derivative parameters P are floated to the band centers-of-gravity. How the P's are floated is prescribed by tokens [IDMOD](tokens.html#SPECcat); there is a corresponding ASA counterpart discussed in the [ASA overview](lmto.html#section2).

    A [new density](FPsamples/out.al.lmf#mixrho) is constructed as follows:

    *   The *output density* is screened using the model Lindhard function, provided the Lindhard parameter [ELIND](tokens.html#HAMcat) is nonzero:

         nout* = nin  + eps^-1 (nout-nin)

    *   An estimate for the self-consistent density is made by mixing nin and nout using some [mixing scheme](tokens.html#mixing).
    *   The resultant density is [saved](FPsamples/out.al.lmf#iors) in rst.*ext*, unless you specify otherwise using [--rs=](Command-line-options.html#section1lmf).
    *   At the end of the iteration, the total energies are printed and checks are made whether self-consistency is achieved to tolerances specified by [ITER_CONV](tokens.html#ITERcat) and [ITER_CONVC](tokens.html#ITERcat). The RMS DQ generated at the [mixing step](FPsamples/out.al.lmf#mixrho) is the measure compared against tolerance [CONVC](tokens.html#ITERcat); the change in energy from one iteration to the next is tested against tolerance [CONV](tokens.html#ITERcat). Both tolerances must be satisfied, unless you set CONV=0 or CONVC=0 (0 tolerance tells **lmf** not to test that parameter). Since only one iteration has been completed [so far](FPsamples/out.al.lmf#endofiter1), there is no way to test the CONV, so no tests are made. **lmf** proceeds without checks to the second iteration; from the [second iteration](FPsamples/out.al.lmf#endofiter2) onwards convergence checks are made.   

    Because Al is rather well approximated by free electron gas, the Lindhard function is an excellent approximation to the true dielectric function, and the iterations converge rapidly to self-consistency. However, because the tolerances were set [very small](#mix), self-consistency is achieved only after [six iterations](FPsamples/out.al.lmf#endofiter6). To see how the RMS DQ evolves, do

     grep 'RMS DQ' out

    You should see a table like this:

     mixrho:  sought 3 iter from file mixm; read 0.  RMS DQ=8.57e-3
     mixrho:  sought 3 iter from file mixm; read 1.  RMS DQ=5.48e-4  last it=8.57e-3
     mixrho:  sought 3 iter from file mixm; read 2.  RMS DQ=1.29e-4  last it=5.48e-4
     mixrho:  sought 3 iter from file mixm; read 3.  RMS DQ=6.44e-6  last it=1.29e-4
     mixrho:  sought 3 iter from file mixm; read 4.  RMS DQ=4.24e-7  last it=6.44e-6
     mixrho:  sought 3 iter from file mixm; read 4.  RMS DQ=4.97e-8  last it=4.24e-7


    The code calculates two energy functionals, the Hohenberg-Kohn and Harris-Foulkes functional. Both energies printed at the end of each iteration. The HF energy is more binding than the HK after the [first iteration](FPsamples/out.al.lmf#endofiter1); at [self-consistency](FPsamples/out.al.lmf#endofiter5) they are the same. The HK energy is variational; it should approach the self-consistent value from above. Usually (but not always) the HF energy approaches it from below. Thus the difference in the two is an additional measure of deviation from self-consistency. Moniter the convergence the two with:

     grep ehf=- out

    You should see the following table:

      h ehf=-.2923995 ehk=-.2897842
      i ehf=-.2905176 ehk=-.2903167
      i ehf=-.2904201 ehk=-.2904115
      i ehf=-.2904344 ehk=-.2904343
      i ehf=-.2904324 ehk=-.2904322
      c ehf=-.2904324 ehk=-.2904322

    The HF and HK energy functionals are completely different; that they converge to (nearly) the same answer is a test of the validity of the implementation.

    These lines are also written to the [save file](lmto.html#section5); a very convenient tool [vextract](Building_FP_input_file.html#vextract) is designed to be used with it, as can be seen when evaluating the [shear constant](#shearconstant) below.

    ## 6. Other things to read and do

    A panopoly of other tools are available, including a tools to [automatically generate the input file](Building_FP_input_file.html), and tools to do a variety of other kinds of calculations. You can see many of them by invoking fp/testing/test.fp: this script serves both to test that the code works as it should, and to showcase program features. To see the test cases on offer with a brief description of their purpose, run from the top-level directory:

      fp/test/test.fp --list

    You can generate and plot the energy bands using **lmf**. It proceeds in the same way as in the [ASA tutorial](ASAtutorial.html#bands). Generate the band file this way:

       cp startup/syml.fcc ./syml.al
       lmf al --band:fn=syml

    Plot the bands as in the ASA tutorial, or look at this [this tutorial](generating-energy-bands.html).

    The generation of the core-level spectroscopy, Mulliken analysis or density-of-states is done first by invoking **lmf** with the appropriate [command-line switch](fp.html#section3), followed by **lmdos**. The **lmdos** step is illustrated (including a way to plot results) in the [ASA tutorial](ASAtutorial.html#dos).

    To compute the density of states, see [this tutorial](generating-density-of-states.html). To compute core-level EELS spectra or Mulliken analysis in Fe, try running

       fp/test/test.fp fe 2

    To compute total or partial DOS in hcp Co, try running

       fp/test/test.fp co 2

    [Another tutorial](siged-tutorial.html#AsAntisiteLatticeRelaxation) goes through a lattice relaxation of an As antisite defect in the LDA. It also shows how quasiparticle self-consistent *GW* self-energies can be incorporated into **lmf** to obtain a quasiparticle description of the defect level. This tutorial also shows how to use **lmf** to calculate the [spin orbit coupling and magnetic anisotropy](siged-tutorial.html#SOcoupling) in Fe. Quasiparticle self-consistent *GW* self-energies can be incorporated there as well. While QS*GW* significantly improves on the LDA band structure, it is not yet known whether they improve on the LDA's prediction of the anisotropy.

    ## 7. Shear constants

    This section shows how to calculate two of the three independent shear constants in Al. We first calculate *c*<sub>11</sub>− *c*<sub>12</sub>, which we will do by computing the total energy at different lattice distortions, and fitting the curvature of the total energy. The tetragonal distortion is conveniently generated using the line

            SHEAR=0 0 1 1+dist

    which distorts the lattice in a way that conserves volume to all orders (this is useful because it tends to be less error-prone). The direction of distortion is set by the first three parameters; the lattice will be sheared along (001).   

    The first difficulty is that our specification of the FT mesh using token GMAX may cause the program to switch meshes for as parameter *dist* changes. This is a bad idea, since we want to resolve very small energy differences. So, the first step is to comment out the line with GMAX=gmax in the input and use instead:

       FTMESH=10 10 10

    The second difficulty is that the shear constants in Al are difficult to converge, because they require many *k*-points. The following steps are written in 'tcsh' and compute the self-consistent total energy parameterically as a function of 'dist':

       rm -f out save.al
       foreach x ( -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04)
         rm -f mixm.al wkp.al
         lmf al -vdist=$x -vnk=24 --pr20,20 >>out
       end

    Note that the mixing file eigenvalue weights file (mixm.al and wkp.al) are deleted for each new shear calculation. File save.al contains total energies ehf for 9 values of dist using 24 divisions of k-points. (To properly converge the calculation use nk=32 or even nk=40.)

    Extracting ehf and ehk parametrically as a function of dist is very easy with the [vextract](Building_FP_input_file.html#vextract) tool:

       cat save.al | startup/vextract c dist ehf > dat

    The key 'c' tells vextract that you want lines beginning only with 'c': these lines correspond to band passes when [self-consistency](Building_FP_input_file.html#vextract) was reached. You can use any regular expression for the key. You can ask vextract to extract any quantity associated with a variable in the file.

    File  'dat'  should look something very nearly like:

      -.04 -.2901536
      -.03 -.290358
      -.02 -.2904993
      -.01 -.2905869
      0 -.2906165
      .01 -.2905871
      .02 -.2905041
      .03 -.2903603
      .04 -.2901537

    Fitting a sixth-order polynomial through these points, we obtain as the second derivative of ehf with respect to dist:

       E'' = .578 Ry

    With a little algebra, and converting from atomic Ry units to ergs/cm<sup>3</sup> it is easy to show that

             vol = a^3/4 = 110 a.u.
        1Ry/a0^3 = 147e12 erg/cm^3
        c11-c12  = (2/3*147/vol)*E'' (10^12 erg/cm^3)
                 = 0.514 x 10^12 erg/cm^3


    which is 6% less than the experimental 0K value, 0.55 × 10<sup>12</sup> erg/cm<sup>3</sup>.

    A trigonal shear will yield *c*<sub>44</sub>. To compute it, replace the SHEAR token with:

             SHEAR=1 1 1 1+dist

    Now the lattice is sheared along the [111] direction. Repeat the preceding command sequence with this substitution, and you should find file 'dat' looking something very nearly like:

      -.04 -.2900159
      -.03 -.2902898
      -.02 -.2904768
      -.01 -.2905849
      0 -.2906164
      .01 -.2905768
      .02 -.2904718
      .03 -.2902827
      .04 -.290012


    Fitting a sixth-order polynomial through these points, we obtain as the second derivative of ehf with respect to dist:

       E'' = .684 Ry

    In this case,

        c44 = (1/3*147/vol)*E'' (10^12 erg/cm^3)
            = 0.304 x 10^12 erg/cm^3


    which is about 6% smaller than the extrapolation to 0K of the experimental value, 0.32 × 10<sup>12</sup> erg/cm<sup>3</sup>. Both of these elastic constants depend on the fitting procedure with an uncertainty of about 5%. A careful calculation would use more points dist and increase nk. The final shear constant, the bulk modulus, you can calculate by varying the lattice constant. We do not do it here, but if you do this, you are advised to use token STRUC_DALAT, rather than change ALAT (see the following note).

    *Note* that [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) includes a token DALAT, which it sets to 0. The actual lattice constant is ALAT+DALAT. Do it this way because some parameters change with ALAT, but are kept frozen when DALAT varies. A calculation of *B* yields 0.85× 10<sup>12</sup> erg/cm<sup>3</sup> when evaluated at the LDA mininum energy lattice constant (7.53 a.u., about 1% smaller than the experiment), and 0.72 × 10<sup>12</sup> erg/cm<sup>3</sup> when evaluated at the experimental lattice constant. Because the lattice constant is slightly wrong there is an ambiguity as to which value is appropriate to compare against experiment. The experimental value extrapolated to 0K is 0.81× 10<sup>12</sup> erg/cm<sup>3</sup>.
