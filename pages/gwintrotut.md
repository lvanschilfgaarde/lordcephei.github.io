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

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this is a demonstration of a QSGW calculation (the 1-shot GW code is described in a separate tutorial) The LDA calculation can be run with the following commands (click on the LDA calculation dropdown menu). More details on the set up and running of a self-consistent LDA calculation can be found on the fpintrotut page. 

<hr style="height:5pt; visibility:hidden;" />
### Command summary     
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ cp path/init.si .                                    #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20 --gw  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent
    $ lmf si --band:fn=syml                                #plot LDA band structure

{::nomarkdown}</div>{:/}

Note that we have included an extra --gw switch. This switch tailors the ctrl file for a GW calculation. To see how it affects the ctrl file, try running blm without --gw. The basis set section is modified (see the autobas line) to increase the size of the basis set. GW calculations require a larger basis and this is accounted for by the gw switch. There are a number of considerations when choosing an appropriate basis set but we will leave these details to the additional exercises and the basis set page. 

Two new blocks of text, the HAM and GW categories, are also added towards the end of the file. The HAM category includes parameters for the handling of the self-energy. The GW category provides default values for parameters that are required in a GW calculation. For now we will only consider the NKABC= token. This defines the GW k mesh and is specified in the same way as the nkabc= for the LDA calculation. Usually a comparable or coarser mesh may be used because the self-energy generally varies much more smoothly with k than does the kinetic energy. This is fortunate because GW calculations are much more expensive and moreover the CPU time scales as the square of the number of k points, in contrast to the LDA's linear scaling.

<hr style="height:5pt; visibility:hidden;" />
### GW input file
The GW package (both one-shot and QSGW) uses one main user-supplied input file, GWinput. The script lmfgwd can create a template GWinput for you.

    $ test


The approximate self-consistent gap comes out to 0.58 eV as can be seen by inspecting the output of lmf (This is actually the Γ-X gap; the true gap is 0.44 eV as can be seen by running lmf with a fine k mesh). 

The k mesh data that the GW codes actually reads comes from the following tag in the GWinput file: 



