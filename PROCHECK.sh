#!/bin/bash
## Download a standalone version of PROCHECK from https://www.ebi.ac.uk/thornton-srv/software/PROCHECK/
## Install Procheck on your local machine and provide the path of installation in next lne.
MODULE=<Absolute path to PROCHECK installation>
## Run this script in the directory containing the model structures.
## For each model a seprate output file of PROCHECK assessment will be generated, e.g. MODEL.out
UPLOAD=`pwd`
ls *.pdb | sed 's:.pdb$::g' > MLIST
for PDB in `cat MLIST`
     do
      csh $MODULE/ProCheck/procheck.scr $PDB.pdb 2.0
      mv $PDB.sum $PDB.out
	  echo -e "Quality assessment of $PDB is finished"
	  echo -e "The output file is $UPLOAD/$PDB.out"
     done
