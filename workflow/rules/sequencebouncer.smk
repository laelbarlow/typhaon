# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule sequencebouncer:
    """
    Filter outlier sequences using the SequenceBouncer.py script written by
    Cory D. Dunn, downloaded from GitHub
    (https://github.com/corydunnlab/SequenceBouncer).

    Citation:
         SequenceBouncer: A method to remove outlier entries from a multiple
         sequence alignment Cory D. Dunn bioRxiv 2020.11.24.395459; doi:
         https://doi.org/10.1101/2020.11.24.395459

    Note: If the -k option is set to zero, then all sequences with median "nCS"
    scores above the 75th percentile will be excluded.
    """
    input:
        sequence_bouncer_script = sequence_bouncer_file,
        fasta_unalignment_script = 'workflow/scripts/afa_to_fa.py',
        aligned_fasta_dir =\
        'results/align_subsets/{fasta_name}_FASTA'

    output:
        filtered_fasta_dir =\
        directory('results/sequencebouncer/{fasta_name}_FASTA')

    params:
        k = config['sequencebouncer_k']

    conda:
        '../envs/sequencebouncer.yaml'

    shell:
        """
        mkdir -p {output.filtered_fasta_dir} && \
        for X in {input.aligned_fasta_dir}/*.afaa; do \
            python3 {input.sequence_bouncer_script} \
              -i $X \
              -o $(echo {output.filtered_fasta_dir}/$( basename $X ) | cut -f 1 -d '.') \
              -g 20 \
              -s 3 \
              -k {params.k} \
            && \
            python3 {input.fasta_unalignment_script} \
                       $(echo {output.filtered_fasta_dir}/$( basename $X) \
                           | cut -f 1 -d '.')'_output_clean.fasta' \
                       $(echo {output.filtered_fasta_dir}/$( basename $X) \
                           | cut -f 1 -d '.')'.faa'
            done
        """


