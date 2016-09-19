---
layout: page-fullwidth
title: "Fourth tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft4/"
sidebar: "left"
header: no
---

# Charge + static-magnetic contributions 

This method is a way to close the outer loop in a QSGW+DMFT or LDA+DMFT calculation, but instead of relying on an update of the density it actually relies on an (approximate) update of the self-energy.
The assumption behind this method is that charge-charge excitations are well described by the low-level technique (QSGW, LDA or LSDA), while magnetic excitations have to be computed within DMFT, although their effect can be well approximated by a static field. The idea is then to extract only the spin component of the static limit of the impuirty self-energy and to add it to the spin-averaged part of the lattice exchange-correlation potential $$V_{\rm xc}$$ (obtained in QSGW or LSDA).

### Extracting the charge component
The underlying lattice problem can be solved in basically two ways: QSGW or LDA. As recommended in the [first tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1), either calculation must be spin-resolved (**HAM_NSPIN=2**). The QSGW calculation generates a _sigm_{: style="color: green"}, while the LDA calculation does not.

To extract the charge components, things have already been set up in the [first tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1), where we have taken the spin-average part of the *sigm.ni*{: style="color: green"} file and we have edited the *ctrl.ni*{: style="color: green"} to assign **HAM_BXC0=True** through the command **-vbxc0=1**{: style="color: blue"}.

### Extracting the static spin-flip component
Using the charge-only density and self-energy, you have performed a full DMFT loop whith **HAM_NSPIN=2** (see variables and line command used in the [second tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft2)). Once converged, you have to extract the static spin-flip component from your last _Sig.out.brd_{: style="color: green"}.

1. You interpolates _Sig.inp.out.brd_{: style="color: green"} to zero frequency. You can use the program **mk_siginp-freq0.py**{: style="color: blue"} downloadable at [this link](???). The ouytput file _sif.inp.f0_{: style="color: green"} is the static limit of the impurity self-energy.
2. In the same folder, you can launch **lmfdmft**{: style="color: blue"} using exactly the same input (files and flags) as your last run. The program will automatically find _sig.inp.f0_{: style="color: green"}, it will embed it and symmetrise it before exiting. The output *sig.inp.f0.emb*{: style="color: green"} is a text file.
3. Still in the same folder you can run again **lmfdmft**{: style="color: blue"}, adding **- -makesigqp**{: style="color: blue"} to the command line. This will
  * subtract the average self-energy component to the whole matrix hence keeping only the spin-flip part and
  * project the resulting matrix in the correct basis.
The result will be saved in the *sigm1.ni*{: style="color: green"} file.

```
python mk_siginp-freq0.py                                  # 1. interpolate Sig.out.brd to zero frequency
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1                   # 2. embed+symmetrise sig.inp.f0 to sig.inp.f0.emb
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1 --makesigqp       # 3. write sig.inp.f0.emb on quasiparticle basis sigm1.ni
```
  
### Adding charge and magnetic channels
You now have a static magnetic-only self-energy produced by DMFT. This has to be added to the charge-oly LDA/QSGW potentials.

``` 
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1 --makesigqp --wsig --mixsig=1,1   # add sigm and sigm1 to get sigm2   
```

As a result files *sigm.ni*{: style="color: green"} and *sigm1.ni*{: style="color: green"} are summed together and exported in *sigm2.ni*{: style="color: green"}. This is a new $$V_{\rm xc}$$ that can be fed to **lmf**{: style="color: blue"} to restart a QSGW+DMFT cycle.
