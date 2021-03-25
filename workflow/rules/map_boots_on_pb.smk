# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule map_boots_on_pb:
    """
    Map bootstrap support values from standard IQ-TREE bootstrap analysis to
    Phylobayes topology.
    """
    input:
        script = 'workflow/scripts/map_boots_on_pb.py',
        pb_newick =\
        'results/trace_pb_chains/{seed}/{fasta_name}_bpcomp_output.con.tre',
        iqtree_bootstrap_newick =\
        'results/iqtree_standard_newick/{seed}/{fasta_name}.boottrees'

    output:
        just_boots_newick =\
        'results/map_boots_on_pb/{seed}/{fasta_name}_boots_only.suptree',
        newick = 'results/map_boots_on_pb/{seed}/{fasta_name}.suptree'

    conda:
        '../envs/visualize_fasttree.yaml'

    shell:
        """
        python3 {input.script} \
                    {input.pb_newick} \
                    {input.iqtree_bootstrap_newick} \
                    {output.newick}
        """


