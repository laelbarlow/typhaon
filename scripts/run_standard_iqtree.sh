#!/usr/bin/env bash

# Determine what Snakemake profile to use.
source scripts/determine_snakemake_profile.sh

# Determine whether to use the --profile option at all.
profile_option="--profile"
if [ "$snakemake_profile" == "" ]; then
    profile_option="--cores 1"
fi

# Determine which environment management options to use.
source scripts/determine_snakemake_env_options.sh

# Activate python virtual environment.
source scripts/workflow_python_env_definition.sh

# Run snakemake in python virtual environment.
snakemake standard_iqtree -j 100 $env_options $profile_option $snakemake_profile

# Deactivate python virtual environment.
source scripts/deactivate_python_env.sh
