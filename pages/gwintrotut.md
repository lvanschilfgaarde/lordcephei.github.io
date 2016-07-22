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
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">QSGW - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

In this code, each iteration of a QSGW calculation has two main parts. It begins with a self-consistent DFT calculation to calculate eigenfunctions and eigenvalues. These are then used in the second part, the GW calculation, that constructs a self-energy. 

The QSGW calculation takes as input the self-consistent DFT eigenfunctions and eigenvalues (usually LDA) and these are used to construct a self-energy. In the next iteration, the self-energy replaces the DFT exchnage-correlation functional in the hamiltonian and a self-consistent DFT calculation is carried out to obtain the new eigenfunctions and eigenvalues. These are then used to construct a new self-energy. This process is repeated until the change in the root mean square between the old and the new self-energy is below a certain tolerance. The final self-energy is an effective exchange-correlation functional, tailored to the system, that can be conveniently used within the standard DFT formalism to calculate properties such as the band structure.  

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

Two new blocks of text, the HAM and GW categories, are also added towards the end of the file. The HAM category includes parameters for the handling of the self-energy. The GW category provides default values for parameters that are required in a GW calculation. The details are not important for now. One part to note is the NKABC= token, which defines the GW k mesh. It is specified in the same way as the nkabc= for the LDA calculation. Usually a comparable or coarser mesh may be used because the self-energy generally varies much more smoothly with k than does the kinetic energy. This is fortunate because GW calculations are much more expensive and moreover the CPU time scales as the square of the number of k points, in contrast to the LDA's linear scaling.

Check the output file out.lmfsc. The approximate self-consistent gap comes out to 0.58 eV as can be seen by inspecting the output of lmf (This is actually the Γ-X gap; the true gap is 0.44 eV as can be seen by running lmf with a fine k mesh). Note that this result differs to that from the LDA tutorial because, with the gw switch, the basis set is now different. The next step is to create a GW input file. 

<hr style="height:5pt; visibility:hidden;" />
### GW input file
The GW package (both one-shot and QSGW) uses one main user-supplied input file, GWinput. The script lmfgwd can create a template GWinput file for you by running the following command: 

    $ echo -1 | lmfgwd si                              #makes a GWinput file

The lmfgwd script has multiple options and is designed to run interactively. Using 'echo -1' automatically passes it the '-1' option that creates a template input file. You can try running it interactively by just using the command 'lmfgwd si' and then entering -1. Take a look at the file GWinput that was made. It is a rather complicated input file but we will only consider the GW k mesh for now (further information can be found on the GWinput page). In the GWinput file, the k mesh is specified on the line:
    $ n1n2n3  4  4  4 ! for GW BZ mesh
This is the

after n1n2n3 and here it is 4x4x4. In setting up the GWinput file, lmfgwd checks the GW section of the ctrl file and then uses these values in the template file. The 'NKABC= 4' part of the ctrl file is read by lmfgwd and


However, please note that the file is only a template and care must be taken in selecting appropriate parameter values.




The k mesh data that the GW codes actually reads comes from the following tag in the GWinput file: 



