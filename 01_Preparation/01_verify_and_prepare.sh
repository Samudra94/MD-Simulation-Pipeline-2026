#!/bin/bash
# ==============================================================================
# Script: 01_verify_and_prepare.sh
# Purpose: Verifies system integrity (e.g. from CHARMM-GUI or pdb2gmx) and
#          generates necessary index (.ndx) files for downstream simulation.
# ==============================================================================
# Force Field: CHARMM36m (via CHARMM-GUI) or AMBER99SB-ILDN / AMBER14SB (via pdb2gmx)
# As per User, Any standard GROMACS-compatible force field (CHARMM, AMBER, OPLS) can be added

COMPLEX_PDB="step5_input.pdb"
TOPOLOGY="topol.top"
LIGAND_NAME="LIG" # Change this to your ligand's residue name (e.g., JZ4)

echo "---------------------------------------------------"
echo "1. Checking Coordinate File ($COMPLEX_PDB)"
echo "---------------------------------------------------"
if [ ! -f "$COMPLEX_PDB" ]; then
    echo "ERROR: $COMPLEX_PDB not found!"
    exit 1
fi

# Verify the ligand is actually inside the PDB
LIG_COUNT=$(grep "$LIGAND_NAME" "$COMPLEX_PDB" | wc -l)
if [ "$LIG_COUNT" -eq 0 ]; then
    echo "ERROR: Ligand '$LIGAND_NAME' is missing from $COMPLEX_PDB."
    echo "       Check your parameterization (e.g., CHARMM-GUI Ligand Reader) steps."
    exit 1
else
    echo "SUCCESS: Found $LIG_COUNT atoms for ligand '$LIGAND_NAME' in coordinate file."
fi

echo ""
echo "---------------------------------------------------"
echo "2. Checking Topology File ($TOPOLOGY)"
echo "---------------------------------------------------"
if [ ! -f "$TOPOLOGY" ]; then
    echo "ERROR: $TOPOLOGY not found!"
    exit 1
fi

grep -i "$LIGAND_NAME" "$TOPOLOGY" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Ligand '$LIGAND_NAME' is missing from $TOPOLOGY!"
    exit 1
else
    echo "SUCCESS: Ligand topology included correctly."
fi

echo ""
echo "---------------------------------------------------"
echo "3. Generating Standard Index File (index.ndx)"
echo "---------------------------------------------------"
# This creates an index file and automatically groups Protein and Ligand
# so you can easily reference 'Protein-Ligand' later for centering or MM-PBSA.
echo -e "q\n" | gmx make_ndx -f "$COMPLEX_PDB" -o index.ndx

echo "Preparation checks passed! You can proceed to 02_Simulation."
