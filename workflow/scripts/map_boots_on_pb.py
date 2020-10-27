#!/bin/env python3
"""Script for mapping IQ-TREE bootstrap proportions onto Phylobayes (or other)
topology.

***Functions defined below are adapted from code here:
    https://github.com/laelbarlow/amoebae
"""

import os
import sys
import subprocess
import re
from ete3 import Tree



def reformat_combined_supports(tree_string):
    cs = re.compile(r'\)\d+:')
    for instance in cs.findall(tree_string):
        #print(instance)
        # Define a reformatted support string.
        supcomb = instance[1:-1]
        boot = supcomb[-3:].lstrip('0')
        prob = str(int(supcomb[:-3])/100)
        supcomb2 = prob + '/' + boot

        # Replace the instance with a reformatted support string in the
        # tree_string.
        #tree_string = tree_string.replace(instance, instance[0] +\
        #        supcomb2 + instance[-1])
        tree_string = tree_string.replace(instance, '\"' + instance[0] +\
                supcomb2 + instance[-1] + '\"')

    # Return modified tree string.
    return tree_string


def check_leaf_names_match(t1, t2):
    """Take two ETE3 TreeNode objects and check that the lists of leaf names
    are perfectly overlapping sets.
    """
    # Get leaf names from tree 1.
    t1_names = [leaf.name for leaf in t1.get_leaves()]

    # Get leaf names from tree 2.
    t2_names = [leaf.name for leaf in t2.get_leaves()]

    # Find leaf names in tree 1 but not 2.
    in_1_not_2 = []
    for i in t1_names:
        if not i in t2_names:
            in_1_not_2.append(i)
    if len(in_1_not_2) > 0:
        print("""The following leaf names are in tree 1 but not tree 2:
        %s""" % ',\n'.join(in_1_not_2))

    # Find leaf names in tree 2 but not 1.
    in_2_not_1 = []
    for i in t2_names:
        if not i in t1_names:
            in_2_not_1.append(i)
    if len(in_2_not_1) > 0:
        print("""The following leaf names are in tree 2 but not tree 1:
        %s""" % ',\n'.join(in_2_not_1))

    ## Assert that both trees have the same number of leaf nodes.
    #print(len(t1_names))
    #print(len(t2_names))
    #assert len(t1_names) == len(t2_names), """Different numbers of terminal
    #(leaf) nodes in input trees."""

    # Assert they are identical sets.
    assert len(list(set(t1_names + t2_names))) == min([len(t1_names), len(t2_names)]), """Sets of
    terminal (leaf) node names do not perfectly overlap."""


def combine_supports(boot_newick, prob_newick, combined_figtree_newick):
    """Takes two newick files and writes another newick file that when opened
    in figtree will show posterior probabilities and bootstrap values together.

    ***Should add a function to check whether the two trees being compared are
    rooted on the same node, because that might affect the accuracy of
    comparisons.
    """
    # Define function for adding zeros as necessary.
    get_3_digit = lambda x: '0'*(3 - len(x)) + x

    # Parse the input newick tree files.
    boot_newick_tree = Tree(boot_newick)
    prob_newick_tree = Tree(prob_newick)

    # Check that the leaf node names match.
    check_leaf_names_match(boot_newick_tree, prob_newick_tree)

    # Generate a newick file with the topology of the phylobayes tree, but
    # without any branch support values.
    intermediate_topology_file = combined_figtree_newick.rsplit('.', 1)[0] +\
        '_topology.nwk'
    #topo = prob_newick_tree.copy()
    #for n in topo.traverse():
    #    if not n.is_leaf():
    #        n.support = ''
    #topo.write(outfile=intermediate_topology_file)
    prob_newick_tree.write(outfile=intermediate_topology_file, format=9)

    # Map bootstrap values onto the phylobayes topology using IQ-TREE.
    intermediate_topo_with_boots_file = combined_figtree_newick.rsplit('.', 1)[0] +\
        '_boots_only.suptree'
    subprocess.call(['iqtree',
                     '-sup', intermediate_topology_file,
                     boot_newick,
                     '-pre', intermediate_topo_with_boots_file.rsplit('.', 1)[0]
                     ])
    boot_newick_tree = Tree(intermediate_topo_with_boots_file)
    

    # Root trees on the same node arbitrarily.
    arbitrary_leaf_node = prob_newick_tree.get_leaves()[0]
    prob_newick_tree.set_outgroup(arbitrary_leaf_node.name)
    boot_newick_tree.set_outgroup(arbitrary_leaf_node.name)

    # Iterate through the rooted trees matching nodes and combining the support
    # values onto a single tree.
    for n1 in prob_newick_tree.traverse():
        found_boot = False
        if len(n1.get_leaf_names()) > 1:
            for n2 in boot_newick_tree.traverse():
                if set(n1.get_leaf_names()) == set(n2.get_leaf_names()):
                    found_boot = True

                    mb_support = get_3_digit(str(int(float(n1.support) * 100)))

                    iqtree_support = get_3_digit(str(n2.support)[:-2])

                    combined_support = mb_support + iqtree_support 
                    n1.support = int(combined_support)

        # Make sure that all the right nodes were identified.
        if not found_boot:
            if len(n1.get_leaves()) == 1:
                found_boot = True
        assert found_boot, """Error: could not identify one of the nodes in the
        bootstrap tree."""

    # Write the newick tree file to a temporary output file.
    temp_file = combined_figtree_newick + '_temp.newick'
    prob_newick_tree.write(outfile=temp_file)

    # Reformat supports in temporary file with tree so that they will be
    # displayed properly in FigTree.
    with open(temp_file) as infh, open(combined_figtree_newick, 'w') as o:
        for i in infh:
            # Call function to reformat tree string.
            new_tree_string = reformat_combined_supports(i)
            # Write reformatted tree string.
            o.write(new_tree_string)

    # Remove temporary file.
    os.remove(temp_file)




if __name__ == '__main__':

    # Parse command line arguments.
    cmdln = sys.argv
    pb_newick = cmdln[1]
    iqtree_bootstrap_newick = cmdln[2]
    output_newick = cmdln[3]

    # Map bootstrap values onto pb topology.
    combine_supports(iqtree_bootstrap_newick,
                     pb_newick,
                     output_newick)


