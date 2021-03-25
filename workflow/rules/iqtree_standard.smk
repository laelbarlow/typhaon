# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule iqtree_standard:
    """
    Run IQ-TREE with standard non-parametric bootstrapping. This more thorough
    form of bootstrapping often yields considerably different topologies than
    ultrafast bootstrapping, at least for single-gene/protein analyses.
    """
    input:
        model_text_file = 'results/modelfinder/{seed}/{fasta_name}.txt',
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    output:
        newick_tree_file =\
        'results/iqtree_standard_newick/{seed}/{fasta_name}.treefile',
        bootstraps_file = \
        'results/iqtree_standard_newick/{seed}/{fasta_name}.boottrees',

    conda:
        'envs/iqtree_ultrafast.yaml'

    shell:
        """
        iqtree \
            -s {input.phylip_file} \
            -pre $(echo {output.newick_tree_file} | cut -f 1 -d '.') \
            -nt AUTO \
            -m $(cat {input.model_text_file}) \
            -b 100 \
            -redo
        """


