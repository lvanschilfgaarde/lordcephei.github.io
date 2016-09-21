#!/bin/bash
#============================================================
# This script handles the I/O procedures required 
# to cycle a DMFT loop.
#
# It DOES NOT submit jobs or check for consistency.
#
# You launch it as
# $ bash HandleIO_dmft.sh IT RUNTYPE
# where 
# IT       = index of the iteration higher than 1
# RUNTYPE  = either lmf or qmc
#
#============================================================
# General variables to set by hand 
# At the beginning of the DMFT loop 

SUBLMF=scriptsub.sh    # name of the lmfrun submission script (to be put in lmfinput) 
SUBQMC=scriptsub.sh    # name of the qmcrun submission script (to be put in qmcinput) 
EXT='ni'               # extension of the lmf files 
J=0.9                  # Hund's Coupling (eV) - check consistency with double counting
U=10.0                 # Hubbard insite interaction (eV) - check consistency with double counting 
beta=50.0              # inverse temperature (eV^{-1}) - check consistency with ctrl.$EXT 
n=8                    # nominal occupancy of d-states - check consistency with double counting  
WD=`pwd`

#=============================================================


# Arguments 
IT=$1
RUNTYPE=$2

echo " "
# Empty arguments
if [ "$1" == "" -o "$2" == "" ]
then
  echo "Usage:"
  echo '$ ./HandleIO $IT $RUNTYPE'
  echo 'IT = index of the iteration'
  echo 'RUNTYPE = either lmf or qmc (lower case)'
exit
fi

# Initialise folders
RUNDIR="it$1_$2run"
mkdir $RUNDIR
echo "Creating directory $RUNDIR"
echo ""

if [ $2 == 'lmf' ]
then
  INF1='lmfinput'
  INF2="it"$((IT-1))"_qmcrun" 
  INF3='' 
elif [ $2 == 'qmc' ]
then
  INF1='qmcinput'
  INF2="it$1_lmfrun"
  INF3="it"$((IT-1))"_qmcrun"
else
  echo 'Runtype argument not valid'
  exit
fi

#############################
###      the LMF run      ###
#############################
if [ $RUNTYPE == 'lmf' ]
then
  # copy input files
  cp $INF1/*.$EXT       $RUNDIR
  cp $INF1/$SUBLMF      $RUNDIR

  # broadens previous impurity self-energy
  cd $INF2 
  echo 'Sig.out 150 l "55  20  150" k "1 2 3 2 3"'| ./broad_sig.x 
  cd $WD
  cp $INF2/Sig.out.brd  $RUNDIR/sig.inp 
  
  echo ""
  echo "Job now ready for submission"
fi


#############################
###      the QMC run      ###
#############################
if [ $RUNTYPE == 'qmc' ]
then
  # copy input files
  cp $INF2/delta.$EXT   $RUNDIR/Delta.inp
  cp $INF2/eimp1.$EXT   $RUNDIR/Eimp.inp
  cp $INF1/*            $RUNDIR 
  cp $INF3/statu*       $RUNDIR

  # Launch atom_d.py 
  cd $RUNDIR
  module load dmft
  IN=`sed -n '3p' ./Eimp.inp`
  IFS='#' read -ra OP <<< "$IN"
  python atom_d.py J=$J l=2 cx=0.0 OCA_G=False qatom=0 "CoulombF='Ising'" HB2=False "${OP[0]}"


  # update Ed in PARAMS 
  NLINE=`awk '/Ed/ { print NR ; exit}' PARAMS `   # get line to be replaced in PARAMS 
  IN=`sed -n '4p' ./Eimp.inp`                     # get new line from Eimp
  IFS='#' read -ra ED <<< "$IN"                   # Remove comments at the end
  EED=`echo ${ED[0]} | cut -d= -f2-`              # Remove '=' sign
  sed -i "$NLINE""s/.*/Ed $EED    # Impurity levels updated by HandleIO.sh/" PARAMS  # update PARAMS
  # update mu in PARAMS
  NLINE=`awk '/QMC / { print NR ; exit}' PARAMS ` # get line to be replaced in PARAMS
  IN=`sed -n '5p' ./Eimp.inp`                     # get new line from Eimp
  IFS='#' read -ra MU <<< "$IN"                   # Remove comments at the end
  sed -i "$NLINE""s/.*/${MU[0]} # QMC chemical potential by HandleIO.sh/" PARAMS # update PARAMS
  # add U,J,n, and beta to PARAMS
  echo "U    $U"    >> PARAMS
  echo "J    $J"    >> PARAMS
  echo "nf0  $n"    >> PARAMS
  echo "beta $beta" >> PARAMS
  cd $WD
  
  echo ""
  echo "Job now ready for submission"
fi
echo " "

