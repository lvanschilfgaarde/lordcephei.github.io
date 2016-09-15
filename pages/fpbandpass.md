---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA Bandpass"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/fpbandpass/"
header: no
---

To go back to the preliminaries click [here](/fpnew/).

Start with **lmchk** just to verify some things.

*   Verify that the preprocessor works as advertised: try

               lmchk al --showp

    For example, the line containing  RSMH=  should have been turned into

               RSMH=1.8,1.8,1.8 EH=-.1,-.1,-.1

*   Invoke

               lmchk al

    and verify from the [output](FPsamples/out.al.lmchk) that the sphere overlaps about 0.6% (a safe number) and that sum-of-sphere volumes equals about 75% of the total. That is a pretty large packing fraction, as a consequence of the close packing of the fcc structure.



*   Invoke **lmfa** to generate densities for the free atom. Atomic densities will be overlapped to make a first trial density for the solid (Mattheis construction).

               lmfa al

    **lmfa**'s main function is to generate atomic densities and store them in  atm._ext_. Look at the [standard output](FPsamples/out.al.lmfa):

    1.  The atomic density is represented inside the MT spheres on a shifted logarithmic radial mesh: the _i_th mesh point is _ri_ = _b_[exp(_a_(_i_−1)−1]. The mesh is determined by the MT radius, mesh spacing parameter and number of points ([rmt, a, and nr](FPsamples/out.al.lmfa#species)).

    2.  The atomic density is completely determined by the charges in each _l_ channel (2,1,0 for _spd_). These are automatically supplied from an internal default; alternatively you can specify them with [SPEC_ATOM_Q](tokens.html#SPECcat). Self-consistency is reach after 47 iterations; then [total energies and atomic levels](FPsamples/out.al.lmfa#energies) and other information about the atomic wave functions are printed out, e.g. the charge spilling outside the MT radius. Total energy is needed to compute the heat formation of a crystal from the free-atom constituents.  

        _*Note_  When calculating cohesive energies (the change in energy on forming a solid from separate atoms), the proper reference energy must be computed for the spin polarized case. That is how the number in the input file (EREF=-483.5463) was computed. It is slightly lower than what **lmfa** generates here for the nonmagnetic atom (-483.5325 Ry).

    3.  Optimal values for envelope parameters [RSMH and EH](FPsamples/out.al.lmfa#rsmh) were detemined numerically by minimizing the total energy with respect to them. They are optimal, unfortunately, for the free atom only; but the choices are not bad and you can use the optimizer to improve them.   
        Also you can have the **lmfa** save these parameters and **lmf** read them, and save the trouble of estimating them yourself. This is accomplished with tokens in [HAM_AUTOBAS](tokens.html#HAMcat). See [this tutorial](Building_FP_input_file.html#autobas) for an example.

    4.  The density for _r_>rmt is fit to a linear combination of smoothed Hankels of various energies with a fixed smoothing radius specified by [SPEC_RSMFA](fp.html#spec). Coefficients are stored in file  atm.al.

    5.  In this setup the core is allowed to spill into the interstitial (interstitial charge q=3.59e-4). The core tails are fit to a single smoothed Hankel with smoothing radius specified by [SPEC_RFOCA](fp.html#spec). Its contribution to the interstitial density will be included.  

*   Invoke **lmf** in a [non self-consistent mode](#OPTIONS)

              lmf al -vhf=1

    _*Note_  You can change how much text is output with token [IO_VERBOSE](IOcat). The default verbosity (31) is relatively terse.  

     Note the following points in the output file (it was doctored slightly to incorporate some hyperlinks)
    1.  The [first stages](FPsamples/out.al.lmf.hf#start) of the output (symmetry group, k-points) follow the [ASA tutorial](ASAtutorial.html#lm).   
        XC:BH &larr means the Barth Hedin exchange correlation functional is used.   
        Autoread:none &larr the basis set is taken from the input file. This line looks different if you [read basis information from a file](Building_FP_input_file.html#autobas).   
        bz: metal(2), tetra, invit &larr the system is to be treated as a metal using [tetrahedron integration](bzintegration.html).  

    2.  Lattice data and symmetry operations are printed next. In this case no symmetry was specified and 48 operations were found automatically.  

    3.  Next follows a [table](FPsamples/out.al.lmf.hf#specparm) of important species data. It is advisable to pay some attention to these parameters, as they can affect the results. In general, apart from the MT radius, and the augmentation lmxa which you must supply, most parameters have good internal defaults.

        *   The augmentation _l_-cutoff lmxa can be set very low in this FP program. The reason for this is is rather subtle and is connected with the special way augmentation is done; see the [manual](nfp-doc.ps) describing this method. It has some elements in common with what amounts to augmentation in the PAW method: this form offers a justification for the _a posteriori_ fact that pseudopotential _l_-cutoffs can be much lower than corresponding cutoffs in usual all-electron implementations. Try seeing what happens by increasing lmxa to 3 or 4\. lmxa=2 is acceptable here; a more typical value is 3; it should be 4 for transition metal elements and 6 for _f_ elements.
        *   The choice of rmt was mentioned [previously](#spec) and is discussed in the [ASA tutorial](ASAtutorial.html#SPEC).  

        *   See the [FP documentation](fp.html#spec) for a discussion of augmentation smoothing radius  rsma, and the polynomial cutoff kmxa connected with it.   
            _*Note_  The internal default for  kmxa  is usually adequate for the LMTO basis set. If you include plane waves in the basis, this number should increase (the internal default increases). Even so this cutoff should be monitored especially if you use a relatively high PW cutoff, e.g. 5 Ry.
        *   Although the density _l_-cutoff  lmxl  is distinct from the augmentation _l_-cutoff  lmxa, usually you just choose lmxl=lmxa. That's the default unless you specify otherwise.
        *   Parameter  rg  corresponds to token [RSMG](fp.html#spec).
        *   Parameters rsmv and kmxv are connected with how the program manages the electrostatic interaction between spheres and interstitial. They not usually of interest.
        *   foca corresponds to token [LFOCA](fp.html#spec). LFOCA=1 is safest; LFOCA=2 is a perturbative approximation and is more efficient, and corresponds approximately to the "nonlinear core correction" common in pseudopotential programs. The difference can be important if the atom has shallow core states. In this case, choosing LFOCA=1 or 2 changes the total energy by less than 10−6 Ry.
        *   For either choice of  lfoca  there is a corresponding smoothing radius rfoca, specified by [RFOCA](fp.html#spec). Choosing rfoca large makes the density smoother and easier to manage, but degrades the quality of fit of the core density, which in turn will affect the total energy somewhat. For example it will create some dependence of the total energy on choice of MT radius. Choosing rfoca more sharply peaks the (smoothed) core density, and puts greater demands on the quality of the interstitial mesh density, which slows down the calculation.  

    4.  Next follows the setting of the [mesh density](FPsamples/out.al.lmf.hf#meshparm) which you do by one of the tokens [GMAX](tokens.html#HAMcat) or [FTMESH](tokens.html#HAMcat) in HAM. Finer meshes are more accurate, but the computation time scales in proportion to the total number of points. Column "last term" is an estimate of the error in the envelope function when expanded in plane waves. It should not be too large: 10−5 is usually quite acceptable. If it is too large, the FT mesh should be increased (larger GMAX or FTMESH). If the numbers in the "cutoff" column are all small compared to the total number of **G** vectors in the the mesh, you can safely reduce the fineness of the mesh. This particular choice of gmax=7 is extremely conservative: a.u. generated 10×10×10 divisions, or 609 G vectors. The cutoff column of the table show many G vectors are needed for each orbital to be converged with the specified tolerance (you specify tolerance with [TOL](tokens.html#HAMcat)). It is evident from the table that the most G vectors any orbital needs is less than 200, far less than the 609 possible with gmax=7\. In this case, reducing gmax to as low as 4 reduces the maximum number of G vectors to 113, and changes the total energy by ~10−5 Ry. In general the mesh density must be fine as the most strongly peaked orbital in the basis. [This tutorial](Building_FP_input_file.html#gmax) shows how mesh requirements are strongly affected by the character of states entering into the basis, and how you can use **lmfa** to select a reasonable value for you.  

    5.  The lines around [Makidx](FPsamples/out.al.lmf.hf#meshparm) show the dimensions of the hamiltonian. In the present FP context, the only meaningful number is the `Low' dimension. This calculation uses a standard minimal basis of 9 _spd_ orbitals.  

    6.  Next **lmf** looks for an [input density](fp.html#programs). It can start from free-atom files or from a restart file. Unless you specify with command-line switch [--rs=](Command-line-options.html#section1lmf), **lmf** will:
        *   try to read from (binary) restart file rst._ext_.
        *   If this fails, it will to read [atm._ext_](#lmfa) and create a density by overlapping free-atom charges. That is what is done [here](FPsamples/out.al.lmf.hf#startingrho) as no rst file is yet available.
        *   If this also fails, **lmf** aborts.  

    7.  Next **lmf** begins the [iterations cycle](FPsamples/out.al.lmf.hf#iteration1). First the interstitial potential is created, followed by local potentials and potential parameters for each site in the lattice (there is only one site in this example).  

    8.  Next follows a [table](FPsamples/out.al.lmf.hf#iteration1table1) summarizing the charge, magnetic moment (in the spin polarized case) and all parameters needed to compute the total energy, except the eigenvalue sum, which it determines after a band pass.  

    9.  Next follows the [Brillouin zone](FPsamples/out.al.lmf.hf#bzint) integration over k-points. Because the input file chose tetrahedron integration with [METAL=2](tokens.html#BZcat), **lmf** tries to read k-point weights from the  `wkp'  file, so that it can _use weights from a prior iteration_ for the present band pass. Since the file doesn't have the right number of k-points, **lmf** makes a special band pass to create the weights. Use [METAL=3](tokens.html#BZcat) if you want **lmf** to create the weights every band pass. This is safer, because there is a guaranteed connection between the weights and the eigenvalues, but slower because two passes are required each iteration. The recommended choice is METAL=5: it combines the best of METAL=2 and METAL=3. But this mode keeps eigenvectors in memory, and is more memory intensive, so don't use  METAL=5  for large systems.  

    10.  The determination of the [Fermi level](FPsamples/out.al.lmf.hf#efermi) proceeds in the same way as in the ASA; see the [ASA tutorial](ASAtutorial.html#efermi), and also [this page](bzintegration.html) for a detailed discussion of the tetrahedron method for Brillouin zone integration. Note that the total density-of-states was made. This is because BZ_SAVDOS=t. Setting this token causes the DOS to be generated and written to dos._ext_.  

    11.  The Harris-Foulkes total energy is calculated (it requires only the input density and band energy to evaluate). This is a [non self-consistent](#OPTIONS) calculation, so no output density is generated and the program stops.

<hr style="height:10pt; visibility:hidden;" />

To go back to the preliminaries click [here](/fpnew/).
