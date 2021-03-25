# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule trace_pb_chains:
    """
    Generate a consensus tree with posterior probabilities from two Phylobayes
    chains (and generate files with measures of convergence).
    """
    input:
        topology_file_1 =\
        'results/pb_chains/{seed}/{fasta_name}_chain_1.treelist',
        topology_file_2 =\
        'results/pb_chains/{seed}/{fasta_name}_chain_2.treelist'

    output:
        consensus_tree =\
        'results/trace_pb_chains/{seed}/{fasta_name}_bpcomp_output.con.tre'

    conda:
        '../envs/phylobayes_mpi.yaml'

    shell:
        """
        bpcomp \
            -x 1000 10 \
            -c 0.0 \
            -o $(echo {output.consensus_tree} | cut -f 1 -d '.') \
            $(echo {input.topology_file_1} | cut -f 1 -d '.') \
            $(echo {input.topology_file_2} | cut -f 1 -d '.')
        """


