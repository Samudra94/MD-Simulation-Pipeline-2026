#!/bin/bash
# Automates RMSD, RMSF, and SASA calculation.

TPR="md.tpr"
XTC="md_center.xtc"

echo -e "4\n4" | gmx rms -s $TPR -f $XTC -o rmsd.xvg -tu ns
echo "1" | gmx rmsf -s $TPR -f $XTC -o rmsf.xvg -res
echo "1" | gmx sasa -s $TPR -f $XTC -o sasa.xvg
