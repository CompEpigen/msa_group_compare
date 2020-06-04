cwlVersion: v1.0
class: CommandLineTool

hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000
    tmpdirMin: 400
  DockerRequirement:
    dockerPull: kerstenbreuer/msa_group_compare:2
  
baseCommand:
  - Rscript 
  - --vanilla
  - /src/calc_msa_and_dist_mat.R

inputs:
  fasta_1:
    type: File
    inputBinding:
      position: 10
  fasta_2:
    type: File
    inputBinding:
      position: 11
  group_name_1:
    type: string
    inputBinding: 
      position: 12
  group_name_2:
    type: string
    inputBinding: 
      position: 13
  msa_method:
    type: 
      type: enum
      symbols:
        - ClustalW
        - ClustalOmega
        - Muscle
    inputBinding: 
      position: 14
  seq_type:
    type: 
      type: enum
      symbols:
        - protein
        - dna
        - rna
    inputBinding: 
      position: 15
  homology_method:
    type: 
      type: enum
      symbols:
        - identity
        - similarity
    inputBinding: 
      position: 16

outputs:
  dist_tsv:
    type: File
    outputBinding:
      glob: "*.tsv"
  dist_rds:
    type: File
    outputBinding:
      glob: "*.RDS"
    