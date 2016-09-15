---
layout: page-fullwidth
title: "LM Suite - Zeeman Field Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/misc/extbfield/"
header: no
---

# **Adding external Zeeman field to potential (v7.03)**  
________________________________________  

Note: this page has not been carefully worked out, especially the description of the Stoner parameter may not be accurate.

You can add to the crystal potential an external magnetic field inside each augemetation sphere, in the ASA program **lm** and full-potential program **lmf**. Use token BFIELD to tell **lm** or **lmf** that a field is to be read. The calculation must be spin polarized, e.g.

    HAM    NSPIN=2 BFIELD=2
    ...


*BFIELD=1*{: style="color: green"} allows the field to point in any direction; *BFIELD=2*{: style="color: green"} restricts the field to the _z_ axis. The former case generates a noncollinear hamiltonian; the latter is spin diagonal. (The hamiltonian may also be noncollinear for another reason, e.g. spin-orbit coupling is turned on.)   
Caution: **lmf** does not as yet generate noncollinear output densities. Self-consistent calculations with noncollinear **B** fields are not possible; also the total energy is not trustworthy if **B** is not along the _z_ axis.   

By selecting BFIELD nonzero, you are telling **lm** or **lmf** that a (site-dependent) Zeeman field is to be added. In this case you must also supply a site-dependent external field, which you do through the additional file bfield.ext. If this file is omitted, the program will not execute. bfield.ext contains one row for each site; each row contains three numbers corresponding to _x_,_y_,_z_ components of **B**. (The file must always contain three components _B<sub>x</sub>._ _B<sub>y</sub>_ _B<sub>z</sub>_ even if *BFIELD=2*{: style="color: green"}.)   
The GdN test case (part of the test suite) is an instructive example. In the top-level directory, run this test:

    fp/test/test.fp gdn


This test combines the LDA+_U_ hamiltonian with spin-orbit coupling. Bands are calculated for that case; then a magnetic field of 0.25 eV=0.037/2 Ry is added to the Gd site and the bands are recalculated. GdN has two atoms and file *bfield.gdn*{: style="color: blue"} reads:

    0 0 .037/2
    0 0 0


The test generates files *bnds.bfield.gdn*{: style="color: blue"} and *bnds.nobfield.gdn*{: style="color: blue"} To analyze the bands you need to use a graphics package. If you have the FPLOT packaged installed, you can draw the picture shown below comparing the two cases, by invoking the following commands after running the test:

    echo -8,8,5,10 | plbnds -fplot -ef=0 -scl=13.6 -lbl=L,G,X,W,G -dat=blue bnds.nobfield.gdn
    echo -8,8,5,10 | plbnds -fplot -ef=0 -scl=13.6 -lbl=L,G,X,W,G -dat=dat  bnds.bfield.gdn
    mv plot.plbnds plot.plbnds~
    echo "% char0 colr=3,bold=4,clip=1,col=1,.2,.3" >>plot.plbnds
    echo "% char0 colb=2,bold=2,clip=1,col=.2,.3,1" >>plot.plbnds
    awk '{if ($1 == "-colsy") {sub("-qr","-lt {colr} -qr");print;sub("dat","blue");sub("colr","colb");print} else {print}}' plot.plbnds~ >>plot.plbnds
    fplot -disp -f plot.plbnds


**[Click here for image](http://lordcephei.github.io/images/graph1.png)**

In the figure, blue bands are LDA+_U_ results. Because spin-orbit coupling is included both minority and majority spin bands appear. You can see majority Gd _f_ states near -6.5 eV, and minority _f_ states near +5.5 eV. Gd _d_ states are spin-split by the exchange-correlation field originating from spin splitting of the Gd _f_ states; majority and minority _d_ states are found near 2.5 eV and 3.5 eV, respectively, at the Γ point.

Red bands use the same potential as the LDA+_U_ case, except that a _B<sub>z</sub>_ field of magnitude 0.5 eV was added to the Gd site. _B<sub>z</sub>_ causes the the following shifts:

*   The majority _f_ shifts _down_ by ~0.22 eV, and the minority _f_ states shift _up_ by ~0.27 eV. States that are purely atomic like and are little affected by the kinetic energy will be shifted by the Zeeman field, ±_B_/2. This is the case for Gd _f_ orbitals.
*   The majority _d_ states at Γ shift _down_ by ~0.16 eV; the minority _d_ states shift _up_ by ~0.20 eV.
*   The As _p_ states, in the (-4,0) eV range, are only slightly shifted.

### _Longitudinal susceptibility_   
____________________________________  

The magnetic susceptibility is the system's magnetic response to an external magnetic field:  

$$ \delta M = \chi \delta B $$  

or  

$$ \delta B = \chi ^{- 1} \delta M $$  


δM itself can be obtained from a derivative of the total energy:  

$$ \delta M = {\delta E\over \delta B} \delta B $$  


Thus  

$$ \chi = { \delta ^ 2 E\over  \delta B ^ 2 } $$  

and  

$$ \chi ^ {-1} = { \delta ^ 2 E\over \delta M ^ 2 } $$  


In linear response theory, χ<sup>-1</sup> can be written as a sum of a noninteracting part and an interacting part

$$ \chi ^ {-1} = \chi _ {0} ^ {-1} - I $$


The kernel _I_ is often associated with the "Stoner parameter." It is typically about 1 eV in 3_d_ transition metals.   
The noninteracting part χ<sub>0</sub><sup>-1</sup> is connected with the induced magnetization of the noninteracting system, i.e.

$$ \delta B = \chi _ {0} ^ {-1} \delta M _ {0} $$    


where δM<sub>0</sub> is the magnetization induced by δB without taking into account the internal potential shifts that δ_M_ cause. In the density-functional context, δM<sub>0</sub> can be obtained from an initially self-consistent potential _V_0, which is generated in the absence of an external field. δM<sub>0</sub> is then the change in _M_ for the potential _V_0+δB. In practice this is obtained by evaluating the change in _M_ from the change in output density of a 1-shot calculation with potential _V_0+δB.   

You can use **lmf** to apply a field and calculate _E_LDA and δ_M_ as a function of B. By comparing self-consistent and 1-shot calculations you can in principle also obtain _I_. The example below does this in an approximate way for Fe, using input file fp/test/ctrl.felz. Note: a proper calculation of _I_ would require a supercell large enough that the interactions between external _B_-fields would be sufficiently small. (_I_ is a local function of **r** in density functional theory; thus _I_ is a site-diagonal matrix.) Here we only consider a single atom cell. The interactions are not small, and _I_ is underestimated.   
The results below were generated by this command:

    lmf -vnk=16 --pr31 -vrel=1 -vnit=50 -vso=0 --rs=1 -vbeta=.3 -vbf=2 -vbz=$bz -vconv=1d-6 -vconvc=1d-6 felz


bz must be set as a shell variable.   

Magnetization and total energy (relative to the B=0 case) were generated for several values of B, and ∂E/∂B was obtained from numerical differentiation of _E_.  

**[Click here for image](http://lordcephei.github.io/images/graph2.png)**

As the top figure shows, the total energy _E_ has a minimum near, but not exactly at B=0\. This shows that there are some slight errors in the LDA calculation (in an exact self-consistent LDA calculation _E_ should be minimum at exactly B=0).   
_E_ is smooth in the interval (−0.01, 0.01) Ry, as the figure shows. The behavior is somewhat unsmooth near B=−0.01 Ry, and its discontinuity or near discontinuity is evident near B=0.01 Ry. That means numerical differentiation ∂E/∂B is a bit problematic, particularly outside the (−0.01,0.01) interval. Nevertheless we can perform it. In the bottom figure, _M_−_M_(B=0) and ∂E/∂B are plotted respectively as a function of B as dashed lines+circles, and a solid line. The two curves track fairly well, though ∂E/∂B is noisy; nor is _M_(B) particularly smooth.   

We can obtain χ from the slope ∂_E_/∂B. There is some uncertainty in the calculation since _M_ is not particularly smooth (note in particular that (∂E/∂B)<sub>+</sub> and (∂E/∂B)<sub>−</sub> are a little different).   

We can also obtain both χ<sub>0</sub> by obtaining δM<sub>0</sub> from a 1-shot calculation. The table below shows M<sub>0</sub> and _M_ for two values of B:  


|    B      |        M<sub>0</sub>        |         _M_      |
|:---------:|:---------------------------:|:----------------:|
| -0.005    |     -2.363587               |      -2.402973   |
|  0.005    |     -2.234213               |      -2.219662   |



Thus we get:  

$$ \chi _ {0} ^ {−1} = {0.01\over −2.234213−−2.363587} = 0.0773 Ry \Rightarrow \chi _ {0} = 12.9 Ry ^ {−1}  = 0.95 eV. $$
$$ \chi ^ {−1} = {0.01 \over −2.219662−−2.402973} = 0.0546 Ry \Rightarrow \chi = 18.3 Ry ^ {−1} = 1.35 eV. $$
$$ I = \chi _ {0} ^ {−1} − \chi ^ {−1} = 0.0227 Ry = 0.30 eV $$


As noted above, _I_ calculated in this way only approximately corresponds to the Stoner _I_. A better calculation should produce _I_ about 1 eV.
