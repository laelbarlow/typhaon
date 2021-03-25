# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule mafft:
    """
    Align a FASTA file using MAFFT.

    Note: The --threadit 0 option ensures that the iterative refinement step
    uses a single thread, while other steps can use multiple threads (Kazutaka
    Katoh, personal communication).

    See documentation here for choosing paramaters:
        https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html
        https://mafft.cbrc.jp/alignment/software/manual/manual.html
        https://mafft.cbrc.jp/alignment/software/dash.html
    """
    input:
        script =\
        'workflow/scripts/remove_guide_alignment_seqs.py',
        fasta_dir = 'resources/{fasta_name}_FASTA',
        nonredun_fasta_file = 'results/cdhit_combined/{seed}/{fasta_name}.faa'

    output:
        aligned_fasta_file = 'results/mafft/{seed}/{fasta_name}.afaa'

    conda:
        'envs/mafft.yaml'

    shell:
        """
        guide_alignment="" && \
        for X in {input.fasta_dir}/*.afaa; do \
          if [[ "$X" == *"GUIDE"* ]]  
          then  
            guide_alignment=$X 
          fi 
        done && \
        echo $guide_alignment && \
        if [[ "$guide_alignment" == "" ]]  
        then 
          #mafft --maxiterate 1000 --localpair --thread -1 --threadit 0 {input.nonredun_fasta_file} > {output.aligned_fasta_file} 
          #mafft --thread -1 --threadit 0 --dash --originalseqonly {input.nonredun_fasta_file} > {output.aligned_fasta_file} 

          mafft --thread -1 --threadit 0 {input.nonredun_fasta_file} > {output.aligned_fasta_file} 
        else 
          mafft --maxiterate 1000 --localpair --thread -1 --threadit 0 --add {input.nonredun_fasta_file} $guide_alignment > {output.aligned_fasta_file} && \
          python3 {input.script} {output.aligned_fasta_file} $guide_alignment
        fi
        """


