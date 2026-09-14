# How to Interpret MM-PBSA Results

When `gmx_MMPBSA` finishes, it produces a file called `FINAL_RESULTS_MMPBSA.dat`. 
If you open this file, you will see a lot of numbers. Here is what they actually mean.

## The Core Equation
**ΔG (Binding Free Energy) = ΔE_vdW + ΔE_elec + ΔG_polar + ΔG_nonpolar**

*Note: In MM-PBSA, a **NEGATIVE** ΔG means favorable binding. A **POSITIVE** ΔG means the ligand does not want to bind.*

### 1. VDWAALS (Van der Waals Energy)
*   **What it is:** The energy of shape complementarity and hydrophobic packing.
*   **Interpretation:** Highly negative values mean the ligand fits perfectly inside the pocket (like a jigsaw puzzle piece). 

### 2. EEL (Electrostatic Energy)
*   **What it is:** The energy from Hydrogen bonds, salt bridges, and charged interactions.
*   **Interpretation:** Highly negative values mean your ligand forms strong H-bonds with the receptor.

### 3. EPB (Polar Solvation Energy)
*   **What it is:** The energy penalty of stripping water molecules away from the protein and ligand so they can bind together.
*   **Interpretation:** This is almost always a **highly positive** (unfavorable) number. Polar atoms *like* being in water. Forcing them into a dry binding pocket costs energy.

### 4. ENPOLAR (Non-Polar Solvation Energy)
*   **What it is:** The hydrophobic effect. 
*   **Interpretation:** Usually a small negative number. It reflects the favorable energy of hiding greasy/hydrophobic surface area away from water.

## The Bottom Line (ΔG TOTAL)
Look at the very bottom of the `.dat` file for the **TOTAL** (or ΔG binding). 
- If the score is **-30 kcal/mol**, you have a potentially great binder.
- If the score is **+5 kcal/mol**, the ligand will likely just float away in reality.
