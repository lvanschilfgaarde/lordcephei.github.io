---
layout: page-fullwidth
title: "Basic lmf Tutorial for PbTe"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/lmf_pbte_tutorial/"
header: no
---
_____________________________________________________________


### _Purpose_
{:.no_toc}

This tutorial carries out a self-consistent density-functional calculation for PbTe using the **lmf**{: style="color: blue"} code.  Some of the basics are covered in this tutorial, and you may wish to go through it first.  This tutorial

1. generates a self consistent potential within the LDA

2. illustrates some features of the programming language capabilities in reading the input file

3. demonstrates how to get neighbour tables using the **lmchk**{: style="color: blue"} tool

4. synchronizes with an [ASA tutorial](https://github.com/lordcephei/lordcephei.github.io/blob/master/pages/fptut-pbte.md) enabling a comparison of the ASA and full potential methods.

5. is the starting point for other tutorials on optics, corresponding calculations with QSGW, and drawing energy bands.


### _Preliminaries_

____________________________________________________________

Executables **blm**{: style="color: blue"}, **lmchk**{: style="color: blue"}, **lmstr**{: style="color: blue"} and **lm**{: style="color: blue"} are required and are assumed to be in your path.  The source code for all Questaal executables can be found [here](https://bitbucket.org/lmto/lm).

### _Tutorial_

_____________________________________________________________

##### _Building the input file_

PbTe crystallizes in the rocksalt structure with lattice constant _a_=6.428$\AA$. You need the structural information in the box below to construct the main input file,
_ctrl.pbte_{: style="color: green"}. Cut and paste its contents to _init.pbte_{: style="color: green"}.

    LATTICE
	    ALAT=6.427916  UNITS=A
            PLAT=    0.0000000    0.5000000    0.5000000
                     0.5000000    0.0000000    0.5000000
                     0.5000000    0.5000000    0.0000000
    SITE
		ATOM=Pb   X=     0.0000000    0.0000000    0.0000000
		ATOM=Te   X=     0.5000000    0.5000000    0.5000000


Create the input file (_ctrl.pbte_{: style="color: green"}) and the site file with structural information (_site.pbte_{: style="color: green"}) with

    $ blm init.pbte
    $ cp actrl.pbte ctrl.pbte

##### _2\. How the input file is organized_

Take a look at the ctrl file.  Lines which have the first character containing one of the following are treated specially:

    Lines beginning with `#' are comment lines and are ignored. (More generally, text after a `#' in any line is ignored)

    Lines beginning with `%' may be interpreted as directives to the preprocessor.  They are not part of the the post-processed input programs read to get data

Near the top, beginning with **% const**, are a series of variable declarations
Click on the box below to see a snippet showing what **blm**{: style="color: blue"} should have produced.
<hr style="height:5pt; visibility:hidden;" />
<div onclick="elm = document.getElementById('iors'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="iors">{:/}

~~~
# Variables entering into expressions parsed by input
% const nit=10
% const met=5
% const so=0 nsp=so?2:1
% const lxcf=2 lxcf1=0 lxcf2=0     # for PBE use: lxcf=0 lxcf1=101 lxcf2=130
% const pwmode=0 pwemax=3          # Use pwmode=1 or 11 to add APWs
% const nkabc=0 gmax=0
~~~ 

{::nomarkdown}</div>{:/}

**nit**, **met**, etc,  are variables used in expressions further down.  The parser interprets the side of brackets {..} as expressions, converts it into numbers, which are finally read as numerical values associated with a tag.  The parser is explained in further detail [here](file-preprocessor.html)

For example this line
  metal=  {met}                    # Management of k-point integration weights in metals
beomes
  metal=  5
because met is a numerical expression (admittedly a trivial one) that evaluates to 5, since met is an algebraic variable that is assigned the value 5.  The advantage is that you can do algebra in the input file, and you can also assign values to variables from the command line, as we will see shortly.

The actual input is divided into categories and token within the categories.
A category begins when a character (other than **%** or **#**) occurs in the
first column.  Each token belongs to a category; for example in this line

    IO    SHOW=f HELP=f IACTIV=f VERBOS=35,35  OUTPUT=*

SHOW is a token within category; the full tag name is IO_SHOW.

##### _3\. Finding what an executable looks for when reading the input file_




###### _2.2 Self-consistency_
Before a  self consistant calculation can be preforem the real-space structure constants have to be generated.  They are made once, for a given structure, with a separate tool

       lmstr ctrl.pbte

The penultimate step is to generate the initial the multipole moments Q$_0$,Q$_1$,Q$_2$. For this we first change the nkabc variable within the control file to for (**nkabc=4**, this variable represents the k-mesh density):
change 
	
	% const nkabc=0
	
to

	% const nkabc=4


next  the  **lm**{: style="color: blue"} executable is invoked with zero number of iterations such that

    lm -vnit=0 ctrl.pbte

and lastly for a fully consistant LDA-ASA calculation **lm**{: style="color: blue"} is invoked with **-vnit**>1 so that

    lm -vnite=20 ctrl.pbte

The message at the end of the standard out put will indicate if self-consistency has been achieved, which in this case it has.
	    
