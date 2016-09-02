---
layout: page-fullwidth
title: "Optics Tutorial"
permalink: "/docs-equ-optics/"
header: no
---
_____________________________________________________________
### _Prerequisite_

To calculate the optical and electronic properties which can be accessed through the OPTICS mode a full selfc-consistent calculation is needed.
For this tutorials the **lm**{: style="color: blue"} or  **lmf**{: style="color: blue"} are needed (the same executable as for the self-consistent calculation should be used)..
_____________________________________________________________

### _Tutorial_

#### _Introduction_

The full-optential (FP) and the atomic spherical approximation (ASA) implementations of the code executed through  **lmf**{: style="color: blue"} and  **lm**{: style="color: blue"} respectivily have the capacity to preform a number of equlibrium and non-equlibrim optical and electronic calculations. This tutorial will only focus on the equilibrium calculation for optical properties and the joint density of states (JDOS), non-equlibrium modes will be covered here(HYPERLINKTHIS).

#### _Input File_

Using the optics mode for calculating JDOS or the imaginary part of the complex dielectric function  can be done in two steps. The first step is to include a new category in the control file with associated tokens, an example of what needs to be included for a simple calculation is shown below:

      OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 LTET=3

the category above describes all neccessery information needed to calculate the imaginary part of the complex dielectric function. The tokens above indicate an optics calculation mode 1 which is the imaginary part of the dielectric function, calculated for an energy range of 0-1 Ry (indicated by WINDOW token) with an enegy mesh density of 1001 using the  enhanced tetrahedron integration method (determined through LTET).

#### _Preforming calculations_

To preform this calculation simply add the text above to the ctrl file (in this tutorial we will use **lm**{: style="color: blue"} and GaAs) and invoke:

    lm -vnit=1 ctrl.gas

or equevilantly for the FP implementation

   lmf -vnit=1 ctrl.gas

additional switches are added to restrict the number of iteration to one, it is also recomended to include the switch "--rs=1,0" which will read the saved density from disk but will not update the electron density; this insures that all calculations after self-consistent calculation are preformed on the same density.

#### _Output file_

The output file of the optics mode can vary by mode, for the mode above the file will be named opt.ext, and will contain 4 columns and 1002 rows. The first row contains brief metadat; the columns from left to right are enery value (in Ry), followed by values for the imaginary part of the dielectric function for three orientations of the electric field polarization.

#### _Further Optic Modes_

##### _Imaginary part of the dielectric function_
The optics ppmode=1 used above calculates the dielectric function for the cases of unpolarized spin (GGGGGG) or analytic implementation of SOC(GGGGGG), in the cases of polarized spin or pertubation based implemetation of SOC optics ppmode=1 only calculates Im$\eps$ for spin up, to preform the same calculation for spin down electrons optics ppmode=2 must be used.

##### _Single and Joint Density of States(DOS)_

It is possible to calculate  Single DOS and the Joint DOS (JDOS) through the optics category of the ctrl file. These calculations are preformed by simply using optics ppmode=-1 to -4 for JDOS calculations, and -5 and -6 for density calculations and running the pplm or pplmf as describe for Im$\eps$ calculations above.
The six modes described above correlate to

    ppmode=:
       		-1: generate JDOS, similarly to ppmode=1 this generates complete JDOS in case of unpolarized spins and  ppso=1, otherwise JDOS for spin 1
       		-2: generate JDOS for spin 2, similarly to ppmode=2 this generates JDOS for the second spin  in cases ofpolarized spin and ppso=3
       		-3: generate JDOS between spin 1 and spin 2
       		-4: generate JDOS between spin 2 and spin 1
       		-5: generate single DOS for spin 1
       		-6: generate single DOS for spin 2

The output files for all six optic ppmodes described above  consiste of 2 columns ( the number of rows is optics ppnpts +1), the first of which is energy (in Ry) followed by the corresponding JDOS or DOS values.

#### _Resolving output_
Both pplm and pplmf offer a range of option to resolve Im$\eps$,DOS and JDOS through OPTICS_PART, OPTICS_FILBND and OPTICS_EMPBND, the options described here apply to all of the optic modes described above (Im$\eps$,JDOS and DOS).

##### _Occupied and unoccupied bands_

It is possible to perform any of the optics mode calculations described above for a restricted number of bands, this can greatly speed up the calculation and allow for isolation and identification of individual band contributions. To restric the bands involved in tha calculation simply provide a range of values for occupied and unoccupied bands through OPTICS_PART, OPTICS_FILBND and OPTICS_EMPBND respectively. Below is an example of an optics category which calculates the contribution to  Im$\eps$ from the highest two valence bands and the lowest two conduction bands for silicon:

      OPTICS  MODE=1 NPTS=1001 WINDOW=0 1 LTET=3
              FILBND=7,8 EMPBND=9,10
              
The optics output file generated with restricted bands will have the same name and format as unrestricted band calculations, which has be described previously in this tutorial.
##### _Resolve by k,$\eps$ and band to band contibution_


