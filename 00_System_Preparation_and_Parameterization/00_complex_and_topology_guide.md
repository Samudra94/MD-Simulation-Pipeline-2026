# System Preparation, Complex Assembly, and Parameterization

Before you can run MD, you must assemble your complex and generate mathematical parameters (topology) for every atom.

## 1. Assembling the Protein-Ligand Complex
If you performed molecular docking, you likely have a protein PDB and a ligand PDB/SDF. 
To simulate them together, they must be merged into a single file.

**Method A: The Unix Command Line (Fastest)**
Remove the `END` tags from the protein and simply concatenate them:
```bash
grep -v "^END" protein.pdb > temp_protein.pdb
cat temp_protein.pdb ligand.pdb > complex.pdb
rm temp_protein.pdb
```

**Method B: Using PyMOL**
1. Open PyMOL.
2. Load both the protein and the docked ligand.
3. Type: `save complex.pdb, all`

## 2. Parameterization (Topology Generation)
GROMACS needs to know the physics of your molecules (bonds, angles, charges).

### Scenario A: Soluble Protein (Protein in Water)
1. **Protein Topology:** Use GROMACS built-in tools.
   `gmx pdb2gmx -f complex.pdb -o processed.gro -water spce`
   *(Choose a force field like AMBER99SB-ILDN or CHARMM36).*
2. **Ligand Topology:** GROMACS cannot natively parameterize drug-like small molecules.
   - For **CHARMM** force fields: Use the [CGenFF server](https://cgenff.umaryland.edu/) or CHARMM-GUI Ligand Reader.
   - For **AMBER** force fields: Use [ACPYPE](https://www.bioinformatics.nl/cgi-bin/acpype/acpype.cgi) (AnteChamber Python Parser interface) to generate GAFF parameters.
3. **Merging:** You must manually `#include` the ligand's `.itp` (topology) file inside the protein's `topol.top` file and add the ligand to the `[ molecules ]` directive at the bottom.

### Scenario B: Membrane-Bound Protein (Lipid Bilayer)
Membrane systems are incredibly complex to build manually because you must insert the protein into a lipid bilayer (e.g., POPC, DPPC) without steric clashes, solvate it above and below the membrane, and add specific ion concentrations.

**The Gold Standard: CHARMM-GUI**
We highly recommend using [CHARMM-GUI Membrane Builder](https://charmm-gui.org/?doc=input/membrane.bilayer).
1. Upload your `complex.pdb`.
2. Select your lipid types (e.g., 100% POPC or a custom cholesterol mix).
3. The server will pack the lipids around your protein, solvate it, add ions, and give you a downloadable folder with a pre-configured `topol.top` and all necessary `.mdp` equilibration scripts.
