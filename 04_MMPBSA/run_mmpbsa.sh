#!/bin/bash
# Generalized MM-PBSA calculation script

TPR="md.tpr"
XTC="md_center.xtc"
NDX="index.ndx"

# Ensure index file is generated
# echo -e "q" | gmx make_ndx -f $TPR -o $NDX
# Example for gmx_MMPBSA:
# mpirun -np 4 gmx_MMPBSA -O -i mmpbsa.in -cs $TPR -ci $NDX -cg 1 13 -ct $XTC -cp topol.top
