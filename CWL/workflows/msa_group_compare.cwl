cwlVersion: v1.0
class: Workflow

inputs:
  fasta_1:
    type: File
  fasta_2:
    type: File
  group_name_1:
    type: string
    default: "group1"
  group_name_2:
    type: string
    default: "group2"
 
steps:
  calc_msa_and_dist_mat:
      # doc: samtools sort - sorting of filtered bam file by read name
      run: "../tools/calc_msa_and_dist_mat.cwl"
      in:
        fasta_1: fasta_1
        fasta_2: fasta_2
        group_name_1: group_name_1
        group_name_2: group_name_2
      out:
        - dist_tsv
        - dist_rds
       
  generate_tree_and_visualize:
    # doc: bedtools bamtobed
    run: "../tools/generate_tree_and_visualize.cwl"
    in:
      dist_rds:
        source: calc_msa_and_dist_mat/dist_rds
    out:
      - tree_plot

outputs:
  dist_tsv:
    type: File
    outputSource: calc_msa_and_dist_mat/dist_tsv
  tree_plot:
    type: File
    outputSource: generate_tree_and_visualize/tree_plot