Description
ProFitFun-Meta is successor of ProFitFun for assessing the quality of predicted model structures by 
an effective combination structural information of various backbone dihedral angle and residue surface
accessibility preferences of amino acid residues with other spatial properties of protein structures. 

#######################################################################
########## File Structure of ProFitFun-Meta at GitHub #################
AA_FiSi.tar.gz		Backbone Dihedral Preference Scores for Amino Acid Residues Triplets
AA_McSc.tar.gz		Surface Accessibility of Main Chain and Side Chains Preference Scores for Amino Acid Residues Triplets
AA_PaNp.tar.gz		Surface Accessibility of Polar and Non-Polar Preference Scores for Amino Acid Residues Triplets

AS_FiSi.tar.gz		Backbone Dihedral Preference Scores for Amino Acid Residues and Secondary Structural Triplets
AS_McSc.tar.gz		Surface Accessibility of Main Chain and Side Chains Preference Scores for Amino Acid Residues and Secondary Structural Triplets
AS_PaNp.tar.gz		Surface Accessibility of Polar and Non-Polar Preference Scores for Amino Acid Residues and Secondary Structural Triplets
AS_RCSS.tar.gz		Revised CSS Scores of Amino Acid Residues and Secondary Structural Triplets

SS_FiSi.tar.gz		Backbone Dihedral Preference Scores for Secondary Structural Triplets
SS_McSc.tar.gz		Surface Accessibility of Main Chain and Side Chains Preference Scores for Secondary Structural Triplets
SS_PaNp.tar.gz		Surface Accessibility of Polar and Non-Polar Preference Scores for Secondary Structural Triplets

CLASS.exe			Backbone Dihedral Preference and Surface Accessibility Preference Class Assignment

ProFitFun.tar.gz    The trained Models to ProFitFun
ProFitFun-Meta.sh   The main script to calculate various preference scores. The output of this script is used as input to ProFitFun-Meta

MolProbity.sh		Script for running MolProbity. The Molprobity standalone version needs to be downloaded and installed locally on your machine.
					Download link for MolProbity: http://molprobity.biochem.duke.edu/ The details for installation are also provided under this link.

PROCHECK.sh			Script for running PROCHECK. The PROCHECK standalone version needs to be downloaded and installed locally on your machine.
					Download link for PROCHECK: https://www.ebi.ac.uk/thornton-srv/software/PROCHECK/ The details for installation are also provided under this link.
					
ProFitFun.sh		Script for running ProFitFun locally on your machine. Download link: https://github.com/KYZ-LSB/ProTerS-FitFun

######################################## 
## Stepwise installation and testing ###
Step 1: Download and install ProFitFun, MolProbity, and Procheck on your machine.
Step 2: Test the local installation by providing paths of the installation directories in the provided scripts (ProFitFun.sh, MolProbity.sh, and PROCHECK.sh)
Step 3: Successful installation would generate the output file for respective tools. Use the output file as input to ProFitFun-Meta.sh.
Step 4: ProFitFun-Meta would generate a output file with predicted GDT-TS scores for individual model structures.

And you are done.