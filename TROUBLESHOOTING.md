# Troubleshooting Guide

## 1. Missing Ligand in Topology (CHARMM-GUI output)
**Symptom:** You generate a system via CHARMM-GUI, but running `gmx grompp` complains about missing molecules, or the ligand is completely missing from `topol.top` and `step5_input.pdb`.
**Fix:** 
- Double-check the ligand was properly uploaded and parameterization succeeded in the CHARMM-GUI Ligand Reader module.
- Always visualize `step5_input.pdb` in PyMOL or VMD before running minimization. If the ligand is missing, re-run the CHARMM-GUI pipeline ensuring the ligand SDF/MOL2 is correctly attached to the complex.

## 2. Trajectory Naming Mismatches
**Symptom:** Post-processing scripts fail to find `step7_production.xtc`.
**Fix:**
- Standard `gmx mdrun` commands (without the `-o` flag explicitly specifying the name) will output `md.xtc` by default. 
- Ensure your analysis scripts point to `md.xtc` (or `md_center.xtc` if PBC corrected) instead of expecting CHARMM-GUI's default naming convention if you aren't using their specific run scripts.

## 3. Periodic Boundary Condition (PBC) Artifacts
**Symptom:** During visualization in PyMOL/VMD, the protein or ligand appears to "jump" across the simulation box or gets broken across the boundaries.
**Fix:** 
Center the trajectory around the protein-ligand complex and make it whole.
```bash
# 1. Make the protein whole
gmx trjconv -s md.tpr -f md.xtc -o md_whole.xtc -pbc whole

# 2. Center the complex (Select 'Protein-Ligand' then 'System')
gmx trjconv -s md.tpr -f md_whole.xtc -o md_center.xtc -pbc mol -center
```
