---
layout: page-fullwidth
title: "Building A TBE Ctrl File"
permalink: "/tbectrl/"
header: no

---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
________________________________________

The purpose of this tutorial is to outline the steps to produce very simple cells within TBE, first a bcc unit cell and then a more complex super-cell containing a vacancy, and show generally what the output will look like. 
All of the tokens and categories are defined and explained in the LMTO [tokens](http://www.lmsuite.org/lm-suite-tutorials/input-reference/) page, and so will not be explained fully here. More information specific to TBE is given in the [TBE](http://www.lmsuite.org/lm-suite-tutorials/tbe/) page


#### Producing the ctrl file
________________________________________

First have to state the versions of each program being used in the [VERS](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#VERScat) category and some details of the output can be set in [IO](file:///home/edmund/BROYDEN/lmto/lm/doc/tokens.html#IOcat).

         VERS TB=10 LM=7 FP=7
         IO      SHOW=0 HELP=F VERBOS=31 WKP=F
         
Constants used elsewhere in the file may be defined as follows: 

         %const amass=1.09716d-3 r0=5.423516

Each subsequent line of constants must start with *% const*, or they may be defined in the [CONST](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#CONSTcat) category, but will then be referenced without {} brackets. They can then be used in the subsequent categories.

         STRUC   ALAT={r0} NBAS=2
                 PLAT= 1.0 0.0 0.0   0.0 1.0 0.0   0.0 0.0 1.0

         SPEC ATOM=Fe Z=26 AMASS=55.845/{amass} NL=3 IDXDN=3 3 1

[STRUC](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#STRUCcat), as may be expected, defines the details of the structure, here setting the lattice spacing using the constant *r0*, setting the number of atoms in the unit cell with *NBAS* and the three primitive lattice vectors, note that these, like the atom positons unless specified otherwise, are scaled by the lattice parameter, which must be given in atomic units.

[SPEC](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#SPECcat) will define the details of the species involved, here we only have iron, where *NL* sets the number of l's per site value and IDXDN determines which of the spd orbitals are included, where 3 means the orbital is excluded and 1 is included, so this Fe atom will only have d-orbitals. For simple sp-carbon atoms it would be:
     
	      ATOM=C Z=6 AMASS=12.0107/{amass} IDXDN=1 1 3 

The positions of these atoms may then be defined using the category [SITE](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#SITEcat)

         SITE 
              ATOM=Fe POS=0.0 0.0 0.0  RELAX= 1 1 1
              ATOM=Fe POS=0.5 0.5 0.5  RELAX= 1 1 1

The atom coordinates will be scaled by the lattice parameter, unless they are specified using *XPOS*, causing them to be scaled instead by the lattice vectors. *RELAX* defines the directions that the atoms may be relaxed along (if the structure is being relaxed), where a value of 0 will prevent relaxation along that axis.

         HAM	  NSPIN=1

         BZ    NKABC=4 4 4 METAL=3 TETRA=F EF0=0.643 DELEF=0.01 N=1 W=0.002

         TB    RMAXH=1.01*{r0}  FORCES=1

         ME      0
                 Fe Fe | 0 0 0 0 0 0 0 -0.6 0.4 -0.1

         START   CNTROL=T
                 ATOM=Fe P=4 4 3
                         Q=0 0.15 1
                           0 0.45 1
                           6 0.00 1

[HAM](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#HAMcat) includes details of the Hamiltonian, here only being used to set the number of spins to one.

[BZ](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#BZcat) will specify details of the Brillouin zone integration, including the number of k-point divisions alnog each axis with *NKABC* and the method of integration used, here using Methfessel-Paxton sampling.

[TB](http://www.lmsuite.org/lm-suite-tutorials/tbe/#section2) includes the Tight Binding specific switches *FORCES* will decide whether or not the forces are calculated, *RMAXH* sets the range for finding neighbours in the lattice.

[ME](http://www.lmsuite.org/lm-suite-tutorials/tbe/#section1) sets the matrix elements for interactions between atoms, here it is set to the simplest case of fixed hopping integrals, where their values are set in the string of numbers below, here all have been set to zero apart from the d-orbital sigma, pi and delta integrals which are set to their canonical values.

[START](http://www.lmsuite.org/lm-suite-tutorials/tbe/#section2) defines some of the diagonal elements of the Hamiltonian for each species, where the P values are not used but must be set and the Q values refer to the number of electrons, the onsite energy and the Hubbard U for the s, p and d orbitals respectively, here there are 6 electrons in the d-orbital and the onsite energy is set to zero.

         ITER
            CONV=1d-4
            CONVC=5d-7
            NIT=100
            MIX=A5,b=0.5

[ITER](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#ITERcat) defines mixing details, but the quantities being mixed will be defined in the command line, it defaults to mixing elements of the Hamiltonian, but it will often be more effective to use *tbe --mxq* to mix charges or *tbe --mxq2* to mix charges and magnetic moments seperately.

TBE has two methods of mixing available: Andersen, which can be more stable but take longer to converge, and Broyden, these are chosen by using *A* and *B* in the *MIX* token. How they are specified is similar to the [LMTO](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#mixing), however Broyden has some differences.
When --mxq2 is being used with Broyden mixing w=w1,w2 will still set the weights used for charge and magnetic moment mixing respectively, however if *wa=1* is set it will do an alternate method called "clock mixing", whereby it will mix the charges to self consistency before each iteration of magnetic mixing. Now *CONV* will set the charge rms difference requirement and *CONVC* will set that for magnetic moments. This method can generally produce better converged magnetic moments than the alternatives.  

Note that these categories may be written in other files and included using:

              % include /path/to/file/SPECfile


#### Running the simulation
________________________________________

The simulation may then be run with:

         tbe --mxq ctrl.file
         
So it will read everything from ctrl.file and use charge mixing. First it will read in the structure and build the k-point map, reducing the number required unless --nosym is specified in the command line.
The values specified will be used to build the lattice. At each iteration it will also print the eigenvalues at selected k-points:

         SECMTB:  kpt 1 of 10, k=  0.00000  0.00000  0.00000
         -3.9667 -3.9667 -0.2333 -0.2333  0.1556  0.1556  0.1556  2.6444  2.6444

         SECMTB:  kpt 10 of 10, k=  0.50000  0.50000  0.50000
         -1.4000 -1.4000 -1.4000 -1.4000 -1.4000 -1.4000  2.1000  2.1000  2.1000
         
It will then mix the charges as follows:
         
         QMIX mixing multipole moments:
         Anderson iteration   1. 2 elements; mixed 0 of 0, beta=0.5, rms diff: 8.88178e-16
         
Here it has 2 elements, the charge from each atom, and zero prior iterations to mix as it is the first, but it would build to 5 if it didn't complete so quickly due to the simplicity of this system. *rms diff* is the convergence criterion defined in *MIX* and so it only has to get lower than 1d-4.

The forces will be calculated once the charges have been mixed to self consistency, although they will obviously be zero here as this is a perfect lattice.

	Site                pos                              force
	1 Fe         0.00000   0.00000   0.00000      0.00000   0.00000   0.00000
	2 Fe         0.50000   0.50000   0.50000      0.00000   0.00000   0.00000

Finally it will print the results of the calculation, giving the trace of the density matrix *Tr[rho]* (or the total number of electrons), the trace of the density matrix with the Hamiltonian *Tr[rho][H_0]* (which will just give the band structure energy here), the second order correction *E_2*, the internal Virial *3PV* and the electrostatic energy *emad*. A description of the rest of these terms may be found in the source code file tbtote.f.
Note that due to the simplicity of this calculation most of these values are zero, but as the calculation becomes more complex with the inclusion of a pair potential, multiple spins, charge transfer, polarisation and so on more values will be calculated.


	    Tr[rho]                 :       12.00000000
	    Tr[rho][H_0]            :      -11.12658182
	    band structure energy   :      -11.12658182
	    E_2                     :       -0.00000000
	    pair potential energy   :        0.00000000
	    reference energy        :        0.00000000
	    total energy            :      -11.12658182
	    free energy             :      -11.12676850
	    3PV              pair   :        0.00000000
 
	    c mmom=0 sev=-11.126582 erep=0 etot=-11.126582 emad=0 3pv=0 TS=.000187



#### Producing a more complex simulation
________________________________________

Now attempt relaxation of a structure with two spins per atom and a more complex description of the hopping integrals.

The [DYN](http://www.lmsuite.org/lm-suite-tutorials/input-reference/#DYNcat) category can be used to relax a static structure as follows:

	DYN
	      MSTAT[MODE=5 HESS=F XTOL=1d-3 GTOL=1d-3
		    STEP=0.01 NKILL=100] NIT=1000
		  

This sets the relaxation scheme to Fletcher-Powell and sets the tolerance for displacement and forces with *XTOL* and *GTOL* respectively, although only one is really necessary,
A more interesting structure to relax may be a 54 atom super-cell with one atom removed to produce a vacancy:

      STRUC   NBAS=53 NSPEC=1 NL=3 ALAT=5.423516
	      PLAT=3 0 0   0 3 0   0 0 3
      SITE    
	  ATOM=Fe POS=0      0      0
	  ATOM=Fe POS=1.0    0      0
	  ATOM=Fe POS=0      1.0    0
	  ATOM=Fe POS=1.0    1.0    0
	  ATOM=Fe POS=2.0    0.0    0
	  ATOM=Fe POS=2.0    1.0    0
	  ATOM=Fe POS=2.0    2.0    0
	  ATOM=Fe POS=0     2.0    0
	  ATOM=Fe POS=1.0    2.0    0
	  ATOM=Fe POS=0.5    0.5    0.5
	  ATOM=Fe POS=1.5    0.5    0.5
	  ATOM=Fe POS=0.5    1.5    0.5
	  ATOM=Fe POS=1.5    1.5    0.5
	  ATOM=Fe POS=2.5    0.5    0.5
	  ATOM=Fe POS=2.5    1.5    0.5
	  ATOM=Fe POS=2.5    2.5    0.5
	  ATOM=Fe POS=1.5    2.5    0.5
	  ATOM=Fe POS=0.5    2.5    0.5
	  ATOM=Fe POS=0       0     1.0
	  ATOM=Fe POS=1.0     0     1.0
	  ATOM=Fe POS=0      1.0    1.0
	  ATOM=Fe POS=1.0    1.0    1.0
	  ATOM=Fe POS=2.0    0.0    1.0
	  ATOM=Fe POS=2.0    1.0    1.0
	  ATOM=Fe POS=2.0    2.0    1.0
	  ATOM=Fe POS=0      2.0    1.0
	  ATOM=Fe POS=1.0    2.0    1.0
	  ATOM=Fe POS=0.5    0.5    1.5
	  ATOM=Fe POS=1.5    0.5    1.5
	  ATOM=Fe POS=0.5    1.5    1.5
	  ATOM=Fe POS=1.5    1.5    1.5
	  ATOM=Fe POS=2.5    0.5    1.5
	  ATOM=Fe POS=2.5    1.5    1.5
	# ATOM=Fe POS=2.5    2.5    1.5
	  ATOM=Fe POS=1.5    2.5    1.5
	  ATOM=Fe POS=0.5    2.5    1.5
	  ATOM=Fe POS=0       0     2.0
	  ATOM=Fe POS=1.0     0     2.0
	  ATOM=Fe POS=0      1.0    2.0
	  ATOM=Fe POS=1.0    1.0    2.0
	  ATOM=Fe POS=2.0    0.0    2.0
	  ATOM=Fe POS=2.0    1.0    2.0
	  ATOM=Fe POS=2.0    2.0    2.0
	  ATOM=Fe POS=0      2.0    2.0
	  ATOM=Fe POS=1.0    2.0    2.0
	  ATOM=Fe POS=0.5    0.5    2.5
	  ATOM=Fe POS=1.5    0.5    2.5
	  ATOM=Fe POS=0.5    1.5    2.5
	  ATOM=Fe POS=1.5    1.5    2.5
	  ATOM=Fe POS=2.5    0.5    2.5
	  ATOM=Fe POS=2.5    1.5    2.5
	  ATOM=Fe POS=2.5    2.5    2.5
	  ATOM=Fe POS=1.5    2.5    2.5
	  ATOM=Fe POS=0.5    2.5    2.5

Here the atom was removed by inserting # before it, which will cause any line to become a comment.
Due to the more complex structure it may be advisable to change the mixing parameters in order to accelerate convergence:
	
	ITER    CONV=1d-4 CONVC=1d-3 NIT=1000 MIX=b13,b=0.008,bv=0.008,wc=-1,w=-1,-1

Now TBE will use Broyden mixing, with a smaller beta and increased number of prior mixing iterations to improve stability, and with the weights for charge and spin mixing set separately, with *w=*, if --mxq2 is specified in the command line, otherwise only wc will be used. Note that wc is set to a negative number, this causes new weights to be calculated on each iteration from the previous RMS.
Another way to improve the stability of the mixing is to use the clock-mixing scheme, as mentioned, by setting *wa=1* in **ITER**, which could be useful for this simulation. Note: in order to include magnetism, and use clock mixing, the number of spins must be set to 2 in the **HAM** category.

      HAM         NSPIN=2 ELIND= -0.7 PWMODE=11 PWMAX=5 PWMIN=1

      SPEC    
	      ATOM=Fe Z=26 R=R I=0.05 A=0.025 AMASS=55.845/{amass}
	      IDU= 0 0 0 0 UH= 0 0 0 0  JH=0.05 0.05 0.05 0.05 
	      COLOUR=0.1 0.1 0.1  RADIUS=0.5
	      IDXDN=3 3 1 


      START   CNTROL=T
	      ATOM=Fe   P= 4 4 3 4 4 3
			Q= 0            0.15   1
			  0            0.45   1
			  (8.8)/2       0.0   1
			  0            0.15   1
			  0            0.45   1
			  (4.8)/2       0.0   1
			  
The spin channels must now be specified separately using two sets of Q values, so that the number of electrons in each may be specified.
In order for the relaxation to be actually meaningful the matrix elements for the interactions should be changed from their fixed form.

      ME     2
	      Fe Fe MEMODE=2 PPMODE=10 POLY=5 CUTMOD=2 CUTPP=4.88116 7.592922
		  | -0.35 0 0 0 -0.14067 0 0 -2.43826 1.99715735 -0.90723918
	      DECAY=0.3 1 1 1    0.3 1  1    0.9 0.9 0.9
		CUT=5.9658 10.847 0 0 0 0 0 0 5.96586 10.847 0 0 0 0 4.88116 7.5929 4.88116 7.5929 4.88116 7.5929
		    @ 0.45 0 0 0 0.5 0 0 0 0 0
		DECAY=0.3 1 1 1   0.3 1  1    0.9 0.9 0.9
		CUT=5.9658 10.847 0 0 0 0 0 0 5.96586 10.847 0 0 0 0 4.88116 7.5929 4.88116 7.5929 4.88116 7.5929
		    ! 683.1 0 1.5376   -459.5 0 1.4544   0 0 0
		    
      TB      FORCES=1 EVDISC=T RMAXH=7.59292 TRH=T RHO=T 3PV=1
	      UL=1 IODEL=0 OVLP=0
		
      SYMGRP  find
		
      BZ      NKABC=8 TETRA=T METAL=3
              EFMAX=5 

Here the interaction between iron atoms has been chosen to have an exponential decay, where the first set of numbers set the actual values for the elements, then *DECAY* sets the exponents of the decay function and CUT will set the points where the decay starts and where the function goes to zero for each interaction.
There are values set for the overlaps after @, and has a similar form for its decay parameter, although this will not be relevant here as there are no electrons in the s-bands and OVLP is set to false. PPMODE defines the form of the pair potential, here set to a sum of power law multiplied by an exponential, the values of which are set after !.
More details are given on the [TBE](http://www.lmsuite.org/lm-suite-tutorials/tbe/) page.  
Finally the value of RMAXH must be changed to reflect the new range of the interactions. Note that IODEL is set to zero here so the simulation must be started fresh each time it is interrupted, but if set to 1 the delta and qmom files can be used to pick up the simulation where it left off.



#### Running the simulation
________________________________________

This time, in order to use the clock-mixing scheme, the simulation must be run with:

         tbe --mxq2 ctrl.file
         
Now it will first mix the charges to a consistency of at least *CONV*:

         Broyden iteration   62:   53 charges; mixed 13 of 13, rms diff: 2.61389e-5 (tol: 1e-4)
         
Before it mixes the moments once:

         Broyden iteration   63:   53 spins;   mixed  1 of 13, rms diff: 2.8871 (tol: 1e-3)

This will continue until the spins reach a consistency of  *CONVc*, then it will calculate the forces on each atom, broken down into contributions:

          Forces on atom    1    Species: Fe  
            Coordinates        :    0.00000000    0.00000000    0.00000000
            From bands         :    0.00007160    0.00007160    0.00000000
            From e'stx         :    0.00000201    0.00000201    0.00000000
            From pairs         :   -0.00000000   -0.00000000    0.00000000
            Total              :    0.00007361    0.00007361    0.00000000
            
And the maximum force:

          Maximum force= 0.013959 on atom 25 (Fe)
          
This is what will be used to determine whether the structure is relaxed or not with *GTOL*, it will then use the process **gradzr** to update the site postions using the Fletcher-Powell scheme:

          gradzr: begin F.P. xtol=1e-3 and gtol=1e-3  gtll=0.25  dxmx=0.01  isw=161
          gradzr new line 1:  g.h=-0.00271  g.(h-g)=0  max g=-0.0135  |grad|=0.0521  
            p= 0.00000000 0.00000000 0.00000000 1.00000000 0.00000000 0.00000000
            g= -7.3610e-5 -7.3610e-5 -6.367e-21 -6.832e-21 -5.1871e-4 6.9440e-18
            h= 7.36102e-5 7.36102e-5 6.3673e-21 6.8323e-21 5.18712e-4 -6.944e-18
          rfalsi: new start  (c) xtol=0.074  dxmn=0.037  dxmx=0.74
          rfalsi ir=-1: seek xn=0.73960125
          RELAX line 1:  new line minimization;  max shift=0.01000  |g|=0.0521
          
And will print out the new coordinates:

          Updated atom positions:
            Site   Class                      Position(relaxed)
            1      Fe         0.00005444(T)    0.00005444(T)    0.00000000(T)
            
Before it begins mixing again with the atoms in their new positions, this will continue until the structure is sufficently relaxed, then it will print the final energies and coordinates:

            Tr[rho]         total   :      360.40000000
                            moment   :      153.91791280
            Tr[rho][H_0]       up   :       -0.93026638
                              down   :       -9.09863081
                            total   :      -10.02889719
            band structure energy   :      -21.16528983
            E_2                     :       -5.58942732
            pair potential energy   :       -0.78950422
            reference energy        :        0.00000000
            Stoner magnetic energy  :       -5.58999333
            Magnetic moment         :      153.91791280
            total energy            :      -16.40782873
            free energy             :      -16.40783056
            3PV              pair   :       42.22590387
                            bands   :      -45.87326581
                            charges :       -0.00061289
                            total   :       -3.64797484
                            
Due to the increased complexity of the interactions and the inclusion of two spins there is a lot more information printed here than previously.