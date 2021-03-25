# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule summarize_au_tests:
    """
    Collate all the iqtree AU test results into a single table in CSV format.
    """
    input:
        iqtree_output_files = expand('results/iqtree_au_test/{params}/{fasta_name}.iqtree', \
            fasta_name = fasta_names, params=paramspace1.instance_patterns),
        concat_order_files = expand('results/concat_ml_trees/{params}/{fasta_name}_concat_order.txt', \
            fasta_name = fasta_names, params=paramspace1.instance_patterns),

    output:
        outfile = 'results/summarize_au_tests/iqtree_au_test_summary.csv'

    script:
        '../scripts/summarize_au_tests.py'


