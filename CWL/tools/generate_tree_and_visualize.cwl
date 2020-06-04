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
  - /src/generate_tree_and_visualize.R
arguments:
  - valueFrom: |
    ${
      if ( inputs.color_by_group ){
        return("TRUE")
      }
      else {
        return("FALSE")
      }
    }
    position: 11

inputs:
  dist_rds:
    type: File
    inputBinding:
      position: 10
  color_by_group:
    type: boolean

outputs:
  tree_plot:
    type: File
    outputBinding:
      glob: "*.png"
    