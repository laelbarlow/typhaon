# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule decode_alignment:
    """
    Decode names in alignment files.
    """
    input:
        script = 'workflow/scripts/decode_names_in_alignment.py',
        alignment = \
        'results/trimal/{seed}/{fasta_name}.afaa',
        conversion_table_file = 'results/code_names/{seed}/{fasta_name}.table'

    output:
        alignment = \
        'results/decode_alignment/{seed}/{fasta_name}.afaa'

    conda:
        'envs/name_replace.yaml'

    shell:
        """
        python3 {input.script} \
                    {input.alignment} \
                    {output.alignment} \
                    {input.conversion_table_file} 
        """


