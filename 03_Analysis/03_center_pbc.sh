#!/bin/bash
# ==============================================================================
# Script: 03_center_pbc.sh
# Purpose: Fixes Periodic Boundary Condition (PBC) artifacts. Standard MD 
#          trajectories often show the protein jumping across the box edges.
# ==============================================================================

TPR="md.tpr"
XTC="md.xtc"
NDX="../01_Preparation/index.ndx" # Generated in 01_Preparation
OUT="md_center.xtc"

echo "Step 1: Making the protein whole (fixing broken molecules across boundaries)..."
# Select 'System' (usually 0) for output
echo "0" | gmx trjconv -s $TPR -f $XTC -o md_whole.xtc -pbc whole

echo "Step 2: Centering the complex in the box..."
# Select 'Protein-Ligand' (or 'Protein' if no ligand) to center (e.g. 1)
# Select 'System' (0) for output
# You may need to adjust the group numbers depending on your index file.
echo -e "1\n0" | gmx trjconv -s $TPR -f md_whole.xtc -n $NDX -o $OUT -pbc mol -center

# Clean up intermediate file
rm md_whole.xtc

echo "Done! Use $OUT for all subsequent analyses (RMSD, RMSF, MM-PBSA)."
