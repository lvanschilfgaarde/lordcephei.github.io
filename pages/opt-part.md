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
This tutorial follows from the [self-consistent](http://lordcephei.github.io/asa-doc/) and [optics]() tutorial preformed on PbTe, it is highly recomended that you go through those before this tutorial, for this tutorials the **lm**{: style="color: blue"} or  **lmf**{: style="color: blue"} are needed.

### _Individual band to band contribution _

Will be comming soon, sorry.

### _Resolving by k-points_
In both the **lm**{: style="color: blue"} and **lmf**{: style="color: blue"} implementations of the code it is possible to separate the contribution to the optical properites by individual k-points, this calculation can be done by simply adding **PART=2** to the optics category, however few additional steps are needed to interpret the out put. Lets start by running an optics calculation for PbTe with the following setup in the control file:

  OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 ESCISS=0 LTET=3
          PART=2

we can preform this calculation just as any other optics calculation, simply invoke:

  lm pbte -voptmod=1 -vnit=1

through this the program will write a new file name popt.pbte. The format of this file is different to opt.ext or jdos.ext which you have prebiously encountered; here the first number in each row represtnts the energy while the next 3*i numbers are the contributions from i ireducible k-points for the three orientation of the electric field. For the porpuses of demonstration and clarificationlets preform the calculation above for restricted number of bands so that the **OPTICS** category in the control file reads:
  
  OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 ESCISS=0 LTET=3
          PART=2 FILBND=9,10 EMPBND=11,12
          
In this way the optical contibution is restricted to the top two valence and bottom two conduction bands. Rerunning

  lm pbte -voptmod=1 -vnit=1
  
now produces a popt.pbte file with significantly reduced information (this is done for the porpuses of demonstration). the first row of the popt file is shown below:


### _Resolving by k-points and band to band contributions_

Will be comming soon, sorry.
