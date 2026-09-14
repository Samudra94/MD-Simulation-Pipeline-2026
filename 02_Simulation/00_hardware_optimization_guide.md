# Hardware & Performance Optimization Guide

MD Simulations are incredibly computationally expensive. 100ns of a protein can take weeks on a laptop, or hours on a supercomputer. Here is how to make GROMACS run as fast as possible.

## 1. Using GPUs (Crucial)
If you have an NVIDIA GPU (e.g., RTX 3080, RTX 4090, or A100), GROMACS can offload the heaviest math (non-bonded interactions) to the graphics card.

Add this flag to your `mdrun` command:
`-update gpu -pme gpu`

*Example:*
`gmx mdrun -v -deffnm md -update gpu -pme gpu -ntomp 8`

## 2. CPUs: Threads vs. MPI Ranks
You will see two flags often used in HPC environments: `-ntomp` and `-ntmpi`.

*   **`-ntomp` (OpenMP Threads):** How many CPU cores should work together on a single chunk of data. If you are running on a single computer or single HPC node, just set this to the number of CPU cores you have (e.g., `-ntomp 16`).
*   **`-ntmpi` (MPI Ranks):** Used when combining *multiple* computers together across a network. If you aren't stringing multiple HPC nodes together, you generally do not need to worry about this.

## 3. The "Sweet Spot"
If you have a 16-core CPU and 1 GPU:
`gmx mdrun -v -deffnm md -ntomp 16 -pin on -gpu_id 0`
*(The `-pin on` command locks threads to specific CPU cores, preventing the OS from shuffling them around, which provides a ~5% speed boost!)*
