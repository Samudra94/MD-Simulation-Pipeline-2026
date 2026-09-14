#!/bin/bash
# ==============================================================================
# Script: 02_run_MD_pipeline.sh
# Purpose: Executes the standard MD pipeline: Minimization -> NVT -> NPT -> MD
# Note: Ensure you have your .mdp files (minimization, nvt, npt, production) ready.
# ==============================================================================

# Variables
SYS_NAME="step5_input"
TOP="topol.top"
MDP_DIR="mdp_templates"

# Optional: Number of CPU threads (adjust for your hardware)
NTOMP=8 

echo "==================================================="
echo " Step 1: Energy Minimization (Steepest Descent)"
echo "==================================================="
# Objective: Relax steric clashes before giving atoms thermal energy
gmx grompp -f ${MDP_DIR}/minimization.mdp -c ${SYS_NAME}.pdb -p ${TOP} -o em.tpr
if [ $? -ne 0 ]; then echo "Grompp failed at EM"; exit 1; fi

gmx mdrun -v -deffnm em -ntomp $NTOMP

# Extract Potential Energy to check if minimization was successful
echo "10 0" | gmx energy -f em.edr -o potential.xvg
echo "Check potential.xvg to ensure potential energy is negative and plateaued."

echo "==================================================="
echo " Step 2: NVT Equilibration (Constant Volume/Temp)"
echo "==================================================="
# Objective: Bring the system up to target temperature (e.g. 300K)
gmx grompp -f ${MDP_DIR}/nvt.mdp -c em.gro -r em.gro -p ${TOP} -o nvt.tpr
if [ $? -ne 0 ]; then echo "Grompp failed at NVT"; exit 1; fi

gmx mdrun -v -deffnm nvt -ntomp $NTOMP

# Extract Temperature to verify it reached ~300K
echo "16 0" | gmx energy -f nvt.edr -o temperature.xvg

echo "==================================================="
echo " Step 3: NPT Equilibration (Constant Pressure)"
echo "==================================================="
# Objective: Bring the system to proper density (e.g. 1 bar pressure)
gmx grompp -f ${MDP_DIR}/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p ${TOP} -o npt.tpr
if [ $? -ne 0 ]; then echo "Grompp failed at NPT"; exit 1; fi

gmx mdrun -v -deffnm npt -ntomp $NTOMP

# Extract Pressure and Density to verify equilibration
echo "17 0" | gmx energy -f npt.edr -o pressure.xvg
echo "23 0" | gmx energy -f npt.edr -o density.xvg

echo "==================================================="
echo " Step 4: Production Molecular Dynamics"
echo "==================================================="
# Objective: Generate the actual trajectory for analysis
gmx grompp -f ${MDP_DIR}/production.mdp -c npt.gro -t npt.cpt -p ${TOP} -o md.tpr
if [ $? -ne 0 ]; then echo "Grompp failed at Production"; exit 1; fi

gmx mdrun -v -deffnm md -ntomp $NTOMP

echo "==================================================="
echo " Pipeline Complete!"
echo " Your final trajectory is md.xtc and final structure is md.gro"
echo "==================================================="
