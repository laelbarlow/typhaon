#!/usr/bin/env python3
# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

"""This script converts aligned fasta files to fasta files.

Usage:

    python3 afa_to_fa.py <input (.faa) file path> <output (.afaa) file path>
    
"""
import sys
import os
from Bio import SeqIO


def get_fa_record_text_from_obj(obj):
    """Takes a Bio.SeqIO sequence object and returns the fasta record as a
    string (two lines for writing to a fasta format file).
    """
    text = str('>' + obj.description + '\n' + obj.seq + '\n')
    return text


def afa_to_fa(infilepath, outfilepath):
    """Takes an aligned fasta file (protein) and writes a .fa file.
    """
    with open(infilepath) as inhandle, open(outfilepath, 'w') as outhandle:
        afa_file = SeqIO.parse(inhandle, "fasta")
        for record in afa_file:
            x = str(record.seq)
            record.seq = x.replace('-', '')
            outhandle.write(get_fa_record_text_from_obj(record))


if __name__ == '__main__':
    command_line_list = sys.argv
    input_file_path = str(command_line_list[1])
    output_file_path = str(command_line_list[2])
    # Call main function to write unaligned sequences to output file.
    afa_to_fa(input_file_path, output_file_path)    
