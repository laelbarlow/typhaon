# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule combine_seqs:
    """
    Generate a combined FASTA file by simply concatenating multiple FASTA files
    together.
    """
    input:
        fasta_dir1 = 'resources/{fasta_name}_FASTA',
        fasta_dir2 = \
        'results/randomly_sample_seqs/{seed}/{fasta_name}_FASTA'

    output:
        concat_fasta_file = 'results/combine_seqs/{seed}/{fasta_name}.faa'

    shell:
        """
        for X in {input.fasta_dir1}/*.faa; do \
          if [[ "$X" == *"ESSENTIAL"* ]] 
            then
            cat $X >> {output.concat_fasta_file}
          fi 
        done \
        && \
        for X in {input.fasta_dir2}/*.faa; do cat $X >> {output.concat_fasta_file}; done
        """


