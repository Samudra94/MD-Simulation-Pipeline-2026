#!/bin/bash
#SBATCH --job-name=MD_Prod
#SBATCH --output=md_run_%j.out
#SBATCH --error=md_run_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12       # Adjust based on HPC cluster guidelines
#SBATCH --gres=gpu:1             # Request 1 GPU
#SBATCH --time=48:00:00          # 48 hour limit
#SBATCH --partition=gpu          # Check your cluster's partition name

# Load required GROMACS module
module purge
module load gromacs/2023.2       # Replace with your cluster's version

# Example: Run only production (assuming EM, NVT, NPT were done locally or previously)
# We use gpu_id to bind to the GPU, and ntomp to set OpenMP threads
gmx mdrun -v -deffnm md -ntomp $SLURM_CPUS_PER_TASK -gpu_id 0
