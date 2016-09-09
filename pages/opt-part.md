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



### _Resolving by k-points and band to band contributions_

Will be comming soon, sorry.
