# Third QSGW+DMFT tutorial : static spin-averaged+spin-flip method

This method is a way to close the outer loop (density loop) in a QSGW+DMFT or LDA+DMFT calculation, but instead of doing an update of the density it actually relies on an (approximate) update of the self-energy.
The assumption behind this method is that charge-charge excitations are well described by the low-level technique (QSGW, LDA or LSDA), while magnetic excitations have to be computed within DMFT, although their effect can be well approximated by a static field. The idea is then to extract only the spin-component of the static limit of the impuirty self-energy and to add it to the spin-averaged part of the lattice calculation (QSGW, LDA or LSDA).

### Extracting the charge component
The underlying lattice problem can be solved in basically two ways: QSGW or LDA. In either case, the calculation can be done non-magnetic (**HAM_NSPIN=1**) or magnetic (**HAM_NSPIN=2** ; in this case we reather speak of LSDA). The QSGW calculations generate a _sigm_, while the L(S)DA calculations do not.

Before starting the DMFT loop, one has to extrac the charge component from the low-level calculation. This has to be done for the density and, if you perform a QSGW calculation, for the self-energy.
* LDA (NSPIN=1) calculation:
   Your calculation is spin-unpolarized and you don't have any self-energy. You can initialise and run the DMFT loop without manipulating the LDA result.
* LSDA (NSPIN=2) calculation: 
   In this case you are doing a spin-polarized calculation but you don't have any self-energy. You have to average out only the spin components of the density. To do that you run interactively **lmf** with the flag '--rsedit'. Then, when asked, you type
   ~~~
   rs              # this enables the editing of rst file 
   set all 1 zers  # this averages out the spin-flip components
   savea           # saves the averaged density in Ascii formatted rsta file. Check how to read it from the manual (--rs flag) 
   q               # quits the editing session
   ~~~
* QSGW spin unpolarized (NSPIN=1) calculation: 
   Your calculation is spin-upolarized but produces a _sigm_ file. You can initialise and run the DMFT loop without manipulating the QSGW results. 
* QSGW spin polarized (NSPIN=2) calculation: 
   You have to average out the spin component of both the density and the self-energy. To average the density you can follow the instructions given for the LSDA calculation.
   To average the spin components of the _sigm_ file you just need to run **lmf** with the flat '--wsig:onesp'. Note that the output file _sigm2_ is now formatted as if it was produced by a NSPIN=1 calculation. This will require some manipulation at the end of the DMFT loop when the charge and the spin-flip components will be summed together.

### Extracting the static spin-flip component
Using the charge-only density and self-energy, you have performed a full DMFT loop whith NSPIN=2. Once converged, you have to extract the static spin-flip component from the converged _Sig.out.brd_.
  1.  You run the code *mk_siginp-freq0.py* that interpolates _Sig.inp.out.brd_ to zero frequency (in fact, $$i\omega=0$$ is not part of the Fermionic Matsubara axis, so you need to interpolate the data). The ouytput file _sif.inp.f0_ is the interpolated static limit of the impurity self-energy.
  2.  In the same folder you can launch again **lmfdmft** using exactly the same input (files and flags) as your last run. The program will automatically find the _sig.inp.f0_ and it will embed it and symmetrise it before exiting. The output *sig.inp.f0.emb* is a text file.
  3.  Still in the same folder you can again run **lmfdmft**, adding *--makesigqp* to the command line. This will
     * subtract the average self-energy component to the whole matrix hence keeping only the spin-flip part and
     * project the resulting matrix in the correct basis.
    The result will be saved in the *sigm1.lsco* file.
  

### Adding charge and magnetic channels
You now have a static spin-flip only self-energy produced by DMFT. This has to be added to either a charge-only L(S)DA potential or to a charge-only QSGW self-energy.
* LDA and LSDA calculations: 
    you don't need any manipulation of the L(S)DA data. 
* QSGW calculations: 
    Irrespectively to the origin of your _sigm_ file (NSPIN=1 or spin-averaged NSPIN=2), the latter is formatted as a NSPIN=1  self-energy. So first you have to run **lmfdmft** with the flag --wsig and NSPIN=2 to convert it in a NSPIN=2 format (you can check with ls -sh).
    Then you run once more *lmfdmft* adding *--wsig --mixsig=1,1* to the command line. As a result files *sigm.* and *sigm1* are summed together and exported in *sigm2*. This is a new QSGW+DMFT self-energy.
Once you are done, you can close finally the loop by running one **lmf** calculation with the tag **HAM_BXC0=t** and **HAM_NSPIN=2** added to the _ctrl_ file. This flag forces the LDA exchange-correlation potential to be computed from a spin-averaged density.
At the end you will end up with a new solution of the lattice problem and you can start a new DMFT loop. 
