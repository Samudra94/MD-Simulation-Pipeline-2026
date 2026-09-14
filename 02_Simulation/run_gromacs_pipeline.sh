#!/bin/bash
# Generalized GROMACS MD Pipeline (Minimization, NVT, NPT, Production)

PREFIX="step5_input"
PROD_STEPS=50000000 # 100 ns at 2 fs/step

echo "1. Energy Minimization"
gmx grompp -f step6.0_minimization.mdp -c ${PREFIX}.pdb -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

echo "2. NVT Equilibration"
gmx grompp -f step6.1_equilibration.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -v -deffnm nvt

echo "3. NPT Equilibration"
gmx grompp -f step6.2_equilibration.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -v -deffnm npt

echo "4. Production MD"
gmx grompp -f step7_production.mdp -c npt.gro -t npt.cpt -p topol.top -o md.tpr
gmx mdrun -v -deffnm md
