# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule pb_chain_one:
    """
    Run one MCMC tree-searching chain using Phylobayes.
    """
    input:
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    output:
        topology_file =\
        'results/pb_chains/{seed}/{fasta_name}_chain_1.treelist',
        a = 'results/pb_chains/{seed}/{fasta_name}_chain_1.trace',
        b = 'results/pb_chains/{seed}/{fasta_name}_chain_1.run',
        c = 'results/pb_chains/{seed}/{fasta_name}_chain_1.param',
        d = 'results/pb_chains/{seed}/{fasta_name}_chain_1.monitor',
        e = 'results/pb_chains/{seed}/{fasta_name}_chain_1.chain'

    conda:
        '../envs/phylobayes_mpi.yaml'

    shell:
        """
        mpirun -n 16 pb_mpi -d {input.phylip_file} \
                           -x 1 30000 \
                           -catfix C20 -gtr \
                           $(echo {output.topology_file} | cut -f 1 -d '.')
        """


