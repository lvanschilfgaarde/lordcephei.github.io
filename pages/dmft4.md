---
layout: page-fullwidth
title: "Fourth tutorial on QSGW+DMFT"
permalink: "/tutorial/qsgw_dmft/dmft4/"
sidebar: "left"
header: no
---

# Charge + static-magnetic contributions 

This method is a way to close the outer loop in a QSGW+DMFT or LDA+DMFT calculation, but instead of relying on an update of the density it actually relies on an (approximate) update of the exchange-correlation potential (either $$V^{\rm LDA}_{\rm xc}$$ or $$V^{\rm QSGW}_{\rm xc}$$.
The underlying assumption is that charge-charge excitations are well described by the low-level technique (QSGW or LDA), while magnetic excitations (computed with DMFT) can be well approximated by a static field. Then the idea is to extract only the magnetic component of the static limit of the impuirty self-energy and add it to the spin-averaged part of the lattice exchange-correlation potential $$V_{\rm xc}$$.

### Extracting the charge component from LDA/QSGW
As recommended in the [first tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1), either QSGW or LDA calculations must be spin-resolved (**HAM_NSPIN=2**). The former generates a _sigm_{: style="color: green"}, while the latter does not.

To extract the charge components, things have already been set up in the [first tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft1), where we have taken the spin-average part of the *sigm.ni*{: style="color: green"} file and we have edited the *ctrl.ni*{: style="color: green"} to be able to assign **HAM_BXC0=True** through the command **-vbxc0=1**{: style="color: blue"}.

These two things together make the (QSGW or LDA) Hamiltonian effectively spin-unresolved (you can check that the magnetic moment is null by **grep Mag. log**{: style="color: blue"}.

### Extracting the static magnetic component from DMFT
You have performed a full DMFT loop whith **HAM_NSPIN=2** (see variables and line command used in the [second tutorial](https://lordcephei.github.io/tutorial/qsgw_dmft/dmft2)). Once converged, you have to extract the static magnetic component from your last _Sig.out.brd_{: style="color: green"}.

```
mkdir sigfreq0
cp ../lmfinput/*.ni  sigfreq0
cp ../itN_qmcrun/Sig.out.brd sigfreq0/sig.inp              # copy converged Sig.out.brd file 
cd sigfreq0
ln -sf sig.inp Sig.out.brd                                 # mk_siginp-freq0.py looks for Sig.out.brd
python mk_siginp-freq0.py                                  # 1. interpolate Sig.out.brd to zero frequency
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1                   # 2. embed+symmetrise sig.inp.f0 to sig.inp.f0.emb
lmfdmft ni --ldadc=71.85 -job=1 -vbxc0=1 --makesigqp       # 3. write sig.inp.f0.emb on quasiparticle basis sigm1.ni
```
<div onclick="elm = document.getElementById('statmag'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">More details - Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="statmag">{:/}

1. First interpolate _Sig.inp.out.brd_{: style="color: green"} to zero frequency. You can use the program **mk_siginp-freq0.py**{: style="color: blue"} downloadable at [this link](https://lordcephei.github.io/assets/download/inputfiles/mk_siginp-freq0.py). The output file _sif.inp.f0_{: style="color: green"} is the static limit of the impurity self-energy (you can check the quality of the extrapolation by plotting *Sig.out.brd*{: style="color: green"} and *Sig.out.brd.extrap*{: style="color: green"}).

2. In the same folder, you can launch **lmfdmft**{: style="color: blue"} using exactly the same input (files and flags) as your last run. The program will automatically find _sig.inp.f0_{: style="color: green"}, it will embed it and symmetrise it before exiting. The output *sig.inp.f0.emb*{: style="color: green"} is a text file. 
You should find the line
 
  ```
  Exit 0 File sig.inp.f0 embedded successfully and recorded in sig.inp.f0.emb
  ```

  at the bottom of the *log*{: style="color: green"} file.

3. Still in the same folder you can run again **lmfdmft**{: style="color: blue"}, adding **\-\-makesigqp**{: style="color: blue"} to the command line. This will
  * subtract the average self-energy component to the whole matrix hence keeping only the magnetic part and
  * project the resulting matrix in the quasiparticle basis.
The result will be saved in the *sigm1.ni*{: style="color: green"} file. 
You should have the line 

  ```
  Exit 0 wrote embedded sigma (orbital basis) to file sigm1
  ```

  at the bottom of the *log*{: style="color: green"} file.

{::nomarkdown}</div>{:/}

 
### Adding charge and static-magnetic components 
You now have a static magnetic-only potential produced by DMFT. This has to be added to the charge-only (LDA or QSGW) potential.

``` 
lmf ni --wsig --mixsig=1,1   # add sigm and sigm1 to get sigm2   
```

As a result files *sigm.ni*{: style="color: green"} and *sigm1.ni*{: style="color: green"} are summed together and exported in *sigm2.ni*{: style="color: green"}. This is a new $$V_{\rm xc}$$ that can be fed to **lmf**{: style="color: blue"} to get a new magnetic starting point for a DMFT loop.
