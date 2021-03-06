---
layout: page-fullwidth
title: "ASA Green's function package tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmgf/lmgf/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Preliminaries_
_____________________________________________________________
For this tutorial the **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmstr**{: style="color: blue"}, **lm**{: style="color: blue"} and **lmgf**{: style="color: blue"} executibles are required and are assumed to be in your PATH; the source code for all Questaal exectuables can be found [here](https://bitbucket.org/lmto/lm).


### _Purpose_
_____________________________________________________________
This package implements the ASA local spin-density approximation using Green's functions. The Green's functions are contructed by approximating KKR multiple-scattering theory with an analytic potential function. The approximation to KKR is essentially similar to the linear approximation employed in band methods such as LMTO and LAPW. It can be shown that this approximation is nearly equivalent to the LMTO hamiltonian without the "combined correction" term. With this package a new program, **lmgf**{: style="color: blue"} is added to the suite of executables. **lmgf**{: style="color: blue"} plays approximately the same role as the LMTO-ASA band program **lm**{: style="color: blue"}: a potential is generated from energy moments $$Q_0$$, $$Q_1$$, and $$Q_2$$ of the density of states. in the same way as the **lm**{: style="color: blue"} code. You can use **lmgf**{: style="color: blue"} to make a self-consistent density as you can do with **lm**{: style="color: blue"}. lmgf is a Green's function method: Green's functions have less information than wave functions, so in one sense the things you can do with lmgf are more limited: you cannot make the bands directly, for example. However **lmgf**{: style="color: blue"} enables you do do things you cannot do with **lm**{: style="color: blue"}. The two most imprortant are:

+ Calculate magnetic exchange interactions 
+ Calculate magnetic susceptibility (spin-spin, spin-orbit, orbit-orbit parts)
+ Calculate properties of disordered materials, either chemically disordered or spin disorder from finite temperature, within the Coherent Potential Approximation, or CPA.
+ Calculate the ASA static susceptibility at $$q=0$$ to help converge calculations to self-consistency. 

**You can find some extra information on the way** **lmgf**{: style="color: blue"} **works in** [lmgf documentation](https://lordcephei.github.io/lmgf-documentation/).

<div onclick="elm = document.getElementById('lmgfvslm'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">lmgf vs lm</button></div>{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="lmgfvslm">{:/}

**lmgf vs lm**{: style="color: orange"}

**lmgf**{: style="color: blue"} is a Green's function program complementary to the ASA band code **lm**{: style="color: blue"}. For some properties, e.g. calculating moments $$Q_{0..2}$$ **lmgf**{: style="color: blue"} can be straightforwardly substituted for lm because both calculate the DOS. The DOS is $$1/(2\pi ) {\rm Im} G$$: it can be decomposed into site contributions and thus moments Q0..2 can be generated for each site and l channel, as an alternative to decomposing the eigenfunctions of the bands, as lm does. Thus it can achieve self-consistency in a manner similar to lm, but generating $$Q_{0..2,{\bf R}l}$$ by an alternate route. If the ASA hamiltionian built by lm is suitably simplified, i.e. by

+ omitting the "combined correction term" (**OPTIONS_ASA_CCOR**)
+ generating $$Q_{0..2,{\bf R}l}$$ from true power moments as the Green's function does (**HAM_QASA=0**), 

then **lmgf**{: style="color: blue"} and **lm**{: style="color: blue"} will produce nearly identical self-consistent solutions. When potential functions are parameterized to 2nd order in both **lm**{: style="color: blue"} and **lmgf**{: style="color: blue"}, and both methods are fully k converged, they should product nearly identical results. By default lm parameterizes the potential function to 3rd order; **lmgf**{: style="color: blue"} can do the same. The 3rd order parameterizations are similar in the two methods, but not identical. To verify this, try the following test:

    gf/test/test.gf co 1 2   ← Test 1 for 2nd order parameterization; test 2 for 3rd order

**lmgf**{: style="color: blue"} is a bit messier to work with (Green's functions are harder to stabilize than wave functions), and it a bit less accurate as the simplifications to lm amount to approximations. So, typically lm makes a better self-consistent potential.

But **lmgf**{: style="color: blue"} can do things **lm**{: style="color: blue"} doesn't do, e.g. calculate magnetic exchange interactions through linear response as this tutorial demonstrates. Sometimes there is a need or advantage to carrying self-consistency via **lmgf**{: style="color: blue"}, e.g. when performing CPA calculations. Unless there is good reason to do otherwise, it is better use the self-consistent potential generated by **lm**{: style="color: blue"} to calculate other properties such as the magnetic exchange parameters. We follow that strategy here.

{::nomarkdown}</div>{:/}

### _Tutorial_
_____________________________________________________________

##### _1\. Building input file_
_____________________________________________________________

Before starting working with this tutorial we advise you to read through the [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/) which explains building the imput file in more details (you can also look through the input described in a [full-potential context](https://lordcephei.github.io/buildingfpinput/)). In the present tutorial we'll focus on the part of the input specific for using with **lmgf**{: style="color: blue"}.

To get started, **copy** **doc/demos/asa-copt/init.copt**{: style="color: green"} to your working directory. Inspect the init file and you will see it contains just the minimum structural information, apart from one line supplying some information about the magnetic structure:

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show the init file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    LATTICE
             ALAT=7.1866
             PLAT=    1.000000   0.000000   0.000000
                      0.000000   1.000000   0.000000
                      0.000000   0.000000   1.000000
    SPEC ATOM=Co MMOM=0,0,2.2
    SITE
          ATOM=Pt POS=  0.0  0.0   0.0 
          ATOM=Co POS=  0.5  0.5   0.0 
          ATOM=Co POS=  0.0  0.5   0.5
          ATOM=Co POS=  0.5  0.0   0.5 

{::nomarkdown}</div>{:/}

Then **use the** **blm**{: style="color: blue"} tool (described in more details in [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/) and [full-potential tutorial](https://lordcephei.github.io/buildingfpinput/). )

~~~
blm --mag --nk=8 --asa --gf copt
~~~

**blm**{: style="color: blue"} should generate file **actrl.copt**{: style="color: green"}, which should be essentially the same as **doc/demos/asa-copt/ctrl.copt**{: style="color: green"} (commented lines might be different though). If this is not the case, something is wrong with your configuration. _At the moment if actrl looks slightly different from the one provided just move on to the next steps._{: style="color: red"}

The command-line arguments are not required, but they supply quantities **blm**{: style="color: blue"} cannot determine automatically, that you will have to supply at some point. If you supply them on the command-line they are folded into the ctrl file at the outset; or, you can edit the ctrl file after it is generated. Command-line switches **blm**{: style="color: blue"} recognizes are summarized in [Building FP input file](https://lordcephei.github.io/buildingfpinput/). 

###### _The \-\-asa switch_

This switch tailors the ctrl file for the ASA. To see how it affects the ctrl file, try running **blm**{: style="color: blue"} without **\-\-asa**{: style="color: green"}. For more details see the [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/).

###### _The \-\-mag switch_

This switch tells **blm**{: style="color: blue"} that you plan on doing a spin polarized calculation. All it does is change the preprocessor variable _nsp_ to 2. This turns on the spin polarization through **NSPIN={nsp}**.

Without any other information the spin polarized calculation will proceed with zero magnetic moment. The system needs a "push" in the initial direction to find the magnetic state. You have to supply some initial information about the magnetic structure. Since we know that the magnetization is concentrated on the Co (Pt is paramagnetic, though it has a high magnetic susceptibility), the init file supplies an initial magnetic moment on the Co site of about 2 Bohr on the Co d orbital, in the SPEC category (**SPEC ATOM=Co MMOM=0,0,2.2** in the initial file). The precise value 2.2 is not important: this quantity is determined self-consistently later. Choosing it rather large (the bulk moment is 1.8 $$\mu_B$$) gives it a strong initial push so to encourage it not revert to a (metastable) nonmagnetic state in the course of a self-consistent calculation. 

###### _The \-\-gf switch_

When **\-\-gf**{: style="color: green"} is used, **blm**{: style="color: blue"} prepares the input file for the Green's function program **lmgf**{: style="color: blue"}. This tutorial uses **lmgf**{: style="color: blue"} to calculate magnetic exchange interactions.  Adding **\-\-gf**{: style="color: green"} to the **blm**{: style="color: blue"} command line argument modifies **actrl.copt**{: style="color: green"} in two ways:

**1\. The GF category is created:**{: style="color: orange"}

~~~
% const gfmode=1 c3=t
GF      MODE={gfmode} GFOPTS={?~c3~p3;~p2;}
~~~

To see the purpose of **GF_MODE**, do:

~~~
lmgf --input
~~~

and look for **GF_MODE**. You should see:

~~~
    GF_MODE           reqd   i4       1,  1          default = 0
           0: do nothing
           1: self-consistent cycle
           10: Transverse exchange interactions J(q), MST
           11: Read J(q) from disk and print derivative properties
           ...
~~~
So, if **MODE=1**, **lmgf**{: style="color: blue"} does a self-consistent calculation, generating the _P_ and $$Q_{0..2}$$ for each _l_ channel using Green's functions rather than wave functions as **lm**{: style="color: blue"} does. 

**GFOPTS** bundles a variety of lmgf-specific options, which you supply through a sequence of strings separated by semicolons. This tag: 

~~~
GFOPTS={?~c3~p3;~p2;}
~~~

becomes **GFOPTS=p3** after parsing by the preprocessor, because _c3_ is nonzero (**see preprocessor documentation**{: style="color: red"}). 
_p3_ tells **lmgf**{: style="color: blue"} to use $$3^{rd}$$ order potential functions (somewhat more accurate than $$2^{nd}$$ order, but also prone to generating false poles not too far from the real axis).

**2\. EMESH is added to BZ:**{: style="color: orange"}

~~~
% const nz=16 ef=0
        EMESH={nz},10,-1,{ef},.5,.3  # nz-pts;contour mode;emin;emax;ecc;bunching
~~~

Green's functions are energy resolved; thus physical properties such as the charge density or magnetic exchange interactions require an integration over the energy as well as over the BZ. For both density and static exchange interactions, the integration must be taken on the real axis from below the lowest eigenstate in the system to the Fermi level $$E_F$$. Im _G_ is basically the density-of-states. It is very spikey on the real axis, and a very fine energy mesh would be required to integrate Im _G_ close to the real axis. The integration can be accomplished with vastly greater ease by deforming the contour into an elliptical path in the complex plane. A gaussian quadrature is used; typically 15 or so energy points is sufficient for a well converged result.

This contour is specified through **EMESH**. Breaking down the constituents of **EMESH** as autogenerated by **blm**{: style="color: blue"}: 

~~~
     EMESH={nz}          ←  number of energy points in the contour; {nz} evaluates 16 in this file
            10           ←  elliptical contour
            -1           ←  starting energy on the contour.  Must be deeper than the lowest state in the system (-0.776 Ry)
           {ef}          ←  Fermi level determined by charge neutrality; see below
           0.5           ←  eccentricity of the ellipse ranging from 0 (circle) to 1 (line)
           0.3           ←  bunching parameter, bunching points near Ef. 0→no bunching
~~~

We don't know what $$E_F$$ is _a priori_. In the ASA, a general reasonable guess is 0. If we perform the band calculation, see [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/), we get $$E_F$$ generated by **lm**{: style="color: blue"}: it is _−0.12927 Ry_. $$E_F$$ is fixed by charge neutrality. If **lmgf**{: style="color: blue"} generated exactly the same spectrum as **lm**{: style="color: blue"}, and the k-integration were fully converged (or at least identical in the two cases) $$E_F$$ would be the same for **lm**{: style="color: blue"} as for **lmgf**{: style="color: blue"}. However we can expect that the charge neutrality points will slightly different in the two methods.  Further we'll find $$E_F$$ using **lmgf**{: style="color: blue"}. 

If you want to practice finding $$E_F$$ using **lm**{: style="color: blue"} use the following commands (for the details see [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/)) (**We advise you to do those steps since you'll need some of them further anyway but the following lm-part contains some useful comments**{: style="color: red"}):

<div onclick="elm = document.getElementById('lm'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show/hide the lm-part.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="lm">{:/}

Invoking **blm**{: style="color: blue"} with the switches given above is sufficient to make a working input file. Normally you can **copy** **actrl.copt**{: style="color: green"} to **ctrl.copt**{: style="color: green"} as it is.

All the ASA electronic structure codes (**lm**{: style="color: blue"}, **lmgf**{: style="color: blue"}, and **lmpg**{: style="color: blue"}) use a tight-binding form of the LMTO basis, where the envelope functions are screened to make them short ranged. This information is carried through screened structure constants, which in this package are precomputed and stored using lmstr. Run this setup to make the structure constants:

     lmstr ctrl.copt                             ← Make and store structure constants

It should store **str.copt**{: style="color: green"} and **sdot.copt**{: style="color: green"} on disk. (**If not, something is wrong and you should not proceed.**)

Invoking **blm**{: style="color: blue"} with the switches given above is sufficient to make a working input file. Normally you can **copy** **actrl.copt**{: style="color: green"} to **ctrl.copt**{: style="color: green"} as it is.

As of yet we **have no starting density or potential**. You can see this immediately by trying to run the band code straight off:

    lm ctrl.copt

The program **will stop** with this message:

    LM:  Q=ATOM encountered or missing input

In usual LDA calculations, a trial density is obtained by generating densities for free atoms, and superposing them (Mattheis construction). While the ASA code could have been written to do just this, it does something different. This code takes advantage of the simplification the ASA offers, namely that the sphere density is completely determined by a small number of parameters, namely the log derivative parameters _P_ and energy moments of the charge density $$Q_{0..2}$$ for each _l_ channel. We can supply reasonable guesses through the ctrl file, or let the program pick some defaults as a first guess. Defaults are typically assigned so that $$Q_0$$ is the charge in the _l_ channel of the atom and $$Q_{1..2}$$ are taken to be zero. While this is a pretty crude guess (cruder than the Mattheis construction) usually it is good enough that the program can find its way to the proper self-consistent solution.

The ASA code can either start from "potential parameters", which gives it enough information to generate energy bands and calculate moments ($$P_l$$, $$Q_{0..2,l}$$) , or from the moments ($$P_l$$, $$Q_{0..2,l}$$)  which is sufficient for the sphere routine to fix the potential and calculated potential parameters. The band and sphere blocks of the code are thus complementary: one takes the input of the other and generates output required by the other. The cycle is described in the **LMTO-ASA documentation**{: style="color: red"}.

The ctrl file is built with the following **START** category:

    START CNTROL={nit==0} BEGMOM={nit==0}

If **BEGMOM** is nonzero, **lm**{: style="color: blue"} will start from potential parameters (which don't exist yet, in the present case).
If **BEGMOM=0** **lm**{: style="color: blue"} will start from the ($$P_l$$, $$Q_{0..2,l}$$). These haven't been given either, but **lm**{: style="color: blue"} can pick defaults for them. We get an initial potential by doing:

    lm ctrl.copt -vnit=0         ← Because -vnit=0, BEGMOM={nit} is preprocessed into BEGMOM=0
 
**lm**{: style="color: blue"} will start from (default) moments and generate a trial density for each sphere, together with potential parameters corresponding to potential generated.

The output should generate a table of potential parameters like this:

    PPAR:  Pt        nl=4  nsp=2  ves=  0.00000000
      l     e_nu          C        +/-del     1/sqrt(p)      gam         alp
      ...
      1 -0.33739987  0.66438324  0.17542338   6.2239779  0.13462479  0.13462479
      2 -0.21536757 -0.17914263  0.02841817   1.1299418  0.01358564  0.01358564
      ...
      1 -0.33739987  0.66438324  0.17542338   6.2239779  0.13462479  0.13462479
      2 -0.21536757 -0.17914263  0.02841817   1.1299418  0.01358564  0.01358564
      ...

and a similar table for Co. Particularly important are _C_, the band center of gravity _C_ and the bandwidth _del_. You can see that $$C_p$$ sits far above zero while $$C_d$$ is a little below. It tells you that the Pt _d_ orbital is important for bonding while the Pt _p_ orbital is pretty far above from the Fermi level and of much less importance. del is the bandwidth parameter; a little more detail is given in the **LMTO-ASA documentation**{: style="color: red"}. A disk file is created for each class. It contains the ($$P_l$$, $$Q_{0..2,l}$$), the potential parameters, and possibly other things. Take a look at files **co.copt**{: style="color: green"} and **pt.copt**{: style="color: green"}. You can see what defaults were chosen for ($$P_l$$, $$Q_{0..2,l}$$). 

We are now ready for a self-consistent calculation. **Doing**:

    lm ctrl.copt -vnit=30 --pr31,20                ← NIT={nit} is preprocessed into NIT=30.
                                                    --pr31,20 sets verbosity fairly low

will perform up to 30 self-consistent cycles, that is 

$$PPAR\stackrel{crystal}{\longrightarrow} (P_l, Q_{0..2,l})\stackrel{sphere}{\longrightarrow} PPAR \stackrel{crystal}{\longrightarrow} (P_l, Q_{0..2,l})\stackrel{sphere}{\longrightarrow}$$

**lm**{: style="color: blue"} will continue until the RMS change in ($$P_l$$, $$Q_{0..2,l}$$) falls below tolerance **ITER_CONVC**, or until 30 iterations is reached.

If it's converged you'll get the following phrase at the end of your output:

    Jolly good show! You converged to ...
    
In this demo convergence should be reached in 21 iterations. 

**Interpreting the output:**

The output can provide some very useful information. For example, the self-consistent Co moment is 1.8 $$\mu_B$$; Pt has a moment (induced by the neighboring Co) of 0.3 $$\mu_B$$. You can see it in the line of the following form

    ATOM=PT Z=78 Qc=68 R=2.928343 Qv=-0.008929 mom=0.35606 a=0.025 nr=481
    ATOM=Co ...

Scrolling up you can find the density-of-states at the Fermi level $$E_F$$ is **D(Ef)=72** (units of $$Ry^{−1}$$ per unit cell), or about 1.3 $$eV^{−1}/atom$$. Had the calculation been done without spin polarization, D(Ef) would be ~187, more than twice larger. This is a very large number and suggests there is a likely instability. Indeed, the system can lower its energy by spontaneously magnetizing. Consider the Stoner criterion for spontaneous magnetization, I D(EF) > 1. In 3d transition metals I is about 1 eV. Thus the Stoner criterion is easily satisfied and the system should spontaneously magnetize. In magnetizes so strongly that the Co moment (1.8 $$\mu_B$$) is larger than that for elemental Co (1.6 $$\mu_B$$). 

The same line also provides you with the Fermi energy:

    BZINTS: Fermi energy:   -0.129278; ...

{::nomarkdown}</div>{:/}


##### _2\. Making ctrl file and structure constants_
_____________________________________________________________

**If you've done the lm-part above go straight to ['The Green's function program lmgf'](https://lordcephei.github.io/lmgf-tutorial/#the-greens-function-program-lmgf)**{: style="color: red"}

Invoking **blm**{: style="color: blue"} with the switches given above is sufficient to make a working input file. Normally you can **copy** **actrl.copt**{: style="color: green"} to **ctrl.copt**{: style="color: green"} as it is.

For a fuller description of the ctrl file, see the the [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/), the [FP tutorial](https://lordcephei.github.io/lmf_tutorial/), and also [Building FP input file](https://lordcephei.github.io/buildingfpinput/). 

All the ASA electronic structure codes (**lm**{: style="color: blue"}, **lmgf**{: style="color: blue"}, and **lmpg**{: style="color: blue"}) use a tight-binding form of the LMTO basis, where the envelope functions are screened to make them short ranged. This information is carried through screened structure constants, which in this package are precomputed and stored using **lmstr**{: style="color: blue"}. Run this setup to make the structure constants (for more detailes see see the the [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/)):

     lmstr ctrl.copt                             ← Make and store structure constants

It should store **str.copt**{: style="color: green"} and **sdot.copt**{: style="color: green"} on disk. (**If not, something is wrong and you should not proceed.**)

As of yet we **have no starting density or potential**.We get an initial potential by doing:

    lm ctrl.copt -vnit=0        
    
We are now ready for a self-consistent calculation. **Do**:

    lm ctrl.copt -vnit=30 --pr31,20

##### _3\. The Green's function program lmgf_
_____________________________________________________________

###### _a) Finding $$E_F$$_

If **GF_MODE=1**, **lmgf**{: style="color: blue"} will generate the $$Q_{0..2,{\bf R}l}$$ for whatever $$E_F$$ you give it. However there is only one physically meaningful $$E_F$$ -- the one that satifies charge neutrality. The input file is constructed so you can supply $$E_F$$ through command-line argument **-vef=expr**{: style="color: green"}: the preprocessor evaluates  ef  from  expr, substitutes it for  {ef}  in the input file (**see preprocessor documentation**{: style="color: red"}). We're going to use the one obtained by running **lm**{: style="color: blue"} (see above).

The simplest way to find the charge neutrality point is to run **lmgf**{: style="color: blue"} interactively in the self-consistent mode (**GF_MODE=1**). By running **lmgf**{: style="color: blue"} interactively you can monitor convergence. **Do**: 

~~~
lmgf ctrl.copt -vnit=30 --pr31,20 --iactiv -vef=-.1293
~~~

Since we're using **\-\-iactiv** switch the code is going to stop and ask us to make some choices. At first you'll see

    QUERY: max it (def=30)?

Just hit Enter (return) to confirm. Output contains two tables the first of which looks like

    GFASA:  integrated quantities to efermi = -0.1293
        PL      D(Ef)      N(Ef)       E_band      2nd mom      Q-Z
    spin 1   11.457550   21.527384   -7.139500    2.654650    3.027384
    spin 2   79.622866   15.413290   -4.696401    1.699871   -3.086710
    total   91.080415   36.940675  -11.835901    4.354521   -0.059325
           deviation from charge neutrality: -0.059325

The non-zetro deviation from charge neutrality means that ef=-.1293 results in a slight electron deficiency. **lmgf**{: style="color: blue"} will estimate a constant shift to crystal potential to make the system neutral, and interpolate _G_ to contour adjusted by this shift using a Pade approximant.

**Note**  **lmgf**{: style="color: blue"} shifts the average crystal potential: ef  is kept fixed. 

Then **lmgf**{: style="color: blue"} prints out some results of the Pade correction in a subsequent table. 

    Corrections to integrated quantities estimated by Pade interpolation
        PL      D(Ef)      N(Ef)       E_band      2nd mom      Q-Z
    spin 1    8.853521   21.530102   -7.151426    2.654705    3.030102
    spin 2  110.784521   15.469898   -4.712034    1.700815   -3.030102
     total  119.638042   37.000000  -11.863460    4.355519   -0.000000
            deviation from charge neutrality: 0

At the prompt you should see

    QUERY: redo gf pass (def=F)?

It is asking you whether you want to accept the Pade approximant, or redo the GF calculation with the potential shift added. Let's do the latter, to see how good the estimate was.
At the prompt type 'st' and hit return twice

    QUERY: redo gf pass (def=F)?  st <RET> <RET>

After the cycle you should see

    deviation from charge neutrality: 0.015468

The Pade correction reduces the deviation from neutrality but overestimates the shift. A new estimate is made for the potential shift and the prompt reappears. You can repeat the GF cycle as many times as you like. (If you see **QUERY: modify vbar (def=...)?** just hit return) If you iterate enough you should see something like: 

    gfasa:  potential shift this iter = 0.000001.  Cumulative shift = -0.000423

The shift of this last iteration is negligible.  `Cumulative shift'  is the net shift accumulated over all the iterations. 

You can now proceed to self-consistency but we will instead use the potential generated by lm in order to make the exchange parameters. (If you do proceed to self-consistency using **lmgf**{: style="color: blue"}, note that it writes the potential shift and Fermi level to file **vshft.copt**{: style="color: green"} This shift is automatically read when **lmgf**{: style="color: blue"} is restarted. After self-consistency is reached you can either keep **vshft.copt**{: style="color: green"}, or remove the file and modify  ef  so charge neutrality is satisfied without the shift.)

At the prompt enter

    QUERY: redo gf pass (def=F)?  a <RET> 

to prevent **lmgf**{: style="color: blue"} from continuing its self-consistency cycle. The constant potential shift is just the negative the the requisite Fermi level shift to achieve charge neutrality:  ef needs to be adjsted to -0.1293−(-0.000423) = −0.128877 Ry. 

To confirm that this is the correct  ef, repeat the interactive **lmgf**{: style="color: blue"} calculation with  -vef=-0.1289. 

###### _b) Magnetic Exchange Interactions_
_____________________________________________________________

As we mentioned before **lmgf**{: style="color: blue"} requires a GF-specific category (look into the **ctrl.copt**{: style="color: green"}).

    GF  MODE=1 GFOPTS=options

Token **MODE=** controls what **lmgf**{: style="color: blue"} calculates. Options are MODE=1, MODE=10, MODE=11, MODE=26.

Look into **ctrl.copt**{: style="color: green"}. Two lines are important here:

    % const gfmode=1 c3=t
    GF      MODE={gfmode} GFOPTS={?~c3~p3;~p2;}

**MODE={gfmode}** means that you can define MODE in the command line by adding **-vgfmode=1/10/11/26**; if you don't it will be set to 1 (from **const gfmode=1**). In the previous example we used **MODE=1** now we'll need **MODE=10** that invokes a special branch computing magnetic exchange interactions using a linear response technique. 

The Heisenberg model is an empirical model that postulates a set of interacting rigid local spins. The Hamiltonian is 

$$H = − \sum_{RR'} J_{RR'} S_RS_{R'}$$

The $$J_{RR'}$$ are called "Heisenberg exchange parameters". The Heisenberg applies to a system of rigid spins undergoing small excursions about equilibrium. R and R' are any pair sites and $$J_{RR'}$$ is a kind of magnetic analog to the dynamical matrix describing small oscillations of nuclei around their equilibrium point. In a crystal with periodic boundary conditions $$J_{RR'}$$ can be Bloch transformed to read:

$$J_{RR'}(q) = \sum_T \exp(iqT) J_{R+T,R'}$$, where R and R' are now confined to sites within a unit cell.

**lmgf**{: style="color: blue"} calculates $$J_{RR'}(q)$$ from the "Lichtenstein formula." This famous expression ([J. Magn. Magn. Mater. 67, 65 (1987)](http://www.sciencedirect.com/science/article/pii/0304885387907219)), closely related the static transverse magnetic susceptibility $$\chi^{+−}$$, is derived from density functional perturbation theory. It establishes a first-principles basis for the Heisenberg model. One elegant (though approximate) feature of the ASA is that the magnetization is everywhere associated with an atomic sphere. For local moment systems, the magnetization is well confined inside a sphere; thus associated with every site R there is a well defined local moment. If sufficiently localized it rotates rigidly under the influence of an external perturbation.

 When you set **GF_MODE=10**, **lmgf**{: style="color: blue"} will generate $$J_{RR'}(q)$$, and then perform an inverse Bloch transform (by Fast Fourier Transform) to make $$J_{R+T,R'}$$ for as many lattice translation vectors T as there are k-points. 
 
 **Do**

    lmgf -vgfmode=10 ctrl.copt -vef=-.1289

Results are saved in file **jr.copt**{: style="color: green"} (see below). 

Most of the analysis is done in the next step, but already the output from **gfmode=10** contains some useful information. In the first of this pair of tables you see **J_0** and **2/3 J_0**. J_0 is the net Weiss magnetic field from the surrounding neighbors; 2/3 J_0 would be the (classical) mean-field estimate for the critical temperature $$T_c$$ if there were one atom/cell. Since the Pt moment is very small it is weakly magnetic and has little effect on $$T_c$$. In the second table (**J_0 resolved by L**) J_0 is decomposed into lm contributions. As expected, the contributions to J_0 originates almost entirely from the d states.

Now if you run **lmgf**{: style="color: blue"} with **GF_MODE=11**, it reads **jr.copt**{: style="color: green"} (which means you have to run **MODE=10** first) and does some analysis with the parameters. **Invoke** **lmgf**{: style="color: blue"} with

    lmgf -vgfmode=11 ctrl.copt -vef=-.1289

A unit cell of N sites has $$N^2$$ pairs. Thus **jr.copt**{: style="color: green"} holds a succession of $$N^2$$ tables of J, one array for each RR' pair in the unit cell. Each array has $$n_1n_2n_3$$ exchange parameters, corresponding to the lattice translation vectors that follow from the Fast Fourier Transform of a k mesh of $$n_1n_2n_3$$ points. You can find the headers for each array (headers follow a standard format this package uses) by doing, e.g.  

    grep rows jr.copt

to see:

    % rows 64 cols 8 real  rs  ib=1  jb=1
    % rows 64 cols 8 real  rs  ib=1  jb=2
     ...

ach array has 64×8 entries, for T vectors derived from 8×8×8 k-points (the 3D array is stored in a 2D format). **lmgf**{: style="color: blue"} unpacks these (**GFMODE=11**) and prints them out in a sequence of tables, e.g. this one coupling all pairs of atoms belong to sites 2 and 3 in the unit cell. Pairs are ordered by separation distance d. Interactions fall off rapidly with d, and oscillate around 0, as might be expected from RKKY theory. Then follow estimates for the critical temperature $$T_c$$. $$T_c$$ is estimated in Weiss mean-field theory, and also according to a spin-waves theory by Tyablikov (sometimes called the "RPA"). Mean-field tends to overestimate $$T_c$$; RPA tends to be a little more accurate but tends to underestimate it. From these two estimates $$T_c$$ should be around 1000K (see the **GFMODE=11** output).

Next follows an estimate for the spin wave stiffness. We need a symmetry lines file, let's copy it from **/lm/startup/**{: style="color: green"} (make sure you have the correct path there. The folder has symmetry files for different structures, e.g. **syml.fcc**{: style="color: green"}, **syml.hcp**{: style="color: green"}, etc):

    cp startup/syml.sc syml.copt

**lmgf**{: style="color: blue"} reads this file and calculates the spin wave spectrum from the Heisenberg model, along the lines specified. Results are saved in **bnds.copt**{: style="color: green"} (the energy scale is now mRy). So let's **run** **GFMODE=11** again to get it (now we have the symmetry lines file):

    lmgf -vgfmode=11 ctrl.copt -vef=-.1289

You can plot magnon spectra using the same technology you use for plotting energy bands, see [ASA-tutorial](/tutorial/asa/lm_pbte_tutorial/). If you have the **plbnds**{: style="color: blue"} and **fplot**{: style="color: blue"} packages installed **do**:

    echo 0 350 5 10 | plbnds -scl=13.6 -fplot -lbl=X,G,M,R,G bnds.copt
    fplot -f plot.plbnds

Now you have the **fplot.ps**{: style="color: green"} file with the spectra (you can rename this file to **some-name.ps**{: style="color: green"}) and use your favorite postscript reader to view it. You should see something close to what is shown in the figure:

![magnon figure](http://lordcephei.github.io/images/magnon1.png){:height="300px" width="260px"}.

Magnon energies are in meV. 

_Note:  The 8×8×8 mesh is a bit coarse. Use a finer k mesh for a smoother and more accurate magnon spectrum._ 

