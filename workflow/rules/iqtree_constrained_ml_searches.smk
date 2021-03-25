# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule iqtree_constrained_ml_searches:
    """
    Perform one constrained Maximum Likelihood (ML) tree search with IQ-TREE.
    """
    input:
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy',
        constraint_tree_dir = \
        'results/elaborate_constraint_trees/{seed}/{fasta_name}'

    output:
        constrained_tree_dir = \
        directory('results/iqtree_constrained_ml_searches/{seed}/{fasta_name}')

    params:
        iqtree_model = config['iqtree_model']

    conda:
        'envs/iqtree_ultrafast.yaml'

    shell:
        """
        #    -m $(cat _input.model_text_file_) 
        mkdir -p {output.constrained_tree_dir}
        for X in {input.constraint_tree_dir}/*.tre; do
        iqtree \
            -s {input.phylip_file} \
            -nt AUTO \
            -m {params.iqtree_model} \
            -pre {output.constrained_tree_dir}/$( basename $X ) \
            -g $X \
            --runs 1 
        done
        """


