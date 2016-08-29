---
layout: page-fullwidth
title: "lmgf Tutorial"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/lmgf-tutorial/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc} 

### _Purpose_

This package implements the ASA local spin-density approximation using Green's functions. The Green's functions are contructed by approximating KKR multiple-scattering theory with an analytic potential function. The approximation to KKR is essentially similar to the linear approximation employed in band methods such as LMTO and LAPW. It can be shown that this approximation is nearly equivalent to the LMTO hamiltonian without the "combined correction" term. With this package a new program, lmgf is added to the suite of executables. lmgf plays approximately the same role as the LMTO-ASA band program lm: a potential is generated from energy moments Q0, Q1, and Q2 of the density of states. in the same way as the lm code. You can use lmgf to make a self-consistent density as you can do with lm. lmgf is a Green's function method: Green's functions have less information than wave functions, so in one sense the things you can do with lmgf are more limited: you cannot make the bands directly, for example. However lmgf enables you do do things you cannot do with lm. The two most imprortant are:

+ Calculate magnetic exchange interactions (essentially the static magnetic susceptibility)
+ Calculate properties of disordered materials, either chemically disordered or spin disorder from finite temperature, within the Coherent Potential Approximation, or CPA.
+ Calculate the ASA static susceptibility at q=0 to help converge calculations to self-consistency. 

### _lmgf vs lm_

### _Tutorial_
