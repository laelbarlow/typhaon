#!/usr/bin/env python3
"""Script for writing copies of FASTA files with headers replaced with short
alphabetic codes.
"""

import sys
from name_replace import write_afa_with_code_names

if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    infile = cmdln[1]
    outfile = cmdln[2]
    tablefile = cmdln[3]

    write_afa_with_code_names(infile, outfile, tablefile)

