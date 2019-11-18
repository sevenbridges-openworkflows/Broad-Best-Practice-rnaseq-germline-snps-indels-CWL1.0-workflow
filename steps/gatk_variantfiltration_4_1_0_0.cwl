$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: /opt/gatk
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job)\n    {\n        return \"--java-options\"\
    ;\n    }\n    else\n    {\n        return '';\n    }\n}\n    "
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    return '';\n}"
- position: 3
  shellQuote: false
  valueFrom: VariantFiltration
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var in_variants = inputs.in_variants;\n    var output_ext =\
    \ inputs.output_file_format ? inputs.output_file_format : \"vcf.gz\";\n    var\
    \ output_prefix = '';\n    if (inputs.output_prefix)\n    {\n        output_prefix\
    \ = inputs.output_prefix;\n    }\n    else \n    {\n        if (in_variants.metadata\
    \ && in_variants.metadata.sample_id)\n        {\n            output_prefix = in_variants.metadata.sample_id;\n\
    \        }\n        else \n        {\n            output_prefix = in_variants.path.split('/').pop().split('.')[0];\n\
    \        }\n    }\n    \n    return \"--output \" + output_prefix + \".variant_filtered.\"\
    \ + output_ext;\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK VariantFiltration** tool filters variant calls of the input VCF file\
  \ based on INFO and/or FORMAT annotations and outputs a filter VCF file. \n\nThis\
  \ tool is designed for hard-filtering variant calls based on certain criteria. Records\
  \ are hard-filtered by changing the value in the FILTER field to something other\
  \ than PASS. Filtered records will be preserved in the output unless their removal\
  \ is requested in the command line [1].\n\n*A list of **all inputs and parameters**\
  \ with corresponding descriptions can be found at the bottom of the page.*\n\n###Common\
  \ Use Cases\n\n* The **GATK VariantFiltration** tool requires the VCF file on its\
  \ **Input variants file** (`--variant`) input and a reference file on its **Reference**\
  \ (`--reference`) input. The tool generates a filtered VCF file on its **Output\
  \ filtered variants file** output.\n\n* Usage example:\n```\n   gatk VariantFiltration\
  \ \\\n   --reference reference.fasta \\\n   --variant input.vcf.gz \\\n   --output\
  \ output.vcf.gz \\\n   --filter-name \"my_filter1\" \\\n   --filter-expression \"\
  AB < 0.2\" \\\n   --filter-name \"my_filter2\" \\\n   --filter-expression \"MQ0\
  \ > 50\"\n\n```\n\n###Changes Introduced by Seven Bridges\n\n* All output files\
  \ will be prefixed using the **Output prefix** parameter. In case **Output prefix**\
  \ is not provided, output prefix will be the same as the Sample ID metadata from\
  \ **Input variants file**, if the Sample ID metadata exists. Otherwise, output prefix\
  \ will be inferred from the **Input variants** filename. This way, having identical\
  \ names of the output files between runs is avoided. Moreover,  **filtered** will\
  \ be added before the extension of the output file name. \n\n* The user has a possibility\
  \ to specify the output file format using the **Output file format** argument. Otherwise,\
  \ the output will be in the compressed VCF file format.\n\n###Common Issues and\
  \ Important Notes\n\n* Note: Composing filtering expressions can range from very\
  \ simple to extremely complicated depending on what you're trying to do.\n\nCompound\
  \ expressions (ones that specify multiple conditions connected by &&, AND, ||, or\
  \ OR, and reference multiple attributes) require special consideration. By default,\
  \ variants that are missing one or more of the attributes referenced in a compound\
  \ expression are treated as PASS for the entire expression, even if the variant\
  \ would satisfy the filter criteria for another part of the expression. This can\
  \ lead to unexpected results if any of the attributes referenced in a compound expression\
  \ are present for some variants, but missing for others.\n\nIt is strongly recommended\
  \ to provide such expressions as individual arguments, each referencing a single\
  \ attribute and specifying a single criteria. This ensures that all of the individual\
  \ expression are applied to each variant, even if a given variant is missing values\
  \ for some of the expression conditions.\n\nAs an example, multiple individual expressions\
  \ provided like this:\n\n```\n   gatk VariantFiltration \\\n   --reference reference.fasta\
  \ \\\n   --variant input.vcf.gz \\\n   --output output.vcf.gz \\\n   --filter-name\
  \ \"my_filter1\" \\\n   --filter-expression \"AB < 0.2\" \\\n   --filter-name \"\
  my_filter2\" \\\n   --filter-expression \"MQ0 > 50\"\n \n```\n\nare preferable to\
  \ a single compound expression such as this:\n\n```\n    gatk VariantFiltration\
  \ \\\n    --reference reference.fasta \\\n    --variant input.vcf.gz \\\n    --output\
  \ output.vcf.gz \\\n    --filter-name \"my_filter\" \\\n    --filter-expression\
  \ \"AB < 0.2 || MQ0 > 50\"\n  \n```\n\n###Performance Benchmarking\n\nThis tool\
  \ is ultra fast, with a running time less than a minute on the default AWS c4.2xlarge\
  \ instance.\n\n\n###References\n\n[1] [GATK VariantFiltration](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_filters_VariantFiltration.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-variantfiltration-4-1-0-0/7
inputs:
- doc: If true, adds a command line header line to created vcf files.
  id: add_output_vcf_command_line
  inputBinding:
    position: 4
    prefix: --add-output-vcf-command-line
    shellQuote: false
  label: Add output vcf command line
  sbg:altPrefix: -add-output-vcf-command-line
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: add_output_vcf_command_line
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: The number of SNPs which make up a cluster. Must be at least 2.
  id: cluster_size
  inputBinding:
    position: 4
    prefix: --cluster-size
    shellQuote: false
  label: Cluster size
  sbg:altPrefix: -cluster
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '3'
  type: int?
- doc: The window size (in bases) in which to evaluate clustered SNPs.
  id: cluster_window_size
  inputBinding:
    position: 4
    prefix: --cluster-window-size
    shellQuote: false
  label: Cluster window size
  sbg:altPrefix: -window
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: If true, create a VCF index when writing a coordinate-sorted VCF file.
  id: create_output_variant_index
  inputBinding:
    position: 4
    prefix: --create-output-variant-index
    shellQuote: false
  label: Create output variant index
  sbg:altPrefix: -OVI
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: create_output_variant_index
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: If true, don't cache bam indexes, this will reduce memory requirements but
    may harm performance if many intervals are specified. Caching is automatically
    disabled if there are no intervals specified.
  id: disable_bam_index_caching
  inputBinding:
    position: 4
    prefix: --disable-bam-index-caching
    shellQuote: false
  label: Disable BAM index caching
  sbg:altPrefix: -DBIC
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: If specified, do not check the sequence dictionaries from our inputs for compatibility.
    Use at your own risk!
  id: disable_sequence_dictionary_validation
  inputBinding:
    position: 4
    prefix: --disable-sequence-dictionary-validation
    shellQuote: false
  label: Disable sequence dictionary validation
  sbg:altPrefix: -disable-sequence-dictionary-validation
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: 'Disable all tool default read filters (warning: many tools will not function
    correctly without their default read filters on).'
  id: disable_tool_default_read_filters
  inputBinding:
    position: 4
    prefix: --disable-tool-default-read-filters
    shellQuote: false
  label: Disable tool default read filters
  sbg:altPrefix: -disable-tool-default-read-filters
  sbg:category: Advanced Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: File which contains one or more genomic intervals to exclude from processing.
  id: exclude_intervals_file
  inputBinding:
    position: 4
    prefix: --exclude-intervals
    shellQuote: false
  label: Exclude intervals file
  sbg:altPrefix: -XL
  sbg:category: Optional Arguments
  sbg:fileTypes: BED
  sbg:toolDefaultValue: 'null'
  type: File?
- doc: One or more genomic intervals to exclude from processing.
  id: exclude_intervals_string
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--exclude-intervals',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Exclude intervals string
  sbg:altPrefix: -XL
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: One or more expressions used with INFO fields to filter.
  id: filter_expression
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--filter-expression',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Filter expression
  sbg:altPrefix: -filter
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Names to use for the list of filters.
  id: filter_name
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--filter-name',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Filter name
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Filter records not in given input mask.
  id: filter_not_in_mask
  inputBinding:
    position: 4
    prefix: --filter-not-in-mask
    shellQuote: false
  label: Filter not in mask
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: One or more expressions used with FORMAT (sample/genotype-level) fields to
    filter (see documentation guide for more info).
  id: genotype_filter_expression
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--genotype-filter-expression',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Genotype filter expression
  sbg:altPrefix: -G-filter
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Names to use for the list of sample/genotype filters (must be a 1-to-1 mapping);
    this name is put in the FILTER field for variants that get filtered.
  id: genotype_filter_name
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--genotype-filter-name',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Genotype filter name
  sbg:altPrefix: -G-filter-name
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Amount of padding (in bp) to add to each interval you are excluding.
  id: interval_exclusion_padding
  inputBinding:
    position: 4
    prefix: --interval-exclusion-padding
    shellQuote: false
  label: Interval exclusion padding
  sbg:altPrefix: -ixp
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Interval merging rule for abutting intervals.
  id: interval_merging_rule
  inputBinding:
    position: 4
    prefix: --interval-merging-rule
    shellQuote: false
  label: Interval merging rule
  sbg:altPrefix: -imr
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: ALL
  type:
  - 'null'
  - name: interval_merging_rule
    symbols:
    - ALL
    - OVERLAPPING_ONLY
    type: enum
- doc: Amount of padding (in bp) to add to each interval you are including.
  id: interval_padding
  inputBinding:
    position: 4
    prefix: --interval-padding
    shellQuote: false
  label: Interval padding
  sbg:altPrefix: -ip
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Set merging approach to use for combining interval inputs.
  id: interval_set_rule
  inputBinding:
    position: 4
    prefix: --interval-set-rule
    shellQuote: false
  label: Interval set rule
  sbg:altPrefix: -isr
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: UNION
  type:
  - 'null'
  - name: interval_set_rule
    symbols:
    - UNION
    - INTERSECTION
    type: enum
- doc: File which contains one or more genomic intervals over which to operate.
  id: include_intervals_file
  inputBinding:
    position: 4
    prefix: --intervals
    shellQuote: false
  label: Include intervals file
  sbg:altPrefix: -L
  sbg:category: Optional Arguments
  sbg:fileTypes: BED
  sbg:toolDefaultValue: 'null'
  type: File?
- doc: One or more genomic intervals over which to operate.
  id: include_intervals_string
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--intervals',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    return '';\n\
      }"
  label: Include intervals string
  sbg:altPrefix: -L
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Remove previous filters applied to the VCF.
  id: invalidate_previous_filters
  inputBinding:
    position: 4
    prefix: --invalidate-previous-filters
    shellQuote: false
  label: Invalidate previous filters
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Invert the selection criteria for --filter-expression.
  id: invert_filter_expression
  inputBinding:
    position: 4
    prefix: --invert-filter-expression
    shellQuote: false
  label: Invert filter expression
  sbg:altPrefix: -invfilter
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Invert the selection criteria for --genotype-filter-expression.
  id: invert_genotype_filter_expression
  inputBinding:
    position: 4
    prefix: --invert-genotype-filter-expression
    shellQuote: false
  label: Invert genotype filter expression
  sbg:altPrefix: -invG-filter
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Lenient processing of VCF files.
  id: lenient
  inputBinding:
    position: 4
    prefix: --lenient
    shellQuote: false
  label: Lenient
  sbg:altPrefix: -LE
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Input mask.
  id: mask
  inputBinding:
    position: 4
    prefix: --mask
    shellQuote: false
  label: Mask
  sbg:altPrefix: -mask
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string?
- doc: How many bases beyond records from a provided 'mask' should variants be filtered.
  id: mask_extension
  inputBinding:
    position: 4
    prefix: --mask-extension
    shellQuote: false
  label: Mask extension
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: The text to put in the FILTER field if a 'mask' is provided and overlaps with
    a variant call.
  id: mask_name
  inputBinding:
    position: 4
    prefix: --mask-name
    shellQuote: false
  label: Mask name
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: Mask
  type: string?
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
  type: int?
- doc: When evaluating the JEXL expressions, missing values should be considered failing
    the expression.
  id: missing_values_evaluate_as_failing
  inputBinding:
    position: 4
    prefix: --missing-values-evaluate-as-failing
    shellQuote: false
  label: Missing values evaluate as failing
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Reference sequence.
  id: in_reference
  inputBinding:
    position: 4
    prefix: --reference
    shellQuote: false
  label: Reference
  sbg:altPrefix: -R
  sbg:category: Optional Arguments
  sbg:fileTypes: FASTA, FA
  sbg:toolDefaultValue: 'null'
  secondaryFiles:
  - .fai
  - ^.dict
  type: File?
- doc: Use the given sequence dictionary as the master/canonical sequence dictionary.
    Must be a .dict file.
  id: sequence_dictionary
  inputBinding:
    position: 4
    prefix: --sequence-dictionary
    shellQuote: false
  label: Sequence dictionary
  sbg:altPrefix: -sequence-dictionary
  sbg:category: Optional Arguments
  sbg:fileTypes: DICT
  sbg:toolDefaultValue: 'null'
  type: File?
- doc: Set filtered genotypes to no-call.
  id: set_filtered_genotype_to_no_call
  inputBinding:
    position: 4
    prefix: --set-filtered-genotype-to-no-call
    shellQuote: false
  label: Set filtered genotype to no call
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: If true, don't emit genotype fields when writing VCF file output.
  id: sites_only_vcf_output
  inputBinding:
    position: 4
    prefix: --sites-only-vcf-output
    shellQuote: false
  label: Sites only vcf output
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: A VCF file containing variants.
  id: in_variants
  inputBinding:
    position: 4
    prefix: --variant
    shellQuote: false
  label: Input variants file
  sbg:altPrefix: -V
  sbg:category: Required Arguments
  sbg:fileTypes: VCF, VCF.GZ
  secondaryFiles:
  - "${\n    if (self.nameext == \".vcf\")\n    {\n        return \".idx\";\n    }\n\
    \    else\n    {\n        return self.basename + \".tbi\";\n    }\n}"
  type: File
- doc: Output file name prefix.
  id: output_prefix
  label: Output prefix
  sbg:category: Optional Arguments
  type: string?
- doc: Output file format.
  id: output_file_format
  label: Output file format
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: VCF.GZ
  type:
  - 'null'
  - name: output_file_format
    symbols:
    - vcf
    - vcf.gz
    type: enum
- doc: CPU per job.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK VariantFiltration
outputs:
- doc: Ouput filtered variants file
  id: out_variants
  label: Ouput filtered variants file
  outputBinding:
    glob: "${\n    var output_ext = inputs.output_file_format ? inputs.output_file_format\
      \ : \"vcf.gz\";\n    return \"*\" + output_ext;\n        \n    \n    \n}"
    outputEval: $(inheritMetadata(self, inputs.in_variants))
  sbg:fileTypes: VCF.GZ
  secondaryFiles:
  - "${\n    var output_ext = inputs.output_file_format ? inputs.output_file_format\
    \ : \"vcf.gz\";\n    if (output_ext == \"vcf\")\n    {\n        return self.basename\
    \ + \".idx\";\n    }\n    else \n    {\n        return self.basename + \".tbi\"\
    ;\n    }\n    \n}"
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 1;\n}"
  ramMin: "${\n    var memory = 3500;\n    if (inputs.memory_per_job) \n    {\n  \
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
- VCF Processing
- Variant Filtration
sbg:content_hash: af9e0b8951e53e09339a0fba5101279797fcd3c73268fbaeb60a4c376556222eb
sbg:contributors:
- uros_sipetic
- stefan_stojanovic
- nemanja.vucic
- veliborka_josipovic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/25
sbg:createdBy: uros_sipetic
sbg:createdOn: 1552930494
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-variantfiltration-4-1-0-0/7
sbg:image_url: null
sbg:latestRevision: 7
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
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_filters_VariantFiltration.php
  label: Documentation
sbg:modifiedBy: nemanja.vucic
sbg:modifiedOn: 1559750433
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/25
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552930494
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/10
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554493100
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/18
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554720852
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/19
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554999320
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/20
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1557837718
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/21
- sbg:modifiedBy: stefan_stojanovic
  sbg:modifiedOn: 1558964200
  sbg:revision: 5
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/22
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1559734534
  sbg:revision: 6
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/24
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559750433
  sbg:revision: 7
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-variantfiltration-4-1-0-0/25
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
