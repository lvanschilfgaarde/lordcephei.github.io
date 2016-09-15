---
layout: page-fullwidth
title: "Installation"
permalink: "/docs/install/"
header: no
---

### Table of Contents
{:.no_toc}
*  Auto generated table of contents
{:toc}

### Prerequisites

+ Modern C and Fortran compilers (GCC v4.7+ and Intel v11.1+ are known to work).
+ BLAS, LAPACK and fftw3 libraries.
+ Python v2.5+ (2.4 might work too but is not tested)
+ Scons v2.2+ (a local version is included if this is not available on the system)

MPI, BLACS, SCALAPACK etc.. are optional.

Since v7.10d libxc (v2.2+) is also a requirement. The enviroment variable LIBXCPATH should be set to the libxc installation path or the library path can be manually specified in the flags.mk file (discussed below).

### Installation Procedure

For installation of the package the repository should first be cloned on the local machine in the path of your choice. This location will be referred to from here on by `/path/to/lm`. In an empty folder, create *flags.mk* file containing the necessary variables. A working template with annotations can be produced with the included *genflags.py* utility e.g.:

`/path/to/lm/genflags.py intel opt > flags.mk      # if using intel compilers`

If an MPI version is to be built the relevant variables in the file have to be set to the appropriate compiler wrappers or alternatively the MPI INCLUDE paths and libraries need to be specified, together with the necessary preprocessing flags. An MPI enabled template of *flags.mk* can be obtained by appending mpi to the *genflags.py* command line arguments above.

In the same folder where you created the *flags.mk* file, compile the program using the scons utility. If the scons program is not installed in your machine, a local version provided in `/path/to/lm/scons-local/scons.py` can be used, just replace all occurrences of scons in the following commands. The dependency resolution, compilation, and linking is facilitated by the scons utility. For example:

`scons -Y /path/to/lm/ -j 16 all`

will build target all using up to 4 simultaneous compilation/linking processes. For a list of available targets execute the above without all. For a list of scons options use `--help`.

It is advisable to test the build. Each module has a related set of tests which can be invoked with the following command by replacing `<modulename>` with one of the following  module names: lm, fp, gf, pgf, sx, gwd, optics, tb, mol, dmft, gw.

`scons -Y /path/to/lm/ check<modulename>`

Just as the build itself, multiple tests can be run simultaneously with the `-j N` option to scons. The following convenience command will start all available tests:

`scons -Y /path/to/lm/ checks`

### Notes

If compiler optimisations cause erroneous results one may wish to set lower level of optimisations for certain sensitive files only or have a number of different flags applying to different groups of files. If such is the case the *flags.mk* file may be modified to contain the the special flags for a group of files in a variable beginning with lessflags and ending in a word of one's choosing. Then a variable beginning with lessfiles and ending in the word chosen for the lessflags variable, must be defined containing the questionable file names relative to the `lm/` path. Many pairs of special flags/sensitive files groups are allowed so long as the contents of the lesserfiles variables do not overlap.

To obtain an example containing special flags try `genflags.py intel opt`

On CRAY installations it is advisable to use cray's compiler wrappers cc, ftn and CC with the intel backend. Assuming the default backend is cray, module swap PrgEnv-cray PrgEnv-intel switch your environment to intel. The wrappers bundle pretty much all standard system libs (BLAS, LAPACK, SCALAPACK, FFTW3, MPI etc..) except libxc. genflags cray opt will give a reasonable starting point for such an endeavour.
The executables (and possibly other files in future) can be installed in a path defined in a variable named 'prefix' in the *flags.mk* file. Subsequent `scons -Y /path/to/lm/ install` will copy only the binaries already build, without introducing any additional dependencies.

### Known problems and bugs

Apple's darwin operating system:

1. The standard functions diff, zdiff and awk are less versatile than the linux (gnu) equivalents. Some of the testing scripts make use of the extra versatility of gnu versions. Before running the standard checks, please install the gnu versions of diff and awk, e.g. using macports. Also copy zdiff from a linux system and park it in the directory where diff is located.

2. The gnu BLAS library has some bugs, e.g. the one that accompanies gcc Apple LLVM version 6.1.0 and GNU Fortran 5.1.0 Some of them have been worked around, but zdotc needs to be replaced. Pick up a distribution of zdotc from, [e.g.](http://www.netlib.org/lapack/explore-html/d6/db8/zdotc_8f_source.html) Put it into the slatsm directory, and update SConscript (or Makefile if you are using the old installation)

Intel's mkl library

1. fftw3 is buggy for some special cases, at least in some of the older versions of the library. You can download the fftw3 library from http://www.fftw.org/ and install it yourself. The bugs seem to have been corrected in v15 of the library.