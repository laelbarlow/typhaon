# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule visualize_pb:
    """
    Render the newick tree output by Phylobayes as a phylogram in PDF format.
    """
    input:
        script = 'workflow/scripts/visualize_fasttree.py',
        tree_newick =\
        'results/decode_pb_names/{seed}/{fasta_name}_bpcomp_output.con.tre'

    output:
        tree_pdf = 'results/visualize_pb/{seed}/{fasta_name}.pdf'

    conda:
        'envs/visualize_fasttree.yaml'

    shell:
        """
        python3 {input.script} {input.tree_newick} {output.tree_pdf}
        """


