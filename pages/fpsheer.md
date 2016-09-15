---
layout: page-fullwidth
title: "LM Suite - "
subheadline: ""
showmeta: false
teaser: ""
permalink: "/tutorial/lmf/fpsheer/"
header: no

---

This section shows how to calculate two of the three independent shear constants in Al. We first calculate _c_11− _c_12, which we will do by computing the total energy at different lattice distortions, and fitting the curvature of the total energy. The tetragonal distortion is conveniently generated using the line

        SHEAR=0 0 1 1+dist 

which distorts the lattice in a way that conserves volume to all orders (this is useful because it tends to be less error-prone). The direction of distortion is set by the first three parameters; the lattice will be sheared along (001).

The first difficulty is that our specification of the FT mesh using token GMAX may cause the program to switch meshes for as parameter _dist_ changes. This is a bad idea, since we want to resolve very small energy differences. So, the first step is to comment out the line with GMAX=gmax in the input and use instead:

        FTMESH=10 10 10 

The second difficulty is that the shear constants in Al are difficult to converge, because they require many _k_-points. The following steps are written in 'tcsh' and compute the self-consistent total energy parameterically as a function of 'dist':

           rm -f out save.al
           foreach x ( -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04)
               rm -f mixm.al wkp.al
               lmf al -vdist=$x -vnk=24 --pr20,20 >>out
           end
        
Note that the mixing file eigenvalue weights file (mixm.al and wkp.al) are deleted for each new shear calculation. File save.al contains total energies ehf for 9 values of dist using 24 divisions of k-points. (To properly converge the calculation use nk=32 or even nk=40.)

Extracting ehf and ehk parametrically as a function of dist is very easy with the [vextract](Building_FP_input_file.html#vextract) tool:

        cat save.al | startup/vextract c dist ehf > dat 

The key 'c' tells vextract that you want lines beginning only with 'c': these lines correspond to band passes when [self-consistency](Building_FP_input_file.html#vextract) was reached. You can use any regular expression for the key. You can ask vextract to extract any quantity associated with a variable in the file.

File  `dat'  should look something very nearly like:

          -.04 -.2901536
          -.03 -.290358
          -.02 -.2904993
          -.01 -.2905869
             0 -.2906165
           .01 -.2905871
           .02 -.2905041
           .03 -.2903603
           .04 -.2901537

Fitting a sixth-order polynomial through these points, we obtain as the second derivative of ehf with respect to dist:

        E'' = .578 Ry 

With a little algebra, and converting from atomic Ry units to ergs/cm3 it is easy to show that

        vol = a^3/4 = 110 a.u.
        1Ry/a0^3 = 147e12 erg/cm^3
        c11-c12  = (2/3*147/vol)*E'' (10^12 erg/cm^3)
                 = 0.514 x 10^12 erg/cm^3
        

which is 6% less than the experimental 0K value, 0.55 × 1012 erg/cm3.

A trigonal shear will yield _c_44. To compute it, replace the SHEAR token with:

        SHEAR=1 1 1 1+dist 

Now the lattice is sheared along the [111] direction. Repeat the preceding command sequence with this substitution, and you should find file  `dat'  looking something very nearly like:

          -.04 -.2900159
          -.03 -.2902898
          -.02 -.2904768
          -.01 -.2905849
             0 -.2906164
           .01 -.2905768
           .02 -.2904718
           .03 -.2902827
           .04 -.290012
        
Fitting a sixth-order polynomial through these points, we obtain as the second derivative of ehf with respect to dist:

        E'' = .684 Ry 

In this case,

        c44 = (1/3*147/vol)*E'' (10^12 erg/cm^3)
            = 0.304 x 10^12 erg/cm^3
        
which is about 6% smaller than the extrapolation to 0K of the experimental value, 0.32 × 1012 erg/cm3. Both of these elastic constants depend on the fitting procedure with an uncertainty of about 5%. A careful calculation would use more points dist and increase nk. The final shear constant, the bulk modulus, you can calculate by varying the lattice constant. We do not do it here, but if you do this, you are advised to use token STRUC_DALAT, rather than change ALAT (see the following note).

_Note:_ [doc/FPsamples/ctrl.al](FPsamples/ctrl.al) includes a token DALAT, which it sets to 0\. The actual lattice constant is ALAT+DALAT. Do it this way because some parameters change with ALAT, but are kept frozen when DALAT varies. A calculation of _B_ yields 0.85× 1012 erg/cm3 when evaluated at the LDA mininum energy lattice constant (7.53 a.u., about 1% smaller than the experiment), and 0.72 × 1012 erg/cm3 when evaluated at the experimental lattice constant. Because the lattice constant is slightly wrong there is an ambiguity as to which value is appropriate to compare against experiment. The experimental value extrapolated to 0K is 0.81× 1012 erg/cm3.
