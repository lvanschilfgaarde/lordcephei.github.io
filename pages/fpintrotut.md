---
layout: page-fullwidth
title: "Basic lmf (Full Potential) Tutorial"
permalink: "/lmf_tutorial/"
sidebar: "left"
header: no
---
<hr style="height:5pt; visibility:hidden;" />
# Basic introduction to full-potential program lmf 

This tutorial carries out a basic DFT calculation for silicon. The goal is to introduce you to the different file types and the basics of running the code. It is assumed that you have installed the executables and that they are in your path (see installation tutorial for more). The full tutorial starts under the heading "Main tutorial". You can get straight to the commands by clicking on the "Command summary" dropdown menu below.

<hr style="height:5pt; visibility:hidden;" />
### Command summary     
<div onclick="elm = document.getElementById('1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="1">{:/}

    $ mkdir si; cd si; cp path/init.si .     #create working directory, move into it and copy file     
    $ blm init.si --express                  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                    #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si                           #use lmfa to make basp file, atm file and to get gmax
    $ cp basp0.si basp.si                    #copy basp0 to recognised basp prefix   
    $ vi ctrl.si                             #set iterations number nit, k mesh nkabc and gmax
    $ lmf ctrl.si > out.lmfsc                #make self-consistent

{::nomarkdown}</div>{:/}

<hr style="height:5pt; visibility:hidden;" />
### Main tutorial

To get started, create a new working directory and move into it, here we will call it "si". Then copy the silicon init file "init.si" from path/. The init file is the starting point, it contains basic structural information in a format that is recognised by the code (analogous to the POSCAR file in VASP). 

    $ mkdir si 
    $ cd si
    $ cp path/init.si .

Take a look at the init file using a text editor (e.g. vi) and you will see it contains only the basic structural information. The lattice constant "ALAT" and primitive lattice vectors "PLAT" are shown in the "LATTICE" section. The "UNITS=A" specifies that the lattice constant is in Angstroms (the lattice vectors are in units of the lattice constant). The primitive lattice vectors are in row format (i.e. the first row contains the x, y and z components of the first lattice vector and so forth). In the "SITE" section, the atom type and coordinates are shown. The "X=" label specifies that the coordinates are in fractional (or direct) representation. It is also possible to use cartesian coordinates and in this case the "X=" label would be replaced by "POS=" (see additional exercises below).

    $ vi init.si

In order to run a DFT calculation, you need an input file and structural information. The blm tool takes the init file as input and creates a template input file "actrl.si" and structure file "site.si". Note that the code recognises certain prefixes as file types (such as "ctrl" for input file and "site" for structure file) and extensions as file names (which the user can specify). The additional prefix "a" in "actrl.si" is used to prevent overwriting of an existing ctrl file. Run the blm command and then copy the template file "actrl.si" to "ctrl.si", which is now recognised by the code as an input file. The "--express" switch tells blm to make a particularly simple input file, we will see more complicated examples in later tutorials.

    $ blm init.si --express
    $ cp actrl.si ctrl.si
    
The start of the blm output shows some structural and symmetry information. Further down, the "makrm0:" part gives information about creating the augmentation spheres, both silicon atoms were assigned spheres of radii 2.22 Bohr. Now open up the site file and you can see it contains the lattice constant and lattice vectors in the first line. Note that the lattice constant has been converted from Angstroms to Bohr since the code works in atomic units. The other terms in the first line are just standard settings and a full explanation can be found in the online page for the site file. The second line is a comment line and the subsequent lines contain the atomic species labels and coordinates. Note that blm writes cartesian coordinates by default (they happen to be the same as fractional coordinates in this case) and that running blm produces a new actrl and site file each time. 

    $ vi site.si

Next take a look at the input file "ctrl.si". The first few lines are just header information, then you have a number of basic parameters for a calculation. We won't talk about these values now but a full description is provided on the ctrl file page. Defaults are provided by blm for most of the variables except "gmax" and "nkabc", which are left as "NULL". The "gmax" value specifies how fine a real space mesh is used for the interstitial charge density and this depends on the basis set. The "nkabc" specifies the k mesh and has to be set manually (it depends on what system you are looking at). A 4x4x4 k mesh is sufficient for us, set this value now by simply changing "nkabc=NULL" to "nkabc=4" (4 is automatically used for each mesh dimension, you could equivlaently use "nkabc=4 4 4").  Take a look at the last line, it contains information about the different atoms in the system (here we only have silicon) and their associated augmentation spheres.

    $ vi ctrl.si

We now need a basis set and an estimate for gmax. This is done by using the lmfa tool. The lmfa program also calculates free atom wavefunctions and densities. The latter will be used later to make a trial density for the crystal calculation; the free atom wavefunctions are used to fit the basis set parameters. Note that in the all electron approach, the space is partitioned in two: an augmentation sphere part (around each atom) and an interstitial part (region between spheres). In the augmentation spheres, the basis set is composed of local atomic functions. In the interstitial regions, the basis consists of smooth-Hankel functions, characterised by their smoothing radius (RSMH) and Hankel energies (EH). The number of interstitial functions and their parameters (RSMH and EH) are defined in the basp file (the size of which is determined by parameters in the ctrl file). There are a few more subtleties to the code's basis set but we will leave further details to the theory pages and the input file pages. Run the following command: 

    $ lmfa ctrl.si
    
Again the output shows some structural information and then details about finding the free atom density, basis set fitting and estimation of gmax. Note that the Barth-Hedin exchange-correlation functional is used, as indicated by "XC:BH", this was specified by "xcfun=  2" in the ctrl file (the default). We won't go into more detail now, but a full description can be found on the lmfa page. One thing to note is the gmax value given towards the end: "GMAX=5.0". Now that we have a gmax value, open up the ctrl file and change the default NULL value to 5.0.

    $ vi ctrl.si

Check the contents of your working directory and you will find two new files "atm.si" and "basp0.si". The "atm.si" file contains the free atom densities calculated by lmfa. File basp0.si is the template basis set file; the standard basis set name is basp and the extra 0 is added to avoid overwriting. Take a look at the basp0.si file and you will see that it contains basis set parameters that define silicon's smooth Hankel functions. Changing these values would change their functional form, but lmfa does a reasonable job (also later on parameters can be automatically optimized, if desired) so we will leave them as they are. Copy basp0.si to the recognised basp.si form.

    $ cp basp0.si basp.si
    
We now have everything we need to run an all-electron, full-potential DFT calculation; this is done using the lmf program. Double check that you have specified the k mesh (nkabc) and a gmax value and then run the following command:

    $ lmf ctrl.si

The first part of the output is similar to what we've seen from the other programs. Look for the line beginning with "lmfp", it should be around 60 lines down. This line tells us about what input density is used. The lmf program first looks for a restart file "rst.si" and if it's not found it then looks for the free atom density file "atm.si". Lmf then overlaps the free atom densities to form a trial density (Mattheis construction) and this is used as the input density. Next lmf begins the first iteration of a self-consistent cycle: calculate the potential from the input density, use this potential to solve the Kohn-Sham equations and then perform Brillouin zone integration to get the output density. Towards the end of the output, the Kohn-Sham total energy is reported along with the Harris-Foulkes total energy. These two energies will be the same at self-consistency (or very close at near self-consistency). Note that the calculation stopped here after a single iteration.  This is because the number of iterations "nit" is set to 1 by default in the ctrl file. Now increase the number of iterations to something like 20 and run lmf again. A lot of text is produced so it will be easier to redirect the output to a file, here we call it out.lmfsc (the sc indicates self-consistent).

    $ vi ctrl.si
    $ lmf ctrl.si > out.lmfsc
    
Now take a look at the output file "out.lmfsc". Look for the line beginning with "iors", again around line 60, and you will see that this time the rst file was found and the density is used as the input density (the rst file was created after the single iteration). Now move to the end of the file, the "c" in front of the Harris Foulkes "ehf" and Kohn-Sham "ehk" energies indicates that convergence was reached (note how similar the ehf and ehk energies are). A few lines up you can see that it took 8 iterations to converge: "it 8 of 20". At the end of each iteration the ehf and ehk total energies are printed and a check is made for self-consistency. The two parameters conv and convc in the ctrl file specify, respectively, the self-consistency tolerances for the total energy and root mean square (RMS) change in the density. Note that by default both tolerances have to be met, to use a single tolerance you simply set the one that you don't want to zero. Further up again the converged Fermi energy and band gap values are reported in the Brillouin zone integration section (look for last occurence of "BZWTS" in the file). To see how the density and energy changes between iterations, try grepping for "DQ" and "ehk=-" 

    $ grep 'DQ' out.lmfsc
    $ grep 'ehk=-' out.lmfsc

You can also check how the bandgap changes by grepping out.lmfsc for 'gap'.

ADD BAND STRUCTURE PLOTTING!!!

And that's it! You now have a self-consistent density and have calculated some basic properties such as the band gap and total energy.  

<hr style="height:5pt; visibility:hidden;" />
### FAQ
Below is a list of frequently asked questions. Please get in contact if you have other questions.

1) How does blm determine the augmentation spheres?

Overlaps free atom densities and looks for where potential is flat. 

2) What is the log file? 

The log file "log.si" keeps a compact record of key outputs in the current directory.  In successive runs, data is appended to the log file.

3) What is the Harris-Foulkes energy?

It is a functional of the input density, rather than the output density.  At self-consistency it should be the same as the standard Kohn-Sham functional.  The Harris-Foulkes functional tends to be more stable, and like the Kohn-Sham functional, it is stationary at the self-consistent density. But it is not necessarily a minimum there. See M. Foulkes and R. Haydock, Phys. Rev. B 39, 12520 (1989).
 

<hr style="height:5pt; visibility:hidden;" />
### Additional exercises

1) Converting between fractional and cartesian coordinates

For example, try running the command "blm init.si --express --wsitex" and you will see that "xpos" has been added to the first line, this indicates that the coordinates are now in fractional form. Note that in this case the cartesian and fractional coordinates happen to be the same.

2) You can avoid editing ctrl.si by invoking blm with extra switches:

    $ blm init.si --express --gmax=5 --nk=4 --nit=20
    $ diff actrl.si ctrl.si
    
You can see that values for gmax, nkabc and nit have been set by blm.  If you modify the input file this way, be sure to copy actrl.si to ctrl.si before continuing.

3) 

