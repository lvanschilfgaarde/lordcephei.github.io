---
layout: page-fullwidth
title: "ASA Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/asa-doc/"
header: no
---
_____________________________________________________________

### _Purpose_
{:.no_toc}
In this Tutorial the basics of creating an input file and running a full self consistent LDA atomic speherical approximation (ASA) will be covered.


### _Preliminaries_
_____________________________________________________________
For this tutorial the **blm**{: style="color: blue"},**lmchk**{: style="color: blue"}, **lmstr**{: style="color: blue"} and **lm**{: style="color: blue"} executibles are required and are assumed to be in your PATH; the source code for all Questaal exectuables can be found here[here](https://bitbucket.org/lmto/lm).

### _Tutorial_
_____________________________________________________________
This tutotiral will consist of three main sections:

1. Building a suitible input file for an ASA-LDA calculation
2. Running a self consistent calculaion
3. A breif break down of the output.

A detailed theoretical discription of the methods used with in the ASA calculation will not be provided here.

##### _1\.Building input file_
For the purposes of demonstration we will use PbTe in this tutorial. Under normal pressure/conditions PbTe crystalises in the rocksalt structure with lattice constant 6.428\angstrom. The first step in building an input file is the init.ext (ext is can be replace with any other indicator,pbte in this case) file, which will contain all the structual information about the system of interest. for PbTe we can use:
    
    LATTICE
	    ALAT=6.427916  UNITS=A
            PLAT=    0.0000000    0.5000000    0.5000000
                     0.5000000    0.0000000    0.5000000
                     0.5000000    0.5000000    0.0000000
    SITE
	    ATOM=Pb   X=     0.0000000    0.0000000    0.0000000
      	    ATOM=Te   X=     0.5000000    0.5000000    0.5000000

The init file shown here can be splitt in to two section: lattice and site. The Lattice section will include information regarding the lattice structure such as lattice constant (ALAT=) and it's units (UNITS=, \angstrom in this case) plus the primitive lattice constants (PLAT=). The site section of the init file includes the basis information, in the case of PbTe this is simply two one Pb one Te at the postion indicated by "X=" (X= indicates frocational formalism while POS= is used for cartesian  coordinate formalisim).

Now that the init.pbte file has been created the input file (also refered to as the control file) can be generated easily through

    blm --express=0 --asa --addes --wsitex init.pbte

This command will generate log.pbte,site.pbte and actrl.pbte, for this tutorial we will only discuss the two latter files which contain information about the location of the atoms and options for LDA-ASA calculations.
The **blm**{: style="color: blue"} executable which is used to generate the initial control file was invoked using three commandline tags, the first of which is regarding the  brevity of the control file and takes values 0-7, it is worth experimenting with this switch to find which style of control file you are most confortable with. Using the "--asa" tag the control file generated is modified to suit an ASA calculation. The last tag "--wsitex" simply creates the site.pbte file in the fractional formalism.

For ASA caculation the sume of the potential sphere volumes has to match the unit cell volume, for this task  **lmchk**{: style="color: blue"} can be invoked by:

    lmchk ctrl.pbte

the full output can be viewed by clicking here, however the important information regarding the overlap is towards jthe end of the stdout and in this particular case it can be seen in one line
    
    Cell volume= 448.07190   Sum of sphere volumes= 301.06511 (0.67191)

here the cell volume, summ of all potential volumes and their ratio are presented, the later of which has to equal to 1 for a ASA calculation. Another important value is the overlap percentage, which in this cas is given by

      OVMIN, 38 pairs:  fovl = 4.24366e-7   <ovlp> = 8.7%   max ovlp = 8.7%

This line tells us about the average and maximu sphere overlaps, generally for ASA the average should be kept are 10\% while for full qsGW calculation it should be below 4\%. As the sphere overlap is not equal to unity in this case we have to add empty sphere to meet this requirment. Empty spheres are can be thought of as essentially atoms with zero atomic number.
The appropiate space filling spheres can be found using **lmchk**{: style="color: blue"} by invoking:

    lmchk --findes --wsitex ctrl.pbte

here we have used two command-line switches, the first is to invoke the procedure to finde the empty spheres and the second is to write the information into a new site file called "essite.pbte". At the end of  the stdout of the command above you will see the following message:
     
     ... Final sphere sizes and packing fraction (2 new spheres)

     SCLWSR:  mode = 30  vol = 448.072 a.u.   Initial sphere packing = 81.3%  scaled to 100%
     constr omax1=  16.0  18.0  20.0 %    omax2=  40.0 100.0 100.0 %
     actual omax1=   8.7  12.1   0.0 %    omax2=  16.0  24.6   0.0 %

     spec  name        old rmax    new rmax     ratio
     	1   Pb          3.300000    3.300000    1.000000
        2   Te          3.300000    3.300000    1.000000
   	3   E           1.959808    2.598601    1.325947

which indicates two new empty spheres have been found and are that the new sphere packing is 100\%. The control file has to be changed to reflect the new basis. first change

      NBAS=2+{les?0:0}  NL=4  NSPEC=2+{les?0:0}

to
	
      NBAS=2+{les?2:0}  NL=4  NSPEC=2+{les?1:0}

these two simple logic statments, first one can be interpreted as  "if les>0 then  NBAS=4 else if les<0 then NBAS=2" and the second "if les>0 NSPEC=3 else if les<0 then NSPEC=2", here "les" is a variable which we have defined with in the control file through the following line

      % const nit=10 les=1

here we have also defined nit with value of 10. Next step is to pass the information about the empty sphere sites to the control file, we do this by commenting all instances of "FILE=site" and uncommenting all "FILE=essite" as the new essite.pbte has the new appropiate information, the last stp is to copy the new species information from the poses.pbte file to the SPEC category within the control file (including the new empty spheres).

Before a  self consistant calculation can be preforem the real-space structure constants have to be generated through:

       lmstr ctrl.pbte

the penultimate step is to generate the initial the multiple moments Q$_0$,Q$_1$,Q$_2$, for this we first change the nkabc variable within the control file to for (nkabc=4, this variable represents the k-mesh density)next  the  **lm**{: style="color: blue"} executable is invoked with zero number of iterations such that

    lm -vnit=0 ctrl.pbte

and lastly for a fully consistant LDA-ASA calculation **lm**{: style="color: blue"} is invoked with -vnit>1 so that

    lm -vnite=20 ctrl.pbte

the message at the end of the standard out put will indicate if selfconsistency has been achieved which in this case it has.
	    
