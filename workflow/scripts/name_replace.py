#!/usr/bin/env python3
"""Module for replacing sequence headers in FASTA files with short alphabetic
codes, and for replacing them with the original headers in newick format tree
files.

Some functions adapted from code repository here:
    https://github.com/laelbarlow/amoebae
"""

import sys
import os
import re
from ete3 import Tree

def generate_code_name(number):
    """Take the number of the sequence in the input file, and output an
    alphabetical code that uniquely corresponds to that number.
    """
    # Check that the number is not greater than the maximum possible to code
    # using this function.
    assert number <= 99999999, """Given sequence number exceeds maximum limit
    for coding function."""

    # Define dictionary for converting digits to letters.
    conversion_dict = {'0': 'Z',
                       '1': 'W',
                       '2': 'R',
                       '3': 'P',
                       '4': 'D',
                       '5': 'J',
                       '6': 'K',
                       '7': 'L',
                       '8': 'V',
                       '9': 'Q'
                       }

    # Convert digits to letters.
    codename = ''
    for i in str(number):
        codename = codename + conversion_dict[i]

    # Add prefix.
    prefix = '' + ('Z' * (8-len(codename)))
    codename = prefix + codename

    # Return codename
    return codename


def write_afa_with_code_names(infile, outfile, tablefile):
    """Take an aligned (or unaligned) fasta file, and write a fasta file with
    coded names, and a table for converting names back.
    """
    original_names = []
    with open(infile) as infh, open(outfile, 'w') as o, open(tablefile, 'w') as tableh:
        inum = -1 
        for i in infh:
            if i.startswith('>'):
                inum += 1
                original_name = i[1:].strip()
                original_names.append(original_name)

                # Define code name.
                code_name = generate_code_name(inum)

                # Write coded name to output sequence file.
                o.write('>' + code_name + '\n')

                # Write values to table file.
                tableh.write(code_name + '\n')
                tableh.write(original_name + '\n')

            else:
                # Write line with sequence to output sequence file.
                o.write(i)

    # Check for redundant sequence names.
    assert len(original_names) == len(list(set(original_names))), """Redundant
    sequence names in input fasta file."""


def get_conversion_dict_from_table(tablefile):
    """Take a conversion table and return a dictionary for uncoding names.
    """
    conv_dict = {}
    with open(tablefile) as tablefileh:
        oddlist = []
        evenlist = []
        inum = 0
        for i in tablefileh:
            if not i.startswith('\n'):
                inum += 1
                if inum % 2 == 0:
                    evenlist.append(i.strip())
                else:
                    oddlist.append(i.strip())
    for code, original in zip(oddlist, evenlist):
        conv_dict[code] = original

    return conv_dict


def write_newick_tree_with_uncoded_names(infile, outfile, tablefile,
        quoted_names=False):
    """Take a text file with a newick tree, and write a new one with names
    converted back to original names (given values in a conversion table), and
    optionally put quotation marks around the names in the output tree.
    """
    # Generate a dictionary for converting names.
    conv_dict = get_conversion_dict_from_table(tablefile)

    ## Look for each code in the input tree, and replace with original name.
    #tree_string = None
    #with open(infile) as infh:
    #    tree_string = infh.readline()

    #for code in conv_dict:
    #    if quoted_names:
    #        tree_string = tree_string.replace(code, '"' + conv_dict[code] + '"')
    #    else:
    #        tree_string = tree_string.replace(code, conv_dict[code])

    #t1 = Tree(infile)
    t1 = Tree(infile, format=1)
    t2 = t1.copy()
    for node in t2.traverse():
        if node.is_leaf():
            for x in conv_dict.keys():
                if node.name.strip('\'').replace(' ', '_') == x.strip('\'').replace(' ', '_'):
                    node.name = conv_dict[x]

    # Write uncoded tree to output file.
    #with open(outfile, 'w') as o:
        #o.write(tree_string)
        #o.write(t2)
    t2.write(outfile=outfile, format=1)


def write_newick_tree_with_coded_names(infile, outfile, tablefile,
        quoted_names=False):
    """Take a newick file and replace full taxon names with coded names from a
    table.
    """
    # Generate a dictionary for converting names.
    conv_dict = get_conversion_dict_from_table(tablefile)

    # Look for each original name in the input tree and replace with the coded
    # name for the output tree.
    tree_string = None
    with open(infile) as infh:
        #tree_string = infh.readline()
        tree_string = infh.read()

    for code in conv_dict.keys():
        tree_string = tree_string.replace(conv_dict[code], code)

    # Write uncoded tree to output file.
    with open(outfile, 'w') as o:
        o.write(tree_string)


def write_decoded_fasta_alignment(infile, outfile, tablefile):
    """Take an alignment in FASTA format and a conversion table, and write a
    new FASTA alignment with headers decoded.
    """
    # Generate a dictionary for converting names.
    conv_dict = get_conversion_dict_from_table(tablefile)

    # Iterate over lines in input alignment, writing modified headers.
    with open(infile) as infh, open(outfile, 'w') as o:
        for i in infh:
            if i.startswith('>'):
                found = False
                for x in conv_dict.keys():
                    if x in i:
                        found = True
                        o.write(i.replace(x, conv_dict[x]))
                assert found, """Could not decode header:\n\t%s""" % i
            else:
                o.write(i)
    

