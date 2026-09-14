# How to Visualize Your Simulation (For Beginners)

Staring at numbers in a terminal is boring. Let's actually *watch* your protein move! 

> **CRITICAL RULE:** Never visualize the raw `md.xtc` file. Always run `03_center_pbc.sh` first to generate `md_center.xtc`. Otherwise, your protein will look like it is flying apart across the screen.

## Option A: Using VMD (Visual Molecular Dynamics)
VMD is the fastest tool for loading trajectories.

1. Open VMD.
2. Go to **File -> New Molecule**.
3. Browse and select your `md.gro` file. Load it. (This gives VMD the 3D coordinates and atom types).
4. Browse again, and select `md_center.xtc`. Ensure "Load into" is pointing to the same molecule you just created. Click Load.
5. In the main window, go to **Graphics -> Representations**.
6. Type `protein` in the Selected Atoms box. Change Drawing Method to **NewCartoon**.
7. Create a new representation, type `resname LIG` (or whatever your ligand is named), and change Drawing Method to **Licorice**.
8. Press the "Play" button on the bottom of the main VMD window!

## Option B: Using PyMOL
PyMOL makes beautiful, publication-quality videos.

1. Open PyMOL.
2. Go to **File -> Open** and select `md.gro`.
3. In the command line box at the bottom, type:
   `load_traj md_center.xtc`
4. To make it look nice, type:
   `hide everything, resname SOL or resname WAT or resname NA or resname CL`
   `show cartoon, polymer`
   `show sticks, resname LIG`
5. Use the media player controls at the bottom right to play the trajectory.
