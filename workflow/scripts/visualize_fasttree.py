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
from sys import platform


def add_support_to_nodes_as_faces(t):
    """Take an ETE3 TreeNode object, and add node support values as TextFace on
    top of the branch leading to the node.
    """
    # Add a face to internal nodes with branch support string.
    for node in t.traverse():
        if not node.is_leaf():
            node.add_face(TextFace(node.support, fsize=5), column=0, position='branch-top')
            #node.add_face(TextFace(node.name, fsize=5), column=0, position='branch-top')


def customize_node_styles_for_visualization(t):
    """Take an ete3 tree object , and modify the node styles for better
    visualization.
    """
    # Remove blue dots before leaf names.
    nstyle = NodeStyle()
    nstyle["shape"] = "sphere"
    nstyle["size"] = 0
    # Gray dashed branch lines
    #nstyle["hz_line_type"] = 1
    #nstyle["hz_line_color"] = "#cccccc"
    #nstyle["fgcolor"] = "#0f0f0f"
    nstyle["vt_line_color"] = "#000000"
    nstyle["hz_line_color"] = "#000000"
    nstyle["vt_line_width"] = 1.5
    nstyle["hz_line_width"] = 1.5
    nstyle["vt_line_type"] = 0 # 0 solid, 1 dashed, 2 dotted
    nstyle["hz_line_type"] = 0
    # Applies the same static style to all nodes in the tree. Note that,
    # if "nstyle" is modified, changes will affect to all nodes
    for n in t.traverse():
       n.set_style(nstyle)
       if n.is_leaf():
           # Set font size for leaf/taxon labels.
           name_face = TextFace(n.name, fgcolor="black", fsize=5)
           n.add_face(name_face, column=0, position='branch-right')


if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    tf = cmdln[1]
    output_file_path = cmdln[2]

    # Define query ID present in filename.
    query_id = os.path.basename(tf)[2:].rsplit('_', 1)[0]

    # Initiate a tree style.
    ts = TreeStyle()
    ts.show_leaf_name = False

    # Parse tree.
    #t1 = Tree(tf, format=3)
    t1 = Tree(tf, format=0)
    #print(t1)

    # Make a copy of the TreeNode object.
    t2 = t1.copy()

    # Root on midpoint.
    t2.set_outgroup(t2.get_midpoint_outgroup())

    # Add node support values as branch labels.
    add_support_to_nodes_as_faces(t2)

    # Customize the node styles generally.
    customize_node_styles_for_visualization(t2)


    #####################################################

    # Write tree to pdf.

    if platform == "linux" or platform == "linux2":
        # linux

        # Use this for running on a cluster:
        vdisplay = Xvfb()
        vdisplay.start()
        try:
            t2.render(output_file_path, tree_style=ts, w=8.5, h=11, units='in', dpi=600)
        finally:
            vdisplay.stop()

    elif platform == "darwin":
        # OS X

        # Use this for running on personal computer:
        t2.render(output_file_path, tree_style=ts, w=8.5, h=11, units='in', dpi=600)

    elif platform == "win32":
        # Windows...
        assert platform != "win32", """This software has not been tested on
        Windows operating systems."""

    else:
        assert 2!=2, """Unable to identify opterating system."""


    #####################################################

    # Check that PDF was written.
    assert os.path.isfile(output_file_path)

