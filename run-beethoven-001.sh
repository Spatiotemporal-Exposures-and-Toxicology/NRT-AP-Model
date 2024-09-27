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
  --bind /ddn/gs1/home/messierkp/projects/beethoven_pipeline:/beethoven_pipeline \
  --bind $PWD:/mnt \
  --mount type=bind,src=$PWD/input,dst=/pipeline/input \
  --mount type=bind,src=/ddn/gs1/home/messierkp/projects/beethoven/_targets,dst=/opt/_targets \
  --mount type=bind,src=$PWD,dst=/mnt \  
  beethoven_001.sif \
  Rscript /mnt/run.R


# If I need to mnt the working directory
#   --bind $PWD:/mnt \               # Bind the current working directory to /mnt in the container
