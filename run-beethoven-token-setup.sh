#!/bin/bash
#SBATCH --job-name=nasa_setup
#SBATCH --partition=geo
#SBATCH --mem=36G
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=2
#SBATCH --output=slurm_messages/slurm-%j.out
#SBATCH --error=slurm_messages/slurm-%j.err
#SBATCH --mail-user=kyle.messier@nih.gov
#SBATCH --mail-type=ALL




apptainer exec \
  --bind /ddn/gs1/home/messierkp/projects/beethoven_pipeline:/mnt/pipeline \
  --bind /ddn/gs1/home/messierkp/projects/beethoven:/mnt \
  --bind /ddn/gs1/group/set/Projects/NRT-AP-Model/input:/mnt/pipeline/input \
  --bind /ddn/gs1/home/messierkp/projects/beethoven/slurm_messages:/mnt/slurm_messages \
  beethoven_001.sif \
  Rscript /mnt/NASA_token_setup.R


# If I need to mnt the working directory
#   --bind $PWD:/mnt \               # Bind the current working directory to /mnt in the container
