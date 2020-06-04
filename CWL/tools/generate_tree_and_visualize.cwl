cwlVersion: v1.0
class: CommandLineTool
requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
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
  - /src/generate_tree_and_visualize.R

inputs:
  dist_rds:
    type: File
    inputBinding:
      position: 10

outputs:
  tree_plot:
    type: File
    outputBinding:
      glob: "*.png"
    