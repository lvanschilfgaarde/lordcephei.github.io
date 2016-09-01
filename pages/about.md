---
layout: page-fullwidth
title: "About"
permalink: "/about/"
header:
    image_nologo: "banner_grey.jpg"
---

The *Questaal Suite* offers a range of first principles programs that can be used to model different materials and nanoscale structures. The common basis of these codes is the use of a linear muffin tin orbital basis (LMTO) set to describe the electronic structure of the different materials. These orbitals are expanded in terms of the angular momentum index around each atom and can be considered crystal extensions of atomic orbitals.

Applications include modeling electronic structure, magnetic properties of materials, electronic transport, impurity effects in solids, and optical properties of materials.

Packages distributed in the Questaal package include:

+ **Full Potential LMTO:**   This is an all-electron implementation of density-functional theory using atom-centered functions as a basis set.  These functions have their genesis in the Linear Muffin Tin Orbitals basis of Ole K
A highly accurate tight-binding form will soon be available, with the moniker "Jigsaw Puzzle Orbitals." 

The constraints associated with the ASA approximation have led to research into techniques thatmove beyond the muffin tin boundaries. This has led to different full potential approaches that allow systems with large regions of open space to be calculated with confidence. The LM Suite provides a full potential approach based on Hankel functions which can be used for a wide range of systems. However, while computational accuracy is increased,the computational expense of the calculation also increases.



+ **LMTO-ASA:** In typical LMTO calculations under the atomic sphere approximation (ASA), crystals are divided up into regions (muffin tins) around each atom where the LMTO basis is expanded and interstitial or free space regions outside of the muffin tins. One of the main challenges in this approach is insuring that the wave functions and their derivatives are continuous at the muffin tin boundaries. LMTO-ASA calculations depend on the fact that the system is close-packed and can be described as a collection of slightly overlapping atomic spheres. Since LMTO approaches rely on localized orbitals, it is essential that the muffin tin regions describe most if not all of the space in the system. The LMTO-ASA approach produces a compact basis set that leads to efficient calculations with speeds that rival those found in empirical tight-bindingapproaches. A non-collinear ASA package is also available.

+ **GF LMTO Approach:**  A program based on a Green’s function description of materials is also available in the LM Suite.
The program, lmgf, calculates the Green’s function for a system in the LMTO basis and uses this information to
determine a range of properties including the density of states, band structure, and magnetic moment.
Principle Layer Green Function LMTO Approach  LMPG is based on a Green’s function description of materials and is
ideally suited for examining the properties of multilayer systems or nanoscale devices between contacts. In this
code, the system is divided up into three regions, two contacts and a central device region. The two contact regions
are taken to extend to infinity in the positive and negative z directions, respectively. The device region is
divided up into a series of layers where only nearest neighbor interactions between layers are considered. Green’s
function approaches are a natural choice for transport calculations since the information on the contacts can be
incorporated into the Hamiltonian for the device region through an additional self energy term. The lmpg code has
been used to examine transport in devices ranging from magnetic tunnel junctions to atomic point contacts.

+ **QSGW:**   LM Suite also has the ability to perform quasiparticle self-consistent GW calculations. Unlike standard
density functional calculations that underestimate the band gap of a material, this approach can describe the optical
properties for a wide range of materials.
