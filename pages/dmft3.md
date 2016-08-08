### Third QSGW+DMFT tutorial : static spin-averaged+spin-flip loop

The idea of this method is to extract only the spin-component of the static limit of the impuirty self-energy and add it to the spin-averaged part of the QSGW self-energy. The method provides a way to close the external loop instead of doing an update of the density, but updating directly the QSGW self-energy.

To do that you first need to complete a full DMFT loop. You can do it with the _dmft1_ tutorial, for instance. Once you have a converged impurity self-energy, you can follow these steps:
1.  You run the code *mk_siginp-freq0.py* that interpolate _Sig.inp.out.brd_ to zero frequency (in fact, $$i\omega=0$$ is not part of the Fermionic Matsubara axis, so you need to interpolate the data). The ouytput file _sif.inp.f0_ is the interpolated static limit of the impurity self-energy.
2.  In the same folder you can launch again **lmfdmft** using exactly the same input (files and flags) as your last run. The program will automatically find the _sig.inp.f0_ and it will embed it and symmetrise it before exiting. The output *sig.inp.f0.emb* is a text file that you can check manually.
3.  Still in the same folder you can again run **lmfdmft**, adding *--makesigqp* to the command line. This will (i) subtract the average self-energy component to the whole matrix hence keeping only the spin-flip part and (ii) project the resulting matrix in the correct basis. The result will be dumped in the *sigm1.lsco* file which has the right format to be added to the spin-averaged QSGW self-energy.
4.  This can be done by running once more *lmfdmft* adding *--wsig --mixsig=1,1* to the command line. As a result files *sigm.* and *sigm1* are summed together and exported in *sigm2*. This is a new QSGW+DMFT self-energy.
5.  The electronic density corresponding to this new self-energy can be obtained by running a normal *lmf* run using sigm2 as sigm and adding to the ctrl file the tag **HAM_BXC0=t**.

### Obtaining a spin-averaged QSGW self-energy

### Converting 1-spin to 2-spin self-energies
