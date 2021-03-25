# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule visualize_iqtree_ml_search:
    """
    Render the newick tree output by IQ-TREE as a phylogram in PDF format.
    """
    input:
        script = 'workflow/scripts/visualize_fasttree.py',
        tree_newick = 'results/decode_iqtree_ml_search_names/{seed}/{fasta_name}.treefile'

    output:
        tree_pdf = 'results/visualize_iqtree_ml_search/{seed}/{fasta_name}.pdf'

    conda:
        'envs/visualize_fasttree.yaml'

    shell:
        """
        python3 {input.script} {input.tree_newick} {output.tree_pdf}
        """


