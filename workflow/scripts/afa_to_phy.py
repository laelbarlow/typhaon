#!/usr/bin/env python3
"""Script for converting FASTA alignments to PHYLIP format.
"""

import sys
from Bio import AlignIO


if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    infilepath = cmdln[1]
    outfilepath = cmdln[2]

    # Open input and output alignment files.
    with open(infilepath) as inhandle, open(outfilepath, 'w') as outhandle:

        # Parse input FASTA alignment.
        alignment = AlignIO.read(inhandle,
                                 "fasta")

        # Write alignment in PHYLIP format.
        AlignIO.write(alignment, outhandle, "phylip-sequential")
