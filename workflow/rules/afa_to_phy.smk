# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule afa_to_phy:
    """
    Convert aligned FASTA files to PHYLIP format.

    Necessary for Phylobayes.

    """
    input:
        script = 'workflow/scripts/afa_to_phy.py',
        trimmed_fasta_coded_file = 'results/trimal/{seed}/{fasta_name}.afaa'

    output:
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    conda:
        'envs/afa_to_phy.yaml'

    shell:
        """
        python3 {input.script} {input.trimmed_fasta_coded_file} {output.phylip_file}
        """


