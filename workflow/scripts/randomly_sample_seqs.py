#!/usr/bin/env python3
"""Script for randomly sampling FASTA sequences.
"""

import sys
import os
import glob
import random
from Bio import SeqIO


if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    sample_size = cmdln[1]
    seed = cmdln[2]
    input_fasta_dir = cmdln[3]
    output_fasta_dir = cmdln[4]

    # Make output directory.
    if not os.path.isdir(output_fasta_dir):
        os.mkdir(output_fasta_dir)

    # Identify relevant FASTA files in input directory.
    fasta_files = glob.glob(os.path.join(input_fasta_dir, '*.faa'))

    # Iterate over relevant FASTA files.
    for f in fasta_files:

        # Define corresponding output file path.
        f_out = os.path.join(output_fasta_dir, os.path.basename(f))

        # Open input and output alignment files.
        with open(f) as infh, open(f_out, 'w') as o:

            # Parse input FASTA sequences.
            seqs = list(SeqIO.parse(infh, 'fasta'))

            # Check whether the number of sequences is less than the sample
            # size specified.
            if len(seqs) < int(sample_size):
                # Simply write all the sequences to the output file.
                SeqIO.write(seqs, o, 'fasta')
                
            else:
                # Randomly sample sequences. 

                # Apply random number generator seed.
                random.seed(int(seed))

                # Generate a sub-sample of seqs.
                seqs_sample = random.sample(seqs, int(sample_size))

                # Write sample of sequences to output file.
                SeqIO.write(seqs_sample, o, 'fasta')


