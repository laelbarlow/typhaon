#!/bin/bash
# properties = {properties}

# Load modules.
module load  \
cd-hit/4.8.1 \
fasttree/2.1.10 \
iq-tree/2.0.7 \
mafft/7.471 \
nixpkgs/16.09 \
intel/2018.3 \
trimal/1.4 \
openmpi/3.1.4 \
phylobayes-mpi/20180420 

# Execute job.
{exec_job}
