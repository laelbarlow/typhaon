#!/bin/env python3
"""Script for rendering newick trees as PDF files.

***Functions defined below are adapted from code here:
    https://github.com/laelbarlow/amoebae
"""

import os
import sys
import shutil
import subprocess
import glob
import re
import time
import io
from string import Template
import numpy as np
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from ete3 import Tree, AttrFace, NodeStyle, TreeStyle, TextFace
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
from PyPDF2 import PdfFileWriter, PdfFileReader
import matplotlib.colors as mc
import colorsys
import matplotlib
from matplotlib.pyplot import imread
import matplotlib.pyplot as plt
from xvfbwrapper import Xvfb
from visualize_fasttree import customize_node_styles_for_visualization


def add_combined_support_to_nodes_as_faces(t1, t2):
    """Take two ETE3 TreeNode objects, and add combined node support values as TextFace on
    top of the branch leading to each node in the first tree.
    """
    # Add a face to internal nodes with branch support string.
    for node1 in t1.traverse():
        if not node1.is_leaf():
            # Get corresponding node from the second tree.
            node2 = get_corresponding_node(node1, t2)

            # Construct combined support value.
            combined_support = str(node1.support) + '/' + \
                               str(int(node2.support))

            # Add combined support value as a branch label.
            node1.add_face(TextFace(combined_support, fsize=5), column=0, position='branch-top')


def get_corresponding_node(node, tree):
    """Return the ete3 TreeNode object in a tree that corresponds to
    a given node.
    """
    # Search for a node with child leaf nodes that have the same set of names.
    corresponding_node = None
    node_leaves = [x.name for x in node.get_leaves()]
    for n in tree.traverse():
        if set([y.name for y in n.get_leaves()]) == set(node_leaves):
            corresponding_node = n
            break
    # If necessary, re-root input tree on midpoint for parsing.
    if corresponding_node is None:
        # Re-root on midpoint.
        tree.set_outgroup(tree.get_midpoint_outgroup())
        # Search for node of interest again.
        for n in tree.traverse():
            if set([y.name for y in n.get_leaves()]) == set(node_leaves):
                corresponding_node = n
                break

    # Try rooting on random leaf nodes until the corresponding node can be
    # found.
    if corresponding_node is None:
        # Loop through random leaf nodes in tree, rooting on them, and then
        # searching for the corresponding node.
        for l in tree.iter_leaves():
            tree.set_outgroup(l)
            # Search for node of interest again.
            found = False
            for n in tree.traverse():
                if set([y.name for y in n.get_leaves()]) == set(node_leaves):
                    corresponding_node = n
                    found = True
                    break
            if found:
                break

    # Check that a corresponding node was identified.
    assert corresponding_node is not None, """Could not find corresponding
    node."""

    # Return corresponding node.
    return corresponding_node



if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    pb_newick = cmdln[1]
    pb_newick_boots_only = cmdln[2]
    output_file_path = cmdln[3]

    # Initiate a tree style.
    ts = TreeStyle()
    ts.show_leaf_name = False

    # Parse trees.
    pb_newick_tree = Tree(pb_newick, format=0)
    pb_newick_boots_only_tree = Tree(pb_newick_boots_only, format=0)

    # Root trees on midpoint.
    pb_newick_tree.set_outgroup(pb_newick_tree.get_midpoint_outgroup())
    pb_newick_boots_only_tree.set_outgroup(pb_newick_boots_only_tree.get_midpoint_outgroup())

    # Add node support values as branch labels (modifies pb_newick_tree).
    add_combined_support_to_nodes_as_faces(pb_newick_tree, pb_newick_boots_only_tree)

    # Customize the node styles generally.
    customize_node_styles_for_visualization(pb_newick_tree)


    #####################################################

    # Write tree to pdf.

    ## Use this for running on personal computer:
    #pb_newick_tree.render(output_file_path, tree_style=ts, w=8.5, h=11, units='in', dpi=600)
    
    # Use this for running on a cluster:
    vdisplay = Xvfb()
    vdisplay.start()
    try:
        pb_newick_tree.render(output_file_path, tree_style=ts, w=8.5, h=11, units='in', dpi=600)
    finally:
        vdisplay.stop()


    #####################################################

    # Check that PDF was written.
    assert os.path.isfile(output_file_path)

