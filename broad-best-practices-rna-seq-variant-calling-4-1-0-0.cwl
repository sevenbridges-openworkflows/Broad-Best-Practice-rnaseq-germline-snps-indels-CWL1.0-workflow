dct:creator:
  "@id": "sbg"
  foaf:name: SevenBridges
  foaf:mbox: "mailto:support@sbgenomics.com"
$namespaces:
  sbg: https://sevenbridges.com
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
class: Workflow
cwlVersion: v1.0
id: >-
  uros_sipetic/gatk-rna-seq-best-practice-workflow-4-1-0-0-demo/broad-best-practices-rna-seq-variant-calling-4-1-0-0/8
doc: >-
  This workflow represents the GATK Best Practices for SNP and INDEL calling on
  RNA-Seq data. 


  Starting from an unmapped BAM file, it performs alignment to the reference
  genome, followed by marking duplicates, reassigning mapping qualities, base
  recalibration, variant calling and variant filtering. On the [GATK
  website](https://software.broadinstitute.org/gatk/documentation/article.php?id=3891),
  you can find more detailed information about calling variants in RNA-Seq.


  ### Common Use Cases

  - If you have raw sequencing reads in FASTQ format, you should convert them to
  an unmapped BAM file using the **Picard FastqToSam** app before running the
  workflow.

  - **BaseRecalibrator** uses **Known indels** and **Known SNPs** databases to
  mask out polymorphic sites when creating a model for adjusting quality scores.
  Also, the **HaplotypeCaller** uses the **Known SNPs** database to populate the
  ID column of the VCF output.

  - The **HaplotypeCaller** app uses **Intervals list** to restrict processing
  to specific genomic intervals. You can set the **Scatter count** value in
  order to split **Intervals list** into smaller intervals. **HaplotypeCaller**
  processes these intervals in parallel, which will significantly reduce
  workflow execution time  in some cases.

  - You can provide a pre-generated **STAR** reference index file or a genome
  reference file to the **Reference or STAR index** input.

  - **Running a batch task**: Batching is performed by **Sample ID** metadata
  field on the **Unmapped BAM** input port. For running analyses in batches, it
  is necessary to set **Sample ID** metadata for each unmapped BAM file.



  ### Changes Introduced by Seven Bridges

  This workflow represents the GATK Best Practices for SNP and indel calling on
  RNA-Seq data, and there are no modifications to the original workflow.



  ### Common Issues and Important Notes

  - As the *(--known-sites)* is the required option for GATK BaseRecalibrator
  tool, it is necessary to provide at least one database file to the **Known
  INDELs** or **Known SNPs** input port.

  - If you are providing pre-generated STAR reference index make sure it is
  created using the adequate version of STAR (check the STAR version in the
  original [WDL
  file](https://github.com/gatk-workflows/gatk3-4-rnaseq-germline-snps-indels/blob/master/rna-germline-variant-calling.wdl)).

  - When converting FASTQ files to an unmapped BAM file using **Picard
  FastqToSam**, it is required to set the **Platform** (`PLATFORM=`) parameter.

  - This workflow allows you to process one sample per task execution. If you
  are planning to process more than one sample, it is required to run multiple
  task executions in batch mode. More about batch analyses can be found
  [here](https://docs.sevenbridges.com/docs/about-batch-analyses).
   

  ### Performance Benchmarking

  The default memory and CPU requirements for each app in the workflow are the
  same as in the original [GATK Best Practices
  WDL](https://github.com/gatk-workflows/gatk3-4-rnaseq-germline-snps-indels/blob/master/rna-germline-variant-calling.wdl).
  You can change the default runtime requirements for **STAR GenomeGenerate**
  and **STAR Align** apps. 


  | Experiment type |  Input size | Paired-end | # of reads | Read length |
  Duration |  AWS Instance Cost (spot) | AWS Instance Cost (on-demand) | 

  |:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|

  |     RNA-Seq     |  1.3 GB |     Yes    |     16M     |     101     |  
  2h44min   | 0.79$ | 1.79$ | 

  |     RNA-Seq     |  3.9 GB |     Yes    |     50M     |     101     |  
  4h38min   | 1.29$ | 2.71$ | 

  |     RNA-Seq     | 6.5 GB |     Yes    |     82M    |     101     |  6h44min 
  | 1.85$ | 3.84$ | 

  |     RNA-Seq     | 12.9 GB |     Yes    |     164M    |     101     | 
  12h4min  | 3.30$ | 6.99$ |



  ### API Python Implementation

  The workflow's draft task can also be submitted via the API. To learn how to
  get your Authentication token and API endpoint for the corresponding platform,
  visit our
  [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).

  ```python

  from sevenbridges import Api


  authentication_token, api_endpoint = "enter_your_token", "enter_api_endpoint"

  api = Api(token=authentication_token, url=api_endpoint)

  # Get project_id/workflow_id from your address bar. Example:
  https://igor.sbgenomics.com/u/your_username/project/workflow

  project_id = "your_username/project"

  workflow_id = "your_username/project/workflow"

  # Get file names from files in your project.

  inputs = {
          "input": api.files.query(project=project_id, names=['Homo_sapiens_assembly19_1000genomes_decoy.whole_genome.interval_list']),
          "in_alignments": api.files.query(project=project_id, names=['G26234.HCC1187_1Mreads.bam'])[0],
          "in_reference": api.files.query(project=project_id, names=['Homo_sapiens_assembly19_1000genomes_decoy.fasta'])[0],
          "in_gene_annotation": api.files.query(project=project_id, names=['star.gencode.v19.transcripts.patched_contigs.gtf'])[0],
          "in_reference_or_index": api.files.query(project=project_id, names=['Homo_sapiens_assembly19_1000genomes_decoy.star.gencode.v19.transcripts.patched_contigs.star-2.5.3a_modified-index-archive.tar'])[0],
          "known_indels": api.files.query(project=project_id, names=['Mills_and_1000G_gold_standard.indels.b37.sites.vcf',
                                                                     'Homo_sapiens_assembly19_1000genomes_decoy.known_indels.vcf']),
          "known_snps": api.files.query(project=project_id, names=['Homo_sapiens_assembly19_1000genomes_decoy.dbsnp138.vcf']),
  }


  task = api.tasks.create(name='GATK4 RNA-Seq Workflow - API Example',
  project=project_id, app=workflow_id, inputs=inputs, run=False)

  # For running a batch task

  task = api.tasks.create(name='GATK4 RNA-Seq Workflow - API Batch Example',
  project=project_id, app=workflow_id, inputs=inputs, run=False,
  batch_input='in_alignments', batch_by = { 'type': 'CRITERIA', 'criteria': [
  'metadata.sample_id'] })

  ```


  Instructions for installing and configuring the API Python client are provided
  on GitHub. For more information about using the API Python client, consult
  [sevenbridges-python
  documentation](http://sevenbridges-python.readthedocs.io/en/latest/). More
  examples are available [here](https://github.com/sbg/okAPI).


  Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API
  Java](https://github.com/sbg/sevenbridges-java) clients are available. To
  learn more about using these API clients please refer to the [API R client
  documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client
  documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).
label: BROAD Best Practices RNA-Seq Variant Calling 4.1.0.0
$namespaces:
  sbg: 'https://sevenbridges.com'
inputs:
  - id: in_alignments
    'sbg:fileTypes': 'SAM, BAM, CRAM'
    type: File
    label: Unmapped BAM
    doc: Unmapped BAM file.
    'sbg:x': -1237
    'sbg:y': -463
  - id: in_reference
    'sbg:fileTypes': 'FASTA, FA'
    type: File
    label: Reference
    doc: Genome reference.
    secondaryFiles:
      - .fai
      - ^.dict
    'sbg:x': -178.14291381835938
    'sbg:y': 389.0186462402344
  - id: known_indels
    'sbg:fileTypes': VCF
    type: 'File[]?'
    label: Known INDELs
    doc: Known INDELs.
    secondaryFiles:
      - .idx
    'sbg:x': 729.8524169921875
    'sbg:y': -223.1912841796875
  - id: known_snps
    'sbg:fileTypes': VCF
    type: File?
    label: Known SNPs
    doc: Known SNPs.
    secondaryFiles:
      - .idx
    'sbg:x': 912.197509765625
    'sbg:y': -490.7837829589844
  - id: in_intervals
    'sbg:fileTypes': 'VCF, INTERVAL_LIST'
    type: 'File[]'
    label: Interval list
    doc: Interval list.
    'sbg:x': 1423.5
    'sbg:y': -626.5
  - id: scatter_count
    type: int?
    doc: Scatter count.
    'sbg:exposed': true
  - id: standard_min_confidence_threshold_for_calling
    type: float?
    doc: Standard minimum confidence threshold for calling.
    'sbg:exposed': true
  - id: in_reference_or_index
    'sbg:fileTypes': 'FASTA, FA, FNA, TAR'
    type: File
    label: Reference or STAR index
    doc: Genome reference or STAR index file.
    'sbg:x': -1079.9658203125
    'sbg:y': 13
  - id: in_gene_annotation
    'sbg:fileTypes': 'GTF, GFF, GFF2, GFF3'
    type: File?
    label: Gene annotation
    doc: Gene annotation used by STAR.
    'sbg:x': -1069.978271484375
    'sbg:y': 136
  - id: cpu_per_job
    type: int?
    label: Number of threads
    doc: Number of threads.
    'sbg:x': -1066.9813232421875
    'sbg:y': 261.99688720703125
  - id: mem_per_job
    type: int?
    label: Memory per job
    doc: Amount of RAM memory to be used per job.
    'sbg:x': -1062.9844970703125
    'sbg:y': 386.9906921386719
  - id: read_length
    type: int?
    label: Read length
    doc: Read length used by STAR.
    'sbg:x': -1087.95654296875
    'sbg:y': -111.00310516357422
  - id: cpu_per_star_align
    type: int?
    label: Number of threads
    doc: Number of threads.
    'sbg:x': -690
    'sbg:y': 33.62785720825195
  - id: limitOutSJcollapsed
    type: int?
    label: Max number of collapsed junctions
    doc: Max number of collapsed junctions.
    'sbg:x': -795.79296875
    'sbg:y': -92.24427032470703
  - id: mem_per_star_align
    type: int?
    label: Memory per job
    doc: Amount of RAM memory to be used per job.
    'sbg:x': -918.782470703125
    'sbg:y': -189.21380615234375
outputs:
  - id: out_alignments
    outputSource:
      - gatk_applybqsr_4_1_0_0/out_alignments
    'sbg:fileTypes': 'BAM, SAM, CRAM'
    type: File?
    label: Output recalibrated BAM/SAM/CRAM
    doc: Output recalibrated BAM/SAM/CRAM file.
    'sbg:x': 2278.889892578125
    'sbg:y': -617.44921875
  - id: out_variants
    outputSource:
      - gatk_mergevcfs_4_1_0_0/out_variants
    'sbg:fileTypes': 'VCF, VCF.GZ, BCF'
    type: File?
    label: Output VCF
    doc: Output VCF file.
    'sbg:x': 2655.3984375
    'sbg:y': -385.8646240234375
  - id: out_filtered_variants
    outputSource:
      - gatk_variantfiltration_4_1_0_0/out_variants
    'sbg:fileTypes': VCF.GZ
    type: File?
    label: Output filtered VCF
    doc: Output filtered VCF file.
    'sbg:x': 2750.729248046875
    'sbg:y': -106.19538879394531
steps:
  - id: gatk_applybqsr_4_1_0_0
    in:
      - id: add_output_sam_program_record
        default: 'true'
      - id: bqsr_recal_file
        source: gatk_baserecalibrator_4_1_0_0/output
      - id: in_alignments
        source: gatk_splitncigarreads_4_1_0_0/out_alignments
      - id: in_reference
        source: in_reference
      - id: use_original_qualities
        default: true
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_alignments
    run: steps/gatk_applybqsr_4_1_0_0.cwl
    label: GATK ApplyBQSR
    'sbg:x': 1567.825439453125
    'sbg:y': -247.38088989257812
  - id: gatk_baserecalibrator_4_1_0_0
    in:
      - id: in_alignments
        source: gatk_splitncigarreads_4_1_0_0/out_alignments
      - id: known_indels
        source:
          - known_indels
      - id: known_snps
        source:
          - known_snps
        valueFrom: '$([self])'
      - id: in_reference
        source: in_reference
      - id: use_original_qualities
        default: true
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: output
    run: steps/gatk_baserecalibrator_4_1_0_0.cwl
    label: GATK BaseRecalibrator
    'sbg:x': 1278.3719482421875
    'sbg:y': 18.842971801757812
  - id: gatk_haplotypecaller_4_1_0_0
    in:
      - id: dbsnp
        source: known_snps
      - id: dont_use_soft_clipped_bases
        default: true
      - id: in_alignments
        source:
          - gatk_applybqsr_4_1_0_0/out_alignments
        valueFrom: '$([self])'
      - id: include_intervals
        source: gatk_intervallisttools_4_1_0_0/output_interval_list
      - id: output_prefix
        source: sbg_extract_basename/out_name
      - id: in_reference
        source: in_reference
      - id: standard_min_confidence_threshold_for_calling
        source: standard_min_confidence_threshold_for_calling
    out:
      - id: out_variants
      - id: out_alignments
      - id: out_graph
    run: steps/gatk_haplotypecaller_4_1_0_0.cwl
    label: GATK HaplotypeCaller
    scatter:
      - include_intervals
    'sbg:x': 1927.5069580078125
    'sbg:y': -151.56219482421875
  - id: gatk_intervallisttools_4_1_0_0
    in:
      - id: in_intervals
        source:
          - in_intervals
      - id: scatter_count
        default: 6
        source: scatter_count
      - id: sort
        default: true
      - id: subdivision_mode
        default: BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW
      - id: unique
        default: true
    out:
      - id: output_interval_list
    run: steps/gatk_intervallisttools_4_1_0_0.cwl
    label: GATK IntervalListTools
    'sbg:x': 1680
    'sbg:y': -435.5
  - id: gatk_markduplicates_4_1_0_0
    in:
      - id: create_index
        default: true
      - id: in_alignments
        source:
          - gatk_mergebamalignment_4_1_0_0/out_alignments
        valueFrom: '$([self])'
      - id: validation_stringency
        default: SILENT
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_alignments
      - id: output_metrics
    run: steps/gatk_markduplicates_4_1_0_0.cwl
    label: GATK MarkDuplicates
    'sbg:x': 429.13018798828125
    'sbg:y': -23.46544647216797
  - id: gatk_mergebamalignment_4_1_0_0
    in:
      - id: in_alignments
        source:
          - star_align_2_5_3a_modified/out_aligned_reads
        valueFrom: '$([self])'
      - id: include_secondary_alignments
        default: 'false'
      - id: paired_run
        default: 'false'
      - id: in_reference
        source: in_reference
      - id: unmapped_bam
        source: gatk_revertsam_4_1_0_0/out_alignments
        valueFrom: '$(self[0])'
      - id: validation_stringency
        default: SILENT
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_alignments
    run: steps/gatk_mergebamalignment_4_1_0_0.cwl
    label: GATK MergeBamAlignment
    'sbg:x': 164.83518981933594
    'sbg:y': -137.82554626464844
  - id: gatk_mergevcfs_4_1_0_0
    in:
      - id: in_variants
        linkMerge: merge_flattened
        source:
          - gatk_haplotypecaller_4_1_0_0/out_variants
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_variants
    run: steps/gatk_mergevcfs_4_1_0_0.cwl
    label: GATK MergeVcfs
    'sbg:x': 2178.44580078125
    'sbg:y': -248.1025390625
  - id: gatk_revertsam_4_1_0_0
    in:
      - id: attribute_to_clear
        default:
          - FT
          - CO
      - id: in_alignments
        source: in_alignments
      - id: sort_order
        default: queryname
      - id: validation_stringency
        default: SILENT
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_alignments
    run: steps/gatk_revertsam_4_1_0_0.cwl
    label: GATK RevertSam
    'sbg:x': -743.1947631835938
    'sbg:y': -330.21722412109375
  - id: gatk_samtofastq_4_1_0_0
    in:
      - id: in_alignments
        source: gatk_revertsam_4_1_0_0/out_alignments
        valueFrom: '$(self[0])'
      - id: validation_stringency
        default: SILENT
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_reads
      - id: unmapped_reads
    run: steps/gatk_samtofastq_4_1_0_0.cwl
    label: GATK SamToFastq
    'sbg:x': -537.5
    'sbg:y': -179.5
  - id: gatk_splitncigarreads_4_1_0_0
    in:
      - id: in_alignments
        source: gatk_markduplicates_4_1_0_0/out_alignments
      - id: in_reference
        source: in_reference
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_alignments
    run: steps/gatk_splitncigarreads_4_1_0_0.cwl
    label: GATK SplitNCigarReads
    'sbg:x': 860.520751953125
    'sbg:y': 1.102539300918579
  - id: gatk_variantfiltration_4_1_0_0
    in:
      - id: cluster_size
        default: 3
      - id: cluster_window_size
        default: 35
      - id: filter_expression
        default:
          - '"FS > 30.0"'
          - '"QD < 2.0"'
      - id: filter_name
        default:
          - '"FS"'
          - '"QD"'
      - id: in_reference
        source: in_reference
      - id: in_variants
        source: gatk_mergevcfs_4_1_0_0/out_variants
      - id: output_prefix
        source: sbg_extract_basename/out_name
    out:
      - id: out_variants
    run: steps/gatk_variantfiltration_4_1_0_0.cwl
    label: GATK VariantFiltration
    'sbg:x': 2423.5
    'sbg:y': -106
  - id: sbg_extract_basename
    in:
      - id: in_file
        source: in_alignments
    out:
      - id: out_name
    run: steps/sbg_extract_basename.cwl
    label: SBG Extract Nameroot
    'sbg:x': -948.4229125976562
    'sbg:y': -555.7025146484375
  - id: star_align_2_5_3a_modified
    in:
      - id: cpu_per_job
        source: cpu_per_star_align
      - id: in_index
        source: star_genome_generate_2_5_3a_modified/out_references_or_index
      - id: limitOutSJcollapsed
        source: limitOutSJcollapsed
      - id: mem_per_job
        source: mem_per_star_align
      - id: out_prefix
        source: sbg_extract_basename/out_name
      - id: outSAMtype
        default: BAM
      - id: outSortingType
        default: SortedByCoordinate
      - id: read_length
        source: read_length
      - id: in_reads
        source:
          - gatk_samtofastq_4_1_0_0/out_reads
      - id: runThreadN
        source: cpu_per_star_align
      - id: twopassMode
        default: Basic
    out:
      - id: out_aligned_reads
      - id: out_chimeric_alignments
      - id: out_chimeric_junctions
      - id: out_intermediate_genome
      - id: out_log_files
      - id: out_reads_per_gene
      - id: out_splice_junctions
      - id: out_transcriptome_aligned_reads
      - id: out_unmapped_reads
      - id: out_wiggle_files
    run: steps/star_align_2_5_3a_modified.cwl
    label: STAR Align
    'sbg:x': -181.5723419189453
    'sbg:y': -26
  - id: star_genome_generate_2_5_3a_modified
    in:
      - id: cpu_per_job
        source: cpu_per_job
      - id: mem_per_job
        source: mem_per_job
      - id: in_reference_or_index
        source: in_reference_or_index
      - id: runThreadN
        source: cpu_per_job
      - id: in_gene_annotation
        source: in_gene_annotation
      - id: read_length
        source: read_length
    out:
      - id: out_references_or_index
    run: steps/star_genome_generate_2_5_3a_modified.cwl
    label: STAR Genome Generate
    'sbg:x': -664.0675048828125
    'sbg:y': 227.47145080566406
requirements:
  - class: ScatterFeatureRequirement
'@id': sbg
dct: 'http://purl.org/dc/terms/'
'dct:creator': null
foaf: 'http://xmlns.com/foaf/0.1/'
'foaf:mbox': 'mailto:support@sbgenomics.com'
'foaf:name': SevenBridges
sbg: 'https://sevenbridges.com'
'sbg:appVersion':
  - v1.0
'sbg:categories':
  - Transcriptomics
  - Variant Calling
'sbg:content_hash': a7cd93b6a689ed996463539a672046d65ef7850a1876a5f6b96d65356373f59ca
'sbg:contributors':
  - nemanja.vucic
  - veliborka_josipovic
'sbg:createdBy': nemanja.vucic
'sbg:createdOn': 1555083243
'sbg:id': >-
  uros_sipetic/gatk-rna-seq-best-practice-workflow-4-1-0-0-demo/broad-best-practices-rna-seq-variant-calling-4-1-0-0/8
'sbg:image_url': >-
  https://igor.sbgenomics.com/ns/brood/images/uros_sipetic/gatk-rna-seq-best-practice-workflow-4-1-0-0-demo/broad-best-practices-rna-seq-variant-calling-4-1-0-0/8.png
'sbg:latestRevision': 8
'sbg:license': BSD 3-Clause License
'sbg:links':
  - id: 'https://software.broadinstitute.org/gatk/'
    label: Homepage
  - id: 'https://github.com/broadinstitute/gatk/'
    label: Source Code
  - id: >-
      https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip
    label: Download
  - id: 'https://www.ncbi.nlm.nih.gov/pubmed?term=20644199'
    label: Publications
  - id: 'https://software.broadinstitute.org/gatk/documentation/article.php?id=3891'
    label: Documentation
'sbg:modifiedBy': nemanja.vucic
'sbg:modifiedOn': 1571329771
'sbg:project': uros_sipetic/gatk-rna-seq-best-practice-workflow-4-1-0-0-demo
'sbg:projectName': GATK RNA-Seq Best Practice Workflow 4.1.0.0 - Demo
'sbg:publisher': sbg
'sbg:revision': 8
'sbg:revisionNotes': >-
  STAR aling back to revision 2 Added input port descriptions Updated
  BaseRecalibrator to handle empty list Added note for BaseRecalibrator
  --known-sites options in description Added output descriptions Changed output
  ids
'sbg:revisionsInfo':
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555083243
    'sbg:revision': 0
    'sbg:revisionNotes': null
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555083460
    'sbg:revision': 1
    'sbg:revisionNotes': ''
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555083517
    'sbg:revision': 2
    'sbg:revisionNotes': create image
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555084026
    'sbg:revision': 3
    'sbg:revisionNotes': added CWL1.0 to categories
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555084925
    'sbg:revision': 4
    'sbg:revisionNotes': added descriptions to app settings
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555085202
    'sbg:revision': 5
    'sbg:revisionNotes': added description to Standard minimum confidence
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1555085280
    'sbg:revision': 6
    'sbg:revisionNotes': changed id for variant output file
  - 'sbg:modifiedBy': veliborka_josipovic
    'sbg:modifiedOn': 1561654749
    'sbg:revision': 7
    'sbg:revisionNotes': SamToFastq output glob error fix to support single end files
  - 'sbg:modifiedBy': nemanja.vucic
    'sbg:modifiedOn': 1571329771
    'sbg:revision': 8
    'sbg:revisionNotes': >-
      STAR aling back to revision 2 Added input port descriptions Updated
      BaseRecalibrator to handle empty list Added note for BaseRecalibrator
      --known-sites options in description Added output descriptions Changed
      output ids
'sbg:sbgMaintained': false
'sbg:toolAuthor': Broad Institute
'sbg:validationErrors': []
'sbg:wrapperAuthor': 'veliborka_josipovic, nemanja.vucic'
