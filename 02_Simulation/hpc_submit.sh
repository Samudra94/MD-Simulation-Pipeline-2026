#!/bin/bash
#SBATCH --job-name=MD_Run
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --time=48:00:00
#SBATCH --partition=gpu

module load gromacs/2023
gmx mdrun -v -deffnm md -ntomp 8
