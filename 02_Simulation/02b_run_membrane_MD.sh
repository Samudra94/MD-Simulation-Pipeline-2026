#!/bin/bash
# ==============================================================================
# Script: 02b_run_membrane_MD.sh
# Type: PROTEIN IN MEMBRANE (6-step equilibration)
# Description: Membrane proteins require gradual release of position restraints
#              on the lipid bilayer to allow lipids to pack tightly against the 
#              protein without blowing up the system.
# ==============================================================================
SYS_NAME="step5_input"
TOP="topol.top"
MDP_DIR="mdp_templates/membrane"
NTOMP=8 

echo "1. Energy Minimization"
gmx grompp -f ${MDP_DIR}/step6.0_minimization.mdp -c ${SYS_NAME}.pdb -p ${TOP} -o em.tpr
gmx mdrun -v -deffnm em -ntomp $NTOMP

echo "2. NVT Equilibration (Membrane Heating)"
# Typically strong position restraints (1000 kJ/mol) on protein and lipid headgroups
gmx grompp -f ${MDP_DIR}/step6.1_equilibration.mdp -c em.gro -r em.gro -p ${TOP} -o eq1.tpr
gmx mdrun -v -deffnm eq1 -ntomp $NTOMP

echo "3. NPT Equilibration - Step 2"
# Switch to NPT, maintain strong restraints
gmx grompp -f ${MDP_DIR}/step6.2_equilibration.mdp -c eq1.gro -r eq1.gro -t eq1.cpt -p ${TOP} -o eq2.tpr
gmx mdrun -v -deffnm eq2 -ntomp $NTOMP

echo "4. NPT Equilibration - Steps 3 to 6 (Gradual Release)"
# A loop to gradually release restraints from 500 -> 250 -> 100 -> 50 -> 0 kJ/mol
PREV="eq2"
for i in 3 4 5 6; do
    CURR="eq${i}"
    echo "Running Membrane NPT Equilibration Step ${i}..."
    gmx grompp -f ${MDP_DIR}/step6.${i}_equilibration.mdp -c ${PREV}.gro -r ${PREV}.gro -t ${PREV}.cpt -p ${TOP} -o ${CURR}.tpr
    gmx mdrun -v -deffnm ${CURR} -ntomp $NTOMP
    PREV=${CURR}
done

echo "5. Production MD (Unrestrained)"
gmx grompp -f ${MDP_DIR}/step7_production.mdp -c eq6.gro -t eq6.cpt -p ${TOP} -o md.tpr
gmx mdrun -v -deffnm md -ntomp $NTOMP
