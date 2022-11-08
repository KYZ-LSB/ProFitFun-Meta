#!/bin/bash
## Run this script in the dircetory containing all the model structures.
## The standalone version of MolProbity can be downloaded from http://molprobity.biochem.duke.edu/
## Install MolProbity locally on your machine and edit the next line with the absolute path of installation.
MODULE=<Absolute Path to MolProbity Installation>
UPLOAD=`pwd`
mkdir -p $UPLOAD/RESULTS
$MODULE/MolProb/cmdline/oneline-analysis $UPLOAD > $UPLOAD/RESULTS/RESULTS.txt
echo -e "The MolProbilty Assessment of the Model Structures is $UPLOAD/RESULTS/RESULTS.txt"


