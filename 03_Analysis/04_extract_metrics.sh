#!/bin/bash
# ==============================================================================
# Script: 04_extract_metrics.sh
# Purpose: Automates the extraction of RMSD, RMSF, SASA, and Radius of Gyration.
# ==============================================================================

TPR="md.tpr"
XTC="md_center.xtc" # Always use the centered trajectory!

echo "1. Calculating RMSD (Backbone against Backbone)..."
# Groups 4 (Backbone) for least-squares fit, and 4 (Backbone) for RMSD calculation
echo -e "4\n4" | gmx rms -s $TPR -f $XTC -o rmsd.xvg -tu ns

echo "2. Calculating RMSF (Per-residue fluctuation for Protein)..."
# Group 1 (Protein)
echo "1" | gmx rmsf -s $TPR -f $XTC -o rmsf.xvg -res

echo "3. Calculating Solvent Accessible Surface Area (SASA)..."
# Group 1 (Protein)
echo "1" | gmx sasa -s $TPR -f $XTC -o sasa.xvg

echo "4. Calculating Radius of Gyration (Compactness)..."
# Group 1 (Protein)
echo "1" | gmx gyrate -s $TPR -f $XTC -o gyrate.xvg

echo "All metrics extracted successfully! You can plot the .xvg files using Python or Grace (xmgrace)."
