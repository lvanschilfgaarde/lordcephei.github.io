---
layout: page-fullwidth
title: "LM Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/lmtut/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />
# Basic introduction to full-potential program lmf 

This tutorial carries out a basic DFT calculation for silicon. The goal is to introduce you to the different file types and the basics of running the code. It is assumed that you have installed the executables and that they are in your path (see installing tutorial for more). The starting point is a structure file called "init.si". The init file contains basic structural information in a format that is recognised by the Questaal program (it is analogous to the POSCAR file in VASP). 

<hr style="height:5pt; visibility:hidden;" />
### Command summary     

    $mkdir si       
    $cd si
    $cp path/init.si .
    $blm init.si --express    #create actrl and site files
    $cp actrl.si ctrl.si      #copy actrl to recognised ctrl prefix
    $lmfa ctrl.si             #make basp file, atm file and gmax value
    $vi ctrl.si               #set k mesh and gmax values in ctrl file
    $cp basp0.si basp.si      #copy basp0 to recognised basp prefix
    $lmf ctrl.si              #run single iteration
    $vi ctrl.si               #set nit to 20
    $lmf ctrl.si > out.lmfsc  #make self-consistent

<hr style="height:5pt; visibility:hidden;" />
### Tutorial summary
Brief summary of overall tutorial, to be used as recap or for very quick and basic tutorial. 

<hr style="height:5pt; visibility:hidden;" />
### Main tutorial

To get started, create a new working directory, called "si" for example, and move into it. Then copy the silicon init file "init.si" from path/ into your working directory.

    $mkdir si       #test
    $cd si
    $cp path/init.si 

Take a look at the init file using a text editor (e.g. vi) and you will see it contains only the basic structural information. The first part is the "LATTICE" section which provides the lattice constant and primitive lattice vectors. The lattice constant is displayed after the "ALAT" label and "UNITS=A" specficies that the lattice constant is in Angstroms. The primitive lattice vectors are shown after the "PLAT" variable and are in row format (i.e. the first row contains the x, y and z components of the first lattice vector and so forth). Note that the lattice vectors are given in multiples of the lattice constant. In the "SITE" section, the atom type and coordinates are shown. The "X=" label specifices that the coordinates are in fractional (or direct) representation. It is also possible to use cartesian coordinates and in this case the "X=" label would be replaced by "POS=" (an equivalent structure in cartesian format can be found at /path/).

In order to run a DFT calculation, you need an input file and structural information. The blm tool takes the init file as input and creates a template input file "actrl.si" and structure file "site.si". Note that the code recognises certain prefixes as file types (such as "ctrl" for input file and "site" for structure file) and extensions as file names (which the user can specify). The additional prefix "a" in "actrl.si" is used to prevent overwriting of an existing ctrl file. Run the blm command and then copy the template file "actrl.si" to "ctrl.si", which is now recognised by the code as an input file.

    $blm init.si --express
    $cp actrl.si ctrl.si
    
The "--express" switch tells blm to make a particularly simple input file, we will look at more complicated examples in later tutorials. The site file contains the structural information and is similar to the init file except that it has a slightly different format and some extra terms. Open up the site file and you can see it contains the lattice constant and lattice vectors in the first line. The lattice constant has been converted from Angstrom to Bohr (by multiplying by 1.8897), this is necessary as the code works in atomic units. The other terms in the first line are just standard settings and a full explanation can be found on the site file page. The second line is simply a commented line and the following lines contain the atomic species labels and coordinates. Note that blm writes cartesian coordinates by default (they happen to be the same as fractional coordinates in this case) but you can also use fractional coordinates by including the --wsitex switch. For example, try running the command "blm init.si --express --wsitex" and you will see that "xpos" has been added to the first line, this indicates that the coordinates are now in fractional form. Note that running blm produces a new actrl and site file each time. A log file "log.si" is also produced which keeps a record of what has been run.

Next take a look at the template input file "actrl.si". The first few lines are just header information, then you have a number of basic parameters for a calculation. We won't go into all these values now but a full description is provided on the ctrl file page. Defaults are provided by blm for most of the variables except "gmax" and "nkabc", left as "NULL". The "gmax" value specifies how fine a mesh is used for the interstitial charge density and this depends on the basis set, we will set this value later. The "nkabc" specifies the k mesh and has to be set manually. This will depend on the system of interest, here we are looking at a simple sp semiconductor and the charge density should be well converged with a 4x4x4 mesh. You can either specify three numbers such as "4 4 4" or if you specify just the one number then it is used for each dimension of the mesh. The last line contains information about the different atoms in the system (here we only have silicon) and their associated augmentation spheres.

The next step is to generate a basis set, free atom densities and an estimate for "gmax". This is all done by using the lmfa tool. The lmfa program calculates free atom densities that will be used later on to produce a guess density by the full-potential program lmf. It also calculates the wavefunctions for free atoms and uses these to fit the basis set parameters. The size of the basis set is specified in the ctrl file (here using the default settings) and lmfa then determines values for the smoothing radii (RSMH) and hankel energies (EH) that are needed to define the interstitial functions (smooth Hankel functions). Note that the all electron basis is split into two parts: it has an augmentation sphere part (around each atom) and an interstitial part (region between atoms). The augmentation sphere basis consists only of atomic functions and the number considered (basis set size) is defined in the ctrl file. The interstitial basis consists of smooth hankel functions and the number of these functions and their parameters (RSMH and EH) are defined in the basp file. Lastly, lmfa provides an estimate for "gmax" based on how fine a mesh is needed to accurately represent the basis functions. More details can be found in the theory pages and the ctrl, basp and lmfa pages. Run the following command:

    $lmfa ctrl.si
    
The lmfa output gives the details about finding the free atom density, basis set fitting and determing gmax. We will ignore this for now but a full description can be found on the lmfa page. One thing to note is the gmax value given towards the end: "GMAX=5.0". Open up the ctrl file with your text editor and add in this value instead of the default NULL value.

    $vi ctrl.si

Check the contents of your working directory and you will find two new files "atm.si" and "basp0.si". The "atm.si" file is the free atom density calculated by lmfa. The basp0.si is the template basis set file, the standard basis set name is basp and the extra 0 is added to avoid overwriting. Take a look at the basp0.si file and you will see that it contains basis set parameters that define silicon's smooth hankel functions. Changing these values would change their functional form, but lmfa does a very good job so we will leave them as they are. You need to copy basp0.si to recognised basp.si form.

    $cp basp0.si basp.si
    
We now have everything that we need to run an all-electron, full-potential DFT calculation; this is done using the lmf program. Double check that you have speficied the k mesh (after nkabc) and a gmax value and then run the following command:

    $vi ctrl.si
    $lmf ctrl.si > out.lmfsc
    
Now take a look at the output file "out.lmfsc". Look for the line beginning with "iors", again around line 60, and you will see that the guess density was read from the restart file "rst.si". The rst file was created after the single iteration. Now move to the end of the file, the "it 8 of 20" indicates that the calculation converged after 8 iterations. At the end of each iteration the total energies (KS and HF) are printed and a check is made for self-consistency. Two parameters conv and convc were given in the ctrl file and these specify the self-consistency tolerances for the total energy and root mean square (RMS) change in the density. The change in the density can be tracked by grepping the output for 'DQ' and the change in the energy can be tracked by grepping for 'ehk=-'.

And that's it! You now have a self-consistent density and looked at some basic properties such as the band gap and total energy.  

<hr style="height:5pt; visibility:hidden;" />
### Additional exercises

Note that the silicon band gap was...
