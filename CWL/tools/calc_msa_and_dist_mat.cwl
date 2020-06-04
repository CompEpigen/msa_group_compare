cwlVersion: v1.0
class: CommandLineTool

hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000
    tmpdirMin: 400
  DockerRequirement:
    dockerPull: kerstenbreuer/msa_group_compare:1
  
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

outputs:
  dist_tsv:
    type: File
    outputBinding:
      glob: "*.tsv"
  dist_rds:
    type: File
    outputBinding:
      glob: "*.RDS"
    