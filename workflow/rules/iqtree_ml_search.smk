# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule iqtree_ml_search:
    """
    Perform one Maximum Likelihood (ML) tree search with IQ-TREE.
    """
    input:
        #model_text_file = 'results/modelfinder/{seed}/{fasta_name}.txt'
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    output:
        newick_tree_file = 'results/iqtree_ml_search/{seed}/{fasta_name}.treefile'

    params:
        iqtree_model = config['iqtree_model']

    conda:
        '../envs/iqtree_ultrafast.yaml'

    shell:
        """
        #    -m $(cat _input.model_text_file_) 
        iqtree \
            -s {input.phylip_file} \
            -nt AUTO \
            -m {params.iqtree_model} \
            -pre $(echo {output.newick_tree_file} | cut -f 1 -d '.') \
            --runs 1 \
            -redo
        """


