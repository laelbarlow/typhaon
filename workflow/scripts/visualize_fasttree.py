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

def customize_node_styles_for_visualization(t):
    """Take an ete3 tree object , and modify the node styles for better
    visualization.
    """
    # Add a face to internal nodes with branch support string.
    for node in t.traverse():
        if not node.is_leaf():
            #node.add_face(TextFace(node.support, fsize=5), column=0, position='branch-top')
            node.add_face(TextFace(node.name, fsize=5), column=0, position='branch-top')


    # Remove blue dots before leaf names.
    # Draws nodes as small red spheres of diameter equal to 10 pixels
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


def lighten_color(color, amount=0.5):
    """Takes a hex colour code and returns a hex code for the same colour but
    lighter by multiplying (1-luminosity) by the given amount (fraction).
    """
    try:
        c = mc.cnames[color]
    except:
        c = color
    c = colorsys.rgb_to_hls(*mc.to_rgb(c))
    ct = colorsys.hls_to_rgb(c[0], 1 - amount * (1 - c[1]), c[2])
    return '#%02x%02x%02x' % (int(ct[0]*255), int(ct[1]*255), int(ct[2]*255))


def highlight_node(t, node):
    """Take an ete3 tree object and a list of nodes with paralogues, and modify
    the node styles to emphasize important features.
    """
    # Make a list of colours as an iterable.
    # Colour scheme source: https://www.nature.com/articles/nmeth.1618?WT.ec_id=NMETH-201106
    colour_iterable = iter(['#%02x%02x%02x' % (230, 159, 0),#Orange
                            '#%02x%02x%02x' % (86, 180, 233),#Sky blue
                            '#%02x%02x%02x' % (0, 158, 115),#Bluish green
                            '#%02x%02x%02x' % (240, 228, 66),#Yellow
                            '#%02x%02x%02x' % (0, 114, 178),#Blue
                            '#%02x%02x%02x' % (213, 94, 0),#Vermillion
                            '#%02x%02x%02x' % (204, 121, 167)#Reddish purple
                            ]*100)

    # Get current highlight colour, if any.
    current_bgcolor = node.img_style['bgcolor']

    # Set up a node style for clades with paralogues.
    nstyle2 = NodeStyle()
    nstyle2["shape"] = "sphere"
    nstyle2["size"] = 0
    nstyle2["vt_line_color"] = "#000000"
    nstyle2["hz_line_color"] = "#000000"
    nstyle2["vt_line_width"] = 2
    nstyle2["hz_line_width"] = 2
    nstyle2["vt_line_type"] = 0 # 0 solid, 1 dashed, 2 dotted
    nstyle2["hz_line_type"] = 0

    # Make sure that the new colour is different than the old color (so that
    # all highlighted clades are actually visible.
    same_bgcolor = True
    new_bgcolor = None
    while same_bgcolor:
        new_bgcolor = lighten_color(next(colour_iterable), 0.5)
        if new_bgcolor != current_bgcolor:
            same_bgcolor = False
    assert new_bgcolor != current_bgcolor

    # Set new background color.
    nstyle2["bgcolor"] = new_bgcolor

    ## Temp.
    #print('\n\nNode:')
    #print(node)
    #print('current_bgcolor')
    #print(current_bgcolor)
    #print('new_bgcolor')
    #print(new_bgcolor)

    # Set the node style for node and all subnodes.
    node.set_style(nstyle2)
    for sn in node.traverse():
        sn.set_style(nstyle2)


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
    t1 = Tree(tf, format=1)
    #print(t1)

    # Make a copy of the TreeNode object.
    t2 = t1.copy()

    # Root on midpoint.
    t2.set_outgroup(t2.get_midpoint_outgroup())

    # Customize the node styles generally.
    customize_node_styles_for_visualization(t2)

    ## Identify leaf node with original query sequence.
    #nodes = []
    #for n in t2.iter_leaves():
    #    query_idx = query_id.rsplit('_', 1)[0]
    #    if query_id in n.name:
    #        nodes.append(n)
    #    elif query_idx in n.name and len(query_idx) > 5:
    #        nodes.append(n)
    ##print(len(nodes))
    #assert len(nodes) <= 1
    #if len(nodes) == 1:
    #    node = nodes[0]
    #    # Highlight leaf for original query sequence.
    #    highlight_node(t2, node)
    #elif len(nodes) > 1:
    #    print("""More than one instance of sequence with ID %s in tree for
    #    results of searches with query with ID %s.""" % (query_id,
    #        query_id))
    #    assert not len(nodes) > 1
    #else:
    #    print("""Could not identify sequence with ID %s in tree for results
    #    of searches with query with ID %s.""" % (query_id, query_id))


    # Write tree to pdf.
    vdisplay = Xvfb()
    vdisplay.start()
    try:
        t2.render(output_file_path, tree_style=ts, w=8.5, h=11, units='in', dpi=600)
    finally:
        vdisplay.stop()

    # Check that PDF was written.
    assert os.path.isfile(output_file_path)

    ## Make a copy for markup.
    #shutil.copyfile(output_file_path, output_file_path.rsplit('.', 1)[0] +\
    #        '_with_markup.pdf')
        

