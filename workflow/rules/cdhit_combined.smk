# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule cdhit_combined:
    """
    Run CD-HIT on combined FASTA file to remove redundant sequences.

    The purpose of this step is simply to remove redundant sequences that may
    have been present in more than one input file.
    """
    input:
        concat_fasta_file = 'results/combine_seqs/{seed}/{fasta_name}.faa'

    output:
        nonredun_fasta_file = 'results/cdhit_combined/{seed}/{fasta_name}.faa'

    conda:
        'envs/cdhit.yaml'

    shell:
        """
        cd-hit -i {input.concat_fasta_file} -o {output.nonredun_fasta_file} \
            -c 1.0
        """


