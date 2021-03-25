# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule decode_boots_on_pb:
    """
    Decode names in newick tree files.

    Necessary before visualizing trees.
    """
    input:
        script = 'workflow/scripts/decode_names.py',
        newick_file = \
        'results/map_boots_on_pb/{seed}/{fasta_name}_boots_only.suptree',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table'

    output:
        decoded_newick_file = \
        'results/visualize_boots_on_pb/{seed}/{fasta_name}_boots_only.suptree',

    conda:
        'envs/name_replace.yaml'

    shell:
        """
        python3 {input.script} \
                    {input.newick_file} \
                    {output.decoded_newick_file} \
                    {input.conversion_table_file} 
        """


