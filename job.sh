#!/bin/bash

#SBATCH --job-name=namd2-container
#SBATCH --account=ecxx
#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.e

## Recommended safety settings:
set -o errexit # Make bash exit on any error
set -o nounset # Treat unset variables as errors

FILES=/location_of_the_data
NAMD2="ubuntu2204_mpich421_namd2.sif"

srun -n $SLURM_NTASKS --mpi=pmi2 apptainer exec --bind $FILES:/mnt $NAMD2 namd2 /mnt/1-3/complex/equ_site.namd
