# Troubleshooting Guide

## 1. The Disappearing Ligand (CHARMM-GUI output)
**Symptom:** You generate a system via CHARMM-GUI, but running `gmx grompp` complains about missing molecules, or the ligand is completely missing from `topol.top` and `step5_input.pdb`.
**Fix:** 
- The ligand parameterization failed or the ligand wasn't attached. 
- *Rule of thumb:* **Always** open `step5_input.pdb` in PyMOL or VMD immediately after downloading. If you don't see your ligand, do not proceed to minimization. Re-run the CHARMM-GUI Ligand Reader module.

## 2. Trajectory Naming Mismatches
**Symptom:** Post-processing scripts fail with `File md.xtc not found`, but you ran the simulation.
**Fix:**
- CHARMM-GUI's custom python scripts output files named `step7_production.xtc`. However, standard GROMACS `mdrun` commands output `md.xtc` by default. 
- Ensure your analysis scripts point to the correct output name depending on whether you ran standard GROMACS or CHARMM's wrapper scripts. (This repository standardizes everything to `md.xtc`).

## 3. The "Exploding" or Jumping Protein (PBC Artifacts)
**Symptom:** During visualization in PyMOL/VMD, the protein or ligand appears to "jump" across the simulation box or gets broken into pieces across the boundaries.
**Fix:** 
This is a visual artifact of Periodic Boundary Conditions (PBC), not a failed simulation. You must "center" the trajectory before analysis. Run `03_Analysis/03_center_pbc.sh` to fix this.

## 4. The "System Exploded" (LINCS WARNING)
**Symptom:** You run `mdrun` for NVT or NPT, and within a few seconds, the terminal gets spammed with `LINCS WARNING` messages, and the simulation crashes with a `Segmentation Fault` or `1-4 interaction` error.
**Fix:**
This means atoms in your system were placed too closely together (overlapping). When the physics engine turned on, they repelled each other with near-infinite force, shooting across the simulation box and breaking the math (exploding).
1. **Did you skip Energy Minimization?** Never skip minimization.
2. **Did minimization finish properly?** Check `potential.xvg`. If the potential energy is a positive number, your system is still clashing. Run minimization for more steps (e.g., 5000 -> 10000).
3. **Is your timestep too large?** Sometimes 2 fs is too fast for a highly constrained system. Try lowering `dt = 0.001` (1 fs) in your `.mdp` file for the equilibration phases.

## 5. "No default TIP3P / Water model not found"
**Symptom:** Running `pdb2gmx` gives an error about water topologies.
**Fix:**
You selected a force field (like AMBER) but told it to use a water model it doesn't support natively (like SPC). Always match the water model to the force field (e.g., TIP3P for AMBER/CHARMM).
