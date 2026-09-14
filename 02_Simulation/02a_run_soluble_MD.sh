#!/bin/bash
# ==============================================================================
# Script: 02a_run_soluble_MD.sh
# Type: PROTEIN IN WATER (Standard 2-step equilibration)
# ==============================================================================
SYS_NAME="step5_input"
TOP="topol.top"
MDP_DIR="mdp_templates/soluble"
NTOMP=8 

echo "1. Energy Minimization"
gmx grompp -f ${MDP_DIR}/minimization.mdp -c ${SYS_NAME}.pdb -p ${TOP} -o em.tpr
gmx mdrun -v -deffnm em -ntomp $NTOMP

echo "2. NVT Equilibration (Standard 100-500ps)"
gmx grompp -f ${MDP_DIR}/nvt.mdp -c em.gro -r em.gro -p ${TOP} -o nvt.tpr
gmx mdrun -v -deffnm nvt -ntomp $NTOMP

echo "3. NPT Equilibration (Standard 100-1000ps)"
gmx grompp -f ${MDP_DIR}/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p ${TOP} -o npt.tpr
gmx mdrun -v -deffnm npt -ntomp $NTOMP

echo "4. Production MD"
gmx grompp -f ${MDP_DIR}/production.mdp -c npt.gro -t npt.cpt -p ${TOP} -o md.tpr
gmx mdrun -v -deffnm md -ntomp $NTOMP
