$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var x = inputs.in_reference_or_index.path.split('/').pop();\n\
    \    var y = x.split('.').pop();\n    var z = inputs.runThreadN ? inputs.runThreadN\
    \ : 8;\n    if (y == 'fa' || y == 'fasta' || y == 'FA' || y == \"FASTA\") {\n\
    \        return \"mkdir genomeDir && STAR --runMode genomeGenerate --genomeDir\
    \ ./genomeDir --runThreadN \" + z\n    } else if (y == 'tar' || y == 'TAR') {\n\
    \        return \"echo 'Tar bundle provided, skipping indexing.' \"\n    }\n}"
- position: 100
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var tmp1 = [].concat(inputs.in_reference_or_index)[0].path.split('/').pop();\n\
    \    if (inputs.in_gene_annotation) {\n        var tmp2 = [].concat(inputs.in_gene_annotation)[0].path.split('/').pop();\n\
    \    } else if (inputs.in_intervals) {\n        var tmp2 = [].concat(inputs.in_intervals)[0].path.split('/').pop();\n\
    \    } else {\n        var tmp2 = \"\";\n    }\n\n    var str1 = tmp1.split('.');\n\
    \    var x1 = \"\";\n    for (var i = 0; i < str1.length - 1; i++) {\n       \
    \ if (i < str1.length - 2) {\n            x1 = x1 + str1[i] + \".\"\n        }\
    \ else {\n            x1 = x1 + str1[i]\n        }\n    }\n\n    var str2 = tmp2.split('.');\n\
    \    var x2 = \"\";\n    for (var i = 0; i < str2.length - 1; i++) {\n       \
    \ if (i < str2.length - 2) {\n            x2 = x2 + str2[i] + \".\"\n        }\
    \ else {\n            x2 = x2 + str2[i] + \".\"\n        }\n    }\n    var tmp3\
    \ = inputs.in_reference_or_index.path.split('/').pop();\n    var tmp4 = tmp3.split('.').pop();\n\
    \    if (tmp4 == 'tar' || tmp4 == 'TAR') {\n        return \"\"\n    } else {\n\
    \        return \"&& (tar -zvcf \" + x1 + \".\" + x2 + \"star-2.5.3a_modified-index-archive.tar.gz\
    \ genomeDir --warning=no-file-changed || [ $? -eq 1 ])\"\n    }\n}"
- position: 1
  prefix: --limitGenomeGenerateRAM
  shellQuote: false
  valueFrom: "${// --limitGenomeGenerateRAM\n    return inputs.limitGenomeGenerateRAM\
    \ ? inputs.limitGenomeGenerateRAM * 1000000000 : 60000000000\n}"
- position: 2
  prefix: --sjdbOverhang
  shellQuote: false
  valueFrom: "${ // sjdbOverhang\n    return inputs.read_length? inputs.read_length\
    \ -1:null\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "**STAR Genome Generate** produces the necessary index files for successful **STAR**\
  \ alignment, from an input FASTA and GTF files.  \n\n**STAR** (Spliced Transcripts\
  \ Alignment to a Reference), an ultrafast RNA-seq aligner, is capable of mapping\
  \ full length RNA sequences and detecting de novo canonical junctions, non-canonical\
  \ splices, and chimeric (fusion) transcripts. **STAR** employs an RNA-seq alignment\
  \ algorithm that uses sequential maximum mappable seed search in uncompressed suffix\
  \ arrays followed by seed clustering and stitching procedure. It is optimized for\
  \ mammalian sequence reads, but fine tuning of its parameters enables customization\
  \ to satisfy unique needs [1].\n\n*A list of **all inputs and parameters** with\
  \ corresponding descriptions can be found at the bottom of this page.*\n\n### Common\
  \ Use Cases\n\n**STAR Genome Generate** is a tool that generates genome index files.\
  \ One set of files should be generated per each FASTA/GTF combination. Once produced,\
  \ these files could be used as long as FASTA/GTF combination stays the same. Also,\
  \ **STAR Genome Generate** which produced these files and **STAR** aligner using\
  \ them must be of the same toolkit version.\n\n* If the indexes for a desired FASTA/GTF\
  \ pair have already been generated, make sure to supply the resulting TAR bundle\
  \ to the tool input if you are using this tool in a workflow in order to skip unnecessary\
  \ indexing and speed up the whole workflow process.\n* If you are providing a GFF3\
  \ file (which are usually downloaded from **NCBI's RefSeq database**) and wish to\
  \ use **STAR** results for further downstream analysis, a good idea would be to\
  \ set the **Exon parent name** (`--sjdbGTFtagExonParentTranscript`) option to **Parent**.\n\
  * If you wish to run **STAR** in **multiple samples two-pass mode**, you need to\
  \ provide the resulting **splice junction** outputs from **STAR** to the **List\
  \ of annotated junctions** (`--sjdbFileChrStartEnd`) input of **STAR Genome Generate**,\
  \ and generate the index archive with these, instead of supplying the GTF file [2].\
  \ \n\n###Common issues###\n\n* If the reference genome used has a bit number of\
  \ contig sequences (>5000), a suggestion is to set the **Bins size** (`--genomeChrBinNbits`)\
  \ parameter to the value of min(18, log2(GenomeLength/NumberOfReferences)). \n*\
  \ If the reference genome used is a rather small genome, a suggestion is to set\
  \ the **Pre-indexing string length** (`--genomeSAindexNbases`) parameter to the\
  \ value of min(14, log2(GenomeLength)/2 - 1). \n* If **STAR Genome Generates** for\
  \ some reason fails because of insufficient RAM problem, the **Limit Genome Generate\
  \ RAM** (`--limitGenomeGenerateRAM`) parameter can be increased to make the RAM\
  \ demands, though since the default value is 60GB, this should only be happening\
  \ with extremely large reference files (for example, 30GB is enough for the human\
  \ reference genome). \n* The GTF and FASTA files need to have compatible transcript\
  \ IDs and chromosome names.\n\n### Changes Introduced by Seven Bridges\n\n* The\
  \ directory containing the index files will be outputted as a TAR bundle (the **Genome\
  \ files** output). This bundle can then be provided to the **STAR** aligner, which\
  \ will automatically take care of untarring it and preparing it to run successfully\
  \ without further issues. \n\n### Performance Benchmarking\n\nSince **STAR Genome\
  \ Generate** is run with a FASTA/GTF combination, the runtime of this tool will\
  \ be pretty much constant across a number of different genomes. For the human reference\
  \ genome, the tool is expected to finish in around 30 minutes, costing around $0.75\
  \ on the c4.8xlarge AWS instance. \n\n*Cost can be significantly reduced by using\
  \ **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances)\
  \ for more details.*\n\n### References\n\n[1] [STAR paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3530905/)\n\
  [2] [STAR manual](http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/STAR.sandbox/doc/STARmanual.pdf)"
id: nemanja.vucic/star-2-5-3a-modified-demo/star-genome-generate-2-5-3a_modified/3
inputs:
- doc: Number of CPUs to be used per job.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform options
  sbg:toolDefaultValue: '1'
  type: int?
- doc: 'Set log2(chrBin), where chrBin is the size (bits) of the bins for genome storage:
    each chromosome will occupy an integer number of bins. If you are using a genome
    with a large (>5,000) number of chrosomes/scaffolds, you may need to reduce this
    number to reduce RAM consumption. The following scaling is recomended: genomeChrBinNbits
    = min(18, log2(GenomeLength/NumberOfReferences)). For example, for 3 gigaBase
    genome with 100,000 chromosomes/scaffolds, this is equal to 15.'
  id: genomeChrBinNbits
  inputBinding:
    position: 1
    prefix: --genomeChrBinNbits
    shellQuote: false
  label: Bins size
  sbg:category: Genome generation parameters
  sbg:toolDefaultValue: '18'
  type: int?
- doc: Length (bases) of the SA pre-indexing string. Typically between 10 and 15.
    Longer strings will use much more memory, but allow faster searches. For small
    genomes, this number needs to be scaled down, with a typical value of min(14,
    log2(GenomeLength)/2 - 1). For example, for 1 megaBase genome, this is equal to
    9, for 100 kiloBase genome, this is equal to 7.
  id: genomeSAindexNbases
  inputBinding:
    position: 1
    prefix: --genomeSAindexNbases
    shellQuote: false
  label: Pre-indexing string length
  sbg:category: Genome generation parameters
  sbg:toolDefaultValue: '14'
  type: int?
- doc: 'Distance between indices: use bigger numbers to decrease needed RAM at the
    cost of mapping speed reduction (int>0).'
  id: genomeSAsparseD
  inputBinding:
    position: 1
    prefix: --genomeSAsparseD
    shellQuote: false
  label: Suffux array sparsity
  sbg:category: Genome generation parameters
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Maximum length of the suffixes, has to be longer than read length. -1 = infinite.
  id: genomeSuffixLengthMax
  inputBinding:
    position: 1
    prefix: --genomeSuffixLengthMax
    shellQuote: false
  label: Maximum genome suffic length
  sbg:category: Genome generation parameters
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: Upper RAM limit for genome generation, in GB.
  id: limitGenomeGenerateRAM
  label: Limit Genome Generate RAM
  sbg:category: Run parameters
  sbg:toolDefaultValue: '60'
  type: int?
- doc: Amount of RAM memory to be used per job. Defaults to 2048MB for Single threaded
    jobs,and all of the available memory on the instance for multi-threaded jobs.
  id: mem_per_job
  label: Memory per job
  sbg:category: Platform options
  sbg:toolDefaultValue: '2048'
  type: int?
- doc: Reference sequence to which to align the reads, or a TAR bundle containing
    already generated indices.
  id: in_reference_or_index
  inputBinding:
    position: 1
    prefix: --genomeFastaFiles
    shellQuote: false
  label: Reference/Index files
  sbg:category: Basic
  sbg:fileTypes: FASTA, FA, FNA, TAR
  secondaryFiles:
  - "${ \n    return self.basename + \".fai\";\n}"
  type: File
- doc: Number of threads to use.
  id: runThreadN
  label: Number of threads
  sbg:category: Run parameters
  sbg:toolDefaultValue: '16'
  type: int?
- doc: List of splice junction coordinates in a tab-separated file.
  id: in_intervals
  inputBinding:
    position: 1
    prefix: --sjdbFileChrStartEnd
    shellQuote: false
  label: List of annotated junctions
  sbg:category: Basic
  sbg:fileTypes: TXT, SJDB, TAB
  type: File[]?
- doc: Prefix for chromosome names in a GTF file (e.g. 'chr' for using ENSMEBL annotations
    with UCSC geneomes).
  id: sjdbGTFchrPrefix
  inputBinding:
    position: 1
    prefix: --sjdbGTFchrPrefix
    shellQuote: false
  label: Chromosome names
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: '-'
  type: string?
- doc: Feature type in GTF file to be used as exons for building transcripts.
  id: sjdbGTFfeatureExon
  inputBinding:
    position: 1
    prefix: --sjdbGTFfeatureExon
    shellQuote: false
  label: Set exons feature
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: exon
  type: string?
- doc: 'Gene annotation file in GTF/GFF format. If you are providing a GFF3 file and
    wish to use STAR results for further downstream analysis, a good idea would be
    to set the "Exons'' parents name" (id: sjdbGTFtagExonParentTranscript) option
    to "Parent".'
  id: in_gene_annotation
  inputBinding:
    itemSeparator: ' '
    position: 1
    prefix: --sjdbGTFfile
    shellQuote: false
  label: Gene annotation file
  sbg:category: Basic
  sbg:fileTypes: GTF, GFF, GFF2, GFF3
  type: File?
- doc: Tag name to be used as exons gene-parents.
  id: sjdbGTFtagExonParentGene
  inputBinding:
    position: 1
    prefix: --sjdbGTFtagExonParentGene
    shellQuote: false
  label: Gene name
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: gene_id
  type: string?
- doc: Tag name to be used as exons transcript-parents.
  id: sjdbGTFtagExonParentTranscript
  inputBinding:
    position: 1
    prefix: --sjdbGTFtagExonParentTranscript
    shellQuote: false
  label: Exon parent name
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: transcript_id
  type: string?
- doc: Length of the donor/acceptor sequence on each side of the junctions, ideally
    = (mate_length - 1) (int >= 0), if int = 0, splice junction database is not used.
  id: sjdbOverhang
  inputBinding:
    position: 1
    prefix: --sjdbOverhang
    shellQuote: false
  label: '"Overhang" length'
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Extra alignment score for alignments that cross database junctions.
  id: sjdbScore
  inputBinding:
    position: 1
    prefix: --sjdbScore
    shellQuote: false
  label: Extra alignment score
  sbg:category: Splice junctions db parameters
  sbg:toolDefaultValue: '2'
  type: int?
- doc: The length of the reads.
  id: read_length
  label: Read length
  sbg:toolDefaultValue: '100'
  type: int?
label: STAR Genome Generate
outputs:
- doc: Genome files comprise binary genome sequence, suffix arrays, text chromosome
    names/lengths, splice junctions coordinates, and transcripts/genes information.
  id: out_references_or_index
  label: Genome Files
  outputBinding:
    glob: '*.tar*'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reference_or_index);\n\
      \n}"
  sbg:fileTypes: TAR
  type: File?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 8\n}"
  ramMin: "${\n  var memory = 60000;\n  \n  if(inputs.mem_per_job){\n  \t memory =\
    \ inputs.mem_per_job\n  }\n  else if(inputs.limitGenomeGenerateRAM){\n  memory\
    \ = inputs.limitGenomeGenerateRAM *1000\n  }\n  return memory\n}"
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/veliborka_josipovic/star:2.5.3a_modified
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.in_reference_or_index)
  - $(inputs.in_gene_annotation)
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
sbg:appVersion:
- v1.0
sbg:categories:
- Transcriptomics
- Alignment
sbg:cmdPreview: mkdir genomeDir && STAR --runMode genomeGenerate --genomeDir ./genomeDir
  --runThreadN 5 --genomeFastaFiles /sbgenomics/test-data/chr20.fa  && tar -vcf chr20.sjdbGTFfile.star-2.7.0d-index-archive.tar
  ./genomeDir   && mv Log.out Log.out.log
sbg:content_hash: ac9ece6bf938e08631f0059eb7ac80b329ad0974821cb98eb69747caece76d7d4
sbg:contributors:
- nemanja.vucic
sbg:createdBy: nemanja.vucic
sbg:createdOn: 1553263068
sbg:id: nemanja.vucic/star-2-5-3a-modified-demo/star-genome-generate-2-5-3a_modified/3
sbg:image_url: null
sbg:latestRevision: 3
sbg:license: GNU General Public License v3.0 only
sbg:links:
- id: https://github.com/alexdobin/STAR
  label: Homepage
- id: https://github.com/alexdobin/STAR
  label: Source Code
- id: https://github.com/alexdobin/STAR/archive/2.7.0d.tar.gz
  label: Download
- id: https://www.ncbi.nlm.nih.gov/pubmed/23104886
  label: Publication
- id: http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/STAR.sandbox/doc/STARmanual.pdf
  label: Documentation
sbg:modifiedBy: nemanja.vucic
sbg:modifiedOn: 1559667429
sbg:project: nemanja.vucic/star-2-5-3a-modified-demo
sbg:projectName: STAR 2.5.3a_modified - Demo
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: fixed secondaryFiles expression
sbg:revisionsInfo:
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1553263068
  sbg:revision: 0
  sbg:revisionNotes: null
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1553263087
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559664996
  sbg:revision: 2
  sbg:revisionNotes: tested with cwltool
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559667429
  sbg:revision: 3
  sbg:revisionNotes: fixed secondaryFiles expression
sbg:sbgMaintained: false
sbg:toolAuthor: Alexander Dobin/CSHL
sbg:toolkit: STAR
sbg:toolkitVersion: 2.5.3a_modified
sbg:validationErrors: []
