# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule elaborate_constraint_trees:
    """
    Add sequence names to constraint trees for sequences that are in
    monophyletic clades with the sequences named in the original constraint
    trees.
    """
    input:
        #ml_tree_file = \
        #'results/fasttree/{seed}/{fasta_name}.tre'
        #ml_tree_file = \
        #'results/iqtree_ml_search/{seed}/{fasta_name}.treefile'
        script = 'workflow/scripts/elaborate_constraint_trees.py',
        constraint_tree_dir = \
        'results/code_constraint_trees/{seed}/{fasta_name}',
        ml_tree_file = \
        'results/iqtree_ml_search/{seed}/{fasta_name}.treefile'

    output:
        constraint_tree_dir = \
        directory('results/elaborate_constraint_trees/{seed}/{fasta_name}')

    conda:
        'envs/elaborate_constraint_trees.yaml'

    shell:
        """
        mkdir -p {output.constraint_tree_dir}
        for X in {input.constraint_tree_dir}/*.tre; do
        python3 {input.script} {input.ml_tree_file} \
                               $X \
                               {output.constraint_tree_dir}/$( basename $X )
        done
        """


