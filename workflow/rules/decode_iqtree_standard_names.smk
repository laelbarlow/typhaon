# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule decode_iqtree_standard_names:
    """
    Decode names in newick tree files.

    Necessary before visualizing trees.
    """
    input:
        script = 'workflow/scripts/decode_names.py',
        newick_file = \
        'results/iqtree_standard_newick/{seed}/{fasta_name}.treefile',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table'

    output:
        decoded_newick_file = 'results/iqtree_standard_newick_decoded/{seed}/{fasta_name}.treefile'

    conda:
        '../envs/name_replace.yaml'

    shell:
        """
        python3 {input.script} \
                    {input.newick_file} \
                    {output.decoded_newick_file} \
                    {input.conversion_table_file} 
        """


