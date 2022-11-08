#!/bin/sh
#######################################################################
#### This scripts perform the preprocessors for ProFitFun  	        ###
#### This script will require path to Stride, Naccess and CLASS.exe ###
#######################################################################
PTSFF=$(pwd)
JOB=$1
UPLOAD=$PTSFF/$JOB
SOURCE=$PTSFF/SOURCE
SSFS=$SOURCE/SS_FiSi.dat
AAFS=$SOURCE/AA_FiSi.dat
ASFS=$SOURCE/AS_FiSi.dat
SSMS=$SOURCE/SS_McSc.dat
AAMS=$SOURCE/AA_McSc.dat
ASMS=$SOURCE/AS_McSc.dat
SSPN=$SOURCE/SS_PaNp.dat
AAPN=$SOURCE/AA_PaNp.dat
ASPN=$SOURCE/AS_PaNp.dat
RCSS=$SOURCE/AS_RCSS.dat
#############################################################################################################################################
###*********************       STEP-I: Preprocessors: Extract SEQ, SecStr, BBD and RSA Class Assigment      ******************************###
#############################################################################################################################################
cd $UPLOAD
$SOURCE/bin/stride $JOB.pdb | grep ^ASG | awk '{print $2"\t"$6"\t"$8"\t"$9}' > $JOB.DAT
awk '{print $1}' $JOB.DAT | sed -e 's:ALA:A:g' -e 's:ARG:R:g' -e 's:ASN:N:g' -e 's:ASP:D:g' -e 's:CYS:C:g' -e 's:GLU:E:g' -e 's:GLN:Q:g' \
  -e 's:GLY:G:g' -e 's:HIS:H:g' -e 's:HIE:H:g' -e 's:ILE:I:g' -e 's:LEU:L:g' -e 's:LYS:K:g' -e 's:MET:M:g' -e 's:PHE:F:g' -e 's:PRO:P:g' \
  -e 's:SER:S:g' -e 's:THR:T:g' -e 's:TRP:W:g' -e 's:TYR:Y:g' -e 's:VAL:V:g' | awk '{print $1}' > AA.dat
awk '{print $2}' $JOB.DAT | sed -e 's:[G,I]:H:g' -e 's:[B,b]:E:g' -e 's:[T,S]:C:g'  > SS.dat;
awk '{if ($3 < 0) print ($3+360); else print $3}' $JOB.DAT > PHI.dat
awk '{if ($4 < 0) print ($4+360); else print $4}' $JOB.DAT > PSI.dat
paste AA.dat SS.dat PHI.dat PSI.dat > $JOB.dat
$SOURCE/bin/CLASS.exe $SOURCE/Include/FiSi.dat $JOB.dat | awk '{print $1"-"$2"-"$5}' > $JOB.FiSi
$SOURCE/bin/Naccess/naccess $JOB.pdb
grep ^RES $JOB.rsa | awk '{print substr($0,5,3)"#"substr($0,36,6)"#"substr($0,49,6)"#"substr($0,62,6)"#"substr($0,75,6)}' | sed 's: ::g' | sed -e 's:^ALA:A:g' -e 's:^ARG:R:g' -e 's:^ASN:N:g' -e 's:^ASP:D:g' -e 's:^CYS:C:g' -e 's:^GLU:E:g' -e 's:^GLN:Q:g' -e 's:^GLY:G:g' -e 's:^HIS:H:g' -e 's:^ILE:I:g' -e 's:^LEU:L:g' -e 's:^LYS:K:g' -e 's:^MET:M:g' -e 's:^PHE:F:g' -e 's:^PRO:P:g' -e 's:^SER:S:g' -e 's:^THR:T:g' -e 's:TRP:W:g' -e 's:^TYR:Y:g' -e 's:^VAL:V:g' > RSA.dat
awk -F'#' '{if ($2 > 100 && $3 <= 100) print $1"\t"100.00"\t"$3; else if ($2 <= 100 && $3 > 100) print $1"\t"$2"\t"100.00; else print $1"\t"$2"\t"$3}' RSA.dat > $JOB"_MCSC.dat"
awk -F'#' '{if ($4 > 100 && $5 <= 100) print $1"\t"100.00"\t"$5; else if ($4 <= 100 && $5 > 100) print $1"\t"$4"\t"100.00; else print $1"\t"$4"\t"$5}' RSA.dat > $JOB"_PANP.dat"
paste $JOB"_MCSC.dat" AA.dat SS.dat | awk '{if ($1 ~ $4) print $1"\t"$5"\t"$2"\t"$3}' > $JOB"_McSc.dat"
paste $JOB"_PANP.dat" AA.dat SS.dat | awk '{if ($1 ~ $4) print $1"\t"$5"\t"$2"\t"$3}' > $JOB"_PaNp.dat"
$SOURCE/bin/CLASS.exe $SOURCE/Include/McSc.dat $JOB"_McSc.dat" | awk '{print $1"-"$2"-"$5}' > $JOB.McSc
$SOURCE/bin/CLASS.exe $SOURCE/Include/PaNp.dat $JOB"_PaNp.dat" | awk '{print $1"-"$2"-"$5}' > $JOB.PaNp
rm PHI.dat PSI.dat SS.dat AA.dat $JOB.DAT $JOB.asa $JOB.log RSA.dat $JOB.dat $JOB.rsa $JOB"_MCSC.dat" $JOB"_PANP.dat" $JOB"_McSc.dat" $JOB"_PaNp.dat"
paste $JOB.FiSi $JOB.McSc $JOB.PaNp | awk '{print $1"-"$2"-"$3}' | awk -F'-' '{print $1"-"$2"-"$3"-"$6"-"$9}' > $JOB"_AA_SS_FS_MS_PN.dat"

#############################################################################################################################################
###*********************       STEP-II: Preprocessors: BBD and RSA Formatting into AA and AA-SS Triplets    ******************************###
#############################################################################################################################################
FMP=$(cat $JOB"_AA_SS_FS_MS_PN.dat" | tr '\n' '\t');
declare -a SOQ=($FMP);
LEN=$(echo $FMP | awk '{print NF}');
MAX=$(expr $LEN - 2)

for (( X=1; X <= "$MAX"; X++ ))
  do
    N1=$(expr $X - 1);
    C1=$(expr $X + 1);

    NTR1=$(echo ${SOQ[@]:$N1:1} | tr -d '[[:space:]]');                    
    CTR1=$(echo ${SOQ[@]:$C1:1} | tr -d '[[:space:]]');                     
    MDR1=$(echo ${SOQ[@]:$X:1} | tr -d '[[:space:]]');         
    NTR2=$(echo ${SUQ[@]:$N1:1} | tr -d '[[:space:]]');                                 
    CTR2=$(echo ${SUQ[@]:$C1:1} | tr -d '[[:space:]]');               
    MDR2=$(echo ${SUQ[@]:$X:1} | tr -d '[[:space:]]');
    echo -e "$NTR1-$MDR1-$CTR1-$NTR2-$MDR2-$CTR2" | awk -F'-' '{print $1$6$11"\t"$2$7$12"\t"$8"\t"$9"\t"$10}'
  done > $JOB"_AA_SS_FS_MS_PN.dat"
rm $JOB.FiSi $JOB.McSc $JOB.PaNp

#############################################################################################################################################
###*********************     STEP-III: Calculate  QA Score for 1S-2S, and Assigned Classes of BBD and RD    ******************************###
#############################################################################################################################################
exec < $JOB"_AA_SS_FS_MS_PN.dat"
while read AaA SsS FiS McS PaN
 do
  ###############################################################
  ###   STEP-III(a): Calculate 1S-2S Scores for each Triplet  ###
  ###############################################################
  CSR=$(grep -w $AaA"-"$SsS $RCSS | awk '{print $2}')
  if [ -z "$CSR" ]; then CSR=0.00000; fi 

  ###############################################################
  ###    STEP-III(b): Calculate BBD Scores for each Triplet   ###
  ###############################################################
  BBAA=$(grep $AaA"-"$FiS $AAFS | awk '{print $2}');
  BBSS=$(grep $SsS"-"$FiS $SSFS | awk '{print $2}');
  BBAS=$(grep $AaA"-"$SsS"-"$FiS $ASFS | awk '{print $2}');
  if [ -z "$BBAA" ]; then BBAA=0.00000; fi
  if [ -z "$BBSS" ]; then BBSS=0.00000; fi  
  if [ -z "$BBAS" ]; then BBAS=0.00000; fi

  ###############################################################
  ###  STEP-III(c): Calculate RDC Scores for each Triplet     ###
  ###############################################################
  MSAA=$(grep $AaA"-"$McS $AAMS | awk '{print $2}');
  MSSS=$(grep $SsS"-"$McS $SSMS | awk '{print $2}');
  MSAS=$(grep $AaA"-"$SsS"-"$McS $ASMS | awk '{print $2}');
  if [ -z "$MSAA" ]; then MSAA=0.00000; fi
  if [ -z "$MSSS" ]; then MSSS=0.00000; fi  
  if [ -z "$MSAS" ]; then MSAS=0.00000; fi

  PNAA=$(grep $AaA"-"$PaN $AAPN | awk '{print $2}');
  PNSS=$(grep $SsS"-"$PaN $SSPN | awk '{print $2}');
  PNAS=$(grep $AaA"-"$SsS"-"$PaN $ASPN | awk '{print $2}');
  if [ -z "$PNAA" ]; then PNAA=0.00000; fi
  if [ -z "$PNSS" ]; then PNSS=0.00000; fi  
  if [ -z "$PNAS" ]; then PNAS=0.00000; fi
 ################################################################
 SCS=$(echo "scale=5;($CSR+$BBAA+$BBSS+$BBAS+$MSAA+$MSSS+$MSAS+$PNAA+$PNSS+$PNAS)/10"|bc); 
  echo -e "$AaA\t$SsS\t$FiS\t$McS\t$PaN\t$CSR\t$BBAA\t$BBSS\t$BBAS\t$MSAA\t$MSSS\t$MSAS\t$PNAA\t$PNSS\t$PNAS\t$SCS"
 done > $JOB.LQA

SCS_CSR=$(awk '{sum += $6} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_BBAA=$(awk '{sum += $7} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_BBSS=$(awk '{sum += $8} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_BBAS=$(awk '{sum += $9} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_MSAA=$(awk '{sum += $10} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_MSSS=$(awk '{sum += $11} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_MSAS=$(awk '{sum += $12} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_PNAA=$(awk '{sum += $13} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_PNSS=$(awk '{sum += $14} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_PNAS=$(awk '{sum += $15} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
SCS_SCS=$(awk '{sum += $16} END {printf "%0.4f\n", sum/NR}' $JOB.LQA)
echo -e "$JOB\t$SCS_CSR\t$SCS_BBAA\t$SCS_BBSS\t$SCS_BBAS\t$SCS_MSAA\t$SCS_MSSS\t$SCS_MSAS\t$SCS_PNAA\t$SCS_PNSS\t$SCS_PNAS\t$SCS_SCS" > $JOB.GQA