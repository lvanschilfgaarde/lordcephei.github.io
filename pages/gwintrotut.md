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
# Introduction to GW calculations 

This tutorial begins with an LDA calculation for Si, starting from an init file. Following this are demonstrations of both QSGW and 1-shot GW calculations. The LDA calculation can be run with the following commands (click on the LDA calculation dropdown menu). More details on the set up and running of a self-consistent LDA calculation can be found on the fpintrotut page. 

<hr style="height:5pt; visibility:hidden;" />
### Command summary     
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

    $ cp path/init.si .                                    #copy init file to working directory
    $ blm init.si --express --gmax=5 --nk=4 --nit=20 --gw  #use blm tool to create actrl and site files
    $ cp actrl.si ctrl.si                                  #copy actrl to recognised ctrl prefix
    $ lmfa ctrl.si; cp basp0.si basp.si                    #run lmfa and copy basp file
    $ lmf ctrl.si > out.lmfsc                              #make self-consistent

{::nomarkdown}</div>{:/}

Note that we have included an extra --gw switch. This switch tailors the ctrl file for a GW calculation. To see how it affects the ctrl file, try running blm without --gw. The basis set section is modified (see the autobas line) to increase the size of the basis set. GW calculations require a larger basis and this is accounted for by the gw switch. We will leave further details of the basis set to the additional exercises and basp file page. Two new blocks of text, the HAM and GW categories, are also added towards the end of the file. The HAM category includes parameters for the handling of the self-energy. The GW category provides default values that will go into the GW input file (GWinput), which will be generated later in the QSGW set up.

The GW...



