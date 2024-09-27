#!/bin/bash
#SBATCH --job-name=beethoven_001
#SBATCH --partition=geo
#SBATCH --mem=128G
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=16
#SBATCH --output=slurm_messages/slurm-%j.out
#SBATCH --error=slurm_messages/slurm-%j.err
#SBATCH --mail-user=kyle.messier@nih.gov
#SBATCH --mail-type=ALL




apptainer exec \
  --bind $PWD/inst:/pipeline \
  --bind $PWD/input:/input \
  --bind $PWD/_targets:/opt/_targets \
  --bind $PWD:/mnt \
  beethoven_001.sif \
  Rscript /mnt/run.R


# If I need to mnt the working directory
#   --bind $PWD:/mnt \               # Bind the current working directory to /mnt in the container

