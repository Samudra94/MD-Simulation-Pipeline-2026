#!/bin/bash
# Fixes PBC artifacts and centers the trajectory.

TPR="md.tpr"
XTC="md.xtc"
OUT="md_center.xtc"

echo "0" | gmx trjconv -s $TPR -f $XTC -o md_whole.xtc -pbc whole
echo -e "1\n0" | gmx trjconv -s $TPR -f md_whole.xtc -o $OUT -pbc mol -center
rm md_whole.xtc
