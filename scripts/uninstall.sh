#!/usr/bin/env bash
# Script for removing all files associated with amoebae_example_workflow.

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

# Remove files.

confirm rm -rf ~/env_typhaon_workflow_setup_py

confirm rm -rf ../typhaon

