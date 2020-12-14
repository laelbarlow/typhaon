#!/usr/bin/env bash
# Script for touching intermediate files (such as alignments constructed on
# another machine) using the snakemake --touch option. This prevents the
# workflow from being run from the beginning, when the desired intermediate
# files already exist. 

# Activate python virtual environment.
source scripts/workflow_python_env_definition.sh

# Run snakemake in python virtual environment.
snakemake --cores 1 --touch

# Deactivate python virtual environment.
source scripts/deactivate_python_env.sh

