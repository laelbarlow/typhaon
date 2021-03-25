# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule visualize_constrained_ml_searches:
    """
    Render the newick tree output by IQ-TREE as a phylogram in PDF format.
    """
    input:
        script = 'workflow/scripts/visualize_fasttree.py',
        tree_newick_dir = 'results/decode_constrained_ml_search_names/{seed}/{fasta_name}'

    output:
        tree_pdf_dir = \
        directory('results/visualize_constrained_ml_searches/{seed}/{fasta_name}')

    conda:
        'envs/visualize_fasttree.yaml'

    shell:
        """
        mkdir -p {output.tree_pdf_dir}
        for X in {input.tree_newick_dir}/*.tre; do
        python3 {input.script} $X $(echo {output.tree_pdf_dir}/$( basename $X ) | cut -f 1 -d '.')'.pdf'
        done
        """


