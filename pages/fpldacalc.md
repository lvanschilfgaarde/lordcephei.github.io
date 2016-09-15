---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA Calculations"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/fpldacalc/"
header: no

---

In the [preliminaries](/fpnew/) we built a trial density with a Mattheis construction, and made a band pass with it. Now we can do a self-consistent calculation

        lmf al > out 

Up to the calculation of the Fermi level [Fermi level](FPsamples/out.al.lmf#efermi) the output will be essentially the same.

Now the [output density](FPsamples/out.al.lmf#outrho) is generated. With the output density, the HKS energy functional can be evaluated. Also the log derivative parameters P are floated to the band centers-of-gravity. How the P's are floated is prescribed by tokens [IDMOD](tokens.html#SPECcat); there is a corresponding ASA counterpart discussed in the [ASA overview](lmto.html#section2).

A [new density](FPsamples/out.al.lmf#mixrho) is constructed as follows:

*    The _output density_ is screened using the model Lindhard function, provided the Lindhard parameter [ELIND](tokens.html#HAMcat) is nonzero:

        $$ n_{out}^{\star} = n_{in}  + \epsilon^{-1} (n_{out}-n_{in}) $$

*    An estimate for the self-consistent density is made by mixing n<sub>in</sub> and n<sub>out</sub>* using some [mixing scheme](tokens.html#mixing) .*   The resultant density is [saved](FPsamples/out.al.lmf#iors) in rst._ext_, unless you specify otherwise using [--rs=](Command-line-options.html#section1lmf).*   At the end of the iteration, the total energies are printed and checks are made whether self-consistency is achieved to tolerances specified by [ITER_CONV](tokens.html#ITERcat) and [ITER_CONVC](tokens.html#ITERcat). The RMS DQ generated at the [mixing step](FPsamples/out.al.lmf#mixrho) is the measure compared against tolerance [CONVC](tokens.html#ITERcat); the change in energy from one iteration to the next is tested against tolerance [CONV](tokens.html#ITERcat). Both tolerances must be satisfied, unless you set CONV=0 or CONVC=0 (0 tolerance tells **lmf** not to test that parameter). Since only one iteration has been completed [so far](FPsamples/out.al.lmf#endofiter1), there is no way to test the CONV, so no tests are made. **lmf** proceeds without checks to the second iteration; from the [second iteration](FPsamples/out.al.lmf#endofiter2) onwards convergence checks are made.   

     Because Al is rather well approximated by free electron gas, the Lindhard function is an excellent approximation to the true dielectric function, and the iterations converge rapidly to self-consistency. However, because the tolerances were set [very small](#mix), self-consistency is achieved only after [six iterations](FPsamples/out.al.lmf#endofiter6). To see how the RMS DQ evolves, do

        grep 'RMS DQ' out 

     You should see a table like this:

        mixrho:  sought 3 iter from file mixm; read 0\.  RMS DQ=8.57e-3
        mixrho:  sought 3 iter from file mixm; read 1\.  RMS DQ=5.48e-4  last it=8.57e-3
        mixrho:  sought 3 iter from file mixm; read 2\.  RMS DQ=1.29e-4  last it=5.48e-4
        mixrho:  sought 3 iter from file mixm; read 3\.  RMS DQ=6.44e-6  last it=1.29e-4
        mixrho:  sought 3 iter from file mixm; read 4\.  RMS DQ=4.24e-7  last it=6.44e-6
        mixrho:  sought 3 iter from file mixm; read 4\.  RMS DQ=4.97e-8  last it=4.24e-7
        

     The code calculates two energy functionals, the Hohenberg-Kohn and Harris-Foulkes functional. Both energies printed at the end of each iteration. The HF energy is more binding than the HK after the [first iteration](FPsamples/out.al.lmf#endofiter1); at [self-consistency](FPsamples/out.al.lmf#endofiter5) they are the same. The HK energy is variational; it should approach the self-consistent value from above. Usually (but not always) the HF energy approaches it from below. Thus the difference in the two is an additional measure of deviation from self-consistency. Moniter the convergence the two with:

        grep ehf=- out 

    You should see the following table:

        h ehf=-.2923995 ehk=-.2897842
        i ehf=-.2905176 ehk=-.2903167
        i ehf=-.2904201 ehk=-.2904115
        i ehf=-.2904344 ehk=-.2904343
        i ehf=-.2904324 ehk=-.2904322
        c ehf=-.2904324 ehk=-.2904322
        

    The HF and HK energy functionals are completely different; that they converge to (nearly) the same answer is a test of the validity of the implementation.

    These lines are also written to the [save file](lmto.html#section5); a very convenient tool [vextract](Building_FP_input_file.html#vextract) is designed to be used with it, as can be seen when evaluating the [shear constant](#shearconstant) below.

    To go back to the preliminaries click [here](/fpnew/).
