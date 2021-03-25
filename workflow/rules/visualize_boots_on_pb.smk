# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule visualize_boots_on_pb:
    """
    Render the newick tree output by Phylobayes with both posterior
    probabilities from Phylobayes and bootstrap values from IQ-TREE as a
    phylogram in PDF format.
    """
    input:
        script = 'workflow/scripts/visualize_boots_on_pb.py',
        pb_newick =\
        'results/decode_pb_names/{seed}/{fasta_name}_bpcomp_output.con.tre',
        pb_newick_boots_only = \
        'results/visualize_boots_on_pb/{seed}/{fasta_name}_boots_only.suptree'

    output:
        tree_pdf = 'results/visualize_boots_on_pb/{seed}/{fasta_name}.pdf'

    conda:
        'envs/visualize_fasttree.yaml'

    shell:
        """
        python3 {input.script} {input.pb_newick} {input.pb_newick_boots_only} {output.tree_pdf}
        """


