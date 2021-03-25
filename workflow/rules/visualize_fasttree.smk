# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule visualize_fasttree:
    """
    Render the newick tree output by FastTree as a phylogram in PDF format.
    """
    input:
        script = 'workflow/scripts/visualize_fasttree.py',
        tree_newick = 'results/decode_fasttree_names/{seed}/{fasta_name}.tre'

    output:
        tree_pdf = 'results/visualize_fasttree/{seed}/{fasta_name}.pdf'

    conda:
        '../envs/visualize_fasttree.yaml'

    shell:
        """
        python3 {input.script} {input.tree_newick} {output.tree_pdf}
        """


