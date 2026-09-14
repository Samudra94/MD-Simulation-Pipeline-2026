# Comprehensive GROMACS Molecular Dynamics Tutorial Pipeline

Welcome to the ultimate step-by-step pipeline for running Molecular Dynamics (MD) simulations. 
This repository is designed to teach you **how** and **why** we perform each step, split across the two major types of MD simulations: **Proteins in Water (Soluble)** and **Proteins in Lipid Bilayers (Membrane-Bound)**.

## 🗂 Repository Structure & Workflow

### `00_System_Preparation_and_Parameterization/`
Read the `00_complex_and_topology_guide.md` first. It explains:
1. **Compilation:** How to merge a docked Ligand and a Protein into a single complex.
2. **Parameterization:** How to generate GROMACS topologies (`topol.top`) using `pdb2gmx`, CGenFF, ACPYPE, and CHARMM-GUI.

### `01_Preparation/`
*   **`01_verify_and_prepare.sh`**: Checks your compiled `.pdb` and `.top` files to ensure your ligand parameterization didn't fail. It also generates the standard `index.ndx` groups.

### `02_Simulation/`
We have split the execution pipeline into two distinct branches based on your system type:

#### Branch A: Soluble Proteins (Protein in Water)
*   **`02a_run_soluble_MD.sh`**: Executes the standard 4-step pipeline:
    1. **Minimization:** Removes steric clashes.
    2. **NVT Equilibration:** Heats the system to target temperature (Constant Volume).
    3. **NPT Equilibration:** Pressurizes the system to target density (Constant Pressure).
    4. **Production:** Unrestrained data collection.

#### Branch B: Membrane-Bound Proteins (Lipid Bilayer)
*   **`02b_run_membrane_MD.sh`**: Executes a complex 8-step pipeline. Membrane systems require a 6-phase equilibration. If you give a lipid bilayer thermal energy immediately, the artificial gaps between the lipids and the protein will collapse violently, crashing the simulation. This script gradually reduces position restraints (1000 -> 500 -> 250 -> 100 -> 50 -> 0 kJ/mol) to allow the lipids to slowly "melt" and pack around the protein before production.

### `03_Analysis/`
*   **`03_center_pbc.sh`**: Resolves Periodic Boundary Condition (PBC) artifacts (where the protein jumps across the box).
*   **`04_extract_metrics.sh`**: Generates RMSD, RMSF, SASA, and Radius of Gyration data plots.

### `04_MMPBSA/`
*   **`05_run_mmpbsa.sh`**: Automates end-state binding free energy (ΔG) calculations.

## 💡 Pro-Tips
*   **Membrane Simulation Time:** Membrane simulations are computationally expensive. 100 ns of a membrane protein will take significantly longer than 100 ns of a soluble protein of the same molecular weight due to the massive lipid/solvent box required.
*   **Visualizing Trajectories:** Never visualize the raw `md.xtc`. Always run it through the `03_center_pbc.sh` script first to get `md_center.xtc`, otherwise your ligands will appear to fly out of the binding pocket due to boundary wrapping.
