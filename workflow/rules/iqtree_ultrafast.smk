# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule iqtree_ultrafast:
    """
    Perform ultrafast bootstrapping with IQ-TREE.
    """
    input:
        model_text_file = 'results/modelfinder/{seed}/{fasta_name}.txt',
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    output:
        newick_tree_file = \
        'results/iqtree_ultrafast/{seed}/{fasta_name}.treefile',
        bootstrap_file = \
        'results/iqtree_ultrafast/{seed}/{fasta_name}.ufboot'

    conda:
        'envs/iqtree_ultrafast.yaml'

    shell:
        """
        iqtree \
            -s {input.phylip_file} \
            -nt AUTO \
            -m $(cat {input.model_text_file}) \
            -pre $(echo {output.newick_tree_file} | cut -f 1 -d '.') \
            -B 1000 \
            -bnni \
            -redo
        """


