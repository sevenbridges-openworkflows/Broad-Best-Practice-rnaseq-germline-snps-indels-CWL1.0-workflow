$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: /opt/gatk
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) \n    {\n        return \"--java-options\"\
    ;\n    }\n    else\n    {\n        return '';\n    }\n}"
- position: 3
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    else\n    {\n        return '';\n    }\n}"
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: RevertSam
- position: 5
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (!inputs.output_map)\n    {\n        var in_alignments =\
    \ inputs.in_alignments;\n        var output_ext = inputs.output_file_format ?\
    \ inputs.output_file_format : inputs.in_alignments.path.split('.').pop();\n  \
    \      var output_prefix = '';\n        if (inputs.output_prefix)\n        {\n\
    \            output_prefix = inputs.output_prefix;\n        }\n        else \n\
    \        {\n            if (in_alignments.metadata && in_alignments.metadata.sample_id)\n\
    \            {\n                output_prefix = in_alignments.metadata.sample_id;\n\
    \            }\n            else \n            {\n                output_prefix\
    \ = in_alignments.path.split('/').pop().split('.')[0];\n            }\n      \
    \  }\n        \n        if (inputs.output_by_readgroup)\n            return \"\
    --OUTPUT_BY_READGROUP --OUTPUT \" + output_prefix;\n        else\n           \
    \ return \"--OUTPUT \" + output_prefix + \".reverted.\" + output_ext;\n    }\n\
    \    else\n    {\n        var output_map = inputs.output_map.path;\n        return\
    \ \"--OUTPUT_BY_READGROUP --OUTPUT_MAP \" + output_map;\n    }\n        \n}"
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.output_by_readgroup)\n    {\n        var in_alignments\
    \ = inputs.in_alignments;\n        var output_prefix = '';\n        if (inputs.output_prefix)\n\
    \        {\n            output_prefix = inputs.output_prefix;\n        }\n   \
    \     else \n        {\n            if (in_alignments.metadata && in_alignments.metadata.sample_id)\n\
    \            {\n                output_prefix = in_alignments.metadata.sample_id;\n\
    \            }\n            else \n            {\n                output_prefix\
    \ = in_alignments.path.split('/').pop().split('.')[0];\n            }\n      \
    \  }\n        return \"mkdir \" + output_prefix + \" && \";\n    }\n    else\n\
    \    {\n        return '';\n    }\n        \n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK RevertSam** tool reverts SAM, BAM or CRAM files to the previous state.\
  \ \n\nThis tool removes or restores certain properties of the SAM records, including\
  \ alignment information, which can be used to produce an unmapped BAM (uBAM) from\
  \ a previously aligned BAM. It is also capable of restoring the original quality\
  \ scores of the BAM file that has already undergone base quality score recalibration\
  \ (BQSR) if the original qualities were retained during the calibration (OQ tag)\
  \ [1].\n\n*A list of **all inputs and parameters** with corresponding descriptions\
  \ can be found at the bottom of the page.*\n\n###Common Use Cases\n\n* The **GATK\
  \ RevertSam** tool requires a BAM/SAM/CRAM file on its **Input BAM/SAM/CRAM file**\
  \ (`--INPUT`) input. The tool generates a single BAM file on its output by default,\
  \ or SAM or CRAM if the input file is SAM or CRAM, respectively.\n\n* The **GATK\
  \ RevertSam** tool supports an optional parameter  **Output by readgroup** (`--OUTPUT_BY_READGROUP`)\
  \ which, when true, outputs each read group in a separate file. The output file\
  \ format will be equal to the input file format. This behaviour can be overridden\
  \ with the **Output by readgroup file format** (`--OUTPUT_BY_READGROUP_FILE_FORMAT`)\
  \ argument. Outputting by read group can optionally be done by adding an output\
  \ map on the **Output map** (`--OUTPUT_MAP`) input. The output map is a tab separated\
  \ file which provides file mapping with two columns, READ_GROUP_ID and OUTPUT.\n\
  \n* Usage Example - Output to a single file:\n```\n gatk RevertSam \\\\\n      --INPUT\
  \ input.bam \\\\\n      --OUTPUT reverted.bam\n\n```\n\n* Usage Example - Output\
  \ by read group into multiple files with sample map:\n\n```\n\n gatk RevertSam \\\
  \\\n      --INPUT input.bam \\\\\n      --OUTPUT_BY_READGROUP true\\\\\n      --OUTPUT_MAP\
  \ reverted_bam_paths.tsv\n\n```\n\n* Usage Example - Output by read group with no\
  \ output map:\n\n```\n\ngatk RevertSam \\\\\n      --INPUT input.bam \\\\\n    \
  \  --OUTPUT_BY_READGROUP true \\\\\n      --OUTPUT /write/reverted/read/group/bams/in/this/dir\n\
  \n```\n\n###Changes Introduced by Seven Bridges\n\n* All output files will be prefixed\
  \ using the **Output prefix** parameter. In case **Output prefix** is not provided,\
  \ output prefix will be the same as the Sample ID metadata from the **Input SAM/BAM/CRAM\
  \ file**, if the Sample ID metadata exists. Otherwise, output prefix will be inferred\
  \ from the **Input SAM/BAM/CRAM file** filename. This way, having identical names\
  \ of the output files between runs is avoided. Moreover,  **reverted** will be added\
  \ before the extension of the output file name. \n\n* The user has a possibility\
  \ to specify the output file format using the **Output file format** option. Otherwise,\
  \ the output file format will be the same as the format of the input file.\n\n###Common\
  \ Issues and Important Notes\n\n* Note: If the program fails due to a SAM validation\
  \ error, consider setting the **Validation stringency** (`--VALIDATION_STRINGENCY`)\
  \ option to LENIENT or SILENT if the failures are expected to be obviated by the\
  \ reversion process (e.g. invalid alignment information will be obviated when the\
  \ **Remove alignment information** (`--REMOVE_ALIGNMENT_INFORMATION`) option is\
  \ used).\n\n###Performance Benchmarking\n\nBelow is a table describing runtimes\
  \ and task costs of **GATK RevertSam** for a couple of different samples, executed\
  \ on the AWS cloud instances:\n\n| Experiment type |  Input size | Paired-end |\
  \ # of reads | Read length | Duration |  Cost | Instance (AWS) | \n|:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|\n\
  |     RNA-Seq     |  1.3 GB |     Yes    |     16M     |     101     |   4min  \
  \ | ~0.03$ | c4.2xlarge (8 CPUs) | \n|     RNA-Seq     |  3.9 GB |     Yes    |\
  \     50M     |     101     |   6min   | ~0.04$ | c4.2xlarge (8 CPUs) | \n|    \
  \ RNA-Seq     | 6.5 GB |     Yes    |     82M    |     101     |  9min  | ~0.06$\
  \ | c4.2xlarge (8 CPUs) | \n|     RNA-Seq     | 12.9 GB |     Yes    |     164M\
  \    |     101     |  16min  | ~0.11$ | c4.2xlarge (8 CPUs) |\n\n*Cost can be significantly\
  \ reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n###References\n\n[1] [GATK RevertSam](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_SamToFastq.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-revertsam-4-1-0-0/8
inputs:
- doc: When removing alignment information, the set of optional tags to remove. This
    argument may be specified 0 or more times.
  id: attribute_to_clear
  inputBinding:
    position: 5
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--ATTRIBUTE_TO_CLEAR',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    else\n   \
      \ {\n        return '';\n    }\n    \n}"
  label: Attribute to clear
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '[NM, UQ, PG, MD, MQ, SA, MC, AS]'
  type: string[]?
- doc: Compression level for all compressed files created (e.g. BAM and VCF).
  id: compression_level
  inputBinding:
    position: 5
    prefix: --COMPRESSION_LEVEL
    shellQuote: false
  label: Compression level
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '2'
  type: int?
- doc: The input SAM/BAM/CRAM file to revert the state of.
  id: in_alignments
  inputBinding:
    position: 5
    prefix: --INPUT
    shellQuote: false
  label: Input SAM/BAM/CRAM file
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: SAM, BAM, CRAM
  type: File
- doc: If SANITIZE=true keep the first record when we find more than one record with
    the same name for R1/R2/unpaired reads respectively. For paired end reads, keeps
    only the first R1 and R2 found respectively, and discards all unpaired reads.
    Duplicates do not refer to the duplicate flag in the FLAG field, but instead reads
    with the same name.
  id: keep_first_duplicate
  inputBinding:
    position: 5
    prefix: --KEEP_FIRST_DUPLICATE
    shellQuote: false
  label: Keep first duplicate
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: The library name to use in the reverted output file. This will override the
    existing library name alias in the file and is used only if all the read groups
    in the input file have the same library name.
  id: library_name
  inputBinding:
    position: 5
    prefix: --LIBRARY_NAME
    shellQuote: false
  label: Library name
  sbg:altPrefix: -LIB
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: If SANITIZE=true and higher than MAX_DISCARD_FRACTION, reads are discarded
    due to sanitization then the program will exit with an Exception instead of exiting
    cleanly. Output BAM will still be valid.
  id: max_discard_fraction
  inputBinding:
    position: 5
    prefix: --MAX_DISCARD_FRACTION
    shellQuote: false
  label: Max discard fraction
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0.01'
  type: float?
- doc: When writing files that need to be sorted, this will specify the number of
    records stored in RAM before spilling to disk. Increasing this number reduces
    the number of file handles needed to sort the file, and increases the amount of
    RAM needed.
  id: max_records_in_ram
  inputBinding:
    position: 5
    prefix: --MAX_RECORDS_IN_RAM
    shellQuote: false
  label: Max records in RAM
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '500000'
  type: int?
- doc: This input allows a user to set the desired overhead memory when running a
    tool or adding it to a workflow. This amount will be added to the Memory per job
    in the Memory requirements section but it will not be added to the -Xmx parameter
    leaving some memory not occupied which can be used as stack memory (-Xmx parameter
    defines heap memory). This input should be defined in MB (for both the platform
    part and the -Xmx part if Java tool is wrapped).
  id: memory_overhead_per_job
  label: Memory overhead per job
  sbg:category: Platform Options
  type: int?
- doc: This input allows a user to set the desired memory requirement when running
    a tool or adding it to a workflow. This value should be propagated to the -Xmx
    parameter too.This input should be defined in MB (for both the platform part and
    the -Xmx part if Java tool is wrapped).
  id: memory_per_job
  label: Memory per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: 2048 MB
  type: int?
- doc: When true, outputs each read group in a separate file.
  id: output_by_readgroup
  label: Output by readgroup
  sbg:altPrefix: -OBR
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: 'When using OUTPUT_BY_READGROUP, the output file format can be set to a certain
    format. Possible values: { sam (generate SAM files.) bam (generate BAM files.)
    cram (generate CRAM files.) dynamic (generate files based on the extention of
    input.) }.'
  id: output_by_readgroup_file_format
  inputBinding:
    position: 5
    prefix: --OUTPUT_BY_READGROUP_FILE_FORMAT
    shellQuote: false
  label: Output by readgroup file format
  sbg:altPrefix: -OBRFF
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: dynamic
  type:
  - 'null'
  - name: output_by_readgroup_file_format
    symbols:
    - sam
    - bam
    - cram
    - dynamic
    type: enum
- doc: Tab separated file with two columns, READ_GROUP_ID and OUTPUT, providing file
    mapping only used if OUTPUT_BY_READGROUP is true.
  id: output_map
  label: Output map
  sbg:altPrefix: -OM
  sbg:category: Optional Arguments
  sbg:fileTypes: TSV
  type: File?
- doc: Remove all alignment information from the file.
  id: remove_alignment_information
  inputBinding:
    position: 5
    prefix: --REMOVE_ALIGNMENT_INFORMATION
    shellQuote: false
  label: Remove alignment information
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type: boolean?
- doc: Remove duplicate read flags from all reads. Note that if this is false and
    REMOVE_ALIGNMENT_INFORMATION==true, the output may have the unusual but sometimes
    desirable trait of having unmapped reads that are marked as duplicates.
  id: remove_duplicate_information
  inputBinding:
    position: 5
    prefix: --REMOVE_DUPLICATE_INFORMATION
    shellQuote: false
  label: Remove duplicate information
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type: boolean?
- doc: True to restore original qualities from the OQ field to the QUAL field if available.
  id: restore_original_qualities
  inputBinding:
    position: 5
    prefix: --RESTORE_ORIGINAL_QUALITIES
    shellQuote: false
  label: Restore original qualities
  sbg:altPrefix: -OQ
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type: boolean?
- doc: The sample alias to use in the reverted output file. This will override the
    existing sample alias in the file and is used only if all the read groups in the
    input file have the same sample alias.
  id: sample_alias
  inputBinding:
    position: 5
    prefix: --SAMPLE_ALIAS
    shellQuote: false
  label: Sample alias
  sbg:altPrefix: -ALIAS
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: 'Warning: this option is potentially destructive. If enabled, will discard
    reads in order to produce a consistent output BAM. Reads discarded include (but
    are not limited to) paired reads with missing mates, duplicated records, records
    with mismatches in length of bases and qualities. This option can only be enabled
    if the output sort order is queryname and will always cause sorting to occur.'
  id: sanitize
  inputBinding:
    position: 5
    prefix: --SANITIZE
    shellQuote: false
  label: Sanitize
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: The sort order to create the reverted output file with.
  id: sort_order
  inputBinding:
    position: 5
    prefix: --SORT_ORDER
    shellQuote: false
  label: Sort order
  sbg:altPrefix: -SO
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: queryname
  type:
  - 'null'
  - name: sort_order
    symbols:
    - unsorted
    - queryname
    - coordinate
    - duplicate
    - unknown
    type: enum
- doc: Validation stringency for all SAM files read by this program. Setting stringency
    to SILENT can improve performance when processing a BAM file in which variable-length
    data (read, qualities, tags) do not otherwise need to be decoded.
  id: validation_stringency
  inputBinding:
    position: 5
    prefix: --VALIDATION_STRINGENCY
    shellQuote: false
  label: Validation stringency
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: STRICT
  type:
  - 'null'
  - name: validation_stringency
    symbols:
    - STRICT
    - LENIENT
    - SILENT
    type: enum
- doc: Output file format.
  id: output_file_format
  label: Output file format
  sbg:category: Optional Arguments
  type:
  - 'null'
  - name: output_file_format
    symbols:
    - sam
    - bam
    - cram
    type: enum
- doc: Output file name prefix.
  id: output_prefix
  label: Output prefix
  sbg:category: Optional Arguments
  type: string?
- doc: This input allows a user to set the desired CPU requirement when running a
    tool or adding it to a workflow.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK RevertSam
outputs:
- doc: Output reverted SAM/BAM/CRAM file(s).
  id: out_alignments
  label: Output reverted SAM/BAM/CRAM file(s)
  outputBinding:
    glob: "${\n    if (inputs.output_by_readgroup)\n    {\n        var in_alignments\
      \ = inputs.in_alignments;\n        var output_prefix = '';\n        if (inputs.output_prefix)\n\
      \        {\n            output_prefix = inputs.output_prefix;\n        }\n \
      \       else \n        {\n            if (in_alignments.metadata && in_alignments.metadata.sample_id)\n\
      \            {\n                output_prefix = in_alignments.metadata.sample_id;\n\
      \            }\n            else \n            {\n                output_prefix\
      \ = in_alignments.path.split('/').pop().split('.')[0];\n            }\n    \
      \    }\n        if (inputs.output_map)\n        {\n            return '*am';\n\
      \        }\n        else\n        {\n            return output_prefix + \"/*\"\
      ;\n        }\n            \n    }\n    else\n    {\n        return \"*reverted*\"\
      ;\n    }\n}"
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM, SAM
  type: File[]?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 1\n}"
  ramMin: "${\n    var memory = 4096;\n    if (inputs.memory_per_job) \n    {\n  \
    \      memory = inputs.memory_per_job;\n    }\n    if (inputs.memory_overhead_per_job)\n\
    \    {\n        memory += inputs.memory_overhead_per_job;\n    }\n    return memory;\n\
    }"
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/stefan_stojanovic/gatk:4.1.0.0
- class: InitialWorkDirRequirement
  listing: []
- class: InlineJavascriptRequirement
  expressionLib:
  - "var updateMetadata = function(file, key, value) {\n    file['metadata'][key]\
    \ = value;\n    return file;\n};\n\n\nvar setMetadata = function(file, metadata)\
    \ {\n    if (!('metadata' in file))\n        file['metadata'] = metadata;\n  \
    \  else {\n        for (var key in metadata) {\n            file['metadata'][key]\
    \ = metadata[key];\n        }\n    }\n    return file\n};\n\nvar inheritMetadata\
    \ = function(o1, o2) {\n    var commonMetadata = {};\n    if (!Array.isArray(o2))\
    \ {\n        o2 = [o2]\n    }\n    for (var i = 0; i < o2.length; i++) {\n   \
    \     var example = o2[i]['metadata'];\n        for (var key in example) {\n \
    \           if (i == 0)\n                commonMetadata[key] = example[key];\n\
    \            else {\n                if (!(commonMetadata[key] == example[key]))\
    \ {\n                    delete commonMetadata[key]\n                }\n     \
    \       }\n        }\n    }\n    if (!Array.isArray(o1)) {\n        o1 = setMetadata(o1,\
    \ commonMetadata)\n    } else {\n        for (var i = 0; i < o1.length; i++) {\n\
    \            o1[i] = setMetadata(o1[i], commonMetadata)\n        }\n    }\n  \
    \  return o1;\n};\n\nvar toArray = function(file) {\n    return [].concat(file);\n\
    };\n\nvar groupBy = function(files, key) {\n    var groupedFiles = [];\n    var\
    \ tempDict = {};\n    for (var i = 0; i < files.length; i++) {\n        var value\
    \ = files[i]['metadata'][key];\n        if (value in tempDict)\n            tempDict[value].push(files[i]);\n\
    \        else tempDict[value] = [files[i]];\n    }\n    for (var key in tempDict)\
    \ {\n        groupedFiles.push(tempDict[key]);\n    }\n    return groupedFiles;\n\
    };\n\nvar orderBy = function(files, key, order) {\n    var compareFunction = function(a,\
    \ b) {\n        if (a['metadata'][key].constructor === Number) {\n           \
    \ return a['metadata'][key] - b['metadata'][key];\n        } else {\n        \
    \    var nameA = a['metadata'][key].toUpperCase();\n            var nameB = b['metadata'][key].toUpperCase();\n\
    \            if (nameA < nameB) {\n                return -1;\n            }\n\
    \            if (nameA > nameB) {\n                return 1;\n            }\n\
    \            return 0;\n        }\n    };\n\n    files = files.sort(compareFunction);\n\
    \    if (order == undefined || order == \"asc\")\n        return files;\n    else\n\
    \        return files.reverse();\n};"
  - "\nvar setMetadata = function(file, metadata) {\n    if (!('metadata' in file))\n\
    \        file['metadata'] = metadata;\n    else {\n        for (var key in metadata)\
    \ {\n            file['metadata'][key] = metadata[key];\n        }\n    }\n  \
    \  return file\n};\n\nvar inheritMetadata = function(o1, o2) {\n    var commonMetadata\
    \ = {};\n    if (!Array.isArray(o2)) {\n        o2 = [o2]\n    }\n    for (var\
    \ i = 0; i < o2.length; i++) {\n        var example = o2[i]['metadata'];\n   \
    \     for (var key in example) {\n            if (i == 0)\n                commonMetadata[key]\
    \ = example[key];\n            else {\n                if (!(commonMetadata[key]\
    \ == example[key])) {\n                    delete commonMetadata[key]\n      \
    \          }\n            }\n        }\n    }\n    if (!Array.isArray(o1)) {\n\
    \        o1 = setMetadata(o1, commonMetadata)\n    } else {\n        for (var\
    \ i = 0; i < o1.length; i++) {\n            o1[i] = setMetadata(o1[i], commonMetadata)\n\
    \        }\n    }\n    return o1;\n};"
sbg:appVersion:
- v1.0
sbg:categories:
- Utilities
- BAM Processing
sbg:content_hash: a49c638f1ba71e9b2aba87e9cfce60275b41027bb463214a36fc53afbc98710f3
sbg:contributors:
- uros_sipetic
- veliborka_josipovic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/28
sbg:createdBy: uros_sipetic
sbg:createdOn: 1552659126
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-revertsam-4-1-0-0/8
sbg:image_url: null
sbg:latestRevision: 8
sbg:license: Open source BSD (3-clause) license
sbg:links:
- id: https://software.broadinstitute.org/gatk/
  label: Homepage
- id: https://github.com/broadinstitute/gatk/
  label: Source Code
- id: https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
  label: Download
- id: https://www.ncbi.nlm.nih.gov/pubmed?term=20644199
  label: Publications
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/picard_sam_RevertSam
  label: Documentation
sbg:modifiedBy: veliborka_josipovic
sbg:modifiedOn: 1559564779
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 8
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/28
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552659126
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/14
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552659760
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/15
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492426
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/18
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492542
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/19
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492643
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/20
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554493226
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/21
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554720836
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/23
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554999285
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/24
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1559564779
  sbg:revision: 8
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-revertsam-4-1-0-0/28
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
