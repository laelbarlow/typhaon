# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule concat_ml_trees:
    """
    Concatenate ML trees from unconstrained and constrained analyses.
    """
    input:
        unconstrained_tree = \
        'results/iqtree_ml_search/{seed}/{fasta_name}.treefile',
        constrained_tree_dir = \
        'results/iqtree_constrained_ml_searches/{seed}/{fasta_name}'

    output:
        concat_newick = 'results/concat_ml_trees/{seed}/{fasta_name}.tre',
        constraint_order = \
        'results/concat_ml_trees/{seed}/{fasta_name}_concat_order.txt'

    run:
        with open(output.concat_newick, 'w') as concat, \
        open(output.constraint_order, 'w') as order:
            tree_list = [input.unconstrained_tree] + \
            glob.glob(os.path.join(input.constrained_tree_dir, '*.treefile'))
            assert len(tree_list) > 1
            for t in tree_list:
                order.write(t + '\n')
                with open(t) as th:
                    for i in th:
                        if not i.startswith('\n'):
                            concat.write(i)


