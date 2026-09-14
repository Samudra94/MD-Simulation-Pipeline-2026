#!/bin/bash
# ==============================================================================
# Script: 05_run_mmpbsa.sh
# Purpose: Calculates Binding Free Energy using gmx_MMPBSA.
# Pre-requisite: You MUST have gmx_MMPBSA installed (e.g., via conda).
# ==============================================================================

TPR="../02_Simulation/md.tpr"
XTC="../03_Analysis/md_center.xtc" # Use centered!
TOP="../02_Simulation/topol.top"
NDX="../01_Preparation/index.ndx"

# Generate the MM-PBSA input file dynamically
cat << EOF > mmpbsa.in
&general
sys_name="Protein-Ligand_Complex",
startframe=1,
endframe=1000,
interval=1,
forcefields="oldff/leaprc.ff99SB,leaprc.gaff"
/
&gb
igb=5, saltcon=0.150,
/
EOF

echo "Generated mmpbsa.in configuration file."

# Define your groups from index.ndx
# Receptor (usually Protein = 1), Ligand (usually LIG = 13)
# Check your index.ndx to confirm these numbers!
RECEPTOR_GROUP=1
LIGAND_GROUP=13

echo "Running gmx_MMPBSA using MPI..."
mpirun -np 4 gmx_MMPBSA -O -i mmpbsa.in -cs $TPR -ci $NDX -cg $RECEPTOR_GROUP $LIGAND_GROUP -ct $XTC -cp $TOP

echo "MM-PBSA calculation complete. Review FINAL_RESULTS_MMPBSA.dat for binding free energy."
