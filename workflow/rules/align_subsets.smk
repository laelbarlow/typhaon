# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule align_subsets:
    """
    Align a FASTA file using MAFFT.

    Note: The --threadit 0 option ensures that the iterative refinement step
    uses a single thread, while other steps can use multiple threads (Kazutaka
    Katoh, personal communication).

    See documentation here for choosing paramaters:
        https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html
        https://mafft.cbrc.jp/alignment/software/manual/manual.html
    """
    input:
        nonredun_fasta_dir =\
        'results/cdhit_subsets/{fasta_name}_FASTA'

    output:
        aligned_fasta_dir =\
        directory('results/align_subsets/{fasta_name}_FASTA')

    conda:
        '../envs/mafft.yaml'

    shell:
        """
        mkdir -p {output.aligned_fasta_dir} && \
        for X in {input.nonredun_fasta_dir}/*.faa
            do 
            # Accuracy:
            mafft --maxiterate 1000 --localpair --thread -1 --threadit 0 $X > \
                $(echo {output.aligned_fasta_dir}/$( basename $X ) | cut -f 1 -d '.')'.afaa'
            # Speed:
            #mafft --retree 1 --maxiterate 0 --thread -1 --threadit 0 $X > \
            #    $(echo {output.aligned_fasta_dir}/$( basename $X ) | cut -f 1 -d '.')'.afaa'
            done
        """


