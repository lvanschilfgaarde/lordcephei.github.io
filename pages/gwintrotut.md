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
# Introduction to a QSGW calculation

Notes: add annotated GW output file with explanation of steps

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a quasi-particle self-consistent GW (QSGW) calculation. An example of the 1-shot GW code is provided in a separate tutorial. Click on the 'QSGW' dropdown menu below for a brief description of the QSGW scheme. A complete summary of the commands used throughout is provided in the 'Commands' dropdown menu. Theory notes for GW and QSGW can be found here (add link).  

<hr style="height:5pt; visibility:hidden;" />
### QSGW summary
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius"> QSGW - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}
Each iteration of a QSGW calculation has two main parts: a DFT calculation for input parameters and a GW calculation to obtain a self-energy. The full-potential code (lmf script) carries out the DFT calculation, while the GW code (lmgw) calculates the self-energy. When iterating to self-consistency, there is movement between the DFT and GW parts and this is handled by the script lmgwsc.  
In short, a QSGW calculation consists of the following steps. The starting point is a self-consistent DFT calculation (usually LDA). The DFT eigenfunctions and eigenvalues are then used by the GW code to construct a self-energy. In the next iteration, the self-energy replaces the DFT exchange-correlation functional in the hamiltonian and a self-consistent DFT calculation is carried out to obtain new eigenfunctions and eigenvalues. In turn, these are then used to construct a new self-energy. This process is repeated until the change in the root mean square between the old and the new self-energy is below a certain tolerance value. The final self-energy is an effective exchange-correlation functional, tailored to the system, that can be conveniently used within the standard DFT setup to calculate properties such as the band structure.   

{::nomarkdown}</div>{:/}

<hr style="height:5pt; visibility:hidden;" />
### Command summary
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Commands - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ mkdir si; cd si; cp path/init.si .     #create working directory, move into it and copy file     
    $ blm init.si --express                  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                    #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si                           #use lmfa to make basp file, atm file and to get gmax
    $ cp basp0.si basp.si                    #copy basp0 to recognised basp prefix   
    $ vi ctrl.si                             #set iterations number nit, k mesh nkabc and gmax
    $ lmf ctrl.si > out.lmfsc                #make self-consistent

{::nomarkdown}</div>{:/}



<hr style="height:5pt; visibility:hidden;" />
### LDA calculation
The self-consistent LDA calculation can be run with the following commands. More details on the set up and running of a DFT calculation, within an all-electron framework, can be found on the fpintrotut page. 

<hr style="height:5pt; visibility:hidden;" />
### LDA commands     
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ cp path/init.si .                                    #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20 --gw  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent
    $ lmf si --band:fn=syml                                #plot LDA band structure

{::nomarkdown}</div>{:/}

Note that we have included an extra --gw switch. This switch tailors the ctrl file for a GW calculation. To see how it affects the ctrl file, try running blm without --gw. The basis set section is modified (see the autobas line) to increase the size of the basis set. GW calculations require a larger basis and this is accounted for by the gw switch.

Two new blocks of text, the HAM and GW categories, are also added towards the end of the ctrl file. The HAM category includes parameters for the handling of the self-energy. The GW category provides default values for parameters that are required in a GW calculation. These values are read and used in the stand alone input file for the GW calculation, we will come back to this later. One thing to note is the NKABC= token, which defines the GW k mesh. It is specified in the same way as the lower case nkabc= for the LDA calculation. 

Now check the output file out.lmfsc. The approximate self-consistent gap comes out to 0.58 eV as can be seen by inspecting the output of lmf. Note that this result differs to that from the LDA tutorial because the gw swtich increases the size of the basis set. The next step is to create a GW input file. 

<hr style="height:5pt; visibility:hidden;" />
### Making GWinput
The GW package (both one-shot and QSGW) uses one main user-supplied input file, GWinput. The script lmfgwd can create a template GWinput file for you by running the following command: 

    $ echo -1 | lmfgwd si                              #makes a GWinput file

The lmfgwd script has multiple options and is designed to run interactively. Using 'echo -1' automatically passes it the '-1' option that specifies making a template input file. You can try running it interactively by just using the command 'lmfgwd si' and then entering '-1'. Take a look at GWinput, it is a rather complicated input file but we will only consider the GW k mesh for now (further information can be found on the GWinput page). The k mesh is specified by n1n2n3 in the GWinput file, look for the following line:

    $ n1n2n3  4  4  4 ! for GW BZ mesh

When creating the GWinput file, lmfgwd checks the GW section of the ctrl file and then uses these values. The 'NKABC= 4' part of the ctrl file is read by lmfgwd and used for n1n2n3. Remember if only one number is supplied in NKABC then that number is used as the division in each direction of the reciprocal lattice vectors, so 4 alone means a 4x4x4 mesh. To make things run a bit quicker, change the k mesh to 3x3x3 by editing the GWinput file line:

    $ n1n2n3  3  3  3 ! for GW BZ mesh
    
The k mesh of 3×3×3 divisions is rough, but it makes the calculation fast and for Si the results are reasonable.

<hr style="height:5pt; visibility:hidden;" />
### Running QSGW
We are now ready for a QSGW calculation, this is run using the shell script lmgwsc.  

    $ lmgwsc --wt  --insul=4 --tol=2e-5 --maxit=2 -vnit=10 si

The first iteration is 0 of 10, zeroth. Starts off with lmf calc... Then some preparation then the GW calc... The most expensive step is lsc which is... Then have self-energy and next iteration beings... After 3 iterations the calculation is converged

At this point you should have a file sigm residing in your working directory. Because ctrl.si has HAM_RDSIG=12, it will automatically read sigm.si and effectively add it as an external potential. The actual file is sigm; lmgwsc makes a soft link to sigm.si so lmf can read it.

Do a band pass substituting the QSGW exchange-correlation potential for the LDA one: 

    $ lmf si -vnit=1 --rs=1,0 

Inspect the lmf output and you can find that the Γ-X gap is now 1.28 eV. 

To make the QSGW energy bands, do: 

    $ lmf si --band:fn=syml                            
    $ cp bnds.si bnds-qsgw.si


However, please note that the file is only a template and care must be taken in selecting appropriate parameter values.




The k mesh data that the GW codes actually reads comes from the following tag in the GWinput file: 

<hr style="height:5pt; visibility:hidden;" />
###Additional exercises

- Correct gap
(This is actually the Γ-X gap; the true gap is 0.44 eV as can be seen by running lmf with a fine k mesh).
- Changing k mesh:
We want the calculation to run quickly so let's use a coarser 3x3x3 mesh. Change NKABC in the ctrl file and rerun the lmfgwd command. The GWinput file  
- Adding floating orbitals
Note  that the basis set for this calculation isn't quite converged. For Si this is not much of an issue but it can matter a bit for other materials (making errors of order 0.1 eV). The atom-centered LMTO basis set is sufficient for LDA calculations, but it is not quite adequate for GW (work is in progress for a next-generation basis which should address this limitation). To make the basis complete you should add floating orbitals (you cannot add (you cannot add APWs in the QSGW context because the self-energy interpolator does not work with delocalized orbitals). Floating orbitals are like the empty spheres often required by the ASA, but they have no augmentation radius. You can automatically locate them using lmchk (the same way the empty sphere locator works for the ASA). 

