# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule iqtree_au_test:
    """
    Run an Approximately Unbiased (AU) topology test using IQ-TREE.
    """
    input:
        #model_text_file = 'results/modelfinder/{seed}/{fasta_name}.txt'
        concat_newick = 'results/concat_ml_trees/{seed}/{fasta_name}.tre',
        phylip_file = 'results/afa_to_phy/{seed}/{fasta_name}.phy'

    output:
        test_result = 'results/iqtree_au_test/{seed}/{fasta_name}.iqtree',
        o2 = 'results/iqtree_au_test/{seed}/{fasta_name}.ckp.gz',
        o3 = 'results/iqtree_au_test/{seed}/{fasta_name}.log',
        o4 = 'results/iqtree_au_test/{seed}/{fasta_name}.trees',
        o5 = 'results/iqtree_au_test/{seed}/{fasta_name}.treefile'

    params:
        iqtree_model = config['iqtree_model']

    conda:
        '../envs/iqtree_ultrafast.yaml'

    shell:
        """
        #    -m $(cat _input.model_text_file_) 
        iqtree \
            -s {input.phylip_file} \
            -m {params.iqtree_model} \
            -z {input.concat_newick} \
            -n 0 \
            -zb 10000 \
            -au \
            -pre $(echo {output.test_result} | cut -f 1 -d '.') \
        """


