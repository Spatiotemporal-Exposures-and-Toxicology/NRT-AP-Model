#!/bin/bash

#SBATCH --job-name=beethoven
#SBATCH --mail-user=manwareme@nih.gov
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=geo
#SBATCH --ntasks=1
#SBATCH --mem=800G
#SBATCH --cpus-per-task=100
#SBATCH --error=/ddn/gs1/home/manwareme/beethoven/beethoven/slurm/beethoven_%j.err
#SBATCH --output=/ddn/gs1/home/manwareme/beethoven/beethoven/slurm/beethoven_%j.out

# run pipeline in the container
apptainer exec \
  --bind $PWD:/mnt \
  --bind $PWD/inst:/inst \
  --bind /ddn/gs1/group/set/Projects/NRT-AP-Model/input:/input \
  --bind /ddn/gs1/home/manwareme/beethoven/targets:/opt/_targets \
  beethoven_dl_calc.sif \
  Rscript --no-init-file /mnt/inst/targets/targets_start.R

# run interactive R session in the container
# apptainer exec --bind $PWD/inst:/inst --bind /ddn/gs1/group/set/Projects/NRT-AP-Model/input:/input --bind $PWD:/mnt beethoven_dl_calc.sif R