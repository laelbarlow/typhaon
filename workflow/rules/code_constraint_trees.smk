# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule code_constraint_trees:
    """
    Code names in input constraint trees (newick format) using the appropriate
    conversion table.
    """
    input:
        script = 'workflow/scripts/code_constraint_trees.py',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table',
        constraint_tree_dir = 'resources/{fasta_name}_FASTA'

    output:
        constraint_tree_dir = \
        directory('results/code_constraint_trees/{seed}/{fasta_name}')

    conda:
        'envs/name_replace.yaml'

    shell:
        """
        mkdir -p {output.constraint_tree_dir}
        for X in {input.constraint_tree_dir}/*.tre; do
        python3 {input.script} $X \
                               {output.constraint_tree_dir}/$( basename $X ) \
                               {input.conversion_table_file} 
        done
        """


