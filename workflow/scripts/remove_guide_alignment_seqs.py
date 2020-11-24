#!/usr/bin/env python3
"""Script for removing sequences from a guide alignment.
"""

import sys
import os
import shutil
from Bio import SeqIO


if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    alignment = cmdln[1]
    guide_alignment = cmdln[2]

    # Move input alignment to another path.
    alignment_copy = alignment.rsplit('.', 1)[0] + '_with_guide_seqs.afaa'
    os.rename(alignment, alignment_copy)

    # Count number of sequences in guide alignment.
    guide_seq_count = None
    with open(guide_alignment) as infh:
        guide_seq_count = len(list(SeqIO.parse(infh, 'fasta')))

    # Remove corresponding number of sequences from the alignment.
    with open(alignment, 'w') as o:
        SeqIO.write(list(SeqIO.parse(alignment_copy,\
            'fasta'))[guide_seq_count:], o, 'fasta')
