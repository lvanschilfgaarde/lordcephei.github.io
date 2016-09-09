---
layout: page-fullwidth
title: "Resolving optical calculations"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/opt-part/"
header: no
---

### _Purpose_
{:.no_toc}
This tutorial is designed to describe the procedure and output of **OPTICS_PART=1**,**OPTICS_PART=2** and **OPTICS_PART=3**. 

### _Prerequsites_
This tutorial follows from the [self-consistent](http://lordcephei.github.io/asa-doc/) and [optics](http://lordcephei.github.io/docs-equ-optics/) tutorial preformed on PbTe, it is highly recomended that you go through those before this tutorial, for this tutorials the **lm**{: style="color: blue"} or  **lmf**{: style="color: blue"} are needed.

### _Individual band to band contribution _

Will be comming soon, sorry.

### _Resolving by k-points_
In both the **lm**{: style="color: blue"} and **lmf**{: style="color: blue"} implementations of the code it is possible to separate the contribution to the optical properites by individual k-points, this calculation can be done by simply adding **PART=2** to the optics category, however few additional steps are needed to interpret the output. Lets start by running an optics calculation for PbTe with the following setup in the control file:

  OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 ESCISS=0 LTET=3
          PART=2

we can preform this calculation just as any other optics calculation, simply invoke:

  lm pbte -voptmod=1 -vnit=1

through this the program will write a new file name popt.pbte. The format of this file is different to opt.pbte or jdos.pbte which you have previously encountered; here the first number in each row represtnts the energy while the next 3X numbers are the contributions from X ireducible k-points for the three orientation of the electric field. Below you can see a section of the popt.pbte for 4X4X4 k-mesh:

    0.400000     0.000000     0.514493     0.754321     0.391577     0.955750     1.069400
                 0.564346     0.374508     0.000000     0.514493     0.754321     0.391577
                 0.955750     1.069400     0.564346     0.374508     0.000000     0.514493
                 0.754321     0.391577     0.955750     1.069400     0.564346     0.374508


In the excerpt  above the first value 0.400000 is the energy in Rydbergs, the next 8 numbers correspond to the 8 irreducible k-points and the electric field orientated along x, while the next 8 correspond to electric field orientated along y followed by the z counterpart.
To identify the order of the k points it is necessery to invoke the lm program with an additional command line switch:

   lm pbte -voptmod=0 -vnit=1 --pr81
   
here the switch "- -pr81"  increases the verbosity setting of the program to print out the required information. With such high verbosity setting a large amount of data is printed, however we are looking for the brillouin zone q-point mapping shown, a complete list of reducible k-points is also provided in this output.

<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to see brillouin zone q-point mapping output.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

 BZMESH: qp mapping
 i1..i3                         qp                    iq   ig  g
 (1,1,1)           0.000000    0.000000    0.000000     1    1 i*i
 (2,1,1)          -0.250000    0.250000    0.250000     2    1 i*i
 (4,1,1)           0.250000   -0.250000   -0.250000     2    2 i
 (1,2,1)           0.250000   -0.250000    0.250000     2    3 r3(1,1,-1)
 (1,4,1)          -0.250000    0.250000   -0.250000     2    4 i*r3(1,1,-1)
 (4,4,4)          -0.250000   -0.250000   -0.250000     2    5 r3(-1,-1,1)
 (2,2,2)           0.250000    0.250000    0.250000     2    6 i*r3(-1,-1,1)
 (1,1,2)           0.250000    0.250000   -0.250000     2    9 r3(-1,-1,-1)
 (1,1,4)          -0.250000   -0.250000    0.250000     2   10 i*r3(-1,-1,-1)
 (3,1,1)          -0.500000    0.500000    0.500000     3    1 i*i
 (1,3,1)           0.500000   -0.500000    0.500000     3    3 r3(1,1,-1)
 (3,3,3)          -0.500000   -0.500000   -0.500000     3    5 r3(-1,-1,1)
 (1,1,3)           0.500000    0.500000   -0.500000     3    9 r3(-1,-1,-1)
 (2,2,1)           0.000000    0.000000    0.500000     4    1 i*i
 (4,4,1)           0.000000    0.000000   -0.500000     4    2 i
 (4,1,4)           0.000000   -0.500000    0.000000     4    3 r3(1,1,-1)
 (2,1,2)           0.000000    0.500000    0.000000     4    4 i*r3(1,1,-1)
 (1,4,4)          -0.500000    0.000000    0.000000     4    5 r3(-1,-1,1)
 (1,2,2)           0.500000    0.000000    0.000000     4    6 i*r3(-1,-1,1)
 (3,2,1)          -0.250000    0.250000    0.750000     5    1 i*i
 (3,4,1)           0.250000   -0.250000   -0.750000     5    2 i
 (4,2,4)           0.250000   -0.750000    0.250000     5    3 r3(1,1,-1)
 (2,4,2)          -0.250000    0.750000   -0.250000     5    4 i*r3(1,1,-1)
 (4,3,3)          -0.750000   -0.250000   -0.250000     5    5 r3(-1,-1,1)
 (2,3,3)           0.750000    0.250000    0.250000     5    6 i*r3(-1,-1,1)
 (1,3,2)           0.750000   -0.250000    0.250000     5    7 r3d
 (1,3,4)          -0.750000    0.250000   -0.250000     5    8 i*r3d
 (2,1,3)           0.250000    0.750000   -0.250000     5    9 r3(-1,-1,-1)
 (4,1,3)          -0.250000   -0.750000    0.250000     5   10 i*r3(-1,-1,-1)
 (3,3,4)          -0.250000   -0.250000   -0.750000     5   11 r2x
 (3,3,2)           0.250000    0.250000    0.750000     5   12 mx
 (2,4,4)          -0.750000    0.250000    0.250000     5   17 r3(1,-1,-1)
 (4,2,2)           0.750000   -0.250000   -0.250000     5   18 i*r3(1,-1,-1)
 (3,1,2)          -0.250000    0.750000    0.250000     5   19 r3(-1,1,1)
 (3,1,4)           0.250000   -0.750000   -0.250000     5   20 i*r3(-1,1,1)
 (1,4,3)          -0.750000   -0.250000    0.250000     5   23 r2(1,0,-1)
 (1,2,3)           0.750000    0.250000   -0.250000     5   24 m(1,0,-1)
 (4,4,2)           0.250000    0.250000   -0.750000     5   25 r2y
 (2,2,4)          -0.250000   -0.250000    0.750000     5   26 my
 (2,3,1)           0.250000   -0.250000    0.750000     5   33 r2z
 (4,3,1)          -0.250000    0.250000   -0.750000     5   34 mz
 (3,4,3)          -0.250000   -0.750000   -0.250000     5   41 r3(1,-1,1)
 (3,2,3)           0.250000    0.750000    0.250000     5   42 i*r3(1,-1,1)
 (4,2,1)          -0.500000    0.500000    1.000000     6    1 i*i
 (2,4,1)           0.500000   -0.500000   -1.000000     6    2 i
 (4,3,4)           0.500000   -1.000000    0.500000     6    3 r3(1,1,-1)
 (2,3,2)          -0.500000    1.000000   -0.500000     6    4 i*r3(1,1,-1)
 (3,2,2)          -1.000000   -0.500000   -0.500000     6    5 r3(-1,-1,1)
 (3,4,4)           1.000000    0.500000    0.500000     6    6 i*r3(-1,-1,1)
 (1,4,2)           1.000000   -0.500000    0.500000     6    7 r3d
 (1,2,4)          -1.000000    0.500000   -0.500000     6    8 i*r3d
 (2,1,4)           0.500000    1.000000   -0.500000     6    9 r3(-1,-1,-1)
 (4,1,2)          -0.500000   -1.000000    0.500000     6   10 i*r3(-1,-1,-1)
 (2,2,3)          -0.500000   -0.500000   -1.000000     6   11 r2x
 (4,4,3)           0.500000    0.500000    1.000000     6   12 mx
 (3,3,1)           0.000000    0.000000    1.000000     7    1 i*i
 (3,1,3)           0.000000   -1.000000    0.000000     7    3 r3(1,1,-1)
 (1,3,3)          -1.000000    0.000000    0.000000     7    5 r3(-1,-1,1)
 (4,3,2)           0.000000    0.500000    1.000000     8    1 i*i
 (2,3,4)           0.000000   -0.500000   -1.000000     8    2 i
 (3,2,4)           0.500000   -1.000000    0.000000     8    3 r3(1,1,-1)
 (3,4,2)          -0.500000    1.000000    0.000000     8    4 i*r3(1,1,-1)
 (4,2,3)          -1.000000    0.000000   -0.500000     8    5 r3(-1,-1,1)
 (2,4,3)           1.000000    0.000000    0.500000     8    6 i*r3(-1,-1,1)

{::nomarkdown}</div>{:/}


### _Resolving by k-points and band to band contributions_

Will be comming soon, sorry.
