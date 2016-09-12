---
layout: page-fullwidth
title: "Symmetry Line Files"
permalink: "/docs/input/symfile/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
_____________________________________________________________
This page serves as a source for a possible symmetry-line files, as found in "Computational Materials Science 49, 299 (2010)".

### _Cubic (CUB) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.cub_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('cub'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="cub">{:/}

~~~
# Run with --band~mq~...
# cub lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec M[3] 1/2   1/2 0               # M
% vec R[3] 1/2 1/2 1/2               # R
% vec X[3] 0   1/2  0               # X

# Sequence G-X-M-G-R-X-R
11 {G}  {X}      G to X
11 {X}  {M}      X to M
11 {M}  {G}      M to G
11 {G}  {R}      G to R
11 {R}  {X}      R to X
11 {X}  {R}      X to R
~~~

{::nomarkdown}</div>{:/}

### _Face-centered Cubic (FCC) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.fcc_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('fcc'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="fcc">{:/}

~~~
# Run with --band~mq~...
# fcc lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec M[3] 1/2   1/2 0               # M
% vec R[3] 1/2 1/2 1/2               # R
% vec X[3] 0   1/2  0               # X

# Sequence G-X-M-G-R-X-R
11 {G}  {X}      G to X
11 {X}  {M}      X to M
11 {M}  {G}      M to G
11 {G}  {R}      G to R
11 {R}  {X}      R to X
11 {X}  {R}      X to R
~~~

{::nomarkdown}</div>{:/}

### _Body-centered Cubic (BCC) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.bcc_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('bcc'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="bcc">{:/}

~~~
# Run with --band~mq~...
# bcc lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec H[3] 1/2 -1/2 1/2              # H
% vec P[3] 1/4 1/4 1/4               # P
% vec N[3] 0   0  1/2                # N

# Sequence G-H-N-G-P-H-N
11 {G}  {H}      G to H
11 {H}  {N}      H to N
11 {N}  {G}      N to G
11 {G}  {P}      G to P
11 {P}  {H}      P to H
11 {H}  {N}      H to N
~~~

{::nomarkdown}</div>{:/}

### _Tetragonal (TET) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.tet_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('tet'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="tet">{:/}

~~~
# Run with --band~mq~...
# tet lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec A[3] 1/2 1/2 1/2               # A
% vec M[3] 1/2 1/2 0                 # M
% vec R[3] 0   1/2  1/2              # R
% vec X[3] 0   1/2 0                 # X
% vec Z[3] 0   0  1/2                # Z

# Sequence G-X-M-G-Z-R-A-X-R-A
11 {G}  {X}      G to X
11 {X}  {M}      X to M
11 {M}  {G}      M to G
11 {G}  {Z}      G to Z
11 {Z}  {R}      Z to R
11 {R}  {A}      R to A
11 {A}  {X}      A to X
11 {X}  {R}      X to R
11 {R}  {A}      R to A
~~~

{::nomarkdown}</div>{:/}

### _Body-centered Tetragonal 1 (BCT1) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.bct1_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('bct1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="bct1">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c, for bct lattice, c<a
# Run with --band~mq~...
# bct2 lattice is taken from Computational Materials Science 49, 299 (2010)

# R.S. Lattice vectors are: (units of a)
# -1/2  1/2   0               P1
#  1/2 -1/2   0               P2
#  1/2  1/2  1/2*cbya         P3
% const eta=(1+cbya*cbya)/4
% vec G[3] 0   0   0                   # G
% vec M[3] -1/2 1/2 1/2                # M
% vec N[3] 0   1/2   0                 # N
% vec P[3] 1/4   1/4   1/4             # P
% vec X[3] 0   0  1/2                  # X
% vec Z[3] {eta} {eta} -{eta}          # Z
% vec Z1[3] -{eta} 1-{eta} {eta}       # Z1

# Sequence G-X-M-G-Z-P-N-Z1-X-P
11 {Z}  {G}      Z to G
11 {G}  {X}      G to X
11 {X}  {M}      X to M
11 {M}  {G}      M to G
11 {G}  {Z}      G to Z
11 {Z}  {P}      Z to P
11 {P}  {N}      P to N
11 {N}  {Z1}     N to Z1
11 {Z1}  {X}     Z1 to X
11 {X}  {P}      X to P
~~~

{::nomarkdown}</div>{:/}

### _Body-centered Tetragonal 2 (BCT2) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.bct2_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('bct2'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="bct2">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c, for bct lattice, c>a
# Run with --band~mq~...
# bct2 lattice is taken from Computational Materials Science 49, 299 (2010)

# R.S. Lattice vectors are: (units of a)
# -1/2  1/2   0               P1
#  1/2 -1/2   0               P2
#  1/2  1/2  1/2*cbya         P3
% const eta=(1+1/cbya/cbya)/4 zeta=1/2/cbya/cbya
% vec G[3] 0   0   0                 # G
% vec N[3] 0   1/2 0                 # N
% vec P[3] 1/4 1/4 1/4               # P
% vec X[3] 0   0   1/2               # X
% vec S[3] -{eta} {eta} {eta}        # Sigma
% vec Y[3] -{zeta} {zeta} 1/2        # Y
% vec Z[3] 1/2 1/2 -1/2              # Z

# Sequence Z-G-X-N
11 {Z}  {G}      Z to G
11 {G}  {X}      G to X
11 {X}  {N}      X to N
~~~

{::nomarkdown}</div>{:/}

### _Orthorhombic (ORC) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orc_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orc'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orc">{:/}

~~~
# Run with --band~mq~...
# orc lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                   # G
% vec R[3] 1/2 1/2 1/2                 # R
% vec S[3] 1/2 1/2   0                 # S
% vec T[3] 0  1/2   1/2                # T
% vec U[3] 1/2   0  1/2                # U
% vec X[3] 1/2   0  0                  # X
% vec Y[3] 0   1/2  0                  # Y
% vec Z[3] 0   0    1/2                # Z

# Sequence G-X-S-Y-G-Z-U-R-T-Y-U-S-R
11 {G}  {X}      G to X
11 {X}  {S}      X to S
11 {S}  {Y}      S to Y
11 {Y}  {G}      Y to G
11 {G}  {Z}      G to Z
11 {Z}  {U}      Z to U
11 {U}  {R}      U to R
11 {R}  {T}      R to T
11 {T}  {Y}      T to Y
11 {Y}  {U}      Y to U
11 {U}  {S}      U to S
11 {S}  {R}      S to R
~~~

{::nomarkdown}</div>{:/}

### _Face-centered Orthorhombic 1 (ORCF1) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orcf1_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orcf1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orcf1">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c, for orcf 1/a^2 > 1/b^2 + 1/c^2
# Run with --band~mq~...
# orcf1 lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 + 1/cbya/cbya + 1/bbya/bbya)/4 zeta=(1 + 1/bbya/bbya - 1/cbya/cbya)/4
% vec G[3] 0   0   0                   # G
% vec A[3] 1/2 1/2+zeta zeta           # A
% vec A1[3] 1/2 1/2-zeta 1-zeta        # A1
% vec L[3] 1/2  1/2   1/2              # L
% vec T[3] 1    1/2   1/2              # T
% vec X[3] 0    eta   eta              # X
% vec X1[3] 1   1-eta  1-eta           # X1
% vec Y[3] 1/2   0    1/2              # Y
% vec Z[3] 1/2   1/2    0              # Z

# Sequence G-Y-T-Z-G-X-A1-T-X-A-L-G
11 {G}  {Y}      G to Y
11 {Y}  {T}      Y to T
11 {T}  {Z}      T to Z
11 {Z}  {G}      Z to G
11 {G}  {X}      G to X
11 {X}  {A1}     X to A1
11 {A1}  {T}     A1 to T
11 {T}  {X}      T to X
11 {X}  {A}      X to A
11 {A}  {L}      A to L
11 {L}  {G}      L to G
~~~

{::nomarkdown}</div>{:/}

### _Face-centered Orthorhombic 2 (ORCF2) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orcf2_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orcf2'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orcf2">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c, for orcf 1/a^2 < 1/b^2 + 1/c^2
# Run with --band~mq~...
# orcf2 lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 + 1/bbya/bbya - 1/cbya/cbya)/4 delta=(1 + bbya*bbya - 1/cbyb/cbyb)/4 theta=(1 + cbyb*cbyb - cbya*cbya)/4
% vec G[3] 0   0   0                   # G
% vec C[3] 1/2 1/2-eta 1-eta           # C
% vec C1[3] 1/2 1/2+eta eta            # C1
% vec D[3] 1/2-delta  1/2   1-delta    # D
% vec D1[3] 1/2+delta    1/2   delta   # D1
% vec L[3] 1/2    1/2   1/2            # L
% vec H[3] 1-theta   1/2-theta  1/2    # H
% vec H1[3] theta   1/2+theta  1/2     # H1
% vec X[3] 0   1/2    1/2              # X
% vec Y[3] 1/2   0    1/2              # Y
% vec Z[3] 1/2   1/2    0              # Z

# Sequence G-Y-C-D-X-G-Z-D1-H-C1-X-H-L-G
11 {G}  {Y}      G to Y
11 {Y}  {C}      Y to C
11 {C}  {D}      T to D
11 {D}  {X}      Z to X
11 {X}  {G}      G to G
11 {G}  {Z}     X to Z
11 {Z}  {D1}     A1 to D1
11 {D1}  {H}      T to H
11 {H}  {C1}      X to C1
11 {C1}  {X}      A to X
11 {X}  {H}      L to H
11 {H}  {L}      A to L
11 {L}  {G}      L to G
~~~

{::nomarkdown}</div>{:/}

### _Face-centered Orthorhombic 3 (ORCF3) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orcf3_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orcf3'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orcf3">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c, for orcf 1/a^2 = 1/b^2 + 1/c^2
# Run with --band~mq~...
# orcf3 lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 + 1/cbya/cbya + 1/bbya/bbya)/4 zeta=(1 + 1/bbya/bbya - 1/cbya/cbya)/4
% vec G[3] 0   0   0                   # G
% vec A[3] 1/2 1/2+zeta zeta           # A
% vec A1[3] 1/2 1/2-zeta 1-zeta        # A1
% vec L[3] 1/2  1/2   1/2              # L
% vec T[3] 1    1/2   1/2              # T
% vec X[3] 0    eta   eta              # X
% vec X1[3] 1   1-eta  1-eta           # X1
% vec Y[3] 1/2   0    1/2              # Y
% vec Z[3] 1/2   1/2    0              # Z

# Sequence G-Y-T-Z-G-X-A1-X-A-L-G
11 {G}  {Y}      G to Y
11 {Y}  {T}      Y to T
11 {T}  {Z}      T to Z
11 {Z}  {G}      Z to G
11 {G}  {X}      G to X
11 {X}  {A1}     X to A1
11 {A1}  {X}     A1 to X
11 {X}  {A}      X to A
11 {A}  {L}      A to L
11 {L}  {G}      L to G
~~~

{::nomarkdown}</div>{:/}

### _Body-centered Orthorhombic (ORCI) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orci_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orci'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orci">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c
# Run with --band~mq~...
# orci lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 + abyc*abyc)/4 zeta=(1 + bbyc*bbyc)/4 delta=(b*b - a*a)/(c*c)/4 mu=(a*a + b*b)/(c*c)/4
% vec G[3] 0   0   0                    # G
% vec L[3] -mu  mu  1/2-delta           # L
% vec L1[3] mu  -mu  1/2+delta          # L1
% vec L2[3] 1/2-delta 1/2+delta -mu     # L2
% vec R[3] 0     1/2   0                # R
% vec S[3] 1/2   0    0                 # S
% vec T[3] 0     0   1/2                # T
% vec W[3] 1/4  1/4  1/4                # W
% vec X[3] -zeta  zeta  zeta            # X
% vec X1[3] zeta  1-zeta  -zeta         # X1
% vec Y[3] eta  -eta  eta               # Y
% vec Y1[3] 1-eta  eta  -eta            # Y1
% vec Z[3] 1/2  1/2  -1/2               # Z

# Sequence G-X-L-T-W-R-X1-Z-G-Y-S-L1-Y1-Z
11 {G}  {X}      G to X
11 {X}  {L}      X to L
11 {L}  {T}      L to T
11 {T}  {W}      T to W
11 {W}  {R}      W to R
11 {R}  {X1}     R to X1
11 {X1}  {Z}     X1 to Z
11 {Z}  {G}      Z to G
11 {G}  {Y}      G to Y
11 {Y}  {S}      Y to S
11 {S}  {L1}     S to L1
11 {L1}  {Y1}    L1 to Y1
11 {Y1}  {Z}     YL to Z
~~~

{::nomarkdown}</div>{:/}

### _C-centered Orthorhombic (ORCC) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.orcc_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('orcc'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="orcc">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c
# Run with --band~mq~...
# orcc lattice is taken from Computational Materials Science 49, 299 (2010)

% const zeta=(1 + abyb*abyb)/4
% vec G[3] 0   0   0                  # G
% vec A[3] zeta  zeta  1/2            # A
% vec A1[3] -zeta  1-zeta  1/2        # A1
% vec R[3] 0  1/2  1/2                # R
% vec S[3] 0  1/2  0                  # S
% vec T[3] -1/2  1/2  1/2             # T
% vec X[3] zeta  zeta  0              # X
% vec X1[3] -zeta  1-zeta  0          # X1
% vec Y[3] -1/2   1/2    0            # Y
% vec Z[3] 0   0   1/2                # Z

# Sequence G-X-S-R-A-Z-G-Y-X1-A1-T-Z-T
11 {G}  {X}      G to X
11 {X}  {S}      X to S
11 {S}  {R}      S to R
11 {R}  {A}      R to A
11 {A}  {Z}      A to Z
11 {Z}  {G}      Z to G
11 {G}  {Y}      G to Y
11 {Y}  {X1}     Y to X1
11 {X1}  {A1}    X1 to A1
11 {A1}  {T}     A1 to T
11 {T}  {Z}      T to Z
11 {Z}  {T}      Z to G
~~~

{::nomarkdown}</div>{:/}

### _Hexagonal (HEX) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.hex_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('hex'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="hex">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c
# Run with --band~mq~...
# hex lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0               # G
% vec A[3] 0   0   1/2             # A
% vec H[3] 1/3  1/3  1/2           # H
% vec K[3] 1/3  1/3  0             # K
% vec L[3] 1/2  0    1/2           # L
% vec M[3] 1/2  0    0             # M

# Sequence G-M-K-G-A-L-H-L-K-H
11 {G}  {M}      G to M
11 {M}  {K}      X to S
11 {K}  {G}      S to R
11 {G}  {A}      R to A
11 {A}  {L}      A to Z
11 {L}  {H}      Z to G
11 {H}  {L}      G to Y
11 {L}  {K}      Y to X1
11 {K}  {H}      X1 to A1
~~~

{::nomarkdown}</div>{:/}

### _Rhombohedral 1 (RHL1) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.rhl1_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('rhl1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="rhl1">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha for rhl alpha < 90deg
# Run with --band~mq~...
# rhl1 lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 + 4*cos(alpha))/(2 + 4*cos(alpha))
% const nu=(3/4 - zeta/2)
% vec G[3] 0   0   0               # G
% vec B[3] eta    1/2    1-eta            # B
% vec B1[3] 1/2   1-eta   eta-1           # B1
% vec F[3] 1/2   1/2   0             # F
% vec L[3] 1/2  0    0             # L
% vec L1[3] 0   0   -1/2               # L1
% vec P[3] eta   nu   nu             # P
% vec P1[3] 1-nu   1-nu   1-eta           # P1
% vec P2[3] nu   nu   eta-1             # P2
% vec Q[3] 1-nu   nu   0           # Q
% vec X[3] nu   0   -nu             # X
% vec Z[3] 1/2   1/2   1/2             # Z

# Sequence G-L-B-Z-G-Q-F-P1-L-P
11 {G}  {L}      G to L
11 {L}  {B}      L to B
11 {B}  {Z}      B to Z
11 {Z}  {G}      Z to G
11 {G}  {Q}      G to Q
11 {Q}  {F}      Q to F
11 {F}  {P1}     F to P1
11 {P1}  {L}     P1 to L
11 {L}  {P}      L to P
~~~

{::nomarkdown}</div>{:/}

### _Rhombohedral 2 (RHL2) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.rhl2_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('rhl2'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="rhl2">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha for rhl alpha > 90deg
# Run with --band~mq~...
# rhl2 lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=1/(2*tan(alpha/2)*tan(alpha/2))
% const nu=(3/4 - zeta/2)
% vec G[3] 0   0   0                 # G
% vec F[3] 1/2   -1/2   0       # F
% vec L[3] 1/2   0   0       # L
% vec P[3] 1-nu   -nu   1-nu             # P
% vec P1[3] nu   nu-1   nu-1              # P1
% vec Q[3] eta   eta   eta              # Q
% vec Q1[3] 1-eta   -eta   -eta            # Q1
% vec Z[3] 1/2   -1/2   1/2       # Z

# Sequence G-P-Z-Q-G-F-P1-Q1-L-Z
11 {G}  {P}      G to L
11 {P}  {Z}      P to Z
11 {Z}  {Q}      Z to Q
11 {Q}  {G}      Q to G
11 {G}  {F}      G to F
11 {F}  {P1}      F to P1
11 {P1}  {Q1}     P1 to Q1
11 {Q1}  {L}     Q1 to L
11 {L}  {Z}      L to Z
~~~

{::nomarkdown}</div>{:/}

### _Monoclinic (MCL) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mcl_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mcl'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mcl">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mcl lattice is taken from Computational Materials Science 49, 299 (2010)

% const eta=(1 - b*cos(alphabyc))/(2*sin(alpha)*sin(alpha))
% const nu=(1/2 - eta*c*cos(alphabyb))
% vec G[3] 0   0   0                 # G
% vec A[3] 1/2   -1/2   0       # A
% vec C[3] 0  1/2  1/2       # C
% vec D[3] 1/2  0  1/2             # D
% vec D1[3] 1/2  0  -1/2              # D1
% vec E[3] 1/2  1/2  1/2              # E
% vec H[3] 0  eta  1-nu            # H
% vec H1[3] 0  1-eta  nu       # H1
% vec H2[3] 0  eta  -nu             # H2
% vec M[3] 1/2  eta  1-nu            # M
% vec M1[3] 1/2  1-eta  nu              # M1
% vec M2[3] 1/2  eta  -nu            # M2
% vec X[3] 0  1/2  0       # X
% vec Y[3] 0  0  1/2              # Y
% vec Y1[3] 0  0  -1/2              # Y1
% vec Z[3] 1/2  0  0            # Z

# Sequence G-Y-H-C-E-M1-A-X-M-D-Y-D
11 {G}  {Y}      G to Y
11 {Y}  {H}      Y to H
11 {H}  {C}      H to C
11 {C}  {E}      C to E
11 {E}  {M1}     E to M1
11 {M1}  {A}     M1 to A
11 {A}  {X}      A to X
11 {X}  {M}      X to M
11 {M}  {D}      M to D
11 {D}  {Y}      D to Y
11 {Y}  {D}      Y to D
~~~

{::nomarkdown}</div>{:/}

### _C-centered Monoclinic 1 (MCLC1) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mclc1_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mclc1'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mclc1">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mclc1 lattice is taken from Computational Materials Science 49, 299 (2010)

% const zeta=(2 - b*cos(alphabyc))/(4*sin(alpha)*sin(alpha))
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const psi=(3/4 - (1/4)*abyb*abyb*(1/sin(alpha))*(1/sin(alpha)))
% const phi=(psi + (3/4 - psi)*b*cos(alphabyc))
% vec G[3] 0   0   0                 # G
% vec N[3] 1/2   0   0       # N
% vec N1[3] 0  -1/2  0       # N1
% vec F[3] 1-zeta  1-zeta  1-eta             # F
% vec F1[3] zeta  zeta  eta              # F1
% vec F2[3] -zeta  -zeta  1-eta              # F2
% vec F3[3] 1-zeta  -zeta  1-eta            # F3
% vec I[3] phi  1-phi  1/2       # I
% vec I1[3] 1-phi  phi-1  1/2             # I1
% vec L[3] 1/2  1/2  1/2           # L
% vec M[3] 1/2  0  1/2              # M
% vec X[3] 1-psi  psi-1  0            # X
% vec X1[3] psi  1-psi  0       # X1
% vec X2[3] psi-1  -psi  0              # X2
% vec Y[3] 1/2  1/2  0              # Y
% vec Y1[3] -1/2  -1/2  0            # Y1
% vec Z[3] 0  0  1/2            # Z

# Sequence G-Y-F-L-I1-Z-H-H1-Y1-X-G-M-G
11 {G}  {Y}      G to Y
11 {Y}  {F}      Y to F
11 {F}  {L}      F to L
11 {L}  {I1}      L to I1
11 {I1}  {Z}     I1 to Z
11 {Z}  {H}     Z to H
11 {H}  {H1}      H to H1
11 {H1}  {Y1}      H1 to Y1
11 {Y1}  {X}      Y1 to X
11 {X}  {G}      X to G
11 {G}  {M}      G to M
11 {M}  {G}      M to G
~~~

{::nomarkdown}</div>{:/}

### _C-centered Monoclinic 2 (MCLC2) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mclc2_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mclc2'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mclc2">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mclc2 lattice is taken from Computational Materials Science 49, 299 (2010)

% const zeta=(2 - b*cos(alphabyc))/(4*sin(alpha)*sin(alpha))
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const psi=(3/4 - (1/4)*abyb*abyb*(1/sin(alpha))*(1/sin(alpha)))
% const phi=(psi + (3/4 - psi)*b*cos(alphabyc))
% vec G[3] 0   0   0                 # G
% vec N[3] 1/2   0   0       # N
% vec N1[3] 0  -1/2  0       # N1
% vec F[3] 1-zeta  1-zeta  1-eta             # F
% vec F1[3] zeta  zeta  eta              # F1
% vec F2[3] -zeta  -zeta  1-eta              # F2
% vec F3[3] 1-zeta  -zeta  1-eta            # F3
% vec I[3] phi  1-phi  1/2       # I
% vec I1[3] 1-phi  phi-1  1/2             # I1
% vec L[3] 1/2  1/2  1/2           # L
% vec M[3] 1/2  0  1/2              # M
% vec X[3] 1-psi  psi-1  0            # X
% vec X1[3] psi  1-psi  0       # X1
% vec X2[3] psi-1  -psi  0              # X2
% vec Y[3] 1/2  1/2  0              # Y
% vec Y1[3] -1/2  -1/2  0            # Y1
% vec Z[3] 0  0  1/2            # Z

# Sequence G-Y-F-L-I1-Z-N-G-M
11 {G}  {Y}      G to Y
11 {Y}  {F}      Y to F
11 {F}  {L}      F to L
11 {L}  {I1}      L to I1
11 {I1}  {Z}     I1 to Z
11 {Z}  {N}     Z to N
11 {N}  {G}      N to G
11 {G}  {M}      G to M
~~~

{::nomarkdown}</div>{:/}

### _C-centered Monoclinic 3 (MCLC3) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mclc3_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mclc3'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mclc3">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mclc3 lattice is taken from Computational Materials Science 49, 299 (2010)

% const mu=(1 + bbya*bbya)/4
% const delta=(b*c*cos(alpha*(1/2)*(1/a)*(1/a)))
% const zeta=(mu - 1/4 + (1 - b*cos(alphabyc))/(4*sin(alpha)*sin(alpha)))
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const phi=(1 + zeta - 2*mu)
% const psi=(eta - 2*delta)
% vec G[3] 0   0   0                 # G
% vec F[3] 1-phi   1-phi  1-psi       # F
% vec F1[3] phi  phi-1  psi       # F1
% vec F2[3] 1-phi  -phi  1-psi             # F2
% vec H[3] zeta  zeta  eta          # H
% vec H1[3] 1-zeta  -zeta  1-eta              # H1
% vec H2[3] -zeta  -zeta  1-eta            # H2
% vec I[3] 1/2  -1/2  1/2       # I
% vec M[3] 1/2  0  1/2             # M
% vec N[3] 1/2  0  0           # N
% vec N1[3] 0  -1/2  0              # N1
% vec X[3] 1/2  -1/2  0            # X
% vec Y[3] mu  mu  delta       # Y
% vec Y1[3] 1-mu  -mu  -delta              # Y1
% vec Y2[3] -mu  -mu  -deta              # Y2
% vec Y3[3] mu  mu-1  delta            # Y3
% vec Z[3] 0  0  1/2            # Z

# Sequence G-Y-F-H-Z-I-H1-Y1-X-G-M-G
11 {G}  {Y}      G to Y
11 {Y}  {F}      Y to F
11 {F}  {H}      F to H
11 {H}  {Z}      H to Z
11 {Z}  {I}      Z to I
11 {I}  {H1}     I to H1
11 {H1}  {Y1}    H1 to Y1
11 {Y1}  {X}     Y1 to X
11 {X}  {G}      X to G
11 {G}  {M}      G to M
11 {M}  {G}      M to G
~~~

{::nomarkdown}</div>{:/}

### _C-centered Monoclinic 4 (MCLC4) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mclc4_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mclc4'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mclc4">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mclc4 lattice is taken from Computational Materials Science 49, 299 (2010)

% const mu=(1 + bbya*bbya)/4
% const delta=(b*c*cos(alpha*(1/2)*(1/a)*(1/a)))
% const zeta=(mu - 1/4 + (1 - b*cos(alphabyc))/(4*sin(alpha)*sin(alpha)))
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const phi=(1 + zeta - 2*mu)
% const psi=(eta - 2*delta)
% vec G[3] 0   0   0                 # G
% vec F[3] 1-phi   1-phi  1-psi       # F
% vec F1[3] phi  phi-1  psi       # F1
% vec F2[3] 1-phi  -phi  1-psi             # F2
% vec H[3] zeta  zeta  eta          # H
% vec H1[3] 1-zeta  -zeta  1-eta              # H1
% vec H2[3] -zeta  -zeta  1-eta            # H2
% vec I[3] 1/2  -1/2  1/2       # I
% vec M[3] 1/2  0  1/2             # M
% vec N[3] 1/2  0  0           # N
% vec N1[3] 0  -1/2  0              # N1
% vec X[3] 1/2  -1/2  0            # X
% vec Y[3] mu  mu  delta       # Y
% vec Y1[3] 1-mu  -mu  -delta              # Y1
% vec Y2[3] -mu  -mu  -deta              # Y2
% vec Y3[3] mu  mu-1  delta            # Y3
% vec Z[3] 0  0  1/2            # Z

# Sequence G-Y-F-H-Z-H1-Y1-X-G-M-G
11 {G}  {Y}      G to Y
11 {Y}  {F}      Y to F
11 {F}  {H}      F to H
11 {H}  {Z}      H to Z
11 {Z}  {H1}      Z to H1
11 {H1}  {Y1}    H1 to Y1
11 {Y1}  {X}     Y1 to X
11 {X}  {G}      X to G
11 {G}  {M}      G to M
11 {M}  {G}      M to G
~~~

{::nomarkdown}</div>{:/}

### _C-centered Monoclinic 5 (MCLC5) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.mclc5_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('mclc5'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="mclc5">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# mclc5 lattice is taken from Computational Materials Science 49, 299 (2010)

% const zeta=(bbya*bbya + (1 - b*cos(alphabyc))/(sin(alpha)*sin(alpha)))/4
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const mu=(eta/2 + (1/4)*bbya*bbya - b*c*cos(alphabya*(1/2)*(1/a)))
% const nu=(2*mu - zeta)
% const rho=(1 - zeta*abyb*abyb)
% const eta=(1/2 + 2*zeta*c*cos(alphabyb))
% const omega=((4*nu - 1 - b*b*sin(alphabya*(1/a))*sin(alphabya*(1/a)))*c/(2*b*cos(alpha)))
% const delta=(zeta*c*cos(alphabyb) + omega/2 - 1/4)
% vec G[3] 0   0   0                 # G
% vec F[3] nu  nu  omega       # F
% vec F1[3] 1-nu  1-nu  1-omega       # F1
% vec F2[3] nu  nu-1  omega             # F2
% vec H[3] zeta  zeta  eta          # H
% vec H1[3] 1-zeta  -zeta  1-eta              # H1
% vec H2[3] -zeta  -zeta  1-eta            # H2
% vec I[3] rho  1-rho  1/2       # I
% vec I1[3] 1-rho  rho-1  1/2             # I1
% vec L[3] 1/2  1/2  1/2           # L
% vec M[3] 1/2  0  1/2              # M
% vec N[3] 1/2  0  0            # N
% vec N1[3] 0  -1/2  0       # N1
% vec X[3] 1/2  -1/2  0              # X
% vec Y[3] mu  mu  delta              # Y
% vec Y1[3] 1-mu  -mu  -delta            # Y1
% vec Y2[3] -mu  -mu  -deta              # Y2
% vec Y3[3] mu  mu-1  delta            # Y3
% vec Z[3] 0  0  1/2            # Z

# Sequence G-Y-F-L-I1-Z-H-H1-Y1-X-G-M-G
11 {G}  {Y}      G to Y
11 {Y}  {F}      Y to F
11 {F}  {L}      F to L
11 {L}  {H}      L to H
11 {H}  {Z}      H to Z
11 {Z}  {H}    Z to H
11 {H}  {H1}     H to H1
11 {H1}  {Y1}      H1 to Y1
11 {Y1}  {X}      Y1 to X
11 {X}  {G}      X to G
11 {G}  {M}     G to M
11 {M}  {G}      M to G
~~~

{::nomarkdown}</div>{:/}

### _Triclinic 1a(/2a) (TRI1a) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.tri1a_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('tri1a'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="tri1a">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# tri1a lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec L[3] 1/2  1/2  0       # L
% vec M[3] 0  1/2  1/2       # M
% vec N[3] 1/2  0  1/2             # N
% vec R[3] 1/2  1/2  1/2          # R
% vec X[3] 1/2  0  0              # X
% vec Y[3] 0  1/2  0            # Y
% vec Z[3] 0  0  1/2       # Z

# Sequence X-G-L-G-N-G-R-G
11 {X}  {G}      X to G
11 {G}  {L}      G to L
11 {L}  {G}      L to G
11 {G}  {N}      G to N
11 {N}  {G}      N to G
11 {G}  {R}      G to R
11 {R}  {G}      R to G
~~~

{::nomarkdown}</div>{:/}

### _Triclinic 1b(/2b) (TRI1b) Symmetry File_
_____________________________________________________________
To use this symmetry line file, save the below text in to some file which we will call _syml.tri1b_{: style="color: green"} and use with tools that take symmetry-line files as input parameters, such as _lmf_{: style="color: blue"}.

<div onclick="elm = document.getElementById('tri1b'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show symmetry file.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="tri1b">{:/}

~~~
# Use rdfile on this file for symmetry lines as functions a,b,c,alpha; a, b <= c, alpha < 90deg
# Run with --band~mq~...
# tri1b lattice is taken from Computational Materials Science 49, 299 (2010)

% vec G[3] 0   0   0                 # G
% vec L[3] 1/2  -1/2  0       # L
% vec M[3] 0  0  1/2       # M
% vec N[3] -1/2  -1/2  1/2             # N
% vec R[3] 0  -1/2  1/2          # R
% vec X[3] 0  -1/2  0              # X
% vec Y[3] 1/2  0  0            # Y
% vec Z[3] -1/2  0  1/2       # Z

# Sequence X-G-L-G-N-G-R-G
11 {X}  {G}      X to G
11 {G}  {L}      G to L
11 {L}  {G}      L to G
11 {G}  {N}      G to N
11 {N}  {G}      N to G
11 {G}  {R}      G to R
11 {R}  {G}      R to G
~~~

{::nomarkdown}</div>{:/}