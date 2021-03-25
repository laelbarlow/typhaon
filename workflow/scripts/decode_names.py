#!/usr/bin/env python3
# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

"""Script for writing copies of newick tree topology files with headers
replaced with taxon name codes (short alphabetic codes) replaced with the
original sequence header in quotation marks.
"""

import sys
from name_replace import write_newick_tree_with_uncoded_names

if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    infile = cmdln[1]
    outfile = cmdln[2]
    tablefile = cmdln[3]

    write_newick_tree_with_uncoded_names(infile,
                                         outfile,
                                         tablefile,
                                         True)

