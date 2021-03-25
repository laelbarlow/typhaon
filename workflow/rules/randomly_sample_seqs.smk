# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule randomly_sample_seqs:
    """
    Randomly sample a given maximum number of sequences (without replacement)
    from each input FASTA file. A seed number is specified for random sampling,
    so sampling is reproducible.
    """
    input:
        fasta_dir =\
        f'results/sequencebouncer/{"{fasta_wildcard}"}_FASTA'

    output:
        fasta_dir =\
        directory(f'results/randomly_sample_seqs/{paramspace1.wildcard_pattern}/{"{fasta_wildcard}"}_FASTA')

    params:
        seed_instance = paramspace1.instance,
        sample_size = config['sequence_sample_size']

    conda:
        '../envs/randomly_sample_seqs.yaml'

    script:
        '../scripts/randomly_sample_seqs.py'


