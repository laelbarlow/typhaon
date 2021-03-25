# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule decode_constrained_ml_search_names:
    """
    Decode names in newick tree files.

    Necessary before visualizing trees.
    """
    input:
        script = 'workflow/scripts/decode_names.py',
        newick_file_dir = \
        'results/iqtree_constrained_ml_searches/{seed}/{fasta_name}',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table'

    output:
        decoded_newick_file_dir = \
        directory('results/decode_constrained_ml_search_names/{seed}/{fasta_name}')

    conda:
        'envs/name_replace.yaml'

    shell:
        """
        mkdir -p {output.decoded_newick_file_dir}
        for X in {input.newick_file_dir}/*.treefile; do
        python3 {input.script} \
                    $X \
                    $(echo {output.decoded_newick_file_dir}/$( basename $X ) | cut -f 1 -d '.')'.tre' \
                    {input.conversion_table_file} 
        done
        """


