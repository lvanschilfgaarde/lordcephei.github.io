---
layout: page-fullwidth
title: "lmf CLO"
permalink: "/docs/commandline/lmf/"
header: no
---

____________________________________________________________

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_
_____________________________________________________________
This page serves to document the command line switches specifically applicable to the _lmf_{: style="color: blue"} program.

### _Preliminaries_
_____________________________________________________________
You should familiarize yourself with the contents of the [general command line options](/docs/commandline/general/) documentation and be aware of the capabilities of the _lmf_{: style="color: blue"} program in order to fully understand the options available.

It would also be wise to read up on the different input sources that _lmf_{: style="color: blue"} can read as some input options will pertain to specific input data. Details on these input sources can be found in the Documentation > Input Sources tab.

### _Documentation_
_____________________________________________________________

    --rs=#1,#2,#3,#4,#5  tells lmf what parts to read from the rst file.
                         #1=0: do not read the restart file, but overlap
                               free-atom densities
                            1: read restart data from binary rst.ext
                            2: read restart data from ascii rsta.ext
                            3: same as 0, but also tells lmf to overlap
                               free-atom densities after a molecular statics
                               or molecular dynamics step.
                            11 or 12: same as 1, or 2 but additionally adjust
                                      the mesh density for shifts in site positions
                                      relative to those used in the generation of the
                                      restart file.  Note: see --rs switch #3 below
                                      for which site positions the program uses.  The
                                      same principle for adjusting the density is used
                                      as in computing corrections to the Helman-Feynman
                                      forces; see token FORCES= in HAM.
							
                            Additionally, if you read from rst or rsta
                            you can add 10 to #1
							
                         #2=0: exactly as #1, but except switches apply to
                               writing. Value zero suppresses writing.
                            1: write binary restart file rst (default)
                            2: write ascii restart file rsta
                            3: write binary file to rst.#, where # = iteration number
						   
                         #3=0: read site positions from restart file,
                               overwriting positions from input file
                               (this is the default)
                            1: ignore positions in restart file
						   
                         #4=0: read guess for Fermi level and window from
                               restart file, overwriting data from input
                               file.  This data is needed when the BZ
                               integration is performed by sampling.
                               (this is the default)
                            1: ignore data in restart file
						   
                         #5=0: read linearization pnu from restart file,
                               overwriting data from input file
                               (this is the default)
                            1: ignore pnu in restart file
							
                     Default switches:
                     If not specified, lmf defaults to --rs=1,1,0,0,0
					
                     Look at lmf's standard output around lines
                         iors  : read restart file (binary, mesh density)
                     It tells you what bits are read and what is ignored.
					
    --rdbasp[:fn]    tells the program to read basis parameters (input using
                     tokens RSMH=,EH=,RSMH2=,EH2=,PZ= for each atom in the
                     ctrl file) from file ``basp'' (or optionally file ``fn'').
                     Parameters input in this mode supersedes parameters
                     read from the ctrl file.  You can specify none, or any
                     set of the sets (RSMH=,EH= ; RSMH2=,EH2=; PZ=)
                     for each species.  Parameters not specified here
                     default to what was specified in the ctrl file.
					 
	                 This switch (and --optbas described below) is a useful
                     way to get started when you don't know what to choose
                     for parameters in the basis set.
					 
    --optbas[:sort][:spec=name[,rs][,e][,l=###]...]
                     operates the program in a special mode to optimize
                     the total energy wrt the basis set. lmf makes
                     several band passes (not generating the output density
                     or adding to the save file), varying selected
                     parameters belonging to tokens RSMH= and EH= to
                     miniminize the total energy wrt these parameters.
                     Either the smoothing radius [,rs] or the energy [,e]
                     must be selected for optimization (you can select
                     both).  Select which l quantum numbers whose parameters
                     you want to optimize using ``,l=##..'', e.g. l=02 .  The
                     optimization routine is rather primitive, but it seems
                     to work reasonably well. See the basis optimization tutorial
                     for a more complete description and an example.
					 
    --rpos=filename  tells the program to read site positions from file
                     ``filename'' after the CTRL file has been read
					 
    --wpos=filename  tells the program to write site positions to file
                     ``filename'' after a relaxation step.
					 
    --band[~option~option...] tells lmf to generate energy bands instead
                     of making a self-consistent calculation.  The energy
                     bands can be generated in one of several formats.
                     See generating-energy-bands.html
                     for a detailed description of the available options.
					 
    --pdos[:options] tells lmf to generate weights for density-of-states resolved into partial waves,
                     described in this document.
					 
    --mull[:options] tells lmf to generate weights for Mulliken analysis, described in this document.
	
    --cls[options]   tells lmf to generate weights to compute matrix
                     elements and weights for core-level-spectroscopy.  See
                     subs/suclst.f for a description of options.
					 
    --wden[:options] writes one plane of the charge density to disk, on a
                     uniform of mesh of points.  Information for the
                     plane is specified by three groups of numbers: the
                     origin (i.e. a point through which the plane must
                     pass), a first direction vector with its number of
                     points, and a second direction vector with its
                     number of points.  Default values will be taken for
                     any of the three sets you do not specify.  The
                     density generated is the smooth density, augmented
                     by the local densities in a polynomial approximation
                     (see option core= below)
					 
                     The options are specifications (see below) and
                     different options are separated by delimiters
                     (chosen to be ``:'' in this text; the delimiter
                     actually taken is the first character after ``wden'')
					 
                     At present, there is no capability to interpolate
                     the smoothed density to an arbitrary plane, so you
                     are restricted to choosing a plane that has points
                     on the mesh.  Accordingly, all three groups of
                     numbers are given sets of integers, as will be
                     explained below.  Supposing your lattice vectors are
                     p1, p2 and p3, which the smooth mesh having (n1,n2,n3)
                     divisions.  Then the point (#1,#2,#3) corresponds to
                     the Cartesian coordinate
                         #1/n1 p1 + #2/n2 p2 + #3/n3 p3
					 
                     Specify the origin (a point through which the plane
                     must pass) by
                         :o=#1,#2,#3
                     Default value: o=0,0,0.
					 
                     Specify the direction vectors by
                         :l1=#1,#2,#3[,#4]
                         :l2=#1,#2,#3[,#4]
						 
                     l1 and l2 specify the first and second direction
                     vectors, respectively.  The first three numbers
                     specify the orientation and the fourth specifies the
                     ``length''.  #1,#2,#3 select the increments in mesh
                     points along each of the three lattice vectors that
                     define the direction vector.  Thus a direction
                     vector in Cartesian coordinates is
                         #1/n1 p1 + #2/n2 p2 + #3/n3 p3
                     The last number (#4) specifies how many points to take
                     in that direction and therefore corresponds to a length.
                     Default values:
                         l1=1,0,0,n1+1
                         l2=0,1,0,n2+1
						 
                     Other options:
					 
                     core=#   specifies how local densities is to be included.
                              Any local density added is expanded as
                              polynomial * gaussian, and added to the
                              smoothed mesh density.
                          #=0 includes core densities + nuclear contributions
                          #=1 includes core densities, no nuclear contributions
                          #=2 exclude core densities
                          #=-1 no local densities to be included (only interstitial)
                          #=-2 local density, with no smoothed part
                          #=-3 interstitial and local smoothed densities
					   
                          Default: core=2
						  
                     fn=name  specifies the file name for file I/O
                              The default name is ``smrho''.
							  
                     Example: use ``:'' as the delimiter, and suppose
                              n1=n2=48 and n3=120.  The specification
                              :fn=myrho:o=0,0,60:l1=1,1,0,49:l2=0,0,1,121
                              writes 'myrho.ext' a mesh (49,121) points.
                              The origin (first point) lies at (p3/2).
                              The first vector points along (p1+p2), and
                              has that length; the second vector points
                              along p3, and has that length.
							  
    --window=#1,#2   accumulates the density in an energy window
                     specified by the limits #1,#2.  (This option is
                     intended to be used in conjunction with --wden).  If
                     invoked, lmf exits after a single band pass.
				   
    --oldvc          chooses nfp-style energy zero, which sets the cell
                     average of the potential to zero.  Normally the
                     average estat potential at the RMT boundary is
                     chosen to be the zero.  That puts the Fermi level
                     near zero, like in the ASA.

##### _Interfacing With GW Self-Energy_
The _lmf_{: style="color: blue"} program can interface with the self-energy data generated by GW components of the suite. The following switches specifically relate to this interface

    --mixsig=#1[,#2] lmf takes a linear combination of the self-energy
                     read from one or two files.  See here in the GW documentation.
					 
	--rsig[~options] Tells lmf about the form of the input self-energy file. See here in the GW documentation.
                     ~ascii   read sigm in ascii format (file name is
                     ~rs      read sigm in real space
                              If either of the preceding two switches is used, the file name changes;
                                   k-space  real-space
                                   binary     sigm      sigmrs
                                   ascii      sigma     sigmars
                     ~null    generate a null sigma consistent with the hamiltonian dimensions
                              Useful in combination with the sigma editor.
                     ~fbz     sigma is stored for k in the full Brillouin zone
					 
    --wsig[options]  lmf writes a possibly modified self-energy to file sigm2.ext and exits.
                     See the here in the GW documentation.
					 
	--etot           is a special mode designed to be used in conjuction
                     with the GW suite.  It generates parameters for the
                     LDA total energy without disturbing the rst or mixing
                     files, or logging the energy in the save file.