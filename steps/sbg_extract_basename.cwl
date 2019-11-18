$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    return inputs.in_file.nameroot + \" > out_name.txt\";\n}"
baseCommand:
- echo
class: CommandLineTool
cwlVersion: v1.0
doc: This tool is extracting basename root from a single file provided to the **Input
  file** port. This is performed using nameroot File property built into Common Workflow
  Language.
id: uros_sipetic/gatk-4-1-0-0-demo/sbg-extract-basename/1
inputs:
- doc: File of any type.
  id: in_file
  label: Input file
  type: File?
label: SBG Extract Nameroot
outputs:
- doc: Name generated with this app.
  id: out_name
  label: Output name
  outputBinding:
    glob: out_name.txt
    loadContents: true
    outputEval: "${\n\treturn self[0].contents.replace(/(\\r\\n|\\n|\\r)/gm, \"\"\
      );\n}"
  type: string?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 1000
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/nikola_jovanovic/alpine:1
- class: InlineJavascriptRequirement
sbg:appVersion:
- v1.0
sbg:content_hash: a8ef1bf3f7e18a01bf36acc0ffbdfc977e17d1c916c1fda26063ece28c74c08d0
sbg:contributors:
- veliborka_josipovic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/sbg-extract-basename/5
sbg:createdBy: veliborka_josipovic
sbg:createdOn: 1554494620
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/sbg-extract-basename/1
sbg:image_url: null
sbg:latestRevision: 1
sbg:modifiedBy: veliborka_josipovic
sbg:modifiedOn: 1559741931
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/sbg-extract-basename/5
sbg:revisionsInfo:
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554494620
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/sbg-extract-basename/4
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1559741931
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/sbg-extract-basename/5
sbg:sbgMaintained: false
sbg:toolAuthor: nemanja.vucic
sbg:toolkit: SBGTools
sbg:toolkitVersion: v1.0
sbg:validationErrors: []
