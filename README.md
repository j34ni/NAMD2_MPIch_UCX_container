# NAMD2_MPIch_UCX_container

NAMD stands for Nanoscale Molecular Dynamics, it is a high-performance simulation software designed for the simulation of large biomolecular systems, originaly developed by the Theoretical and Computational Biophysics Group at the University of Illinois at Urbana-Champaign, it is widely used in the fields of computational chemistry and molecular biology (https://www.ks.uiuc.edu/Research/namd).

## Description

This repository contains a Dockerfile to build NAMD2 using a base Ubuntu22.04 image with MPIch4.2.1 supporting UCX1.17 (no Cuda) with the **mpi-linux-x86_64** option.

**Warning: this repository does not include the NAMD application itself**

The user has to obtain the source code, in this instance `NAMD_Git-2022-07-21_Source.tar.gz`, from https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD and put it in the same directory as this Dockerfile.

### Build (with Docker)

With **only** `NAMD_Git-2022-07-21_Source.tar.gz` in the same folder as the Dockerfile, run:

```
docker build --progress=plain -t ubuntu2204_mpich421_namd2 -f Dockerfile .
```

### Coversion to Singularity Image File

```
docker save ubuntu2204_mpich421_namd2 -o ubuntu2204_mpich421_namd2.tar

singularity build ubuntu2204_mpich421_namd2.sif docker-archive://ubuntu2204_mpich421_namd2.tar

```

# Citation

If you use this container recipes and/or related material please kindly cite:

Jean Iaquinta. (2024). j34ni/NAMD2_MPIch_UCX_container: Version 1.1.0 (v1.1.0). Zenodo. 

https://doi.org/10.5281/zenodo.14162224

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14162224.svg)](https://doi.org/10.5281/zenodo.14162224)
