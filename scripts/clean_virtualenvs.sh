#!/usr/bin/env bash
# Script for removing all files associated with typhaon virtual environments.
# This is so that they can be re-generated when the code is modified.

# Define a function to confirm with the user before deleting files.
confirm() {
    echo -n "Do you want to run $*? [N/y] "
    read -N 1 REPLY
    echo
    if test "$REPLY" = "y" -o "$REPLY" = "Y"; then
        "$@"
    else
        echo "Cancelled by user"
    fi
}

# Remove files associated with virtual environments.
if test "$(command -v conda)"; then
    confirm conda env remove --name conda_env_typhaon
else
    confirm rm -rf ~/env_typhaon_snakemake_workflow
fi


