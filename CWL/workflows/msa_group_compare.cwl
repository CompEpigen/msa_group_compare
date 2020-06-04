cwlVersion: v1.0
class: Workflow
doc: |
  This workflow compares two groups of sequences by running two steps: \n
    1. a MSA aligment to calculate a distance matrix \n
    2. generate and plot a phylogenetic tree annotated by group labels \n
  \n
  For more information please see: \n
  https://w3id.org/cwl/view/git/5227e2c45be641c6675c0a24a8b1f72d712fac40/CWL/workflows/msa_group_compare.cwl

inputs:
  fasta_1:
    type: File
    doc: |
      Protein / DNA / RNA sequences of first group in fasta format.
  fasta_2:
    type: File
    doc: |
      Protein / DNA / RNA sequences of second group in fasta format.
  group_name_1:
    type: string
    default: "group1"
    doc: |
      Name of first group.
  group_name_2:
    type: string
    default: "group2"
    doc: |
      Name of second group.
  msa_method:
    type: 
      type: enum
      symbols:
        - ClustalW
        - ClustalOmega
        - Muscle
    default: "ClustalW"
    doc: |
      Which multiple sequence alignment algorithm to use. 
      One of "ClustalW", "ClustalOmega", or "Muscle". 
      For more information see: https://www.ebi.ac.uk/Tools/msa/
  seq_type:
    type: 
      type: enum
      symbols:
        - protein
        - dna
        - rna
    default: "protein"
    doc: |
      The type of sequence. One of "protein", "dna", or "rna".
  homology_method:
    type: 
      type: enum
      symbols:
        - identity
        - similarity
    default: "identity"
    doc: |
      Which distance measure to use. Either "similarity" or "identity".
  tree_color_by_group:
    type: boolean
    default: True
    doc: |
      Whether to color the phylogenetic tree by group.
 
steps:
  calc_msa_and_dist_mat:
      # doc: samtools sort - sorting of filtered bam file by read name
      run: "../tools/calc_msa_and_dist_mat.cwl"
      in:
        fasta_1: fasta_1
        fasta_2: fasta_2
        group_name_1: group_name_1
        group_name_2: group_name_2
        msa_method: msa_method
        seq_type: seq_type
        homology_method: homology_method
      out:
        - dist_tsv
        - dist_rds
       
  generate_tree_and_visualize:
    # doc: bedtools bamtobed
    run: "../tools/generate_tree_and_visualize.cwl"
    in:
      dist_rds:
        source: calc_msa_and_dist_mat/dist_rds
      tree_color_by_group: tree_color_by_group
    out:
      - tree_plot

outputs:
  dist_tsv:
    type: File
    outputSource: calc_msa_and_dist_mat/dist_tsv
  tree_plot:
    type: File
    outputSource: generate_tree_and_visualize/tree_plot