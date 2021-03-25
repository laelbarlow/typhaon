
# Typhaon: A snakemake workflow for phylogentic analysis of protein families

[![DOI](https://zenodo.org/badge/304196232.svg)](https://zenodo.org/badge/latestdoi/304196232)

## Objective

Perform phylogenetic analysis of one or more sets of predicted peptide
sequences for homologous genes using both Maximum Likelihood (ML) and Bayesian
Inference (BI) methods, and generate a phylograms in PDF format with a
combination of branch ML and BI support values. Focus on relationships among
clades of orthologues.


## Rationale

Phylogenetic analysis of single-gene families involves numerous steps (see
workflow diagram below), implying that numerous commands must be entered or
jobs submitted to a cluster (or webservice) for each set of sequences analyzed.
In the absence of major sequence alignment errors, most if not all standard
phylogetic analysis steps for a typical protein-coding gene family are quite
routine and can therefore be programmed. This also brings the benefit of
greater reproducibility. Available software fills this need to a large extent.
For example, the [ete-build tool in the ETE
toolkit](http://etetoolkit.org/cookbook/) allows phylogenetic analysis workflow
to be run from command line, and the [NGPhylogeny.fr
webservice](https://ngphylogeny.fr/) provides a convenient graphical interface
with one-click automated workflows. Such alternatives may be sufficient for
many projects. However, these may not be readily applicable to all projects. In
particular, some projects investigating evolution of large gene superfamilies
over long spans of time may benefit from a focus on filtering sequences prior
to alignment as well as application of Bayesian Inferrence methods for
phylogenetic analysis. This workflow provides these additional
features. Typhaon is also highly reproducible, adaptable, and portable due to
use of the [Snakemake workflow
manager](https://snakemake.readthedocs.io/en/stable/).


## Software requirements

- Linux Sun Grid Engine (SGE) computing cluster. This has not yet been tested on
  other cluster types. Only partial functionality is available if installed on
  a Linux or MacOS personal computer. 
- Python3 and the [Conda package and environment
  manager](https://docs.conda.io/en/latest/) (Conda is not available on all
  clusters).


## Overview of programmed workflow steps

<p align="center">
<img src="images/workflow_diagram.png" width="800">
</p>


## Procedure 

- Clone the code repository from github to your computer by running the
  following shell command in your terminal:
  ```
  git clone https://github.com/laelbarlow/typhaon.git
  ```

- Change directories into the cloned repository:
  ```
  cd typhaon
  ```

- Install typhaon (set up snakemake environment and profile for submitting jobs
  via your cluster's job scheduler), and run a test job.
  ```
  make install
  make dry_run
  ```

- Prepare input FASTA files in the 'resources' directory. All input sequence files
  for phylogenetic analysis must be in FASTA format and file name must end with
      the extension '.faa'.  Sets of one or more FASTA files must be assembled
      into directories with names ending with '_FASTA'. Directory and file
      names must not contain space characters. For example, below is what input
      directories in the resources directory might look like. Sequences from
      files within each directory will be combined and aligned for analysis,
      but sequences from different directories will not be combined. Also, if a
      file contains "ESSENTIAL" in the filename, then it will not be filtered
      using CD-HIT (the "cdhit_subsets" rule), and if a .afaa (FASTA alignment)
      file is present with "GUIDE" in the filename, then this alignment will be
      used to guide alignment of sequences in the .faa files in that directory
      (the "mafft" rule).

- Optionally, prepare input Newick (phylogenetic tree topology) files in the
  'resources' directory. If present, these will be used as constraint trees for
  topology tests using [IQ-TREE](http://www.iqtree.org/doc/). These files must
  meet the following requirements:
    - Filename extensions must be '.tre'.
    - There must be at least four sequences (taxa) represented in each tree.
    - Each sequence (taxon) name in the trees must represent a different
      orthogroup in the relevant protein family.
    - Each of these reference sequences must end up in the final (filtered) set
      of sequences aligned for analysis (so include the corresponding sequences
      in one or more FASTA files marked as "ESSENTIAL"). 
    - Each tree must be in valid Newick format without quotation marks around
      taxon names.  For example, the contents of a constraint tree file could
      look something like this:
        ```
        (IDW__Homo_sapiens, IDX__Homo_sapiens, (IDY__Homo_sapiens, IDZ__Homo_sapiens));
        ```

- This is an example of how the input directory and files could look:
    ```
    typhaon
    └── resources
        ├── Protein_Family_A_FASTA
        │   ├── Orthogroup_A_GUIDE.afaa
        │   ├── Orthogroup_A1.faa
        │   ├── Orthogroup_A2_ESSENTIAL.faa
        │   ├── Orthogroup_A3.faa
        │   ├── Orthogroup_A4.faa
        │   └── Protein_Family_A_RefSeqs_ESSENTIAL.faa
        └── Protein_Family_B_FASTA
            ├── Constraint_tree_1.tre
            ├── Constraint_tree_2.tre
            ├── Orthogroup_B1_RefSeq_ESSENTIAL.faa
            ├── Orthogroup_B1.faa
            ├── Orthogroup_B2_ESSENTIAL.faa
            ├── Orthogroup_B2_RefSeq_ESSENTIAL.faa
            ├── Orthogroup_B2.faa
            ├── Orthogroup_B3_RefSeq_ESSENTIAL.faa
            ├── Orthogroup_B3.faa
            ├── Orthogroup_B4_RefSeq_ESSENTIAL.faa
            └── Orthogroup_B4.faa
    ```

- To customize parameters for any of the various software packages used in this
  workflow, modify the `workflow/Snakefile` file. This is important, as default
  parameters are unlikely to be appropriate for your particular analysis. Pay
  particular attention to rules that use
  [CD-HIT](http://www.bioinformatics.org/cd-hit/cd-hit-user-guide.pdf) and
  random sampling to exclude sequences from the final alignment for
  phylogenetic analysis, as this is critical for obtaining a representative yet
  computationally manageable set of sequences.

- Remove redundant sequences with
  [CD-HIT](http://www.bioinformatics.org/cd-hit/cd-hit-user-guide.pdf), align
  sequences with [MAFFT](https://mafft.cbrc.jp/alignment/software/), trim
  alignment with [TrimAl](http://trimal.cgenomics.org/), and run a very quick
  phylogenetic analysis with [FastTree](http://microbesonline.org/fasttree/) to
  identify any obvious issues before proceeding with more time-intensive
  methods. Snakemake standard output will be written to the file `nohup.out`.
  ```
  make run_fasttree
  ```

- Observe the resulting sequence alignment(s) and tree topology in the results
  directory. It may be useful to run the previous step multiple times with
  different parameter settings (modify Snakefile) to optimize for your dataset.
  This iterative refinement may be feasible on your personal computer (Linux or
  MacOS) with less than ~200 sequences in the final alignment. 

- Run [IQ-TREE](http://www.iqtree.org/doc/) with ultrafast bootstrapping.
  ```
  make run_ultrafast_iqtree
  ```

- Run [IQ-TREE](http://www.iqtree.org/doc/) with standard non-parametric bootstrapping.
  ```
  make run_standard_iqtree
  ```

- Run topology tests with [IQ-TREE](http://www.iqtree.org/doc/).
  ```
  make run_au_test_iqtree
  ```

- Run full analysis including
  [Phylobayes](https://github.com/bayesiancook/pbmpi), and map support values
  from [IQ-TREE](http://www.iqtree.org/doc/) standard bootstrapping onto
  [Phylobayes](https://github.com/bayesiancook/pbmpi) topology. Output file(s)
  will be written to the `results/phylobayes_pdf_with_boots` directory.
  ```
  make run
  ```

- After running a full analysis including Phylobayes, check that phylobayes
  chains 1 and 2 reached convergence (refer to the [Phylobayes MPI
  manual](https://github.com/bayesiancook/pbmpi)).

- Archive a completed analysis for later reproduction.
  ```
  make archive
  ```

## Caveats

- This workflow depends heavily on the assumptions you make when constructing
  the set of input FASTA files. In particular, this workflow assumes that all
  (or almost all) of the sequences within each of the input FASTA files are
  orthologous. So, you need a considerable amount of prior information based on
  exploratory analyses allowing you to make informed judgments about what
  sequences are likely to be orthologous before running this workflow.
- A significant amount of coding (Python and Linux shell scripting) would be
  required to adapt and customize this workflow to a specific analysis project. 

## License

MIT License

Copyright (c) 2020 Lael D. Barlow

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


