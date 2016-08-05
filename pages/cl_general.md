---
layout: page-fullwidth
title: "General CLO"
permalink: "/docs/commandline/general/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This page serves to document the command line switches generally applicable to most of the packages in the suite, and to give an idea of the usage cases of certain switches and switch types.

### _Documentation_
_____________________________________________________________
All of the programs have special branches that may be (and sometimes must be) set from command-line switches.

Here is an example:

    lmf cafeas -vns=4 -vnm=5 --rpos=pos 

Following unix style, switches always begin with “-”. There are many command-line switches that are specific to a particular main program, while a number of others are common to several or all programs.

Some switches have a single “-” ; some have two (“–”). Those with two tend to control program flow (e.g. --show), while those with a single “-” tend to have an “assignment” function, such as a variables declaration (e.g. -vx=3). Sometimes there is not a clear distinction between the two, e.g. the printout verbosity --pr (see below) accepts either “-” or “–”.

In the example above, “-vns=4 -vnm=5“ assigns variables ns and nm to 4 and 5, respectively, while “--rpos=pos” tells lmf to read site positions from file pos.cafeas.

You can also put these switches in the CMD category in the input file. The function is similar to a command-line argument, but
not identical since the preprocessor has already read the input file before the “CMD” switches are read. Thus the "-v” and “-c” variable declarations may behave somewhat differently.

##### _Switches Common to Most or All Programs_

    --h             lists command-line switches for that program
                    and quits.  (warning: sometimes documentation
                    is slightly out of date)
    
	--input         same as turning on HELP=T in category IO; see
                    HELP= in the description of the IO category
                    above.
	
	--show          same as turning on SHOW=T in category IO; see
                    SHOW= in the description of the IO category
                    above.
	
	--showp         prints out input file after having run through
                    the preprocessor, and exits.  This can be
                    useful because it shows the action of the
                    preprocessor.  When trying to parse a
                    complicated input file, it is often simpler to
                    run it through the preprocessor, and use the
                    output of the preprocessor as the input file
					
	--pr#1[,#2]     sets print verbosities, overriding any
     -pr#1[,#2]     specification in the input file's IO category.
                    #2 is verbosity for the potential generation
                    segment of code and assumes the value of #1
                    unless specified.  See input-file-style.txt for
                    a description of the verbosity.
					
	--time=#1[,#2]  prints out a summary of timings in various
                    branches of the code at the close of program
                    execution.  Timings are kept to a nesting level
                    of #1.  If #2 is nonzero, timings are printed
                    `on the fly'
					
	--iactive       turns on `interactive' mode. This overrides
                    specification of interactive mode this in the
                    ctrl file `IO IACTIV=' See input-file-style.txt
                    for a description of the interactive mode.
					
	-iactive=no     
    --no-iactive    turns off `interactive' mode, overriding
                    specification in the ctrl file.
					
	-c"name=strn"   declares a character variable and assigns to
                    value `strn'
					
	-v"name=expr"   declares a numeric variable and assigns to the
                    value of expression `expr'. Be advised that
                    only the first declaration of a variable is
                    used.  Later declarations have no effect.  In
                    addition to the declaration `name=...'  there
                    are assignment operators
                    `*=','/=','+=','-=','^=' modify existing
                    variables, following C syntax, as described in
                    description of category CONST above.

##### _Switches Common To Programs Using Site Information_
Additionally, for any program utilizing site information, the following switches apply

    --rpos=fnam     tells the program to read site positions from
                    file ``fnam'' after the input file has been read.  Data
                    is read following a standard format for 2D arrays.
                    This page more fully describes how site data are read.
					
	--fixpos[:tol=#]
	--fixpos[:#]    tells the symmetry finder to adjust positions
                    to sites that are ``slightly displaced'', that is that
                    if they were displaced a small amount, would make the
                    basis conform to a group operation.  Optional tolerance
                    specifies the maximum amount of adjustment allowed.
                    Example: lmchk --fixpos:tol=.001
				   
	--sfill=class-  list tells the program to adjust the sphere sizes
                    to space filling.
					
                    *By default, ``class-list'' is a list of integers.
                    These enumerate class indices for which spheres
                    you wish to resize, eg 1,5,9 or 2:11.
                    For ``class-list'' syntax see here.
					
                    *A second alternative specification a class-list uses
                    the following:  ``-sfill~style=2~expression''
                    The expression can involve the class index ic and atomic number z.
                    Any class satisfying expression is included in the list.
                    Example: ``-sfill~style=2~ic<6&z==14''
					
                    *A third alternative specification of a class-list is
                    specifically for unix systems.  The syntax is
                    ``-sfill~style=3~fnam''.  Here "fnam" is a filename
                    with the usual unix wildcards.  For each class,
                    the program makes a system call ``ls fnam | grep
                    class'' and any class which grep finds is
                    included in the list.  Example:
                    ``-sfill~style=3~a[1-6]''