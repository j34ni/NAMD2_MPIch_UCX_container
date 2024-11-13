#!/bin/bash

#SBATCH --job-name=namd2-container
#SBATCH --account=ecxxxx
#SBATCH --time=04:00:00
#SBATCH --mem-per-cpu=512
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

srun -n $SLURM_NTASKS --mpi=pmi2 apptainer exec --bind $FILES:/mnt $NAMD2 ...
