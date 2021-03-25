#!/usr/bin/env python3
# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

"""Script for writing copies of newick tree files with taxon/sequence names
replaced with short alphabetic codes from a given name conversion table.
"""

import sys
from name_replace import write_newick_tree_with_coded_names

if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    infile = cmdln[1]
    outfile = cmdln[2]
    tablefile = cmdln[3]

    write_newick_tree_with_coded_names(infile, outfile, tablefile)

