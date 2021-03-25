# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule fasttree:
    """
    Run FastTree on a trimmed sequence alignment
    (http://microbesonline.org/fasttree/).
    """
    input:
        trimmed_fasta_file = 'results/trimal/{seed}/{fasta_name}.afaa'

    output:
        newick_tree_file = 'results/fasttree/{seed}/{fasta_name}.tre'

    conda:
        'envs/fasttree.yaml'

    shell:
        """
        fasttree -lg -sprlength 50 -mlacc 3 -slownni -slow \
        -out {output.newick_tree_file} \
        {input.trimmed_fasta_file}
        """


