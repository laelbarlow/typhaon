# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule cdhit_subsets:
    """
    Reduce redundancy of sequences in each relevant input file.
    """
    input:
        files = input_fasta_files,
        fasta_dir = 'resources/{fasta_name}_FASTA'

    output:
        fasta_dir = directory('results/cdhit_subsets/{fasta_name}_FASTA')

    conda:
        'envs/cdhit.yaml'

    shell:
        """
        mkdir -p {output.fasta_dir} && \
        for X in {input.fasta_dir}/*.faa; do \
          if ! [[ "$X" == *"ESSENTIAL"* ]] 
            then
            cd-hit -i $X -o {output.fasta_dir}/$( basename $X ) \
                -n 5 \
                -c 0.70
          fi
          done
        """


