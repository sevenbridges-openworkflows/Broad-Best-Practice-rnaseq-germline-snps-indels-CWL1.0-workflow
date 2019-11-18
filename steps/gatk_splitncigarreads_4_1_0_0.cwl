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
    ;\n    }\n    else \n    {\n        return '';\n    }\n}"
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.memory_per_job) \n    {\n        return '\\\"-Xmx'.concat(inputs.memory_per_job,\
    \ 'M') + '\\\"';\n    }\n    else\n    {\n        return '';\n    }\n}"
- position: 3
  shellQuote: false
  valueFrom: SplitNCigarReads
- position: 4
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var in_alignments = inputs.in_alignments;\n    var output_ext\
    \ = inputs.output_file_format ? inputs.output_file_format : in_alignments.path.split('.').pop();\n\
    \    var output_prefix = '';\n    if (inputs.output_prefix)\n    {\n        output_prefix\
    \ = inputs.output_prefix;\n    }\n    else \n    {\n        if (in_alignments.metadata\
    \ && in_alignments.metadata.sample_id)\n        {\n            output_prefix =\
    \ in_alignments.metadata.sample_id;\n        }\n        else \n        {\n   \
    \         output_prefix = in_alignments.path.split('/').pop().split('.')[0];\n\
    \        }\n    }\n    \n    return \"--output \" + output_prefix + \".split.\"\
    \ + output_ext;\n}"
- position: 5
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var output_ext = inputs.output_file_format ? inputs.output_file_format\
    \ :\n    inputs.in_alignments.path.split('.').pop();\n    if (output_ext == \"\
    cram\")\n    {\n        return '&& for i in *cram.bai; do mv \"$i\" \"${i%.cram.bai}.cram.crai\"\
    ;  done';\n    }\n    else \n    {\n        return '';\n    }\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "The **GATK SplitNCigarReads** tool splits reads that contain Ns in their CIGAR\
  \ string (e.g. spanning splicing events in RNAseq data) from the input alignment\
  \ file and outputs an alignment file with reads split at N CIGAR elements and CIGAR\
  \ strings updated. \n\nThis tool identifies all N cigar elements in sequence reads,\
  \ and creates k+1 new reads (where k is the number of N cigar elements) that correspond\
  \ to the segments of the original read beside/between the splicing events represented\
  \ by the Ns in the original CIGAR. The first read includes the bases that are to\
  \ the left of the first N element, while the part of the read that is to the right\
  \ of the N (including the Ns) is hard clipped, and so on for the rest of the new\
  \ reads [1].\n\n*A list of **all inputs and parameters** with corresponding descriptions\
  \ can be found at the bottom of the page.*\n\n###Common Use Cases\n\n* The **GATK\
  \ SplitNCigarReads** tool requires a BAM/SAM/CRAM file on its **Input BAM/SAM/CRAM\
  \ file** (`--input`) input and a reference file on its **Reference** (`--reference`)\
  \ input. The tool generates a single BAM file on its **Output split BAM/SAM/CRAM\
  \ file** output by default, or SAM or CRAM if the input file is SAM or CRAM, respectively.\n\
  \n* Usage example:\n\n```\n    gatk SplitNCigarReads \\\n      --reference Homo_sapiens_assembly38.fasta\
  \ \\\n      --input input.bam \\\n      --output output.bam\n```\n\n###Changes Introduced\
  \ by Seven Bridges\n\n* The output file name will be prefixed using the **Output\
  \ prefix** parameter. In case **Output prefix** is not provided, output prefix will\
  \ be the same as the Sample ID metadata from **Input SAM/BAM/CRAM file**, if the\
  \ Sample ID metadata exists. Otherwise, output prefix will be inferred from the\
  \ **Input SAM/BAM/CRAM file** filename. This way, having identical names of the\
  \ output files between runs is avoided. Moreover,  **split** will be added right\
  \ before the extension of the output file name. \n\n* The user has a possibility\
  \ to specify the output file format using the **Output file format** argument. Otherwise,\
  \ the output file format will be the same as the format of the input file.\n\n*\
  \ **Include intervals** (`--intervals`) option is divided into **Include intervals\
  \ string** and **Include intervals file** options.\n\n* **Exclude intervals** (`--exclude-intervals`)\
  \ option is divided into **Exclude intervals string** and **Exclude intervals file**\
  \ options.\n\n###Common Issues and Important Notes\n\n* Note: The **AllowAllReadsReadFilter**\
  \ read filter (do not filter out any read) is automatically applied to the data\
  \ by the Engine before processing by SplitNCigarReads.\n* Note: If **Read filter**\
  \ (`--read-filter`) option is set to \"LibraryReadFilter\", **Library** (`--library`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"PlatformReadFilter\", **Platform filter name** (`--platform-filter-name`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to\"PlatformUnitReadFilter\", **Black listed lanes** (`--black-listed-lanes`)\
  \ option must be set to some value. \n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"ReadGroupBlackListReadFilter\", **Read group black list** (`--read-group-black-list`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"ReadGroupReadFilter\", **Keep read group** (`--keep-read-group`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"ReadLengthReadFilter\", **Max read length** (`--max-read-length`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"ReadNameReadFilter\", **Read name** (`--read-name`) option\
  \ must be set to some value.\n* Note: If **Read filter** (`--read-filter`) option\
  \ is set to \"ReadStrandFilter\", **Keep reverse strand only** (`--keep-reverse-strand-only`)\
  \ option must be set to some value.\n* Note: If **Read filter** (`--read-filter`)\
  \ option is set to \"SampleReadFilter\", **Sample** (`--sample`) option must be\
  \ set to some value.\n\n###Performance Benchmarking\n\nBelow is a table describing\
  \ runtimes and task costs of **GATK SplitNCigarReads** for a couple of different\
  \ samples, executed on the AWS cloud instances:\n\n| Experiment type |  Input size\
  \ | Duration |  Cost | Instance (AWS) | \n|:--------------:|:------------:|:--------:|:-------:|:---------:|\n\
  |     RNA-Seq     |  1.9 GB |   29min   | ~0.19$ | c4.2xlarge (8 CPUs) | \n|   \
  \  RNA-Seq     |  5.4 GB |   1h 10min   | ~0.46$ | c4.2xlarge (8 CPUs) | \n|   \
  \  RNA-Seq     | 8.8 GB |  2h 2min  | ~0.80$ | c4.2xlarge (8 CPUs) | \n|     RNA-Seq\
  \     | 17 GB |  4h 15min  | ~1.69$ | c4.2xlarge (8 CPUs) |\n\n*Cost can be significantly\
  \ reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n###References\n\n[1] [GATK SplitNCigarReads](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_rnaseq_SplitNCigarReads.php)"
id: uros_sipetic/gatk-4-1-0-0-demo/gatk-splitncigarreads-4-1-0-0/4
inputs:
- doc: If true, adds a PG tag to created SAM/BAM/CRAM files.
  id: add_output_sam_program_record
  inputBinding:
    position: 4
    prefix: --add-output-sam-program-record
    shellQuote: false
  label: Add output SAM program record
  sbg:altPrefix: -add-output-sam-program-record
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: add_output_sam_program_record
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: Threshold number of ambiguous bases. If null, uses threshold fraction; otherwise,
    overrides threshold fraction. Cannot be used in conjuction with argument(s) maxAmbiguousBaseFraction.
    Valid only if "AmbiguousBaseReadFilter" is specified.
  id: ambig_filter_bases
  inputBinding:
    position: 4
    prefix: --ambig-filter-bases
    shellQuote: false
  label: Ambig filter bases
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: 'null'
  type: int?
- doc: Threshold fraction of ambiguous bases. Cannot be used in conjuction with argument(s)
    maxAmbiguousBases. Valid only if "AmbiguousBaseReadFilter" is specified.
  id: ambig_filter_frac
  inputBinding:
    position: 4
    prefix: --ambig-filter-frac
    shellQuote: false
  label: Ambig filter frac
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: '0.05'
  type: float?
- doc: Platform unit (PU) to filter out. This argument must be specified at least
    once. Valid only if "PlatformUnitReadFilter" is specified.
  id: black_listed_lanes
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--black-listed-lanes',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Black listed lanes
  sbg:category: Conditional Arguments
  type: string[]?
- doc: If true, create a BAM/CRAM index when writing a coordinate-sorted BAM/CRAM
    file.
  id: create_output_bam_index
  inputBinding:
    position: 4
    prefix: --create-output-bam-index
    shellQuote: false
  label: Create output BAM/CRAM index
  sbg:altPrefix: -OBI
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'true'
  type:
  - 'null'
  - name: create_output_bam_index
    symbols:
    - 'true'
    - 'false'
    type: enum
- doc: Read filters to be disabled before analysis.
  id: disable_read_filter
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--disable-read-filter',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Disable read filter
  sbg:altPrefix: -DF
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type:
  - 'null'
  - items:
      name: disable_read_filter
      symbols:
      - AlignmentAgreesWithHeaderReadFilter
      - AllowAllReadsReadFilter
      - AmbiguousBaseReadFilter
      - CigarContainsNoNOperator
      - FirstOfPairReadFilter
      - FragmentLengthReadFilter
      - GoodCigarReadFilter
      - HasReadGroupReadFilter
      - LibraryReadFilter
      - MappedReadFilter
      - MappingQualityAvailableReadFilter
      - MappingQualityNotZeroReadFilter
      - MappingQualityReadFilter
      - MatchingBasesAndQualsReadFilter
      - MateDifferentStrandReadFilter
      - MateOnSameContigOrNoMappedMateReadFilter
      - MetricsReadFilter
      - NonChimericOriginalAlignmentReadFilter
      - NonZeroFragmentLengthReadFilter
      - NonZeroReferenceLengthAlignmentReadFilter
      - NotDuplicateReadFilter
      - NotOpticalDuplicateReadFilter
      - NotSecondaryAlignmentReadFilter
      - NotSupplementaryAlignmentReadFilter
      - OverclippedReadFilter
      - PairedReadFilter
      - PassesVendorQualityCheckReadFilter
      - PlatformReadFilter
      - PlatformUnitReadFilter
      - PrimaryLineReadFilter
      - ProperlyPairedReadFilter
      - ReadGroupBlackListReadFilter
      - ReadGroupReadFilter
      - ReadLengthEqualsCigarLengthReadFilter
      - ReadLengthReadFilter
      - ReadNameReadFilter
      - ReadStrandFilter
      - SampleReadFilter
      - SecondOfPairReadFilter
      - SeqIsStoredReadFilter
      - ValidAlignmentEndReadFilter
      - ValidAlignmentStartReadFilter
      - WellformedReadFilter
      type: enum
    type: array
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
- doc: 'Disable all tool default read filters (WARNING: many tools will not function
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
- doc: Do not have the walker soft-clip overhanging sections of the reads.
  id: do_not_fix_overhangs
  inputBinding:
    position: 4
    prefix: --do-not-fix-overhangs
    shellQuote: false
  label: Do not fix overhangs
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Allow a read to be filtered out based on having only 1 soft-clipped block.
    By default, both ends must have a soft-clipped block, setting this flag requires
    only 1 soft-clipped block. Valid only if "OverclippedReadFilter" is specified.
  id: dont_require_soft_clips_both_ends
  inputBinding:
    position: 4
    prefix: --dont-require-soft-clips-both-ends
    shellQuote: false
  label: Dont require soft clips both ends
  sbg:category: Conditional Arguments
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
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Exclude intervals string
  sbg:altPrefix: -XL
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: Minimum number of aligned bases. Valid only if "OverclippedReadFilter" is specified.
  id: filter_too_short
  inputBinding:
    position: 4
    prefix: --filter-too-short
    shellQuote: false
  label: Filter too short
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: '30'
  type: int?
- doc: BAM/SAM/CRAM file containing reads.
  id: in_alignments
  inputBinding:
    position: 4
    prefix: --input
    shellQuote: false
  label: Input BAM/SAM/CRAM file
  sbg:altPrefix: -I
  sbg:category: Required Arguments
  sbg:fileTypes: BAM, SAM, CRAM
  secondaryFiles:
  - "${\n    \n    if (self.nameext == \".bam\")\n    {\n        return self.nameroot\
    \ + \".bai\";\n    }\n    else if (self.nameext == \".cram\")\n    {\n       \
    \ return self.nameroot + \".crai\";\n    }\n    return '';\n    \n}"
  type: File
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
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Include intervals string
  sbg:altPrefix: -L
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type: string[]?
- doc: The name of the read group to keep. Valid only if "ReadGroupReadFilter" is
    specified.
  id: keep_read_group
  inputBinding:
    position: 4
    prefix: --keep-read-group
    shellQuote: false
  label: Keep read group
  sbg:category: Conditional Arguments
  type: string?
- doc: Keep only reads on the reverse strand. Valid only if "ReadStrandFilter" is
    specified.
  id: keep_reverse_strand_only
  inputBinding:
    position: 4
    prefix: --keep-reverse-strand-only
    shellQuote: false
  label: Keep reverse strand only
  sbg:category: Conditional Arguments
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
- doc: Name of the library to keep. This argument must be specified at least once.
    Valid only if "LibraryReadFilter" is specified.
  id: library
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--library',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Library
  sbg:altPrefix: -library
  sbg:category: Conditional Arguments
  type: string[]?
- doc: Max number of bases allowed in the overhang.
  id: max_bases_in_overhang
  inputBinding:
    position: 4
    prefix: --max-bases-in-overhang
    shellQuote: false
  label: Max bases in overhang
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '40'
  type: int?
- doc: Maximum length of fragment (insert size). Valid only if "FragmentLengthReadFilter"
    is specified.
  id: max_fragment_length
  inputBinding:
    position: 4
    prefix: --max-fragment-length
    shellQuote: false
  label: Max fragment length
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: '1000000'
  type: int?
- doc: Max number of mismatches allowed in the overhang.
  id: max_mismatches_in_overhang
  inputBinding:
    position: 4
    prefix: --max-mismatches-in-overhang
    shellQuote: false
  label: Max mismatches in overhang
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Keep only reads with length at most equal to the specified value. Valid only
    if "ReadLengthReadFilter" is specified.
  id: max_read_length
  inputBinding:
    position: 4
    prefix: --max-read-length
    shellQuote: false
  label: Max read length
  sbg:category: Conditional Arguments
  type: int?
- doc: Max reads allowed to be kept in memory at a time by the BAM writer.
  id: max_reads_in_memory
  inputBinding:
    position: 4
    prefix: --max-reads-in-memory
    shellQuote: false
  label: Max reads in memory
  sbg:category: Advanced Arguments
  sbg:toolDefaultValue: '150000'
  type: int?
- doc: Maximum mapping quality to keep (inclusive). Valid only if "MappingQualityReadFilter"
    is specified.
  id: maximum_mapping_quality
  inputBinding:
    position: 4
    prefix: --maximum-mapping-quality
    shellQuote: false
  label: Maximum mapping quality
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: 'null'
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
  type: int?
- doc: Keep only reads with length at least equal to the specified value. Valid only
    if "ReadLengthReadFilter" is specified.
  id: min_read_length
  inputBinding:
    position: 4
    prefix: --min-read-length
    shellQuote: false
  label: Min read length
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Minimum mapping quality to keep (inclusive). Valid only if "MappingQualityReadFilter"
    is specified.
  id: minimum_mapping_quality
  inputBinding:
    position: 4
    prefix: --minimum-mapping-quality
    shellQuote: false
  label: Minimum mapping quality
  sbg:category: Conditional Arguments
  sbg:toolDefaultValue: '10'
  type: int?
- doc: Platform attribute (PL) to match. This argument must be specified at least
    once. Valid only if "PlatformReadFilter" is specified.
  id: platform_filter_name
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--platform-filter-name',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Platform filter name
  sbg:category: Conditional Arguments
  type: string[]?
- doc: Have the walker split secondary alignments (will still repair MC tag without
    it).
  id: process_secondary_alignments
  inputBinding:
    position: 4
    prefix: --process-secondary-alignments
    shellQuote: false
  label: Process secondary alignments
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Read filters to be applied before analysis.
  id: read_filter
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--read-filter',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Read filter
  sbg:altPrefix: -RF
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'null'
  type:
  - 'null'
  - items:
      name: read_filter
      symbols:
      - AlignmentAgreesWithHeaderReadFilter
      - AllowAllReadsReadFilter
      - AmbiguousBaseReadFilter
      - CigarContainsNoNOperator
      - FirstOfPairReadFilter
      - FragmentLengthReadFilter
      - GoodCigarReadFilter
      - HasReadGroupReadFilter
      - LibraryReadFilter
      - MappedReadFilter
      - MappingQualityAvailableReadFilter
      - MappingQualityNotZeroReadFilter
      - MappingQualityReadFilter
      - MatchingBasesAndQualsReadFilter
      - MateDifferentStrandReadFilter
      - MateOnSameContigOrNoMappedMateReadFilter
      - MetricsReadFilter
      - NonChimericOriginalAlignmentReadFilter
      - NonZeroFragmentLengthReadFilter
      - NonZeroReferenceLengthAlignmentReadFilter
      - NotDuplicateReadFilter
      - NotOpticalDuplicateReadFilter
      - NotSecondaryAlignmentReadFilter
      - NotSupplementaryAlignmentReadFilter
      - OverclippedReadFilter
      - PairedReadFilter
      - PassesVendorQualityCheckReadFilter
      - PlatformReadFilter
      - PlatformUnitReadFilter
      - PrimaryLineReadFilter
      - ProperlyPairedReadFilter
      - ReadGroupBlackListReadFilter
      - ReadGroupReadFilter
      - ReadLengthEqualsCigarLengthReadFilter
      - ReadLengthReadFilter
      - ReadNameReadFilter
      - ReadStrandFilter
      - SampleReadFilter
      - SecondOfPairReadFilter
      - SeqIsStoredReadFilter
      - ValidAlignmentEndReadFilter
      - ValidAlignmentStartReadFilter
      - WellformedReadFilter
      type: enum
    type: array
- doc: The name of the read group to filter out. This argument must be specified at
    least once. Valid only if "ReadGroupBlackListReadFilter" is specified.
  id: read_group_black_list
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--read-group-black-list',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Read group black list
  sbg:category: Conditional Arguments
  type: string[]?
- doc: Keep only reads with this read name. Valid only if "ReadNameReadFilter" is
    specified.
  id: read_name
  inputBinding:
    position: 4
    prefix: --read-name
    shellQuote: false
  label: Read name
  sbg:category: Conditional Arguments
  type: string?
- doc: Validation stringency for all SAM/BAM/CRAM/SRA files read by this program.
    The default stringency value SILENT can improve performance when processing a
    BAM file in which variable-length data (read, qualities, tags) do not otherwise
    need to be decoded.
  id: read_validation_stringency
  inputBinding:
    position: 4
    prefix: --read-validation-stringency
    shellQuote: false
  label: Read validation stringency
  sbg:altPrefix: -VS
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: SILENT
  type:
  - 'null'
  - name: read_validation_stringency
    symbols:
    - STRICT
    - LENIENT
    - SILENT
    type: enum
- doc: Refactor cigar string with NDN elements to one element.
  id: refactor_cigar_string
  inputBinding:
    position: 4
    prefix: --refactor-cigar-string
    shellQuote: false
  label: Refactor cigar string
  sbg:altPrefix: -fixNDN
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Reference sequence file.
  id: in_reference
  inputBinding:
    position: 4
    prefix: --reference
    shellQuote: false
  label: Reference
  sbg:altPrefix: -R
  sbg:category: Required Arguments
  sbg:fileTypes: FASTA, FA
  secondaryFiles:
  - .fai
  - ^.dict
  type: File
- doc: The name of the sample(s) to keep, filtering out all others. This argument
    must be specified at least once. Valid only if "SampleReadFilter" is specified.
  id: sample
  inputBinding:
    position: 4
    prefix: ''
    shellQuote: false
    valueFrom: "${\n    if (self)\n    {\n        var cmd = [];\n        for (var\
      \ i = 0; i < self.length; i++) \n        {\n            cmd.push('--sample',\
      \ self[i]);\n        }\n        return cmd.join(' ');\n    }\n    \n}"
  label: Sample
  sbg:altPrefix: -sample
  sbg:category: Conditional Arguments
  type: string[]?
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
- doc: Skip the 255 -> 60 MQ read transform.
  id: skip_mapping_quality_transform
  inputBinding:
    position: 4
    prefix: --skip-mapping-quality-transform
    shellQuote: false
  label: Skip mapping quality transform
  sbg:altPrefix: -skip-mq-transform
  sbg:category: Optional Arguments
  sbg:toolDefaultValue: 'false'
  type: boolean?
- doc: Output file name prefix.
  id: output_prefix
  label: Output prefix
  sbg:category: Optional Arguments
  type: string?
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
- doc: This input allows a user to set the desired CPU requirement when running a
    tool or adding it to a workflow.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'
  type: int?
label: GATK SplitNCigarReads
outputs:
- doc: Output BAM/SAM/CRAM file with reads split at N CIGAR elements and CIGAR strings
    updated.
  id: out_alignments
  label: Output split BAM/SAM/CRAM file
  outputBinding:
    glob: '*am'
    outputEval: $(inheritMetadata(self, inputs.in_alignments))
  sbg:fileTypes: BAM, SAM, CRAM
  secondaryFiles:
  - "${\n    var output_ext = self.nameext;\n    if (output_ext == \".bam\")\n   \
    \ {\n        return self.nameroot + \".bai\";\n    }\n    else if (output_ext\
    \ == \".cram\")\n    {\n        return self.nameroot + \".crai\";\n    }\n}"
  type: File?
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
sbg:content_hash: a4e717ec3b368b23d87ae86adfbfa07ac7dea02ebd2082ed86f9874d2a8fe4073
sbg:contributors:
- uros_sipetic
- veliborka_josipovic
sbg:copyOf: veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/23
sbg:createdBy: uros_sipetic
sbg:createdOn: 1552920664
sbg:id: uros_sipetic/gatk-4-1-0-0-demo/gatk-splitncigarreads-4-1-0-0/4
sbg:image_url: null
sbg:latestRevision: 4
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
- id: https://software.broadinstitute.org/gatk/documentation/tooldocs/4.1.0.0/org_broadinstitute_hellbender_tools_walkers_rnaseq_SplitNCigarReads.php
  label: Documentation
sbg:modifiedBy: veliborka_josipovic
sbg:modifiedOn: 1559734483
sbg:project: uros_sipetic/gatk-4-1-0-0-demo
sbg:projectName: GATK 4.1.0.0 - Demo
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/23
sbg:revisionsInfo:
- sbg:modifiedBy: uros_sipetic
  sbg:modifiedOn: 1552920664
  sbg:revision: 0
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/9
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554492879
  sbg:revision: 1
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/14
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554720873
  sbg:revision: 2
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/15
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1554999310
  sbg:revision: 3
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/16
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1559734483
  sbg:revision: 4
  sbg:revisionNotes: Copy of veliborka_josipovic/gatk-4-1-0-0-toolkit-dev/gatk-splitncigarreads-4-1-0-0/23
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: GATK
sbg:toolkitVersion: 4.1.0.0
sbg:validationErrors: []
