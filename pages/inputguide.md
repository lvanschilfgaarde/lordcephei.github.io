---
layout: page-fullwidth
title: "The Input File"
permalink: "/docs/inputfile/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
_____________________________________________________________
This guide aims to detail the structure and use of the input file and related topics. Additionally, the guide details the different categories that the input file uses and the tokens that can be set within each category.

### _The Input File_
_____________________________________________________________

##### _Introduction_
Here is a sample input file for the compound $$ Bi_2Te_3 $$ written for the **lmf**{: style="color: blue"} package.

<div onclick="elm = document.getElementById('sampleinput'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click to show.</div>
{::nomarkdown}<div style="display:none;padding:25px;" id="sampleinput">{:/} 

        categories                  tokens
        ↓                            ↓
        
        VERS    		LM:7 FP:7
        HAM     		AUTOBAS[PNU=1 LOC=1 LMTO=3 MTO=1 GW=0]
                                GMAX=8.1
        ITER    		MIX=B2,b=.3  NIT=10  CONVC=1e-5
        BZ      		NKABC=3  METAL=5  N=2 W=.01
        STRUC
                                NSPEC=2  NBAS=5  NL=4
                                ALAT=4.7825489
                                PLAT= 1     0          4.0154392
                                -0.5   0.8660254  4.0154392
                                -0.5  -0.8660254  4.0154392
        SPEC
                                ATOM=Te         Z= 52  R= 2.870279
                                ATOM=Bi         Z= 83  R= 2.856141
        SITE
                                ATOM=Te         POS=  0.0000000   0.0000000   0.0000000
                                ATOM=Te         POS= -0.5000000  -0.8660254   1.4616199
                                ATOM=Te         POS=  0.5000000   0.8660254  -1.4616199
                                ATOM=Bi         POS=  0.5000000   0.8660254   0.8030878
                                ATOM=Bi         POS= -0.5000000  -0.8660254  -0.8030878

{::nomarkdown}</div>{:/}

Each element of data follows a **token**{: style="color: blue"}. The **token**{: style="color: blue"} tells the reader what the data signifies.  

Each token belongs to a category. **VERS**{: style="color: red"}, **ITER**{: style="color: red"}, **BZ**{: style="color: red"}, **STRUC**{: style="color: red"}, **SPEC**{: style="color: red"}, **SITE**{: style="color: red"} are categories that organize the input by topic.  
Any text that begins in the first column is a category.  

Thus the full identifier consists of a sequence of tags, e.g. **BZ**{: style="color: red"}\_**METAL**{: style="color: blue"}, whose components are stuctured like a tree.  

Sometimes the identifier has three tags, e.g. **HAM**{: style="color: red"}\_**AUTOBAS**{: style="color: green"}\_**LOC**{: style="color: blue"}. The leading tag is the **category**{: style="color: red"}; the last is the **token**{: style="color: blue"}.  

##### _Tags, Categories and Tokens_

The input file offers a very flexible free format: tags identify data to be read by a program, e.g.

        W=.01

reads a parameter (.01) from token **W=**. In this case **W=** belongs to the **BZ**{: style="color: red"} category, so the full tag name is **BZ**{: style="color: red"}\_**W**{: style="color: blue"}.

Tags are organized in a tree structure: a tag connected to the trunk of the tree is called a **category**{: style="color: red"}. A category holds information for a family of data, for example **BZ**{: style="color: red"} contains parameters associated with Brillouin zone integration. The entire input system has at present a grand total of 17 categories, though any one program uses only a subset of them.  

The outermost branch of the tree points to actual data and is called a **token**{: style="color: blue"}. Each category contains a collection of tags within it −− usually tokens, but sometimes an intermediate tag which contains a collection of tokens within it, as described below.  

<div onclick="elm = document.getElementById('tagexample'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';">Click here for an example.</div>
{::nomarkdown}<div style="display:none;padding:25px;" id="tagexample">{:/} 

Suppose for example, the calculation you want to do requires Brillouin zone integrations of a metallic material, which you plan to to carry out using the Methfessel-Paxton sampling method.  Two parameters: polynomial order n and gaussian width w. 
Two tags are used to identify them: internally they are represented as **BZ\_N** and **BZ_W**, but in the input file they are usually expressed as follows: 

        BZ	N=2	W=.01

This format style is the most commonly used because it is clean and easy to read; but it conceals the tree structure a little. The same data can equally be written:

        BZ[	N=2 	W=.01]

Now the tree structure is apparent: [..] delimits the scope of tag **BZ**.  

The root tag, or category, is BZ in this case. Any tag that starts in the first column is a category. Thus any non-white character appearing in the first column automatically starts a new category, and also terminates any prior category, if it hasn’t been terminated already. N= and W= mark tokens **BZ_N** and **BZ_W**.  

Apart from the special use of the first column to identify categories, data is free-format, apart from a few mild exceptions. Thus:

        BZ      N=2
                W=.01
        BZ	W=.01	N=2
        BZ[	W=.01	N=2]

all represent the same information.  

_Note:_{: style="color: red"} if two categories appear in an input file, only the first is used. Subsequent categories are ignored. Generally, only the first tag is used when more than one appears within a given scope.

{::nomarkdown}</div>{:/}

Usually the tag tree has only two levels (category and token) but not always. For example, data associated with atomic sites must be supplied for each site. In this case the tree has three levels, e.g. **SITE_ATOM_POS**. Site data is typically represented in a format along the following lines:

        SITE    ATOM=Ga  POS=  0   0   0    RELAX=T
                ATOM=As  POS= .25 .25 .25
                ATOM=...
                ...
        END

The scope of  **SITE**  starts at "SITE"  and terminates just before "END". There will be multiple instances of the  **SITE_ATOM**  tag, one for each site. The scope of the first instance begins with the first occurrence of  ATOM  and terminates just before the second: 

        ATOM=Ga  POS=  0   0   0    RELAX=T 

And the scope of the second **SITE_ATOM** is 

        ATOM=As  POS= .25 .25 .25 

Note that **ATOM** simultaneously acts like a token pointing to data (e.g. Ga) and as a tag holding tokens within it, in this case **SITE_ATOM_POS** and (for the first site) **SITE_ATOM_RELAX**.  

Some tags are required; others are optional; still others (in fact most) may not be used at all by a particular program. If a code needs site data, **SITE_ATOM_POS** is required, but **SITE_ATOM_RELAX** is probably optional, or not read at all.  

##### _Preprocessor_

Input lines are passed through a preprocessor, which provides a wide flexibility in how input files are structured. The preprocessor has many features in common with a programming language, including the ability to declare variables, evaluate algebraic expressions; and it has constructs for branching and looping, to make possible multiple or conditional reading of input lines.  

For example, supposing through a prior preprocessor instruction you have declared a variable *range*, and it has been assigned the value 3. This line in the input file:

        RMAX={range+1/4}

is parsed and turned in to:

        RMAX=3.25
 
The preprocessor treats text inside brackets {...} as an expression (usually an algebraic expression), which is evaluated and rendered back as an ASCII string.  

The preprocessor’s programming language makes it possible for a single file to serve as input for many materials systems in the manner of a database; or as documentation. Also you can easily vary input conditions in a parameteric fashion.  

Many files other than  `ctrl.ext‘ are first parsed by the preprocessor: files for site positions, Euler angles for noncollinear magnetism, among others.  

### _Input File Categories_
_____________________________________________________________
This section details the various categories and tokens used in the input file.

##### _Preliminaries_
_Note:_{: style="color: red"} The tables below list the input systems’ tokens and their function. Tables are organized by category.

*   The Arguments column refers to the cast belonging to the token ("l", "i", "r", and "c" refer to logical, integer, floating-point and character data, respectively)
*   The Program column indicates which programs the token is specific to, if any
*   The Optional column indicates whether the token is optional (Y) or required (N)
*   The Default column indicates the default value, if any
*   The Explanation column describes the token’s function.

##### _BZ_
Category BZ holds information concerning the numerical integration of quantities such as energy bands over the Brillouin Zone (BZ). The LMTO programs permit both sampling and tetrahedron integration methods. Both are described in bzintegration.html, and the relative merits of the two different methods are discussed. As implemented both methods use a uniform, regularly spaced mesh of k-points, which divides the BZ into microcells as described here. Normally you specify this mesh by the number of divisions of each of the three primitive reciprocal lattice vectors (which are the inverse, transpose of the lattice vectors PLAT); NKABC below.

These tokens are read by programs that make hamiltonians in periodic crystals (lmf,lm,lmgf,lmpg,tbe). Some tokens apply only to codes that make energy bands, (lmf,lm,tbe).

<div onclick="elm = document.getElementById('bztable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="bztable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | - 
GETQP | l | | Y | F | Read list of k-points from a disk file. This is a special mode, and you normally would let the program choose its own mesh by specifying the number of divisions (see NKABC). <br> If token is not parsed, the program will attempt to parse NKABC.
NKABC | l to 3 i | | N | | The number of divisions in the three directions of the reciprocal lattice vectors. k-points are generated along a uniform mesh on each of these axes. (This is the optimal general purpose quadrature for periodic functions as it integrates the largest number of sine and cosine functions exactly for a specified number of points.) <br><br> The parser will attempt to read three integers. If only one number is read, the missing second and third entries assume the value of the first. <br><br> Information from NKABC, together with BZJOB below, contains specifications equivalent to the widely used “Monkhorst Pack” scheme. But it is more transparent and easier to understand. The number of k-points in the full BZ is the product of these numbers; the number of irreducible k-points may be reduced by symmetry operations.
PUTQP | l | | Y | F | If T, Write out the list of irreducible k-points to file qpts, and the weights for tetrahedron integration if available.
BZJOB | l to 3 i | | Y | 0 | Controls the centering of the k-points in the BZ: <br>0: the mesh is centered so that one point lies at the origin <br>1: points symmetrically straddle the origin <br><br>Three numbers are supplied, corresponding to each of the three primitive reciprocal lattice vectors. As with NKABC if only one number is read the missing second and third entries assume the value of the first.
METAL | i | lmf, lm, tbe | Y | 1 | Specifies how the weights are generated for BZ integration. <br><br>Numerical quadrature is used to to accumulate the output density or any BZ-integrated property.<br>In insulators, each point in the full BZ gets equal weight; in metals, the weights depend on the Fermi level $$ E_F $$, which must be determined from the eigenvalues. <br>There are these possibilities: {::nomarkdown} <ul><li>either the weights for each k are known in advance, as is the case for insulators;</li><li>{:/} $$ E_F $$ {::nomarkdown}must be determined before BZ integrations are performed (tetrahedron integration).<br><br>In this more difficult case, there are two possibilities:<ul><li>the weight at k does not depend on values of neighboring k (the case for Methfessel-Paxton sampling integration)</li><li>the weight at k does depend on values of neighboring k (tetrahedron integration). </li></ul></li></ul><br> The first case is easy to handle. For the latter several strategies have been developed.<br>The METAL token accepts the following:<ul><li>System assumed to be an insulator; weights determined a priori.</li><li>Eigenvectors are written to disk, in which case the integration for the charge density can be deferred until all the bands are obtained. This option is available only for the ASA:<br>When accumulating just the spherical part of the charge, eigenvector data can be contracted over m, reducing memory demands.</li><li>Integration weights are read from file wkp.ext, would have been generated in a prior band pass. If wkp.ext is missing or unsuitable, the program will temporarily switch to METAL=3.</li><li>Two band passes are made; the first generates only eigenvalues to determine {:/} $$ E_F $$ {::nomarkdown}. It is slower than METAL=2, but it is more stable which can be important in difficult cases.</li><li>Three distinct Fermi levels are assumed and weights generated for each. After {:/} $$ E_F $$ {::nomarkdown} is determined, the actual weights are calculated by quadratic interpolation through the three points. The three Fermi levels are gradually narrowed to a small window around the true {:/} $$ E_F $$ {::nomarkdown} in the course of the self-consistency cycle.<br>This scheme works for sampling integration where the k-point weights depend on {:/} $$ E_F $$ {::nomarkdown} only and not eigenvalues at neighboring k.<br>You can also use this scheme in a mixed tetrahedron/sampling method:<br>Weights for the band sum are determined by tetrahedron, but the charge density is integrated by sampling.<br>It works better than straight sampling because the total energy is variational in the density.</li><li>like METAL=3 in that two passes are made but eigenvectors are kept in memory so there is no additional overhead in the first pass.<br>This is the recommended mode for lmf unless you are working with a large system and need to conserve memory.</li></ul>{:/}<br>The ASA code lm implements METAL=0,1,2; the FP lmf implements METAL=0,2,3,4,5.
TETRA | 1 | lmf,lm,tbe | Y | T | Selects BZ integration method<br>0: Methfessel-Paxton sampling integration. Tokens NPTS, N, W, EF0, DELEF (see below) are relevant to this integration scheme.<br>1: tetrahedron integration, with Bloechl weights
N | i | lmf,lm,tbe | Y | 0 | Polynomial order for sampling integration; see Methfessel and Paxton, Phys. Rev. B, 40, 3616 (1989). (Not used with tetrahedron integration or for insulators)<br><br>0: integration uses standard gaussian method<br><br>>0: integration uses generalized gaussian functions, i.e. polynomial of order N * gaussian to generate integration weights<br><br>−1: use the Fermi function rather than gaussians to broaden the δ-function. This generates the actual electron (fermi) distribution for a finite temperature.<br><br>100: By default, if a gap is found separating occupied and occupied states, the program will treat the system as and insulator, even when MET>0. To suppress this, add 100 to N (use −101 for Fermi distribution).
W | r | lmf,lm,tbe | Y | 5e-3 | {::nomarkdown} <ul><li>Case BZ_N\>0:<br>Broadening (Gaussian width) for Gaussian sampling integration (Ry).</li><li>Case BZ_N\<0:<br>temperature, in Ry. (the sampling weights are computed from the Fermi function instead of the error function).</li></ul>{:/}<br>Not used with tetrahedron integration or for insulators.
EF0 | r | lmf,lm,tbe | Y | 0 | Initial guess at Fermi energy. Used with BZ_METAL=4.
DELEF | r | lmf,lm,tbe | Y | 0.05 | Initial uncertainty in Fermi level for sampling integration.<br>Used with BZ_METAL=4.
ZBAK | r | lmf,lm | Y | 0 | Homogeneous background charge
SAVDOS | i | lmf,lm,tbe | Y | 0 | {::nomarkdown} <ul><li>0: does not save dos on disk</li><li>1: writes the total density of states on NPTS mesh points to disk file dos.ext.</li><li>2: Write weights to disk for partial DOS (In the ASA this occurs automatically).</li><li>4: Same as (2), but write weights m-resolved.</li></ul>{:/}You may also cause lm or lmf to generate m-resolved dos using the –pdos command-line argument.<br>NB: you must turn OFF all symmetry operations to produce correct results. (The extra inversion symmetry in the k-points from time-reversal symmetry is still allowed.)<br><br>Note:<br>SAVDOS>0 requires BZ_NPTS and BZ_DOS also.
DOS | 2 r | | Y | -1,0 | Energy window over which DOS accumulated. Needed either for sampling integration or if SAVDOS>0.
NPTS | i | | Y | 1001 | Number of points in the density-of-states mesh used in conjunction with sampling integration. Needed either for sampling integration or if SAVDOS>0.
EFMAX | r | lmf,lm,tbe | Y | 2 | Only eigenvectors whose eigenvalues are less than EFMAX are computed; this improves execution efficiency.
NEVMX | i | lmf,lm,tbe | Y | 0 | \>0 : Find at most NEVMX eigenvectors<br>=0 : program uses internal default<br>\<0 : no eigenvectors are generated (and correspondingly, nothing associated with eigenvectors such as density.)<br><br>Caution: if you want to look at partial DOS well above the Fermi level (which comes out around 0), you must set EFMAX and NEVMX high enough to encompass the range of interest.
ZVAL | r | | Y | 0 | Number of electrons to accumulate in BZ integration. Normally zval is computed by the program.
NOINV | l | lmf,lm,tbe | Y | F | Suppress the automatic addition of the inversion to the list of point group operations. Usually the inversion symmetry can be included in the determination of the irreducible part of the BZ because of time reversal symmetry. There may be cases where this symmetry is broken:<br>e.g. when spin-orbit coupling is included or when the (beyond LDA) self-energy breaks time-reversal symmetry. In most cases, the program will automatically disable this addition in cases that it knows the symmetry is broken.
FSMOM | 2 r | lmf,lm | Y | 0 0 | Set the global magnetic moment (collinear magnetic case). In the fixed-spin moment method, a spin-dependent potential shift Beff is added to constrain the total magnetic moment to value assigned by FSMOM=. No constraint is imposed if this value is zero (the default).<br>Optional second arg supplies an initial Beff. It is applied whether or not the first argument is 0. If arg#1 ≠ 0, Beff is made consistent with it.
DMAT | l | lmf,lmgf | Y | F | Calculate the density matrix.
INVIT | l | lmf,lm | Y | F | Enables inverse iteration generate eigenvectors (this is the default). It is more efficient than the QL method, but occasionally fails to find all the vectors. When this happens, the program stops with the message:<br> DIAGNO: tinvit cannot find all evecs<br>If you encounter this message set INVIT=F.
EMESH | r | lmgf,lmpg | Y | 10,0,-1,... | Parameters defining contour integration for Green’s function methods.<br><br>Element: {::nomarkdown} <ol><li>number of energy points n</li><li>contour type:<ul><li>0: Uniform mesh of nz points: Real part of energy z between emin and emax</li><li>1: Same as 0, but reverse sign of Im z</li><li>10: elliptical contour</li><li>11: same as 10, but reverse sign of Im z</li><li>100s digit used for special modifications</li><li>Add 100 for nonequil part using Im(z)=delne</li><li>Add 200 for nonequil part using Im(z)=del00</li><li>Add 300 for mixed elliptical contour + real axis to find fermi level</li><li>Add 1000 to set nonequil part only.</li></ul></li><li>lower bound for energy contour emin (on the real axis)</li><li>upper bound for energy contour emax, e.g. Fermi level (on the real axis)</li><li>(elliptical contour) eccentricity: ranges between 0 (circle) and 1 (line)<br>(uniform contour) Im z</li><li>(elliptical contour) bunching parameter eps : ranges between 0 (distributed symmetrically) and 1 (bunched toward emax)<br>(uniform contour) not used</li><li>(nonequilibrium GF, lmpg) nzne = number of points on nonequilibrium contour</li><li>(nonequilibrium GF, lmpg) vne = difference in fermi energies of right and left leads</li><li>(nonequilibrium GF, lmpg) delne = Im part of E for nonequilibrium contour</li><li>(nonequilibrium GF, lmpg) substitutes for delne when making the surface self-energy.</li></ol> {:/}
MULL | i | tbe | Y | 0 | Mulliken population analysis. Mulliken population analysis is also implemented in lmf, but you specify the analysis with a command-line argument.

{::nomarkdown}</div>{:/}

##### _CONST_

Category CONST enables the user to declare variables for use in algebraic expressions. The syntax is a string of declarations inside the category, e.g:

        CONST   a=10.69 nspec=4+2

Variables declared this way are similar to, but distinct from variables declared for the preprocessor, such as 

        % const nbas=5

In the latter case the preprocessor makes a pass, and may use expressions involving variables declared by e.g. "% const nbas=5" to alter the structure of the input file.  

Variables declared for use by the preprocessor lose their definition after
the preprocessor completes.  

The following code segment illustrates both types:

~~~
% const nbas=5
CONST   a=10.69 nspec=4
SPEC    ALAT=a  NSPEC=nspec NBAS={nbas}
~~~

After the preprocessor compiles, the input file appears as:

~~~
CONST   a=10.69 nspec=4
SPEC    ALAT=a  NSPEC=nspec NBAS=5
~~~

When the CONST category is read (it is read before other categories),
variables a and nspec are defined and used in the SPEC category.

##### _DYN_
Contains parameters for molecular statics and dynamics.

<div onclick="elm = document.getElementById('dyntable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="dyntable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NIT | i | lmf, lmmc, tbe | Y | | maximum number of relaxation steps (molecular statics)
SSTAT[...] | | lm, lmgf | Y | | (noncollinear magnetism) parameters specifying how spin statics (rotation of quantization axes to minimze energy) is carried out
SSTAT\_MODE | i | lm, lmgf | N | 0 | 0: no spin statics or dynamics<br>-1: Landau-Gilbert spin dynamics<br>1: spin statics: quantization axis determined by making output density matrix diagonal<br>2: spin statics: size and direction of relaxation determined from spin torque<br>Add 10 to mix angles independently of P,Q (Euler angles are subject to mixing to accelerate convergence)<br>Add 1000 to mix Euler angles independently of P,Q
SSTAT\_SCALE | i | lm, lmgf | N | 0 | (used with mode=2) scale factor amplifying magnetic forces
SSTAT\_MAXT | i | lm, lmgf | N | 0 | maximum allowed change in angle
SSTAT\_TAU | i | lm, lmgf | N | 0 | (used with mode=-1) time step
SSTAT\_ETOL | i | lm, lmgf | N | 0 | (used with mode=-1) Set tau=0 this iter if etot-ehf>ETOL
MSTAT[...] | | lmf, lmmc, tbe | Y | | (molecular statics) parameters specifiying how site positions are relaxed given the internuclear forces
MSTAT\_MODE | i | lmf, lmmc, tbe | N | 0 | 0: no relaxation<br>4: relax with conjugate gradients algorithm (not generally recommended)<br>5: relax with Fletcher-Powell alogirithm. Find minimum along a line; a new line is chosen. The Hessian matrix is updated only at the start of a new line minimization. Fletcher-Powell is more stable but usually less efficient then Broyden.<br>6: relax with Broyden algorithm. This is essentially a Newton-Raphson algorithm, where Hessian matrix and direction of descent are updated each iteration.
MSTAT\_HESS | l | lmf, lmmc, tbe | N | T | T: Read hessian matrix from file, if it exists<br>F: assume initial hessian is the unit matrix
MSTAT\_XTOL | r | lmf, lmmc, tbe | Y | 1e-3 | Convergence criterion for change in atomic displacements<br>>0: criterion satisfied when xtol > net shift (shifts summed over all sites)<br><0: criterion satisfied when xtol > max shift of any site<br>0: DO not use this criterion to check convergence<br><br>Note: When molecular statics are performed, either GTOL or XTOL must be specified. Both may be specified
MSTAT\_GTOL | r | lmf,lmmc,tbe | Y | 0 | Convergence criterion for tolerance in forces.<br>>0: criterion satisfied when gtol > "net" force (forces summed over all sites)<br><0: criterion satisfied when xtol > max absolute force at any site<br>0: Do not use this criterion to check convergence<br><br>Note: When molecular statics are performed, either GTOL or XTOL must be specified. Both may be specified
MSTAT\_STEP | r | lmf, lmmc, tbe | Y | 0.015 | Initial (and maximum) step length
MSTAT\_NKILL | i | lmf, lmmc, tbe | Y | 0 | Remove hessian after NKILL iterations.<br>Never remove Hessian if NKILL=0
MSTAT\_PDEF= | r | lmf, lmmc, tbe | Y | 0 0 0 ... | Lattice deformation modes (not documented)
MD[...] | | lmmc, tbe | Y | | Parameters for molecular dynamics
MD\_MODE | i | lmmc | N | 0 | 0: no MD<br>1: NVE<br>2: NVT<br>3: NPT
MD\_TSTEP | r | lmmc | Y | 20.671 | Time step (a.u.)<br>NB: 1 fs = 20.67098 a.u.
MD\_TEMP | r | lmmc | Y | 0.00189999 | Temperature (a.u.)<br>NB: 1 deg K = 6.3333e-6 a.u.
MD\_TAUP | r | lmmc | Y | 206.71 | Thermostat relaxation time (a.u.)
MD\_TIME | r | lmmc | N | 20671000 | Total MD time (a.u.)
MD\_TAUB | r | lmmc | Y | 2067.1 | Barostat relaxation time (a.u.)

{::nomarkdown}</div>{:/}

##### _EWALD_
Category EWALD holds information controlling the Ewald sums for structure consstants entering into, e.g. the Madelung summations and Block summed structure constants(**lmf**{: style="color: blue"}). Most programs use quantities in this category to carry out Ewald sums (exceptions are **lmstr**{: style="color: blue"} and the molecules codes).

<div onclick="elm = document.getElementById('ewaldtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="ewaldtable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
AS | r | | Y | 2 | Controls the relative number of lattice vectors in the real and reciprocal space
TOL | r | | Y | 1e-8 | Tolerance in the Ewald sums
NKDMX | i | | Y | 800 | The maximum number of real-space lattice vectors entering into the Ewald sum, used for memory allocation.<br>Normally you should not need this token. Increase NKDMX if you encounter an error message like this one: xlgen: too many vectors, n=...
RPAD | r | | Y | 0 | Scale rcutoff by RPAD when lattice vectors padded in oblong geometries

{::nomarkdown}</div>{:/}

##### _HAM_
This category contains parameters defining the one-particle hamiltonian.  

Pportions of HAM are read by these codes: 

~~~
lm
lmfa
lmfgwd
lmfgws
lmf
lmmc
lmgf
lmdos
lmchk
lmscell
lmstr
lmctl
lmpg
tbe
lmmag
~~~

<div onclick="elm = document.getElementById('hamtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="hamtable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NSPIN | i | ALL | Y | 1 | 1 for non-spin-polarized calculations<br>2 for spin-polarized calculations
REL	| i | ALL | Y | 1 | 0: for nonrelativistic Schrodinger equation<br>1: for scalar relativistic approximation to the Dirac equation<br>2: for Dirac equation<br><br>NB: For the magnetic parameters below to be active, HAM_NSPIN must be 2
SO | i | ALL | Y | 0 | 0: no SO coupling<br>1: Add L·S to hamiltonian<br>2: Add Lz·Sz only to hamiltonian<br>3: Like 2, but also add L·S−LzSz in an approximate manner that preserves indpendence in the spin channels.<br>See [here](http://titus.phy.qub.ac.uk/packages/LMTO/v7.11/doc/spin-orbit-coupling.html) for analysis and description of the different approximations
NONCOL | l | ASA | Y | F | F: collinear magnetism<br>T: non-collinear magnetism
SS | 4 r | ASA | Y | 0 | Magnetic spin spiral, direction vector and angle.<br><br>Example: nc/test/test.nc 1
BFIELD | i | lm, lmf | Y | 0 | 0: no external magnetic field applied.<br>1: add site-dependent constant external Zeeman field (requires NONCOL=T).<br>Fields are read from file bfield.ext.<br>2: add Bz·Sz only to hamiltonian.<br><br>Examples:<br>fp/test/test.fp gdn<br>nc/test/test.nc 5
BXCSCAL | i | lm, lmgf | Y | 0 | This tag provides an alternative means to add an effective external magnetic field in the LDA.<br>0: no special scaling of the exchange-correlation field.<br>1: scale the magnetic part of the LDA XC field by a site-dependent factor 1 + sbxci as described below.<br>2: scale the magnetic part of the LDA XC field by a site-dependent factor $(1 + sbxc_i^2)^{1/2}$ as described below.<br>This is a special mode used to impose contraining fields on rotations, used, e.g. by the CPA code.<br>Site-dependent scalings sbxci are read from file bxc.ext.
XCFUN | i | ALL LDA | Y | 2 | Specifies local exchange correlation functional:<br>1: Ceperly-Alder<br>2: Barth-Hedin (ASW fit)<br>3: PW91 (same as PBE)<br>4: PBE (Same as PW91)
GGA | i | ALL LDA | Y | 0 | Specifies a GGA functional:{::nomarkdown}<ol><li>No GGA (LDA only)</li><li>Langreth-Mehl</li><li>PW91</li><li>PBE</li><li>PBE with Becke exchange<br>Example: fp/test/test.fp te</li></ol>{:/}
PWMODE | i | lmf, lmfgwd | Y | | Controls how APWs are added to the LMTO basis.{::nomarkdown}<br><br>1s digit:<ol><li>LMTO basis only</li><li>Mixed LMTO+PW<br>Examples: <br>fp/test/test.fp srtio3 and fp/test/test.fp felz 4</li><li>PW basis only</li></ol>10s digit:<ol><li>PW basis fixed (less accurate, but simpler)</li><li>PW basis k-dependent. Symmetry-consistent but basis and basis dimension depend on k.<br>Example: fp/test/test.fp te</li></ol>{:/}
PWEMIN | r | lmf, lmfgwd | Y | 0 | Include APWs with energy E > PWEMIN (Ry)
PWEMAX | r | lmf, lmfgwd | Y | -1 | Include APWs with energy E < PWEMAX (Ry)
NPWPAD | i | lmf, lmfgwd | Y | -1 | Overrides default padding of variable basis dimension
RDSIG | i | lmf, lmfgwd, lm, lmgf | Y | 0 | Controls how the self-energy Σ is added to local exchange correlation functional.<br>1s digit:{::nomarkdown}<ul><li>0 do not read Σ</li><li>1 read file Σ in sigm.ext, if it exists, and add it to the LDA potential<br>Add 2 to symmetrize Σ(T)<br>Add 4 to include Re(Σ(T)) only</li></ul>10s digit:<ul><li>0 simple interpolation</li><li>1 approximate high energy parts of sigma by diagonal (see sigp)</li><li>3 interpolate sigma by LDA eigenvectors (no longer supported)<br>In this mode use 100s digit for # interpolation points.<br>Add 10000 to indicate the sigma file was stored in the full BZ (no symmetry operations are assumed)<br>Add 20000 to use the minimum neighbor table (only one translation vector at the surfaces or edges; cannot be used with symmetrization)<br>Add 40000 to allow file mismatch between expected k-points and file values.</li></ul>{:/}<br>Note: Some options can also be supplied through the command-line argument --rsig[~option~option...].
RSSTOL | r | ALL | Y | 5e-6 | Max tolerance in Bloch sum error for real-space Σ.<br><br>Unless otherwise specified (by e.g. --rsig~rs), Σ is read in k-space and is immediately converted to real space by inverse Bloch transform.<br>The r.s.form is forward Bloch summed and checked against the original k-space Σ.<br>If the difference exceeds RSSTOL the program will abort.<br>The conversion should be exact to machine precision unless the range of Σ is truncated.<br>You can control the range of real-space Σ with RSRNGE below.
RSRNGE | r | ALL | Y | 5 | Maximum range of connecting vectors for real-space Σ (units of ALAT)
NMTO | i | ASA | Y | 0 | Order of polynomial approximation for NMTO hamiltonian
KMTO | r | ASA | Y | | Corresponding NMTO kinetic energies.<br>Read NMTO values, or skip if NMTO=0
EWALD | l | lm | Y | F | Make strux by Ewald summation (NMTO only)
VMTZ | r | ASA | Y | 0 | Muffin-tin zero defining wave functions
QASA | i | ASA | Y | 3 | A parameter specifying the definition of ASA moments Q0,Q1,Q2; see lmto documentation{::nomarkdown}<ul><li>0. Methfessel conventions for 2nd gen ASA moments Q0,Q1,Q2</li><li>1. Q2 = coefficient to φ̇2 − p φ2 in sphere.</li><li>2. Q1,Q2 accumulated as coefficients to <φ·φ̇> and <φ̇2>, respectively.</li><li>3. 1+2 (Stuttgart conventions)</li></ul>{:/}
PMIN | r | ALL | Y | 0 0 0 ... | Global minimum in fractional part of logarithmic derivative parameters Pl.<br>Enter values for l=0,..lmx<br>0: no minimum constraint<br>\# : with \#<1, floor of fractional P is \#<br>1: use free-electron value as minimum<br><br>Note: lmf always uses a minimum constraint, the free-electron value (or slightly higher if AUTOBAS_GW is set).<br>You can set the floor still higher with PMIN=#.
PMAX | r | ALL | Y | 0 0 0 ... | Global maximum in fractional part of potential functions Pl. Enter values for l=0,..lmx<br>0 : no maximum constraint<br>\#: with \#<1, uppper bound of of fractional P is \#
OVEPS | r | ALL | Y | 0 | The overlap is diagonalized and the hilbert space is contracted, discarding the part with eigenvalues of overlap < OVEPS<br>Especially useful with the PMT basis, where the combination of smooth Hankel functions and APWs has a tendency to make the basis overcomplete.
OVNCUT | i | ALL | Y | 0 | This tag has a similar objective to OVEPS.<br>The overlap is diagonalized and the hilbert space is contracted, discarding the part belonging to lowest OVNCUT evals of overlap.<br>Supersedes OVEPS, if present.
GMAX | r | lmf, lmfgwd | N | | G-vector cutoff used to create the mesh for the interstitial density. A uniform mesh is with spacing between points in the three directions as homogeneous as possible, with G vectors |G| < GMAX.<br>This input is required; but you may omit it if you supply information with the FTMESH token.
FTMESH | i1 [i2 i3] | FP | N | | The number of divisions specifying the uniform mesh density along the three reciprocal lattice vectors. The second and third arguments default to the value of the first one, if they are not specified. <br>This input is used only in the parser failed to read the GMAX token.
TOL | r | FP | Y | 1e-6 | Specifies the precision to which the generalized LMTO envelope functions are expanded in a Fourier expansion of G vectors.
FRZWF | l | FP | Y | F | Set to T to freeze the shape of the augmented part of the wave functions. Normally their shape is updated as the potential changes, but with FRZWF=t the potential used to make augmentation wave functions is frozen at what is read from the restart file (or free-atom potential if starting from superposing free atoms).<br>This is not normally necessary, and freezing wave functions makes the basis slightly less accurate. However, there are slight inconsistencies when these orbitals are allowed to change shape. Notably the calculated forces to not take this shape change into account, and they will be slightly inconsistent with the total energy.
FORCES | i | FP | Y | 0 | Controls how forces are to be calculated, and how the second-order corrections are to be evaluated. Through the variational principle, the total energy is correct to second order in deviations from self-consistency, but forces are correct only to first order. To obtain forces to second order, it is necessary to know how the density would change with a (virtual) displacement of the core+nucleus, which requires a linear response treatment.<br>lmf estimates this changes in one of two ways:{::nomarkdown}<ol><li>the free-atom density is subtracted from the total density for nuclei centered at the original position and added back again at the (virtually) displaced position.<br><br>For this ansatz, use FORCES=1.</li>the core+nucleus is shifted and screened assuming a Lindhard dielectric response. <br><br>For this ansatz, use FORCES=12. You also must specify ELIND, below.</li></ol>{:/}
ELIND | r | lmf | Y | -1 | a parameter in the Lindhard response function, (the Fermi level for a free-electron gas relative to the bottom of the band). You can specify this energy directly, by using a positive number for the parameter. If you use instead a negative number, the program will choose a default value from the total number of valence electrons and assuming a free-electron gas, scale that default by the absolute value of the number you specify. If you have a simple sp bonded system, the default value is a good choice. If you have d or f electrons, it tends to overestimate the response.<br>Use something smaller, e.g. ELIND=-0.7.<br><br>ELIND is used in three contexts:<br><br>(1) in the force correction term; see FORCES= above<br>(2) to estimate a self-consistent density from the input and output densities after a band pass<br>(3) to estimate a reasonable smooth density from a starting density after atoms are moved in a relaxation step.
SIGP[...] | r | lmf, lmfgwd | Y | | Parameters used to interpolate the self-energy Σ. Used in conjunction with the GW package. See gw.html for description. Default: not used
SIGP\_MODE | r | lmf, lmfgwd | Y | 4 | Specifies the linear function used for matrix elements of Σ at highly-lying energies. With recent implementations of the GW package 4 is recommended; it requires no input from you.
SIGP\_EMAX SIGP\_NMAX SIGP\_EMIN SIGP\_NMIN SIGP\_A SIGP\_B | r | lmf, lmfgwd | Y | | See gw.html
AUTOBAS[...] | r | lmfa, lmf, lmfgwd | Y | | Parameters associated with the automatic determination of the basis set.<br>These switches greatly simplify the creation of an input file for lmf.<br>Note: Programs lmfa and lmf both use tokens in the AUTOBAS tag but they mean different things, as described below. This is because lmfa generates the parameters while lmf uses them.<br><br>Default: not used
AUTOBAS\_GW | i | lmfa | Y | 0 | Set to 1 to tailor the autogenerated basis set file basp0.ext to a somewhat larger basis, better suited for GW.
AUTOBAS\_GW | i | lmf | Y | 0 | Set to 1 to float log derivatives P a bit more conservatively — better suited to GW calculations.
AUTOBAS\_LMTO | i | lmfa | Y | 0 | lmfa autogenerates a trial basis set, saving the result into basp0.ext.<br>LMTO is used in an algorithm to determine how large a basis it should construct: the number of orbitals increases as you increase LMTO. This algorithm also depends on which states in the free atom which carry charge.<br>Let lq be the highest l which carries charge in the free atom.<br><br>There are the following choices for LMTO:{::nomarkdown}<ul><li>0. standard minimal basis; same as LMTO=3.</li><li>1. The hyperminimal basis, which consists of envelope functions corresponding those l which carry charge in the free atom, e.g. Ga sp and Mo sd.<br><br>Note: this basis is only sensible when used in conjunction with APWs.</li><li>2. All l up to lq+1 if lq<2; otherwise all l up to lq</li><li>3. All l up to min(lq+1, 3).<br>For elements lighter than Kr, restrict l≤2.<br>For elements heavier than Kr, include l to 3.</li><li>4. (Standard basis) Same as LMTO=3, but restrict l≤2 for elements lighter than Ar.</li><li>5. (Large basis) All l up to max(lq+1,3) except for H, He, Li, B (use l=spd).</li></ul>{:/}<br>Use the MTO token (see below) in combination with this one. MTO controls whether the LMTO basis is 1-κ or 2-κ, meaning whether 1 or 2 envelope functions are allowed per l channel.
AUTOBAS\_MTO | i | lmfa | Y | 0 | Autogenerate parameters that control which LMTO basis functions are to be included, and their shape.<br><br>Tokens RSMH,EH (and possibly RSMH2,EH2) determine the shape of the MTO basis. lmfa will determine a reasonable set of RSMH,EH automatically (and RSMH2,EH2 for a 2-κ basis), fitting to radial wave functions of the free atom.<br><br>Note: lmfa can generate parameters and write them to file basp0.ext.<br>lmf can read parameters from basp.ext.<br>You must manually create basp.ext, e.g. by copying basp0.ext into basp.ext. You can tailor basp.ext with a text editor. There are the following choices for MTO:<br> 0: do not autogenerate basis parameters<br>1: or 3 1-κ parameters with Z-dependent LMX<br>2: or 4 2-κ parameters with Z-dependent LMX
AUTOBAS\_MTO | i | lmf, lmfgwd | Y | 0 | Read parameters RSMH,EH,RSMH2,EH2 that control which LMTO basis functions enter the basis.<br><br>Once initial values have been generated you can tune these parameters automatically for the solid, using lmf with the --optbas switch; see Building_FP_input_file.html and FPoptbas.html.<br><br>The --optbas step is not essential, especially for large basis sets, but it is a way to improve on the basis without increasing the size.<br><br>There are the following choices for MTO:<br><br>0 Parameters not read from basp.ext; they are specified in the input file ctrl.ext.<br>1 or 3: 1-κ parameters may be read from the basis file basp.ext, if they exist<br>2 or 4: 2-κ parameters may be read from the basis file basp.ext, if they exist<br>1 or 2: Parameters read from ctrl.ext take precedence over basp.ext<br>3 or 4: Parameters read from basp.ext take precedence over those read from ctrl.ext.
AUTOBAS\_PNU | i | lmfa | Y | 0 | Autoset boundary condition for augmentation part of basis, through specification of logarithmic derivative parameters P.<br><br>0 do not make P <br>1 Find P for l < lmxb from free atom wave function; save in file basp0.ext
AUTOBAS\_PNU | i | lmf, lmfgwd | Y | 0 | Autoset boundary condition for augmentation part of basis, through specification of logarithmic derivative parameters P.<br><br>0 do not attempt to read P from basp.ext.<br>1 Read P from basp.ext, for those species which P is given.
AUTOBAS\_LOC | i | lmfa, lmf, lmfgwd | Y | 0 | Autoset local orbital parameters PZ, which determine which deep or high-lying states are to be included as local orbitals.<br><br>Used by lmfa to control whether parameters PZ are to be sought:<br>0: do not autogenerate PZ<br>1 or 2: autogenerate PZ<br><br>Used by lmf and lmfgwd to control how PZ is read:<br><br>1 or 2: read parameters PZ<br>1: Nonzero values from ctrl file take precedence over basis file input
AUTOBAS\_ELOC | r | lmfa | Y | -2 Ry | The first of two criteria to decide which orbitals should be included in the valence as local orbitals. If the energy of the free atom wave function exceeds (is more shallow than) ELOC, the orbital is included as a local orbital.
AUTOBAS\_QLOC | r | lmfa | Y | 0.005 | The second of two criteria to decide which  orbitals should be included in the valence as local orbitals.<br>If the fraction of the free atom wave function’s charge outside the augmentation radius exceeds QLOC, the orbital is included as a local orbital.
AUTOBAS\_PFLOAT | i1 i2 | lmf, lmfgwd | y | 1 1 | Governs how the logarithmic derivative parameters Pl are set and floated in the course of a self-consistency cycle.<br>The 1st argument controls default starting values of P and lower bounds to P when it is floated<br>0: Use version 6 defaults and float lower bound<br>1: Use defaults and float lower bound designed for LDA<br>2: Use defaults and float lower bound designed for GW<br>The 2nd argument controls how the band center of gravity (CG) is determined — used when floating P.<br>0: band CG is found by a traditional method<br>1: band CG is found from the true energy moment of the density

{::nomarkdown}</div>{:/}

##### _GF_
Category GF is intended for parameters specific to the Green’s function code **lmgf**{: style="color: blue"}.
It is read by **lmgf**{: style="color: blue"}.

<div onclick="elm = document.getElementById('gftable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="gftable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | ASA | Y | 0 | 0: do nothing<br>1:self-consistent cycle<br>10: Transverse magnetic exchange interactions J(q)<br>11: Read J(q) from disk and analyze results<br>14: Longitudinal exchange interactions<br>20: Transverse $X^(+-)$ from ASA Green's function<br>21: Read X from disk and analyze results<br>20: Transverse $X^(++)$, X^(--) from ASA Green's function<br>Caution: Modes 14 and higher have not been maintained.
GFOPTS | c | ASA | Y | | ASCII string with switches governing execution of lmgf or lmpg. Use `;‘ to separate the switches.<br><br>Available switches:<br><br>‘p1‘ First order of potential function<br><br>‘p3‘ Third order of potential function<br><br>‘pz‘ Exact potential function (some problems; not recommended<br><br>Use only one of the above; if none are used, the code generates second order potential functions.<br><br>‘idos‘ integrated DOS (by principal layer in the lmpg case)<br><br>‘noidos‘ suppress calculation of integrated DOS<br><br>‘pdos‘ accumulate partial DOS<br><br>‘emom‘ accumulate output moments; use ‘noemom‘ to suppress<br><br>‘noemom‘ suppresss accumulation of output moments<br><br>‘sdmat‘ make site density-matrix<br><br>‘dmat‘ make density-matrix<br><br>‘frzvc‘ do not update potential shift needed to obtain charge neutrality<br><br>‘padtol‘ Tolerance in Pade correction to charge. If tolerance exceeded, lmgf will repeat the band pass with an updated Fermi level<br><br>‘omgtol‘ (CPA) tolerance criterion for convergence in coherent potential<br><br>‘omgmix‘ (CPA) linear mixing parameter for iterating convergence in coherent potential<br><br>‘nitmax‘ (CPA) maximum number of iterations to iterate for coherent potential<br><br>‘lotf‘ (CPA)<br><br>‘dz‘ (CPA)
DLM | i | ALL | Y | 0 | Governs self-consistency for both chemical CPA and magnetic CPA (disordered local moments).<br><br>12 : normal CPA/DLM calculation: charge and coherent potential Ω both iterated to self-consistency.<br><br>32 : Ω alone is iterated to self-consistency.
BXY | 1 | ALL | Y | F | (DLM) Setting this switch to T generates a site-dependent constraining field to properly align magnetic moments.<br><br>In this context constraining field is applied by scaling the LDA exchange-correlation field.<br>The scaling factor is $ [1+bxc(ib)^2]^(1/2) $.<br><br>A table of bxc is kept for each site in the first column of file shfac.ext.<br>See also HAM_BXCSCAL.
TEMP | r | ALL | Y | 0 | (DLM) spin temperature.

{::nomarkdown}</div>{:/}

##### _GW_
Category GW holds parameters specific to GW calculations, particularly for the GW driver **lmfgwd**{: style="color: blue"}. Most of these tokens supply values for tags in the GWinput template when **lmfgwd****{: style="color: blue"} generates it (job −1).

<div onclick="elm = document.getElementById('gwtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="gwtable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
CODE | i | lmfgwd | Y | 2 | This token tells what GW code you are creating input files for.<br>lmfgwd serves as a driver to several GW codes {::nomarkdown} <ul><li>0. First GW version v033a5 (code still works but it is no longer maintained).</li><li>2. Current version of GW codes</li><li>1. Driver for the Julich spex code (not fully debugged or maintained)</li><li>10. Driver for the Rutgers DMFT code (under development)</li></ul> {:/}
NKABC | 1 to 3 i | | Y | | Defines the k-mesh for GW. This token serves the same function for GW as BZ_NKABC does for the LDA codes, and the input format is the same.<br><br>When generating a GWinput template, lmfgwd passes the contents of NKABC to the n1n2n3 tag.<br><br>Note: Shell scripts lmgw and lmgwsc used for the GW codes may also use this token.<br>When invoked with switches --getsigp or --getnk, they will modify the n1n2n3 in GWinput.<br>The data they use is taken from GW\_NKABC.
MKSIG | i | lmfgwd | Y | 3 | (self-consistent calculations only).<br>Controls the form of $ V^(xc) $ (the static QSGW approximation to the dynamical self-energy Σ).<br>In the table below $ Σ_(nn) $‘ (E) refers to a matrix element of Σ between eigenstates n and n‘, at energy E relative to $ E_F $.<br>When generating a GWinput template, lmfgwd passes MKSIG to the iSigMode tag.<br>Values of this tag have the following meanings.{::nomarkdown}<ul><li>0. do not make V<sub>xc</sub></li><li>1. V<sub>xc</sub> = Σ<sub>nn</sub>‘ (E<sub>F</sub>)<br>if n≠n‘, and Σ<sub>nn</sub>(E<sub>n</sub>) if n=n‘:<br>mode B, Eq.(11) in Phys. Rev. B76, 165106 (2007)</li><li>V<sub>xc</sub> = 1/2[Σ</sub>nn</sub>‘ (E<sub>n</sub>) + Σ<sub>nn</sub>‘ (E<sub>n</sub>‘)]:<br>mode A, Eq.(10) in Phys. Rev. B76, 165106 (2007)</li><li>“eigenvalue only” self-consistency V<sub>xc</sub> = δ<sub>nn</sub>‘Σ<sub>nn</sub>‘ (E<sub>n</sub>)</li></ul> {:/}
GCUTB | r | lmfgwd | Y | 2.7 | G-vector cutoff for basis envelope functions as used in the GW package.<br>When generating a GWinput template, lmfgwd passes GCUTB to the QpGcut_psi tag.
GCUTX | r | lmfgwd | Y | 2.2 | G-vector cutoff for interstitial part of two-particle objects such as the screened coulomb interaction.<br>When generating a GWinput template, lmfgwd passes GCUTX to the QpGcut_cou tag.
ECUTS | r | lmfgwd | Y | 2.5 | (self-consistent calculations only). Maximum energy for which to calculate the $ V^(xc) $ described in MKSIG above.<br>This energy should be larger than HAM_SIGP_EMAX which is used to interpolate $ V^(xc) $.<br>When generating a GWinput template, lmfgwd passes ECUTS+1/2 to the emax_sigm tag.
NIME | i | lmfgwd | Y | 6 | Number of frequencies on the imaginary integration axis when making the correlation part of Σ.<br><br>When generating a GWinput template, lmfgwd passes NIME to the niw tag.
DELRE | r | lmfgwd | Y | .01, .04 | frequency mesh parameters (dw,omg\_c) definining the real axis mesh when calculating Im $ χ_0 $.<br>The ith mesh point is given by:<br>$ ω_i = dw × (i−1) + [dw × (i−1)]^2/omg_c/2 $ <br>Points are approximately uniformly spaced, separated by dw, up to frequency omg\_c, around which point the spacing begins to increase linearly with frequency.<br><br>When generating a GWinput template, lmfgwd passes DELRE(1) to the dw tag and DELRE(2) to the omg\_c tag.<br><br>Note: the similarity to OPTICS\_DW used by the optics part of lmf and lm.
DELTA | r | lmfgwd | Y | -1e-4 | δ-function broadening for calculating $ χ_0 $, in atomic units.<br>Tetrahedron integration is used if DELTA<0.<br><br>When generating a GWinput template, lmfgwd passes DELTA to the delta tag.
GSMEAR | r | lmfgwd | Y | .003 | Broadening width for smearing pole in the Green’s function when calculating Σ.<br><br>This parameter is sometimes important in metals, e.g. Fe.<br>See Section 3 in this manual.<br><br>When generating a GWinput template, lmfgwd passes GSMEAR to the esmr tag.
PBTOL | r | lmfgwd | Y | .001 | Overlap criterion for product basis functions inside augmentation spheres.<br>The overlap matrix of the basis of product functions generated and diagonalized for each l. Functions with overlaps less than PBTOL are removed from the product basis.<br><br>When generating a GWinput template, lmfgwd passes PBTOL to the second line after the the start of the PRODUCT_BASIS section.

{::nomarkdown}</div>{:/}

##### _HEADER_
This category is optional, and merely prints to the standard output whatever text is in the category. For example:

~~~
HEADER  This line and the following one are printed to
        standard out on execution of a program.
XXX
~~~

Alternately:

~~~
HEADER [ In this form only two lines reside within the
        category delimiters,]
        and only two lines are printed.
~~~

##### _IO_
This optional category controls what kind of information, and how much, is written to the standard output file.

<div onclick="elm = document.getElementById('iotable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="iotable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
SHOW | 1 | all | Y | F | Echo lines as it is read from input file and parsed by the proprocessor.<br>Command-line argument --show provides the same functionality.
HELP | 1 | all | Y | F | Show what input would be sought, without attempting to read data.<br>Command-line argument --input provides the same functionality.
VERBOS | 1 to 3 | all | Y | 30 | Sets the verbosity. 20 is terse, 30 slightly terse, 40 slightly verbose, 50 verbose, and so on. If more than one number is given, later numbers control verbosity in subsections of the code, notably the parts dealing with augmentation spheres.<br>May also be set from the command-line: --pr#1[,#2]
IACTIV | 1 | all | Y | F | Turn on interactive mode. At some point programs will prompt you with queries.<br>May also be controlled from the command-line: --iactiv or --iactiv=no.
TIM | 1 or 2 | all | Y | 0, 0 | Prints out CPU usage of blocks of code in a tree format.<br>First value sets tree depth. Second value, if present, prints timings on the fly.<br>May also be controlled from the command-line: --time=#1[,#2]

{::nomarkdown}</div>{:/}

##### _ITER_
The ITER category contains parameters that control the requirements to reach self-consistency.

It applies to all programs that iterate to self-consistency:

~~~
lm,
lmfa,
lmf,
lmmc,
lmgf,
lmpg,
tbe.
~~~

<div onclick="elm = document.getElementById('itertable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="itertable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
NIT | i | all | Y | 1 | Maximum number of iterations in the self-consistency cycle.
NRMIX | i1 i2 | ASA, lmfa | Y | 80, 2 | Uses when self-consistency is needed inside an augmentation sphere. This occurs when the density is determined from the momentsQ0,Q1,Q2 in the ASA; or in the free atom code, just Q0.<br>i1: max number of iterations<br>i2: number of prior iterations for Anderson mixing of the sphere density<br><br>Note: You will probably never need to use this token.
MIX | c | all | Y | | Mixing rules for mixing input, output density in the self-consistency cycle. Syntax:<br>A[nmix][,b=beta][,bv=betv][,n=nit][,w=w1,w2][,nam=fn][,k=nkill][;...] or<br>B[nmix][,b=beta][,bv=betv][,wc=wc][,n=#][,w=w1,w2][,nam=fn][,k=nkill]
AMIX | c | ASA | Y | | Mixing rules when Euler angles are mixed independently. Syntax as in MIX
CONV | r | all | Y | 1e-4 | Maximum energy change from the prior iteration for self-consistency to be reached.
CONVC | r | all | Y | 1e-4 | Maximum in the RMS difference in $ <n^(out) − n^(in)> $.<br><br>In the ASA, this is measured by the change in moments Q0..Q2 and log derivative parameter P.<br><br>In the full-potential case it is measured by an integral over the various parts of n (local, interstitial parts).
UMIX | r | all | Y | 1 | Mixing parameter for density matrix; used with LDA+U
TOLU | r | all | Y | 0 | Tolerance for density matrix; used with LDA+U
NITU | i | all | Y | 0 | Maximum number of LDA+U iterations of density matrix

{::nomarkdown}</div>{:/}

##### _OPTICS_
Optics functions available with the ASA extension packages OPTICS.

It is read by **lm**{: style="color: blue"} and is also partially implemented in full-potential **lmf**{: style="color: blue"}.

<div onclick="elm = document.getElementById('opticstable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="opticstable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | OPTICS | Y | 0 | 0: make no optics calculations<br>1: generate linear $ ε_2 $<br>20: generate second harmonic ε<br>Example: optics/test/test.optics sic<br><br>The following cases (MODE < 0) generate joint or single density-of-states.<br><br>Note: MODE < 0 works only with LTET=3 described below:{::nomarkdown}<ul><li> −1: generate joint density-of-states<br>Examples:<br>(ASA)   optics/test/test.optics --all 4<br>(FP)   fp/test/test.fp zbgan</li><li>−2: generate joint density-of-states, spin 2<br>Example:optics/test/test.optics fe 6</li><li>−3: generate up-down joint density-of-states</li><li>−4: generate down-up joint density-of-states</li><li>−5: generate spin-up single density-of-states<br><br>Example: optics/test/test.optics --all 7</li><li>−6: generate spin-dn single density-of-states</li></ul> {:/}
LTET | i | OPTICS | Y | 0 | 0: Integration by Methfessel-Paxton sampling<br>1: standard tetrahedron integration<br>2: standard tetrahedron integration<br>3: enhanced tetrahedron integration<br><br>Note: In the metallic case, states near the Fermi level must be treated with partial occupancy. LTET=3 is the only scheme that handles this properly.<br>It was adapted from the GW package and has extensions, e.g. the ability to handle non-vertical transitions $ k^(occ) ≠ k^(unocc) $.
WINDOW | r1 r2 | OPTICS | N | 0 1 | Energy (frequency) window over which to calculate Im[ε(ω)].<br>Im ε is calculated on a mesh of points $ ω_i $.<br>The mesh spacing is specified by NPTS or DW, below.
NPTS | i | OPTICS | N | 501 | Number of mesh points in the energy (frequency) window. Together with WINDOW, NPTS specifies the frequency mesh as:<br>$ ω_i $ = WINDOW(1) + DW×(i−1)<br>where DW = (WINDOW(2)−WINDOW(1))/(NPTS−1)<br><br>Note: you may alternatively specify DW below.
DW | r1 [r2] | OPTICS | Y | | Frequency mesh spacing DW[,OMG]. You can supply either one argument, or two.<br>If one argument (DW) is supplied, the mesh will consist of evenly spaced points separated by DW.<br>If a second argument (OMG) is supplied, points are spaced quadratically as:<br>$ ω_i $ = WINDOW(1) + DW×(i−1) + [DW×(i−1)]2/OMG/2<br>Spacing is approximately uniform up to frequency OMG; beyond which it increases linearly.<br>Note: The quadratic spacing can be used only with LTET=3.
FILBND | i1 [i2] | OPTICS | Y | 0 0 | i1[,i2] occupied energy bands from which to calculate ε using first order perturbation theory, without local fields.<br>i1 = lowest occupied band<br>i2 = highest occupied band (defaults to no. electrons)
EMPBND | i1 [i2] | OPTICS | Y | 0 0 | i1[,i2] occupied energy bands from which to calculate ε using first order perturbation theory, without local fields.<br>i1 = lowest unoccupied band<br>i2 = highest unoccupied band (defaults to no. bands)
PART | l | OPTICS | Y | F | Resolve ε or joint DOS into band-to-band contributions, or by k.<br>Result is output into file popt.ext.{::nomarkdown}<ul><li>0. No decomposition</li><li>1. Resolve ε or DOS into individual (occ,unocc) contributions<br><br>Example: optics/test/test.optics ogan 5</li><li>2. Resolve ε or DOS by k<br><br>Example: optics/test/test.optics --all 6</li><li>3. Both 1 and 2<br>Add 10 to write popt as a binary file.</li></ul> {:/}
CHI2[..] | | OPTICS | Y | | Tag containing parameters for second harmonic generation.<br>Not calculated unless tag is parsed.<br><br>Example: optics/test/test.optics sic
CHI2\_NCHI2 | i | OPTICS | N | 0 | Number of direction vectors for which to calculate $ χ_2 $
CHI2\_AXES | i1, i2, i3 | OPTICS | N | direction vectors for each of the NCHI2 sets
ESCISS | r | OPTICS | Y | 0 | Scissors operator (constant energy added to unoccupied levels)
ECUT | r | OPTICS | Y | 0.2 | Energy safety margin for determining (occ,unocc) window.<br>lmf will attempt to reduce the number of (occ,unocc) pairs by restricting, for each k, transitions that contribute to the response, i.e. to those inside the optics WINDOW.<br>The window is padded by ECUT include states outside, but near the edge of the window.<br>States outside window may nevertheless make contribution, e.g. because they can be part of a tetrahedron that does contribute.<br>If you do not want lmf to restrict the range, use ECUT<0.

{::nomarkdown}</div>{:/}

##### _OPTIONS_
Portions of OPTIONS are read by these codes:

~~~
lm,
lmfa,
lmfgwd,
lmfgws,
lmf,
lmmc,
lmgf,
lmdos,
lmstr,
lmctl,
lmpg,
tbe
~~~

<div onclick="elm = document.getElementById('optionstable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="optionstable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
HF | 1 | lm, lmf | Y | F | If T, Use the Harris-Foulkes functional only; do not evaluate output density.
SHARM | 1 | ASA, lmf, lmfgwd | Y | F | If T, use true spherical harmonics, rather than real harmonics.
FRZ | l | all | Y | F | (ASA) If T, freezes core wave functions.<br>(FP) If T, freezes the potential used to make augmented partial waves, so that the basis set does not change with potential.
SAVVEC | 1 | lm | Y | F | Save eigenvectors on disk. (This may be enabled automatically in some circumstances)
Q | c | all | Y | | Q=HAM, Q=BAND,<br>Q=MAD, Q=ATOM,<br>Q=SHOW<br>make the program stop at selected points without completing a full iteration.
SCR | i | ASA | Y | 0 | Is connected with the generation or use of the q->0 ASA dielectric response function. It is useful in cases when there is difficulty in making the density self-consistent.<br>See linear-response-asa.html for documentation.{::nomarkdown}<ul></li>0. do not screen qout−qin.</li><li>1. Make the ASA response function P0.</li><li>2. Use P0 to screen qout−qin and the change in ves.</li><li>3. 1+2 (lmgf only)</li><li>4. screen qout−qin from a model P0</li><li>5. illegal input</li><li>6. Use P0 to screen the change in ves only</li></ul> {:/} P0 and U should be updated every iteration, but this is expensive and not worth the cost. However, you can: <br>Add 10*k to recompute intra-site contribution U every kth iteration, 0<k≤9.<br>Add 100*k to recompute P0 every kth iteration (lmgf only).<br><br>Examples: testing/test.scr and gf/test/test.gf mnpt 6
ASA[...] | r | ASA | N | | Parameters associated with ASA-specific input.
ASA\_ADNF | 1 | ASA | Y | F | Enables automatic downfolding of orbitals
ASA\_NSPH | 1 | ASA | Y | 0 | Set to 1 to generate l>0 contributions (from neighboring sites) to l=0 electrostatic potential
ASA\_TWOC | i | ASA | Y | 0 | Set to 1 to use the two-center approximation ASA hamiltonian
ASA\_GAMMA | i | ASA | Y | 0 | Set to 1 to rotate to the (orthogonal) gamma representation. This should have no effect on the eigenvalues for the usual three-center hamiltonian, but converts the two-center hamiltonian from first order to second order.<br>Set to 2 to rotate to the spin-averaged gamma representation. <br>The lm code does not allow downfolding with GAMMA≠0.
ASA\_CCOR | 1 | lm | Y | T | If F, suppresses the combined correction. By default it is enabled. Note: NB: if any orbitals are downfolded, CCOR is automatically enabled.
ASA\_NEWREP | 1 | NC | Y | F | Set to 1 to rotate structure constants to a user-specified representation.<br>It requires special compilation to be effective
ASA\_NOHYB | 1 | NC | Y | F | Set to 1 to turn off hybridization
ASA\_MTCOR | 1 | NC | Y | F | Set to T to turn on Ewald MT correction
ASA\_QMT | r | NC | Y | 0 | Override standard background charge for Ewald MT correction<br>Input only meaningful if MTCOR=T

{::nomarkdown}</div>{:/}

##### _PGF_
Category PGF concerns layer Green’s function calculations by the layer Green’s function program **lmpg**{: style="color: blue"}.

It is read by **lmpg**{: style="color: blue"} and **lmstr**{: style="color: blue"}.

<div onclick="elm = document.getElementById('pgftable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="pgftable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
MODE | i | ASA | Y | | 0: do nothing<br>1: diagonal layer GF<br>Examples: pgf/test/test.pgf -all 5 and pgf/test/test.pgf -all 6<br>2: left- and right-bulk bulk GF<br>3: find k(E) for left bulk<br>Example: pgf/test/test.pgf 2<br>4: find k(E) for right bulk<br>5: Calculate ballistic current<br>Example: pgf/test/test.pgf femgo
SPARSE | i | ASA | Y | 0 | 0: Calculate G layer by layer using Dyson’s equation<br>Example: pgf/test/test.pgf -all 5<br>1: Calculate G using LU decomposition<br>Example: pgf/test/test.pgf -all 6
PLATL | r | ASA | N | | The third lattice vector of left bulk region
PLATR | r | ASA | N | | The third lattice vector of right bulk region
GFOPTS | c | ASA | Y | | ASCII string with switches governing execution of lmgf or lmpg. Use `;‘ to separate the switches.<br><br>Available switches:<br><br>‘p1‘ First order of potential function<br><br>‘p3‘ Third order of potential function<br><br>‘pz‘ Exact potential function (some problems; not recommended<br><br>Use only one of the above; if none are used, the code makes second order potential functions<br><br>‘idos‘ integrated DOS (by principal layer in the lmpg case)<br><br>‘noidos‘ suppress calculation of integrated DOS<br><br>‘pdos‘ accumulate partial DOS<br><br>‘emom‘ accumulate output moments; use ‘noemom‘ to suppress<br><br>‘noemom‘ suppresss accumulation of output moments<br><br>‘sdmat‘ make site density-matrix<br><br>‘dmat‘ make density-matrix<br><br>‘frzvc‘ do not update potential shift needed to obtain charge neutrality<br><br>'padtol‘ Tolerance in Pade correction to charge. If tolerance exceeded, lmgf will repeat the band pass with an updated Fermi level<br><br>‘omgtol‘ (CPA) tolerance criterion for convergence in coherent potential<br><br>‘omgmix‘ (CPA) linear mixing parameter for iterating convergence in coherent potential<br><br>‘nitmax‘ (CPA) maximum number of iterations to iterate for coherent potential<br><br>‘lotf‘ (CPA)<br><br>‘dz‘ (CPA)

{::nomarkdown}</div>{:/}

##### _SITE_
Category SITE holds site information. As in the SPEC category, tokens must read for each site entry, and a similar restriction applies as to the order of tokens. Token ATOM= must be the first token for each site, and all tokens defining parameters for that site must occur before a subsequent ATOM=.

<div onclick="elm = document.getElementById('sitetable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="sitetable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
FILE | c | all | Y | | Provides a mechanism to read site data from a separate file. File subs/iosite.f documents the syntax of the site file structure.<br>The reccommended (standard) format has the following syntax:<br><br>The first line should contain a ‘%’ in the first column, and a `version’ token vn=#.<br>Structural data (see category STRUC documentation) may also be put this line. Each subsequent line supplies input for one site. In the simplest format, a line would would have the following:<br>spid x y z<br>where spid is the species identifier (same information would otherwise be specified by token ATOM= below) and x y z are the site positions.<br><br>Examples: fp/test/test.fp er and fp/test/test.fp tio2<br><br>Bug: when you read site data from an alternate file, the reader doesn’t compute the reference energy.<br><br>Kotani format (documented here but no longer maintained) In this alternative format the first four lines always specify data read in the STRUC category; see FILE= in STRUC.<br>Then follow lines, one line for each site<br>ib iclass spid x y z<br>The first number is merely a basis index and should increment 1,2,3,4,… in successive lines. The second class index is ignored by these programs. The remaining columns are the species identifier for the site positions.<br><br>If SITE_FILE is missing, the following are read from the ctrl file:
ATOM | c | all | N | | Identifies the species (by label) to which this atom belongs. It is a fatal error for the species not to have been defined.
ATOM\_POS | r1 r2 r3 | all | N | | the basis vector (length 3), in dimensionless Cartesian coordinates. As with the primitive lattice translation vectors, the true vectors (in atomic units) are scaled from these by ALAT in category STRUC.<br>NB: XPOS and POS are alternative forms of input. One or the other is required.
ATMOM\_XPOS | r1 r2 r3 | all | N | | Atom coordinates, as (fractional) multiples of the lattice vectors.<br>NB: XPOS and POS are alternative forms of input. One or the other is required.
ATOM\_DPOS | r1 r2 r3 | all | Y | 0 0 0 | Shift in atom coordinates to POS
ATOM\_RELAX | i1 i2 i3 | all | Y | 1 1 1 | relax site positions (lattice dynamics or molecular statics) or Euler angles (spin dynamics)
ATOM\_RMAXS | r | FP | Y | | Site-dependent radial cutoff for structure constants, in a.u.
ATOM\_ROT | c | ASA | Y | | Rotation of spin quantization axis at this site
ATOM\_PL | i | lmpg | Y | 0 | (lmpg) Assign principal layer number to this site

{::nomarkdown}</div>{:/}

##### _SPEC_
Category SPEC contains species-specific information. Because data must be read for each species, tokens are repeated (once for each species). For that reason, there is some restriction as to the order of tokens. Data for a specific species (Z=, R=, R/W=, LMX=, IDXDN= and the like described below) begins with a token ATOM=; input of tokens specific to that species must precede the next occurence of ATOM=.  

The following four species apply to the automatic sphere resizer:

<div onclick="elm = document.getElementById('spec1table'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="spec1table">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
SCLWSR | r | ALL | Y | 0 | SCLWSR>0 turns on the automatic sphere resizer. It defaults to 0, which turns off the resizer.<br>The 10’s digit tells the resizer how to deal with resizing empty spheres; see lmto.html.
OMAX1 | r1 r2 r3 | ALL | Y | 0.16, 0.18, 0.2 | Constrains maximum allowed values of sphere overlaps.<br>You may input up to three numbers, which correspond to atom-atom, and atom-empty-sphere, and empty-sphere-empty-sphere overlaps respectively.
OMAX2 | r1 r2 r3 | ALL | Y | 0.4, 0.45, 0.5 | Constrains maximum allowed values of sphere overlaps defined differently from OMAX1; see lmto.html.<br>Both constraints are applied.
WSRMAX | r | ALL | Y | 0 | Imposes an upper limit to any one sphere radius

{::nomarkdown}</div>{:/}

The following tokens are input for each species. Data sandwiched between successive
occurences of ATOM apply to one species.

<div onclick="elm = document.getElementById('spec2table'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="spec2table">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
ATOM | c | all | N | | A character string (8 characters or fewer) that labels this species. This label is used, e.g. by the SITE category to associate a species with an atom at a given site.<br>Species are split into classes; how and when this is done depends whether you are using an ASA or full-potential implementation.<br><br>ASA-specific:<br>The species ID also names a disk file with information about that atom (potential parameters, moments, potential and some sundry other information). More precisely, species are split into classes, the program differentiates class names by appending integers to the species label. The first class associated with the species has the species label; subsequent ones have integers appended.<br><br>Example: testing/test.ovlp 3
Z | r | all | N | | Nuclear charge. Normally an integer, but Z can be a fractional number. A fractional number implies a virtual crystal approximation to an alloy with some Z intermediate between the two integers sandwiching it.
R | r | all | N | | The augmentation sphere radius, in atomic units. This is a required input for most programs:<br>choose one of R=, R/W= or R/A=. Read descriptions of the latter two below for further remarks; also see this page for a more complete discussion on the choice of sphere radii.<br><br>lmchk can find sphere radii automatically for you. Invoke lmchk with<br>–getwsr.<br>You can also rescale user-chosen radii to meet constraints with the SCLWSR token.
R/W | r | all | N | | R/W= ratio of the augmentation sphere radius to the average Wigner Seitz radius W.<br>W is the radius of a sphere such that (4πW3/3) = V/N, where V/N is the volume per atom.<br>Thus if all radii are equal with R/W=1, the sum of sphere volumes would fill space, as is usual in the ASA.<br><br>ASA-specific:<br>You must choose the radii so that the sum of sphere volumes (4π/3ΣiRi3) equals the unit cell volume V; otherwise results may become unreliable. The space-filling requirement means sphere may overlap quite a lot, particularly in open systems. If sphere overlaps get too large, (>20% or so) accuracy becomes an issue. In such a case you should add “empty spheres” to fill space. Use lmchk to print out sphere overlaps. lmchk also has an automatic empty spheres finder, which you invoke with the –findes switch; see here for a discussion.<br><br>Example: testing/test.ovlp 3<br><br>FP-specific:<br>FP results are much less sensitive to the choice of sphere radii. Strictly, the spheres should not overlap, but because of lmf‘s unique augmentation scheme, overlaps of up to 10% cause negligibly small errors as a rule.<br>(This does not apply to GW calculations!)<br>Even so, it is not advisable to let the overlaps get too large. As a general rule the L-cutoff should increase as the sphere radius increases. Also it has been found in practice that self-consistency is harder to accomplish when spheres overlap significantly.
R/A | r | all | N | | R/A = ratio of the aumentation sphere radius to the lattice constant
A | r | all | Y | | Radial mesh point spacing parameter. All programs dealing with augmentation spheres represent the density on a shifted logarithmic radial mesh. The ith point on the mesh is $ r_i $ = b[exp(a(i−1)−1]. b is determined from the number of radial mesh points specified by NR.
NR | i | all | Y | Depends on other input | Number of radial mesh points
LMX | i | all | Y | | basis l-cutoff inside the sphere. If not specified, it defaults to NL−1
RSMH | r | lmf, lmfgwd | Y | 0 | Smoothing radii defining basis, one radius for each l.<br>RSMH and EH together define the shape of basis function in lmf.<br>To optimize, try running lmf with --optbas
EH | r | lmf, lmfgwd | Y | | Hankel energies for basis, one energy for each l. RSMH and EH together define the shape of basis function in lmf.
RSMH2 | r | lmf, lmfgwd | Y | 0 | Basis smoothing radii, second group
EH2 | r | lmf, lmfgwd | Y | | Basis Hankel function energies, second group
LMXA | i | FP | Y | NL - 1 | angular momentum l-cutoff for projection of wave functions tails centered at other sites in this sphere.<br>Must be at least the basis l-cutoff (specified by LMX=).
IDXDN | i | ASA | Y | 1 | a set of integers, one for each l-channel marking which orbitals should be downfolded.<br>0 use automatic downfolding in this channel.<br>1 leaves the orbitals in the basis.<br>2 folds down about the inverse potential function at $ E_ν $ <br>3 folds down about the screening constant alpha.<br>In the FP case, 1 includes the orbital in the basis; >1 removes it
KMXA | i | lmf, lmfgwd | Y | 3 | Polynomial cutoff for projection of wave functions in sphere.<br>Smoothed Hankels are expanded in polynomials around other sites instead of Bessel functions as in the case of normal Hankels.
RSMA | r | lmf, lmfgwd | Y | R * 0.4 | Smoothing radius for projection of smoothed Hankel tails into augmentation spheres. sm-Hankels are expanded in polynomials by integrating with Gaussians at that site. Thus RSMA=0 => sm-Hankels Taylor series expansion about the origin. For large KMXA the choice is irrelevant, but RSMA is best chosen that maximizes the convergence of sm-Hankels with KMXA.
LMXL | i | lmf, lmfgwd | Y | NL - 1 | Angular momentum l-cutoff for explicit representation of local charge on a radial mesh.
RSMG | r | lmf, lmfgwd | Y | R/4 | Smoothing radius for Gaussians added to sphere densities to correct multipole moments needed for electrostatics. Value should be as large as possible but small enough that the Gaussian doesn’t spill out significantly beyond rmt.
LFOCA | i | FP | Y | 1 | Prescribes how the core density is treated.<br><br>0 confines core to within RMT. Usually the least accurate.<br>1 treats the core as frozen but lets it spill into the interstitial<br>2 same as 1, but interstitial contribution to vxc treated perturbatively.
RFOCA | r | FP | Y | R * 0.4 | Smoothing radius fitting tails of core density. A large radius produces smoother interstitial charge, but less accurate fit.
RSMFA | r | FP | Y | R/2 | Smoothing radius for tails of free-atom charge density. <br>Irrelevant except first iteration only (non-self-consistent harris).<br>A large radius produces smoother interstitial charge, but somewhat less accurate fit.
RS3 | r | FP | Y | 1 | Minimum allowed smoothing radius for local orbital
HCR | r | lm | Y | | Hard sphere radii for structure constants<br>*If token is not parsed, attempt to read the following:
HCR/R | r | lm | Y | 0.7 | Hard sphere radii for structure constants, in units of R
ALPHA | r | ASA | Y | | Screening parameters for structure constants
DV | r | ASA | Y | 0 | Artificial constant potential shift added to spheres belonging to this species
MIX | 1 | ASA | Y | F | Set to suppress self-consistency of classes in this species
IDMOD | i | all | Y | 0 | 0 : floats log derivative parameter $ P_l $ to band center of gravity<br>1 : freezes Pl<br>2 : freezes linearization energy $ E_ν $.
CSTRMX | 1 | all | Y | F | Set to T to exclude this species when automatically resizing sphere radii
GRP2 | i | ASA | Y | 0 | Species with a common nonzero value of GRP2 are symmetrized, independent of symmetry operations.<br>The sign of GRP2 is used as a switch, so species with negative GRP2 are symmetrized but with spins flipped (NSPIN=2)
FRZWF | 1 | FP | Y | F | Set to freeze augmentation wave functions for this species
IDU | i | all | Y | 0 0 0 0 | LDA+U mode:<br><br>0 No LDA+U<br>1 LDA+U with Around Mean Field limit double counting<br>2 LDA+U with Fully Localized Limit double counting<br>3 LDA+U with mixed double counting
UH | r | all | Y | 0 0 0 0 | Hubbard U for LDA+U
JH | r | all | Y | 0 0 0 0 | Exchange parameter J for LDA+U
EREF= | r | all | Y | 0 | Reference energy subtracted from total energy
AMASS= | r | FP | Y | | Nuclear mass in a.u. (for dynamics)
C-HOLE | c | lmf, lm | Y | | Channel for core hole. You can force partial core occupation.<br>Syntax consists of two characters, the principal quantum number and the second one of `s’,`d’,`d’,`f’ for the l quantum number, e.g. `2s’<br>See Partially occupied core holes for description and examples.<br><br>Default: nothing
C-HQ | r[,r] | all | Y | -1 0 | First number specifies the number of electrons to remove from the l channel specified by C-HOLE=.<br>Second (optional) number specifies the hole magnetic moment.<br>See Partially occupied core holes for description and examples.
P | r,r,... | all | Y | | starting values for potential functions, one for each of l=0..LMXA<br><br>Default: taken from an internal table.
PZ | r,r,... | FP | Y | 0 | starting values for local orbital’s potential functions, one for each of l=0..LMX. Setting PZ=0 for any l means that no local orbital is specified for this l. Each integer part of PZ must be either one less than P (semicore state) or one greater (high-lying state).
Q | r,r,... | all | Y | | charges for each l-channel making up free-atom density<br><br>Default: taken from an internal table.
MMON | r,r,... | all | Y | 0 | magnetic moments for each l-channel making up free-atom density<br>Relevant only for the spin-polarized case.

{::nomarkdown}</div>{:/}

##### _STR_
Category STR contains information connected with real-space structure constants, used by the ASA programs. It is read by **lmstr**{: style="color: blue"}, **lmxbs**{: style="color: blue"}, **lmchk**{: style="color: blue"}, and **tbe**{: style="color: blue"}.

<div onclick="elm = document.getElementById('strtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="strtable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
RMAXS | r | all | Y | | Radial cutoff for strux, in a.u.<br>If token is not parsed, attempt to read the following:
RMAX | r | all | Y | 0 | the maximum sphere radius (in units of the average WSR) over which neighbors will be included in the generation of structure constants. <br>This takes a default value and is not required input. It is an interesting exercise to see how much the structure constants and eigenvalues change when this radius is increased.
NEIGHB | i | FP | Y | 30 | Minimum number of neighbors in cluster
ENV\_MODE | i | all | Y | 0 | Type of envelope functions:<br><br>0 2nd generation<br>1 SSSW (3rd generation)<br>2 NMTO<br>3 SSSW and val-lap basis
ENV\_NEL | i | lm, lmstr | Y | | (NMTO only) Number of NMTO energies
ENV\_EL | r | lm, lmstr | N | 0 | SSSW of NMTO energies, in a.u.
DELRX | r | ASA | Y | 3 | Range of screened function beyond last site in cluster
TOLG | r | FP | Y | 1e-6 | Tolerance in l=0 gaussians, which determines their range
RVL/R | r | all | Y | 0.7 | Radial cutoff for val-lap basis (this is experimental)
VLFUN | i | all | Y | 0 | Functions for val-lap basis (this is experimental)<br>0 G0 + G1<br>1 G0 + Hsm<br>2 G0 + Hsm-dot
MXNBR | i | ASA | Y | 0 | make lmstr allocate enough memory in dimensioning arrays for MXNBR neighbors in the neighbor table. This is rarely needed
SHOW | 1 | lmstr | Y | F | Show strux after generating them
EQUIV | 1 | lmstr | Y | F | if true, try to find equivalent neighbor tables, to reduce the computational effort in generating strux.<br>Not generally recommended
LMAXW | i | lmstr | Y | -1 | l-cutoff for (optional) Watson sphere, used to help localize strux
DELRW | r | lmstr | Y | 0.1 | range extending beyond cluster radius for Watson sphere
IINV\_NIT= | i | lmstr | Y | 0 | Number of iterations
IINV\_NCUT | i | lmstr | Y | 0 | Number of sites for inner block
IINV\_TOL | r | lmstr | Y | 0 | Tolerance in errors

*IINV parameters govern iterative solutions to screened strux

{::nomarkdown}</div>{:/}

##### _START_
Category START is specific to the ASA. It controls whether the code starts with moments P,Q or potential parameters; also the moments P,Q may be input in this category. It is read by **lm**{: style="color: blue"}, **lmgf**{: style="color: blue"}, **lmpg**{: style="color: blue"}, and **tbe**{: style="color: blue"}.

<div onclick="elm = document.getElementById('starttable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="starttable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
BEGMOM | i | ASA | Y | 1 | when true, causes program lm to begin with moments from which potential parameters are generated. If false, the potential parameters are used and the program proceeds directly to the band calculation.
FREE | 1 | ASA | Y | F | is intended to facilitate a self-consistent free-atom calculation. When FREE is true, the program uses rmax=30 for the sphere radius rather than whatever rmax is passed to it; the boundary conditions at rmax are taken to be value=slope=0 (rmax=30 should be large enough that these boundary conditions are sufficiently close to that of a free atom.); subroutine atscpp does not calculate potential parameters or save anything to disk; and lm terminates after all the atoms have been calculated.
CNTROL | 1 | ASA | Y | F | 	When CONTRL=T, the parser attempts to read the “continuously variable principal quantum numbers” P and moments Q0,Q1,Q2 for each l channel; see P,Q below.
ATOM | c | ASA | Y | | Class label. P,Q (and possibly other data) is given by class.<br>Tokens following a class label and preceding the next class label belong to that class.
ATOM\_P= and ATOM\_Q | c | ASA | Y | | Read “continuously variable principal quantum numbers” for this class (P=...), or energy moments Q0,Q1,Q2 (Q=...). P consists of one number per l channel, Q of three numbers (Q0,Q1,Q2) for each l.<br><br>Note In spin<br> polarized calculations, a second set of parameters must follow the first, and the moments should all be half of what they are in non-spin polarized calculations.<br><br>In this sample input file for Si, P,Q is given as:<br<br>>ATOM=SI  P=3.5 3.5 3.5    Q=1 0 0    2 0 0   0 0 0<br>ATOM=ES  P=1.5 2.5 3.5    Q=.5 0 0  .5 0 0   0 0 0<br><br>One electron is put in the Si s orbital, 2 in the p and none in the d, while 0.5 electrons are put in the s and p channels for the empty sphere. All first and second moments are zero. This rough guess produces a correspondingly rough potential.<br><br>You do not have to supply information here for every class; but for classes you do, you must supply all of (P,Q0,Q1,Q2). Data read in START supersedes whatever may have read from disk.<br><br>Remarks below provide further information about how P,Q is read and printed.
RDVES | 1 | ASA | Y | F | Read Ves(RMT) from the START category along with P,Q
ATOM\_ENU | r | ASA | Y | | Linearization energies

How the parser reads P,Q
Remember that knowledge of P,Q is sufficient to completely determine the ASA density.
Thus the ASA codes use several ways to read these important quantities.

The parser returns P,Q according the following priorities:

* P,Q are read from the disk, if supplied, (along possibly with other quantities such as potential parameters El, C, Δ, γ.) One file is created for each class that contains this data and other class-specific information. Some or all of the data may be missing from the disk files. Alternatively, you may read these data from a restart file rsta.ext, which if it exists contains data for all classes in one file. The program will not read this data by default; use --rs=1 to have it read from the rsta file. To write class data to rsta, use --rs=*,1 (* must be be 0 or 1)

* If START_CONTRL=T, P,Q (and possibly other quantities) are read from START for classes you supply (usually all classes). Data read from this category supersedes any that might have been read from disk. If class data read from either of these sources, the input system returns it. For classes where none is available the parser will pick a default:

  * If data from a different class but in the same species is available, use it.
  
  * Otherwise use some preset default values for P,Q.

After a calculation finishes you can run **lmctl**{: style="color: blue"} to read P,Q from disk and format it in a form ready to insert into the START category. Thus all the information needed to generate a self-consistent ASA calculation can be contained in the ctrl file.

When the sample Si test is run to self-consistency, invoking **lmctl**{: style="color: blue"} will generate something like:

~~~
ATOM=SI       P=  3.8303101  3.7074067  3.2545634
              Q=  1.1694276  0.0000000  0.0297168
                  1.8803181  0.0000000  0.0489234
                  0.1742629  0.0000000  0.0063520
ATOM=ES       P=  1.4162942  2.2521617  3.1546386
              Q=  0.2873686  0.0000000  0.0129888
                  0.3485430  0.0000000  0.0165416
                  0.1400664  0.0000000  0.0055459
~~~

Because the P‘s float to the band center-of gravity (i.e. center of gravity of the occupied states for a particular site and l channel) the corresponding first moments Q1 vanish. P‘s are floated by default since it minimizes the linearization error.

**Caution:**{: style="color: red"} Sometimes it is necessary to override this default: If the band CG (of the occupied states) is far removed from the natural CG of a particular channel, you must restrict how far P can be shifted to the band CG. In some cases, allowing P to float completely will result in “ghost bands”.

The high-lying Ga 4d state is a classic example. To restrict P to a fixed value, see SPEC_IDMOD.

In such cases, you want to pick P low, but not so low as to cause problems.

{::nomarkdown}</div>{:/}

##### _STRUC_

<div onclick="elm = document.getElementById('structable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show table.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="structable">{:/}

Token | Arguments | Program | Optional | Default | Explanation
- | - | - | - | - | -
FILE | c | all | Y | | provides a mechanism to read structural data from an independent file using alternate input styles.<br>If SITE is not present in the STRUC category, NBAS, PLAT and ALAT are read from the ctrl file.<br><br>File subs/iosite.f documents the syntax of the file structure.<br><br>The first line should contain a "% sign and a "version" token vn=#. On the same line, supply tokens nbas= and plat=, similar to the input file.<br>You can also include alat on this line.<br>If you omit it, alat is read from ALAT in the ctrl file.<br>Example: % vn=3.0 nbas=7 plat= -0.5 0.5 1 0.5 -0.5 1 0.5 0.5 1<br><br>Following the header line comes a table of site positions other site-related stuff. That table is not read in the STRUC category. To read site data from this file, specify FILE in the SITE category.<br><br>Kotani format (documented here but no longer maintained) The first line should contain a "%" sign and a "version" token vn=kotani. Then follow four lines containing real numbers:<br><br> #        <-- alat<br> # # #     <-- plat(1,1) plat(2,1) plat(3,1)<br> # # #     <-- plat(1,2) plat(2,2) plat(3,2)<br> # # #     <-- plat(1,3) plat(2,3) plat(3,3)
ALAT | r | all | N | | A scaling, in atomic units, of the primitive translation and basis vectors
NBAS | i | all | N | | Size of the basis
PLAT | r | all | N | | (dimensionless) primitive translation vectors
NSPEC | i | all | Y | | Number of atom species
DALAT | r | all | Y | 0 | is added to ALAT. Useful because the average Wigner-Seitz radius W is computed from ALAT, so quantities scaled by W are fixed while ALAT varies.<br>NB: this token is Not Particularly Useful for the ASA, since spheres must be space-filling.
NL= | i | all | Y | 3 | Sets a global default value for l-cutoffs $ l^(cut) $ : NL = [1 + $ l^(cut) $]. This default is used for both the basis and augmentation cutoffs.
SHEAR | r | all | Y | | Enables shearing of the lattice in a volume-conserving manner. For SHEAR=#1,#2,#3,#4, #4 is the distortion amplitude, and #1,#2,#3 are a direction vector.<br><br>Example:<br>SHEAR=0,0,1,0.01 <br>This distorts a lattice in initially cubic symmetry to tetragonal symmetry, with 0.01 shear.
ROT | c | all | Y | | Rotates the lattice and basis vectors, and the symmetry group operations by a unitary matrix.<br><br>Example:<br>ROT=z:pi/4,y:pi/3,z:pi/2 generates a rotation matrix corresponding to the Euler angles α=π/4, β=π/3 γ=π/2. See rotations.html for the general syntax.<br><br>Note:<br>Lattice and basis vectors, and point group operations (SYMGRP) are all rotated.
DEFGRD | r | all | Y | | A 3×3 matrix defining a general linear transformation of the lattice vectors.
STRAIN | r | all | Y | | A sequence of six numbers defining a general distortion of the lattice vectors
ALPHA | r | all | N | | Amount of Voigt strain

{::nomarkdown}</div>{:/}

##### _SYMGRP_

<div onclick="elm = document.getElementById('symtable'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show SYMGRP.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="symtable">{:/}

Category SYMGRP provides symmetry information; it helps in two ways. First it is the relevant information to find which sites are equivalent, which makes for simpler and more accurate band calculations, and second, it reduces the number of k-points needed in Brillouin zone integrations.  

Normally you don't need SYMGRP; the program is capable of finding its own symmetry operations. However, there are cases where it is useful or even necessary to manually specify them. For example when including spin-orbit coupling or noncollinear magnetism where the symmetry group isn't only specified by the atomic positions. In this case you need to supply extra information.  

You can use SYMGRP to explicitly declare a set of generators from which the entire group can be created. For example, the three operations R4X, MX and R3D are sufficient to generate all 48 elements of cubic symmetry.  

Unless conditions are set for noncollinear magnetism and/or SO coupling, the inversion is assumed by default as a consequence of time-reversal symmetry.  

A tag describing a generator for a point group operation has the form O(nx,ny,nz) where O is one of M, I or Rj, or E, for mirror, inversion j-fold rotation and identity operation, respectively. nx,ny,nz are a triplet of indices specifying the axis of rotation. You may use X, Y, Z or D as shorthand for (1,0,0), (0,1,0), (0,0,1), and (1,1,1) respectively. You may also enter products of rotations, such as I*R4X.

Thus

    SYMGRP  R4X MX R3D

specifies three generators (4-fold rotation around x, mirror in x, 3-fold rotation around (1,1,1)). Generating all possible combinations of these rotations will result in the 48 symmetry operations of the cube.  

To suppress all symmetry operations, use

    SYMGRP E

Full-potential programs (e.g. lmf) do not make spherical approximations to the potential and require you to specify the full space group. The translation part is appended to the point group (rotation) in one of the following forms: ':(x1,x2,x3)' or alternatively '::(p1,p2,p3)' with the double '::'. The first defines the translation in Cartesian coordinates; the second as multiples of plat. These two lines (taken from testing/ctrl.cr3si6) are equivalent specifications:

    SYMGRP   r6z:(0,0,0.4778973) r2(1/2,sqrt(3)/2,0)
	SYMGRP   r6z::(0,0,1/3)      r2(1/2,sqrt(3)/2,0)

###### _Keywords in the SYMGRP category_
SYMGRP accepts, in addition to symmetry operations the following keywords:

* `find‘ tells the program to determine its own symmetry operations. Thus:

      SYMGRP find
  
  amounts to the same as not incuding a SYMGRP category in the input at all  
   
  You can also specify a mix of generators you supply, and tell the program to find any others that might exist. For example:
  
      SYMGRP r4x find
 
  specifies that 4-fold rotation be included, and `find‘ tells the program to look for any additional symops that might exist.
  
* 'AFM':
  For certain antiferromagnets, certain translation operations exist provided the rotation/shift is accompanied by a spin flip. Say a translation of (-1/2,1/2,1/2)a restores the crystal structure, but all atoms after translation have opposite spin. Specify this symmetry with:
  
      SYMGRP   ...       AFM::-1/2,1/2,1/2

  This operation is used only by **lmf**{: style="color: blue"}.
  
* 'SOC' or 'SOC=2':
  Tells the symmetry group generator to exclude operations that do not preserve the z axis.  
  This is used particularly for spin-orbit coupling where the crystal symmetry is reduced (z is the quantization axis).
  SOC=2 is like SOC but allows operations that preserve z or flip z to −z.
  This works in some cases.  

  **Note:**{: style="color: red"} This keyword is only active when the two spin channels are linked, e.g. SO coupling or noncollinear magnetism.
  
* 'GRP2' turns on a switch that can force the density among inequivalent classes that share a common species to be averaged. In the ASA codes the density is spherical and the averaging is complete; in the FP case only the spherical part of the densities can be averaged. This helps sometimes with stabilizing difficult cases in the path to self-consistency.
  You specify which species are to be averaged with the SPEC_ATOM_GRP2 token.  
  
  'GRP2‘ averages the input density;
  'GRP2=2‘ averages the output density;
  'GRP2=3‘ averages both the input and the output density.
  
* 'RHOPOS' turns on a switch that forces the density positive at all points

{::nomarkdown}</div>{:/}

##### _VERS_
This category is used for version control. As of version 7, the input file must have following tokens for any program in the suite:

    VERS LM:7

It tells the input system that you have a v7 style input file.  

For a particular program you need an additional token to tell the parser that this file is set up for that program.
Thus your VERS category should read:

~~~

VERS LM:7 ASA:7              for lm, lmgf or lmpg
VERS LM:7 FP:7               for lmf or lmfgwd
VERS LM:7 MOL:3              for a molecules codes such as lmmc
VERS LM:7 TB:9               for the empirical tight-binding tbe
                             and so on.

~~~

Add version control tokens for whatever programs your input file is capable of handling.
