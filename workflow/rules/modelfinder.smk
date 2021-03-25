# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule modelfinder:
    """
    Find the best-fit model of amino acid sequence evolution using ModelFinder
    from the IQ-TREE package.
    """
    input:
        trimmed_fasta_file = 'results/trimal/{fasta_name}.afaa'

    output:
        model_file = 'results/modelfinder/{fasta_name}.iqtree'

    conda:
        '../envs/modelfinder.yaml'

    shell:
        """
        #      -madd C10,C20,C30,C40,C50,C60,LG4X,LG4M
        iqtree \
              -s {input.trimmed_fasta_file} \
              -pre $(echo {output.model_file} | cut -f 1 -d '.') \
              -nt AUTO \
              -m MF \
              -redo
        """


