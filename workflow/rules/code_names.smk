# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule code_names:
    """
    Take trimmed alignment files and convert sequence names to short
    alphanumeric codes.

    Necessary before converting to PHYLIP format (for Phylobayes, etc.).
    """
    input:
        script = 'workflow/scripts/code_names.py',
        fasta_file = 'results/mafft/{seed}/{fasta_name}.afaa'

    output:
        coded_fasta_file = 'results/code_names/{seed}/{fasta_name}.afaa',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table'

    conda:
        'envs/name_replace.yaml'

    shell:
        """
        python3 {input.script} \
                    {input.fasta_file} \
                    {output.coded_fasta_file} \
                    {output.conversion_table_file} 
        """


