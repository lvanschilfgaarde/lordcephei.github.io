### Third QSGW+DMFT tutorial : static spin-averaged+spin-flip loop

This method allows one to extract only the spin-component of the static limit of the impuirty self-energy and add it to the spin-averaged part of the QSGW self-energy. The method provides a way to close the external loop, but instead of doing an update of the density it relies on an (approximate) update of the QSGW self-energy.

We will assume that a converged QSGW and a converged DMFT loop have been done.
Moreover we will assume that the _sigm_ file comes from a spin-unpolarized calculatin (as in tutorial _dmft1_). For more details on how the tutorial changes in case of spin-polarized calculations see below.

To do that you first need to complete a full DMFT loop. You can do it with the _dmft1_ tutorial, for instance. Once you have a converged impurity self-energy, you can follow these steps:
  1.  You run the code *mk_siginp-freq0.py* that interpolate _Sig.inp.out.brd_ to zero frequency (in fact, $$i\omega=0$$ is not part of the Fermionic Matsubara axis, so you need to interpolate the data). The ouytput file _sif.inp.f0_ is the interpolated static limit of the impurity self-energy.
  2.  In the same folder you can launch again **lmfdmft** using exactly the same input (files and flags) as your last run. The program will automatically find the _sig.inp.f0_ and it will embed it and symmetrise it before exiting. The output *sig.inp.f0.emb* is a text file that you can check manually.
  3.  Still in the same folder you can again run **lmfdmft**, adding *--makesigqp* to the command line. This will (i) subtract the average self-energy component to the whole matrix hence keeping only the spin-flip part and (ii) project the resulting matrix in the correct basis. The result will be dumped in the *sigm1.lsco* file which has the right format to be added to the spin-averaged QSGW self-energy.
  An extra step is required here in case of spin=2.
  4.  This can be done by running once more *lmfdmft* adding *--wsig --mixsig=1,1* to the command line. As a result files *sigm.* and *sigm1* are summed together and exported in *sigm2*. This is a new QSGW+DMFT self-energy. 
  5.  The electronic density corresponding to this new self-energy can be obtained by running a normal *lmf* run using sigm2 as sigm and adding to the ctrl file the tag **HAM_BXC0=t**.

### Obtaining a spin-averaged QSGW self-energy
The basic idea of this method is to split the charge contributions to the self-energy (computed via LDA or QSGW) and the magnetic contributions (static spin-flip component of the impurity self-energy). Because of this reason, the QSGW starting point has to be non-magnetic. This can be achieved in two ways.
*  Make a non-magnetic calculation at the QSGW level (**HAM_NSPIN=1**). In this case, the resulting _sigm_ and _rst_ files can be added to the spin-flip component of the impurity self-energy as described above, without any additional manipulation. 
*  A better approach is to perform a magnetic calculation (**HAM_NSPIN=2**) and to extract only the spin-averaged components of both the self-energy _sigm_ and the density _rst_. To do this, one has to initialise the DMFT cycle with spin-averaged quantities.
   Once this is done, the averaged _sigm_ file has only one spin channel. For this to be added to the spin-flip component of the impurity self-energy, one has to double the spin channel. This is done by setting **HAM_NSPIN=2** and launching **lmf** with '--wsig' flag. 

### Converting 1-spin to 2-spin self-energies
