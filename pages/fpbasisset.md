---
layout: page-fullwidth
title: "LM Suite - Full Potential LDA Basis Set"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/tutorial/lmf/fpbasisset/"
header: no

---

To go back to the preliminaries click [here](/fpnew/).

*   You can make the basis most optimal by minimizing the total energy with respect to all parameters RSMH and EH. You can in fact do so as explained in [this tutorial](FPoptbas.html). But experience has shown that energies are usually rather insensitive to EH and anyway, for theoretical reasons, EH should not be too negative. In practice you can optimize RSMH efficiently, and it is not necessary to to more. Do this with:

        lmf al --optbas 

    You should find that the optimization reduced the Harris Foulkes energy from ehf=-0.2924 to ehf=-0.2926 Ry. This difference is too small to bother with. Usually the improvement is subtsantially larger, and you take the result of the optimized calculation (saved in basp2._ext_) and copy them to your input file. Or, you can have lmf automatically read these parameters from file basp; tokens in HAM_AUTOBAS control what **lmf** reads from this file, and what **lmfa** writes to it. See [this tutorial](Building_FP_input_file.html#autobas) for an example.

*    We might consider the effect of enlarging the basis, which as we noted we can do from the commmand line with -vbigbas=1. Do this:

        lmf al -vbigbas=1 -vhf=1 

    and you will see that the HF energy is now ehf=-.2943: the additional basis improves the energy by 1.9mRy in this case, again probably too small to worry about.

To go back to the preliminaries click [here](/fpnew/).
