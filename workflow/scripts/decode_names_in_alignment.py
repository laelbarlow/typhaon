#!/usr/bin/env python3
# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

"""Script for writing copies of FASTA alignments with headers decoded.
"""

import sys
from name_replace import write_decoded_fasta_alignment

if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    infile = cmdln[1]
    outfile = cmdln[2]
    tablefile = cmdln[3]

    write_decoded_fasta_alignment(infile, outfile, tablefile)


