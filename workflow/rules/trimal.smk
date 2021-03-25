# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule trimal:
    """
    Trim positions from a sequence alignment using TrimAl.
    """
    input:
        aligned_fasta_file = 'results/code_names/{seed}/{fasta_name}.afaa'

    output:
        trimmed_fasta_file = 'results/trimal/{seed}/{fasta_name}.afaa'

    conda:
        '../envs/trimal.yaml'

    shell:
        """
        #trimal -in {input.aligned_fasta_file} -out {output.trimmed_fasta_file} -gappyout
        #trimal -in {input.aligned_fasta_file} -out {output.trimmed_fasta_file} -automated1
        # -gt 0.5
        trimal \
            -in {input.aligned_fasta_file} \
            -out {output.trimmed_fasta_file} \
            -htmlout \
                $(echo {output.trimmed_fasta_file} | cut -f 1 -d '.')'_trimming_record.html' \
            -gt 0.4

        """


