
# Protein Family Phylogenetics Workflow


## Objectives

As a starting point for further investigation, obtain phylogenetic analysis
results for one or more sets of predicted peptide sequences for homologous
genes (that is, genes that all encode at least one shared homologous domain),
including summary of topology and branch supports in a figure.

## Rationale

- In the absence of major sequence alignment errors, all standard phylogetic
  analysis steps for a typical protein-coding gene family are quite predictable
  and can therefore be automated.
- Performing phylogenetic analysis programmatically, especially using the
  Snakemake workflow manager, helps make analyses reproducible.

## Assumptions regarding input sequences

- All input sequences are in FASTA format with headers formatted with species
  name followed by '\_\_' followed by sequence ID.
- All input sequence file names end with the extension '.faa'.
- All sequences within sets input for alignment share homology, at least in
  some significant subsequence. 

## Software requirements

- Linux or MacOS operating system. 
- Python3 and the Conda package manager (see
  [Anaconda](https://www.anaconda.com/products/individual) if you don't already
  have this on your personal computer).
- Pre-installed software (not installed via Conda):
    - Phylobayes.

## Overview of programmed workflow steps

<p align="center">
<img src="images/workflow_diagram.png" width="800">
</p>


## Procedure 

- Clone the code repository from github to your computer by running the
  following command in your terminal:
  ```
  git clone ...
  ```

- Check that the Conda package manager is installed:
  ```
  conda --version
  ```

- To use the [Snakemake workflow
  manager](https://snakemake.readthedocs.io/en/stable/), activate a Conda
  environment with snakemake installed (see [Snakemake
  documentation](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
  for procedure).

- Run a very quick phylogenetic analysis to identify any obvious issues before
  proceeding with more time-intensive methods.

  ```
  snakemake super_quick_tree --cores 1  ...
  ```

- Observe the resulting sequence alignment(s) and tree topology...

- Run a quick phylogenetic analysis to identify any obvious issues before
  proceeding with more time-intensive methods.
  ```
  snakemake quick_tree --cores 1  ...
  ```

- Run a full phylogenetic analysis.
  ```
  snakemake  --cores 1  ...
  ```


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







