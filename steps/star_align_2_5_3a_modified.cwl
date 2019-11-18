$namespaces:
  sbg: https://sevenbridges.com
arguments:
- position: 0
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    if (inputs.in_reads) {\n\n        var list = [].concat(inputs.in_reads);\n\
    \        var ext = list[0].path.split('.').pop().toLowerCase();\n\n        if\
    \ (ext == 'bam' || ext == 'sam') {\n            var bam_file = list[0].path;\n\
    \            var cmd_line = \"str='SE' && count=`samtools view -h \" + bam_file\
    \ + \" | head -n 500000 | samtools view -c -f 0x1 -`\";\n            var cmd_line\
    \ = cmd_line + \" && if [ $count != 0 ]; then str='PE'; fi;\";\n            return\
    \ cmd_line\n        } else {\n            return \"\"\n        }\n    }\n}"
- position: 1
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var cpus = inputs.runThreadN ? inputs.runThreadN : 8;\n\n  \
    \  var STAR = inputs.starlong ? \"STARlong\" : \"STAR\";\n    var index_ext =\
    \ inputs.in_index.path.split('.').pop();\n    \n    if(index_ext.toLowerCase()\
    \ == 'gz'){\n        var prefix = ' -xvzf ';\n    }\n    else if(index_ext.toLowerCase()\
    \ == 'tar'){\n        var prefix = ' -xvf ';\n    }\n    \n\n    return \"tar\"\
    \ + prefix + inputs.in_index.path + \" && \" + STAR + \" --runThreadN \" + cpus;\n\
    }"
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    var arr = [].concat(inputs.in_reads);\n    var ext = arr[0].path.split('.').pop().toLowerCase();\n\
    \    \n    if (ext == \"gz\") {\n        return \"--readFilesCommand gunzip -c\"\
    ;\n    } else if (ext == \"bz2\") {\n        return \"--readFilesCommand bzcat\"\
    ;\n    } else if (ext == 'bam') {\n        return \"--readFilesCommand samtools\
    \ view -h\";\n    } else {\n        return \"\"\n    }\n}"
- position: 102
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    // if genomic coordinates are provided\n    var out_ext;\n \
    \   if (inputs.in_intervals) {\n        var out_ext = \".twopass-multiple.\";\n\
    \    } \n    else if (inputs.twopassMode == 'Basic') {\n        var out_ext =\
    \ \".twopass-basic.\";\n    }\n    else {\n        var out_ext = \".\";\n    }\n\
    \    \n    var intermediate;\n    var source;\n    var destination;\n    // if\
    \ output name option is set\n    if(inputs.out_prefix){\n        intermediate\
    \ = inputs.out_prefix + out_ext + \"_STARgenome\"\n        source = \"./\".concat(intermediate)\n\
    \        destination = intermediate.concat(\".tar\")\n    } else {\n        var\
    \ in_prefix;\n        var in_num = [].concat(inputs.in_reads).length;\n      \
    \  // create output file name if there is one input file\n        if(in_num ==\
    \ 1){\n            var in_reads = [].concat(inputs.in_reads)[0];\n           \
    \ // check if the sample_id metadata value is defined for the input file\n   \
    \         if(in_reads.metadata && in_reads.metadata.sample_id){\n            \
    \    in_prefix = in_reads.metadata.sample_id\n            // if sample_id is not\
    \ defined\n            } else {\n                in_prefix = [].concat(inputs.in_reads)[0].nameroot\n\
    \            }\n            intermediate = in_prefix + out_ext + \"_STARgenome\"\
    \n            source = \"./\".concat(intermediate)\n            destination =\
    \ intermediate.concat(\".tar\")\n        }\n        // create output file name\
    \ if there are more than one input files\n        else if(in_num > 1){\n     \
    \       var in_reads = [].concat(inputs.in_reads);\n            var in_sample_ids\
    \ = [];\n            var in_read_names = [];\n            for (var i = 0; i <\
    \ in_reads.length; i++) {\n                // check if the sample_id metadata\
    \ value is defined for the input file\n                if(in_reads[i].metadata\
    \ && in_reads[i].metadata.sample_id){\n                    in_sample_ids.push(in_reads[i].metadata.sample_id)\n\
    \                } else {\n                    in_sample_ids.push('')\n      \
    \          }\n                in_read_names.push(in_reads[i].nameroot)\n     \
    \       }\n            if(in_sample_ids.length != 0){\n                in_prefix\
    \ = in_sample_ids.sort()[0]\n            // if sample_id is not defined\n    \
    \        } else {\n                in_prefix = in_read_names.sort()[0]\n     \
    \       }\n            intermediate = in_prefix + '.' + in_num + out_ext + \"\
    _STARgenome\"\n            source = \"./\".concat(intermediate)\n            destination\
    \ = intermediate.concat(\".tar\")\n        }\n    }\n    if ((inputs.in_gene_annotation\
    \ || inputs.in_intervals) && inputs.sjdbInsertSave && inputs.sjdbInsertSave !=\
    \ \"None\") {\n        return \"&& tar -vcf \".concat(destination, \" \", source);\n\
    \    } else {\n        return \"\";\n    }\n}"
- position: 2
  prefix: --outFileNamePrefix
  shellQuote: false
  valueFrom: "${\n    // if output name option is set\n    if(inputs.out_prefix){\n\
    \        return inputs.out_prefix + \".\";\n    } else {\n        // if genomic\
    \ coordinates are provided\n        var out_ext;\n        if (inputs.in_intervals)\
    \ {\n            out_ext = \".twopass-multiple.\";\n        } \n        else if\
    \ (inputs.twopassMode == 'Basic') {\n            out_ext = \".twopass-basic.\"\
    ;\n        }\n        else {\n            out_ext = \".\";\n        }\n      \
    \  var in_prefix;\n        var in_num = [].concat(inputs.in_reads).length;\n \
    \       // create output file name if there is one input file\n        if(in_num\
    \ == 1){\n            var in_reads = [].concat(inputs.in_reads)[0];\n        \
    \    // check if the sample_id metadata value is defined for the input file\n\
    \            if(in_reads.metadata && in_reads.metadata.sample_id){\n         \
    \       in_prefix = in_reads.metadata.sample_id\n            // if sample_id is\
    \ not defined\n            } else {\n                in_prefix = [].concat(inputs.in_reads)[0].nameroot\n\
    \            }\n            return in_prefix + out_ext;\n        }\n        //\
    \ create output file name if there are more than one input files\n        else\
    \ if(in_num > 1){\n            var in_reads = [].concat(inputs.in_reads);\n  \
    \          var in_sample_ids = [];\n            var in_read_names = [];\n    \
    \        for (var i = 0; i < in_reads.length; i++) {\n                // check\
    \ if the sample_id metadata value is defined for the input file\n            \
    \    if(in_reads[i].metadata && in_reads[i].metadata.sample_id){\n           \
    \         in_sample_ids.push(in_reads[i].metadata.sample_id)\n               \
    \ }\n                in_read_names.push(in_reads[i].nameroot)\n            }\n\
    \            if(in_sample_ids.length != 0){\n                in_prefix = in_sample_ids.sort()[0]\n\
    \            // if sample_id is not defined\n            } else {\n          \
    \      in_prefix = in_read_names.sort()[0]\n            }\n            return\
    \ in_prefix + '.' + in_num + out_ext;\n        }\n    }\n}"
- position: 103
  prefix: ''
  shellQuote: false
  valueFrom: "${\n    // if genomic coordinates are provided\n    var out_ext;\n \
    \   if (inputs.in_intervals) {\n        out_ext = \".twopass-multiple.\"\n   \
    \ } \n    else if (inputs.twopassMode == 'Basic') {\n        out_ext = \".twopass-basic.\"\
    \n    }\n    else {\n        out_ext = \".\" \n    }\n    \n    // if output name\
    \ option is set\n    if(inputs.out_prefix){\n        var in_prefix = inputs.out_prefix\
    \ + out_ext;\n    }\n    else {\n        var in_prefix;\n        var in_num =\
    \ [].concat(inputs.in_reads).length;\n        // create output file name if there\
    \ is one input file\n        if(in_num == 1){\n            var in_reads = [].concat(inputs.in_reads)[0]\n\
    \            // check if the sample_id metadata value is defined for the input\
    \ file\n            if(in_reads.metadata && in_reads.metadata.sample_id){\n  \
    \              in_prefix = in_reads.metadata.sample_id\n            // if sample_id\
    \ is not defined\n            } else {\n                in_prefix = [].concat(inputs.in_reads)[0].nameroot\
    \ + out_ext\n            }\n        }\n        // create output file name if there\
    \ are more than one input files\n        else if(in_num > 1){\n            var\
    \ in_reads = [].concat(inputs.in_reads);\n            var in_sample_ids = [];\n\
    \            var in_read_names = [];\n            for (var i = 0; i < in_reads.length;\
    \ i++) {\n                // check if the sample_id metadata value is defined\
    \ for the input file\n                if(in_reads[i].metadata && in_reads[i].metadata.sample_id){\n\
    \                    in_sample_ids.push(in_reads[i].metadata.sample_id)\n    \
    \            } else {\n                    in_sample_ids.push('')\n          \
    \      }\n                in_read_names.push(in_reads[i].nameroot)\n         \
    \   }\n            if(in_sample_ids.length != 0){\n                in_prefix =\
    \ in_sample_ids.sort()[0] + '.' + in_num + out_ext\n            // if sample_id\
    \ is not defined\n            } else {\n                in_prefix = in_read_names.sort()[0]\
    \ + '.' + in_num + out_ext\n            }\n        }\n    }\n    var mate1 = in_prefix.concat(\"\
    Unmapped.out.mate1\");\n    var mate2 = in_prefix.concat(\"Unmapped.out.mate2\"\
    );\n    var arr = [].concat(inputs.in_reads);\n    var x = arr[0].path.split('/').pop();\n\
    \    var y = x.toLowerCase();\n\n    if (inputs.unmappedOutputName) {\n      \
    \  var output_name = inputs.unmappedOutputName + \".\";\n    } else {\n      \
    \  var output_name = \"Unmapped.out.\";\n    }\n\n    var mate1_1 = in_prefix.concat(output_name\
    \ + \"mate1\");\n    var mate2_1 = in_prefix.concat(output_name + \"mate2\");\n\
    \n\n    if (y.endsWith('fastq') || y.endsWith('fq') || y.endsWith('fastq.gz')\
    \ || y.endsWith('fastq.bz2') || y.endsWith('fq.gz') || y.endsWith('fq.bz2') ||\
    \ y.endsWith('bam') || y.endsWith('sam')) {\n        var mate1fq = mate1_1.concat(\"\
    .fastq\");\n        var mate2fq = mate2_1.concat(\".fastq\");\n    } else if (y.endsWith('fasta')\
    \ || y.endsWith('fa') || y.endsWith('fasta.gz') || y.endsWith('fasta.bz2') ||\
    \ y.endsWith('fa.gz') || y.endsWith('fa.bz2')) {\n        var mate1fq = mate1_1.concat(\"\
    .fasta\");\n        var mate2fq = mate2_1.concat(\".fasta\");\n    }\n\n\n   \
    \ if (inputs.sortUnmappedReads) {\n\n        var cmd = \"\";\n        var sort_cmd\
    \ = \" | sed 's/\\\\t.*//' | paste - - - - | sort -k1,1 -S 10G | tr '\\\\t' '\\\
    \\n' > \";\n        if (inputs.outReadsUnmapped == \"Fastx\" && arr.length > 1)\
    \ {\n            cmd = cmd.concat(\" && cat \", mate2, sort_cmd, mate2fq, \" &&\
    \ rm \", mate2)\n        }\n        else if (inputs.outReadsUnmapped == \"Fastx\"\
    ) {\n            cmd = cmd.concat(\" && cat \", mate1, sort_cmd, mate1fq, \" &&\
    \ rm \", mate1)\n        }\n        return cmd;\n\n    } else {\n\n        if\
    \ (inputs.outReadsUnmapped == \"Fastx\" && arr.length > 1) {\n            return\
    \ \"&& mv \".concat(mate1, \" \", mate1fq, \" && mv \", mate2, \" \", mate2fq);\n\
    \        } else if (inputs.outReadsUnmapped == \"Fastx\" && arr.length == 1) {\n\
    \            return \"&& mv \".concat(mate1, \" \", mate1fq);\n        } else\
    \ {\n            return \"\";\n        }\n\n    }\n}"
- position: 2
  prefix: --genomeDir
  shellQuote: false
  valueFrom: "${ // --genomeDir               \n    return inputs.genomeDirName ?\
    \ inputs.genomeDirName : \"genomeDir\";\n}"
- position: 2
  prefix: --limitBAMsortRAM
  shellQuote: false
  valueFrom: "${//--limitBAMsortRAM\n  var memory = 46080;\n  if(inputs.mem_per_job){\n\
    \  \t memory = inputs.mem_per_job\n  }\n\n  return memory * 1000000;\n}\n"
- position: 2
  prefix: ''
  shellQuote: false
  valueFrom: "${// --outSAMtype SAM\n    var SAM_type = inputs.outSAMtype;\n    var\
    \ SORT_type = inputs.outSortingType;\n    if (SAM_type && SORT_type) {\n     \
    \   if (SAM_type == \"SAM\") {\n            return \"--outSAMtype SAM\";\n   \
    \     } else {\n            return \"--outSAMtype \".concat(SAM_type, \" \", SORT_type);\n\
    \        }\n    } else if (SAM_type && SORT_type == null) {\n        if (SAM_type\
    \ == \"SAM\") {\n            return \"--outSAMtype SAM\";\n        } else {\n\
    \            return \"--outSAMtype \".concat(SAM_type, \" Unsorted\");\n     \
    \   }\n    } else {\n        if (SORT_type) {\n            return \"--outSAMtype\
    \ \".concat(\"BAM\", \" \", SORT_type);\n        } else {\n            return\
    \ \"--outSAMtype \".concat(\"BAM\", \" Unsorted\");\n        }\n    }\n}"
- position: 2
  prefix: --alignTranscriptsPerReadNmax
  shellQuote: false
  valueFrom: "${// --alignTranscriptsPerReadNmax\n    if (inputs.alignTranscriptsPerReadNmax)\
    \ {\n        return inputs.alignTranscriptsPerReadNmax;\n    } else if (inputs.starlong)\
    \ {\n        return 100000;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --alignTranscriptsPerWindowNmax
  shellQuote: false
  valueFrom: "${// --alignTranscriptsPerWindowNmax\n    if (inputs.alignTranscriptsPerWindowNmax)\
    \ {\n        return inputs.alignTranscriptsPerWindowNmax;\n    } else if (inputs.starlong)\
    \ {\n        return 10000;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --bamRemoveDuplicatesMate2basesN
  shellQuote: false
  valueFrom: "${// --bamRemoveDuplicatesMate2basesN\n    var x = inputs.in_reads;\n\
    \    if (x.length == 2 && inputs.bamRemoveDuplicatesMate2basesN && inputs.bamRemoveDuplicatesType)\
    \ {\n        return inputs.bamRemoveDuplicatesMate2basesN;\n    } else {\n   \
    \     return null;\n    }\n}"
- position: 2
  prefix: --bamRemoveDuplicatesType
  shellQuote: false
  valueFrom: "${// --bamRemoveDuplicatesType\n    var x = inputs.in_reads;\n    if\
    \ (x.length == 2 && inputs.bamRemoveDuplicatesType) {\n        return inputs.bamRemoveDuplicatesType;\n\
    \    } else {\n        return null;\n    }\n\n}"
- position: 2
  prefix: --outFilterMismatchNmax
  shellQuote: false
  valueFrom: "${// --outFilterMismatchNmax\n    if (inputs.outFilterMismatchNmax)\
    \ {\n        return inputs.outFilterMismatchNmax;\n    } else if (inputs.starlong)\
    \ {\n        return 1000;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --outFilterMultimapScoreRange
  shellQuote: false
  valueFrom: "${// --outFilterMultimapScoreRange\n    if (inputs.outFilterMultimapScoreRange)\
    \ {\n        return inputs.outFilterMultimapScoreRange;\n    } else if (inputs.starlong)\
    \ {\n        return 20;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --outFilterScoreMinOverLread
  shellQuote: false
  valueFrom: "${// --outFilterScoreMinOverLread\n    if (inputs.outFilterScoreMinOverLread)\
    \ {\n        return inputs.outFilterScoreMinOverLread;\n    } else if (inputs.starlong)\
    \ {\n        return \"0\";\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --outWigNorm
  shellQuote: false
  valueFrom: "${// --outWigNorm\n    if (inputs.outWigType && inputs.outWigNorm) {\n\
    \        return inputs.outWigNorm;\n    } else {\n        return null;\n    }\n\
    }"
- position: 2
  prefix: --outWigReferencePrefix
  shellQuote: false
  valueFrom: "${// --outWigReferencePrefix\n    if (inputs.outWigType && inputs.outWigReferencePrefix)\
    \ {\n        return inputs.outWigReferencePrefix;\n    } else {\n        return\
    \ null;\n    }\n}"
- position: 2
  prefix: --outWigStrand
  shellQuote: false
  valueFrom: "${// --outWigStrand\n    if (inputs.outWigType && inputs.outWigStrand)\
    \ {\n        return inputs.outWigStrand;\n    } else {\n        return null;\n\
    \    }\n}"
- position: 2
  prefix: --varVCFfile
  shellQuote: false
  valueFrom: "${ // --varVCFfile\n    if (inputs.in_variants) {\n        var vcf =\
    \ [].concat(inputs.in_variants)[0];\n        if (vcf.path.toLowerCase().endsWith('gz'))\
    \ {\n            return \"<(zcat \" + vcf.path + \")\";\n        } else {\n  \
    \          return vcf.path;\n        }\n    } else {\n        return null;\n \
    \   }\n}"
- position: 2
  prefix: --seedPerReadNmax
  shellQuote: false
  valueFrom: "${// --seedPerReadNmax\n    if (inputs.seedPerReadNmax) {\n        return\
    \ inputs.seedPerReadNmax;\n    } else if (inputs.starlong) {\n        return 100000;\n\
    \    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --seedPerWindowNmax
  shellQuote: false
  valueFrom: "${// --seedPerWindowNmax\n    if (inputs.seedPerWindowNmax) {\n    \
    \    return inputs.seedPerWindowNmax;\n    } else if (inputs.starlong) {\n   \
    \     return 100;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --seedSearchLmax
  shellQuote: false
  valueFrom: "${// --seedSearchLmax\n    if (inputs.seedSearchLmax) {\n        return\
    \ inputs.seedSearchLmax;\n    } else if (inputs.starlong) {\n        return 30;\n\
    \    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --seedSearchStartLmax
  shellQuote: false
  valueFrom: "${// --seedSearchStartLmax\n    if (inputs.seedSearchStartLmax) {\n\
    \        return inputs.seedSearchStartLmax;\n    } else if (inputs.starlong) {\n\
    \        return 12;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --winAnchorMultimapNmax
  shellQuote: false
  valueFrom: "${// --winAnchorMultimapNmax\n    if (inputs.winAnchorMultimapNmax)\
    \ {\n        return inputs.winAnchorMultimapNmax;\n    } else if (inputs.starlong)\
    \ {\n        return 200;\n    } else {\n        return null;\n    }\n}"
- position: 2
  prefix: --sjdbOverhang
  shellQuote: false
  valueFrom: "${ // sjdbOverhang\n    return inputs.read_length? inputs.read_length\
    \ -1: null;\n}"
baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
doc: "**STAR** is an ultrafast universal RNA-seq aligner. \n\n**STAR** (Spliced Transcripts\
  \ Alignment to a Reference), an ultrafast RNA-seq aligner, is capable of mapping\
  \ full length RNA sequences and detecting de novo canonical junctions, non-canonical\
  \ splices, and chimeric (fusion) transcripts. **STAR** employs an RNA-seq alignment\
  \ algorithm that uses sequential maximum mappable seed search in uncompressed suffix\
  \ arrays followed by seed clustering and stitching procedure. It is optimized for\
  \ mammalian sequence reads, but fine tuning of its parameters enables customization\
  \ to satisfy unique needs [1].\n\n**STAR** works with reads starting from lengths\
  \ ~15 bases up to ~300 bases. In case of having longer reads, the use of **STAR\
  \ Long** tool is recommended instead.\n\n*A list of **all inputs and parameters**\
  \ with corresponding descriptions can be found at the bottom of this page.*\n\n\
  ### Common Use Cases\n\nThe main purpose of **STAR** is to generate aligned BAM\
  \ files (in genome and transcriptome coordinates) from RNA-seq data, which can later\
  \ be used in further RNA studies, like gene expression analysis for example. \n\n\
  Some important notes about this tool are: \n\n- The main input to the tool are **Reads**\
  \ (`--readFilesIn`) in FASTQ format (single end or paired end), or unaligned BAM\
  \ format.\n- **Genome files** in the form of a **STAR index archive**, outputted\
  \ by the **STAR Genome Generate** tool, also need to be provided.\n- It\u2019s generally\
  \ a good idea to always provide a GTF file to the inputs, if you want to get the\
  \ **Transcriptome aligned reads** and **Reads per gene** outputs. \n- The main output\
  \ of this tool is the **Aligned reads** output in coordinate sorted BAM format.\
  \ The **Transcriptome aligned reads** BAM file is produced if the **Quantification\
  \ mode** (`--quantMode`) parameter is set to **TranscriptomeSAM**. \n- Gene counts\
  \ are produced if the **Quantification mode** (`--quantMode`) parameter is set to\
  \ **GeneCounts**.  \n- **STAR** can detect chimeric transcripts, but the parameter\
  \ **Min chimeric segment** (`--chimSegmentMin`) in *Chimeric Alignments*  category\
  \ must be adjusted to a desired minimum chimeric segment length (12 is a good value,\
  \ as recommended by the **STAR-Fusion** wiki). This output can later be used in\
  \ **STAR-Fusion** for further fusion analysis. \n- If you want to use **STAR** results\
  \ as an input to an RNA-seq differential expression analysis(using the **Cufflinks**\
  \ app), set the parameter **Strand field flag** (`--outSAMstrandField`) to **intronMotif**.\n\
  - Unmapped reads in FASTQ format are outputted on the **Unmapped reads** output\
  \ if the **Output unmapped reads** (`--outReadsUnmapped`) parameter is set to the\
  \ **Fastx** value. \n- Unmapped reads can be outputted within the main out BAM file\
  \ on the **Aligned reads** and **Transcriptome aligned reads** outputs if the **Write\
  \ unmapped in SAM** (`--outSAMunmapped`) parameter is set to **Within** or **Within\
  \ KeepPairs**. \n- A basic **Two-pass mode** can be turned during the alignment\
  \ step, which means that all the first pass junctions will be inserted into the\
  \ genome indices for the second pass, by setting the **Two-pass mode** (`--twopassMode`)\
  \ option to **Basic**. \n\nAdditionally, if you have long reads available and wish\
  \ to map them with STAR, setting the **STARlong** option will run the **STARlong**\
  \ algorithm instead, which uses a more efficient seed stitching algorithm for long\
  \ reads (>200b), and also uses different array allocations. Selecting this boolean\
  \ option will also automatically change the following parameters of STAR to comply\
  \ with long read alignment best practices:\n`--outFilterMultimapScoreRange 20`\n\
  `--outFilterScoreMinOverLread 0`\n`--outFilterMismatchNmax 1000`\n`--winAnchorMultimapNmax\
  \ 200`\n`--seedSearchLmax 30`\n`--seedSearchStartLmax 12`\n`--seedPerReadNmax 100000`\n\
  `--seedPerWindowNmax 100`\n`--alignTranscriptsPerReadNmax 100000`\n`--alignTranscriptsPerWindowNmax\
  \ 10000`\n\n###Common issues###\n- For paired-end read files, it is important to\
  \ properly set the **Paired-end** metadata field on your read files.\n- For FASTQ\
  \ reads in multi-file format (i.e. two FASTQ files for paired-end 1 and two FASTQ\
  \ files for paired-end2), the proper metadata needs to be set (the following hierarchy\
  \ is valid: **Sample ID/Library ID/Platform Unit ID/File Segment Number**).\n\n\
  ### Changes Introduced by Seven Bridges\n\n- All output files will be prefixed by\
  \ the input sample ID (inferred from the **Sample ID** metadata if existent, of\
  \ from filename otherwise), unless the **Output file name prefix** option is explicitly\
  \ specified.\n- **Unmapped reads** in FASTQ format are by default unsorted by read\
  \ ID. This can induce problems if these files are used in subsequent analysis (i.e.\
  \ downstream alignment). The option to sort unmapped reads by read ID is added to\
  \ this wrapper, by setting the **Sort unmapped reads** parameter to True. The suffix\
  \ for the **Unmapped reads** output can be controlled by the **Unmapped output file\
  \ names** options (the default is *Unmapped*).\n- The tool can accept uncompressed\
  \ FASTQ files, as well as GZ and BZ2 compressed FASTQ files, without the user having\
  \ to specify anything. Also, if unaligned BAM files are used as inputs, the single-end/paired-end\
  \ flag (SE/PE) needn't be specified - it will be inferred automatically using a\
  \ built-in **Samtools** script. \n\n### Performance Benchmarking\n\nBelow is a table\
  \ describing the runtimes and task costs for a couple of samples with different\
  \ file sizes, with the following options in mind - unmapped reads are sorted by\
  \ read id, output BAM is sorted by coordinate and basic two pass mode is turned\
  \ on:\n\n| Experiment type |  Input size | Paired-end | # of reads | Read length\
  \ | Duration |  Cost |  Instance (AWS) |\n|:---------------:|:-----------:|:----------:|:----------:|:-----------:|:--------:|:-----:|:----------:|\n\
  |     RNA-Seq     |  2 x 230 MB |     Yes    |     1M     |     101     |   18min\
  \   | $0.40 | c4.8xlarge |\n|     RNA-Seq     |  2 x 4.5 GB |     Yes    |     20M\
  \     |     101     |   30min   | $0.60 | c4.8xlarge |\n|     RNA-Seq     | 2 x\
  \ 17.4 GB |     Yes    |     76M    |     101     |   64min  | $1.20 | c4.8xlarge\
  \ |\n\n*Cost can be significantly reduced by using **spot instances**. Visit the\
  \ [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for\
  \ more details.*\n\n### References\n\n[1] [STAR paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3530905/)"
id: nemanja.vucic/star-2-5-3a-modified-demo/star-align-2-5-3a_modified/6
inputs:
- doc: 'Allow protrusion of alignment ends, i.e. start (end) of the +strand mate downstream
    of the start (end) of the -strand mate. The input should two arguments separated
    by a space: the first is the maximum number of protrusion bases allowed, and the
    second is [Concordantpair or DiscordantPair], telling whether to report alignments
    with non-zero protrusion as concordant/discordant pairs.'
  id: alignEndsProtrude
  inputBinding:
    position: 2
    prefix: --alignEndsProtrude
    shellQuote: false
  label: Protrusion of alignment ends
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: 0 ConcordantPair
  type: string?
- doc: 'Type of read ends alignment. Local: standard local alignment with soft-clipping
    allowed. EndToEnd: force end to end read alignment, do not soft-clip; Extend5pOfRead1:
    fully extend only the 5p of the read1, all other ends: local alignment; Extend5pOfReads12:
    full extension of 5'' ends of both mates.'
  id: alignEndsType
  inputBinding:
    position: 2
    prefix: --alignEndsType
    shellQuote: false
  label: Alignment type
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: Local
  type:
  - 'null'
  - name: alignEndsType
    symbols:
    - Local
    - EndToEnd
    - Extend5pOfRead1
    - Extend3pOfRead1
    - Extend5pOfReads12
    type: enum
- doc: 'How to flush ambiguous insertion positions. None: old method, insertions are
    not flushed; Right: insertions are flushed to the right.'
  id: alignInsertionFlush
  inputBinding:
    position: 2
    prefix: --alignInsertionFlush
    shellQuote: false
  label: Align insertion flush
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: alignInsertionFlush
    symbols:
    - None
    - Right
    type: enum
- doc: Maximum intron size, if 0, max intron size will be determined by (2^winBinNbits)*winAnchorDistNbins.
  id: alignIntronMax
  inputBinding:
    position: 2
    prefix: --alignIntronMax
    shellQuote: false
  label: Max intron size
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '0'
  type: int?
- doc: 'Minimum intron size: genomic gap is considered intron if its length >= alignIntronMin,
    otherwise it is considered Deletion (int>=0).'
  id: alignIntronMin
  inputBinding:
    position: 2
    prefix: --alignIntronMin
    shellQuote: false
  label: Min intron size
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '21'
  type: int?
- doc: Maximum gap between two mates, if 0, max intron gap will be determined by (2^winBinNbits)*winAnchorDistNbins.
  id: alignMatesGapMax
  inputBinding:
    position: 2
    prefix: --alignMatesGapMax
    shellQuote: false
  label: Max mates gap
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Minimum overhang (i.e. block size) for annotated (sjdb) spliced alignments
    (int>0).
  id: alignSJDBoverhangMin
  inputBinding:
    position: 2
    prefix: --alignSJDBoverhangMin
    shellQuote: false
  label: 'Min overhang: annotated'
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '3'
  type: int?
- doc: Minimum overhang (i.e. block size) for spliced alignments (int>0).
  id: alignSJoverhangMin
  inputBinding:
    position: 2
    prefix: --alignSJoverhangMin
    shellQuote: false
  label: Min overhang
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '5'
  type: int?
- doc: '4*int>=0: maximum number of mismatches for stitching of the splice junctions
    (-1: no limit). (1) non-canonical motifs, (2) GT/AG and CT/AC motif, (3) GC/AG
    and CT/GC motif, (4) AT/AC and GT/AT motif.'
  id: alignSJstitchMismatchNmax
  inputBinding:
    position: 2
    prefix: --alignSJstitchMismatchNmax
    shellQuote: false
  label: Splice junction stich max mismatch
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: 0 -1 0 0
  type: string?
- doc: 'Option which allows soft clipping of alignments at the reference (chromosome)
    ends. Can be disabled for compatibility with Cufflinks/Cuffmerge. Yes: Enables
    soft clipping; No: Disables soft clipping.'
  id: alignSoftClipAtReferenceEnds
  inputBinding:
    position: 2
    prefix: --alignSoftClipAtReferenceEnds
    shellQuote: false
  label: Soft clipping
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: 'Yes'
  type:
  - 'null'
  - name: alignSoftClipAtReferenceEnds
    symbols:
    - 'Yes'
    - 'No'
    type: enum
- doc: Minimum mapped length for a read mate that is spliced (int>0).
  id: alignSplicedMateMapLmin
  inputBinding:
    position: 2
    prefix: --alignSplicedMateMapLmin
    shellQuote: false
  label: Min mapped length
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '0'
  type: int?
- doc: AlignSplicedMateMapLmin normalized to mate length (float>0).
  id: alignSplicedMateMapLminOverLmate
  inputBinding:
    position: 2
    prefix: --alignSplicedMateMapLminOverLmate
    shellQuote: false
  label: Min mapped length normalized
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '0.66'
  type: float?
- doc: Max number of different alignments per read to consider (int>0).
  id: alignTranscriptsPerReadNmax
  label: Max transcripts per read
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '10000'
  type: int?
- doc: Max number of transcripts per window (int>0).
  id: alignTranscriptsPerWindowNmax
  label: Max transcripts per window
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Max number of windows per read (int>0).
  id: alignWindowsPerReadNmax
  inputBinding:
    position: 2
    prefix: --alignWindowsPerReadNmax
    shellQuote: false
  label: Max windows per read
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '10000'
  type: float?
- doc: Number of bases from the 5' end of mate 2 to use in collapsing (e.g. for RAMPAGE).
  id: bamRemoveDuplicatesMate2basesN
  label: BAM remove duplicates mate2 bases
  sbg:category: BAM processing
  sbg:toolDefaultValue: '0'
  type: int?
- doc: 'Mark duplicates in the BAM file. For now, only works with paired-end alignments.
    UniqueIdentical: mark all mutlimappers and duplicate unique mappers. The coordinates,
    FLAG, CIGAR must be identical. UniqueIdenticalNotMulti: mark duplicate unique
    mappers but not multimappers.'
  id: bamRemoveDuplicatesType
  label: BAM remove duplicates type
  sbg:category: BAM processing
  sbg:toolDefaultValue: 'Off'
  type:
  - 'null'
  - name: bamRemoveDuplicatesType
    symbols:
    - UniqueIdentical
    - UniqueIdenticalNotMulti
    type: enum
- doc: Different filters for chimeric alignments None no filtering banGenomicN Ns
    are not allowed in the genome sequence around the chimeric junction.
  id: chimFilter
  inputBinding:
    position: 2
    prefix: --chimFilter
    shellQuote: false
  label: Chimeric filter
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: banGenomicN
  type:
  - 'null'
  - name: chimFilter
    symbols:
    - banGenomicN
    - None
    type: enum
- doc: Minimum overhang for a chimeric junction (int>=0).
  id: chimJunctionOverhangMin
  inputBinding:
    position: 2
    prefix: --chimJunctionOverhangMin
    shellQuote: false
  label: Min junction overhang
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '20'
  type: int?
- doc: Maximum number of multi-alignments for the main chimeric segment. The value
    of 1 will prohibit multimapping main segments.
  id: chimMainSegmentMultNmax
  inputBinding:
    position: 2
    prefix: --chimMainSegmentMultNmax
    shellQuote: false
  label: Max main chimeric segment alignments
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '10'
  type: int?
- doc: Maximum number of chimeric multi-alignments (0 - use the old scheme for chimeric
    detection which only considered unique alignments).
  id: chimMultimapNmax
  inputBinding:
    position: 2
    prefix: --chimMultimapNmax
    shellQuote: false
  label: Chimeric multimap max number
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: The score range for multi-mapping chimeras below the best chimeric score. Only
    works with chimMultimapNmax > 1.
  id: chimMultimapScoreRange
  inputBinding:
    position: 2
    prefix: --chimMultimapScoreRange
    shellQuote: false
  label: Chimeric multimap score range
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '1'
  type: int?
- doc: To trigger chimeric detection, the drop in the best non-chimeric alignment
    score with respect to the read lenght has to be smaller than this value.
  id: chimNonchimScoreDropMin
  inputBinding:
    position: 2
    prefix: --chimNonchimScoreDropMin
    shellQuote: false
  label: Minimum no-chimeric drop score
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '20'
  type: int?
- doc: 'Formatting type for the Chimeric.out.junction file. 0 - no comment lines/headers;
    1 - comment lines at the end of the file: command line and Nreads: total, unique,
    multi.'
  id: chimOutJunctionFormat
  inputBinding:
    position: 2
    prefix: --chimOutJunctionFormat
    shellQuote: false
  label: Chimeric file format
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '0'
  type:
  - 'null'
  - name: chimOutJunctionFormat
    symbols:
    - '0'
    - '1'
    type: enum
- doc: 'Type of chimeric output. SeparateSAMold: output old SAM into separate Chimeric.out.sam
    file; WithinBAM: output into main aligned SAM/BAM files. WithinBAM HardClip -  hard-clipping
    in the CIGAR for supplemental chimeric alignments; WithinBAM SoftClip - soft-clipping
    in the CIGAR for supplemental chimeric alignments. Outputs in both SAM and junctions
    file format are available with the ''Junctions SeparateSAMold'' option.'
  id: chimOutType
  inputBinding:
    position: 2
    prefix: --chimOutType
    shellQuote: false
  label: Chimeric output type
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: Junctions
  type:
  - 'null'
  - name: chimOutType
    symbols:
    - Junctions
    - SeparateSAMold
    - WithinBAM
    - WithinBAM HardClip
    - WithinBAM SoftClip
    - Junctions SeparateSAMold
    type: enum
- doc: Max drop (difference) of chimeric score (the sum of scores of all chimeric
    segements) from the read length (int>=0).
  id: chimScoreDropMax
  inputBinding:
    position: 2
    prefix: --chimScoreDropMax
    shellQuote: false
  label: Max drop score
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '20'
  type: int?
- doc: Penalty for a non-GT/AG chimeric junction.
  id: chimScoreJunctionNonGTAG
  inputBinding:
    position: 2
    prefix: --chimScoreJunctionNonGTAG
    shellQuote: false
  label: Non-GT/AG penalty
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: Minimum total (summed) score of the chimeric segments (int>=0).
  id: chimScoreMin
  inputBinding:
    position: 2
    prefix: --chimScoreMin
    shellQuote: false
  label: Min total score
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Minimum difference (separation) between the best chimeric score and the next
    one (int>=0).
  id: chimScoreSeparation
  inputBinding:
    position: 2
    prefix: --chimScoreSeparation
    shellQuote: false
  label: Min separation score
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '10'
  type: int?
- doc: Minimum length of chimeric segment length, if =0, no chimeric output (int>=0).
  id: chimSegmentMin
  inputBinding:
    position: 2
    prefix: --chimSegmentMin
    shellQuote: false
  label: Min chimeric segment
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Maximum gap in the read sequence between chimeric segments (int>=0).
  id: chimSegmentReadGapMax
  inputBinding:
    position: 2
    prefix: --chimSegmentReadGapMax
    shellQuote: false
  label: Chimeric segment gap
  sbg:category: Chimeric Alignments
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Max proportion of mismatches for 3p adapter clipping for each mate. In case
    only one value is given, it will be assumed the same for both mates.
  id: clip3pAdapterMMp
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --clip3pAdapterMMp
    shellQuote: false
  label: Max mismatches proportions
  sbg:category: Read parameters
  sbg:toolDefaultValue: '0.1'
  type: float[]?
- doc: Adapter sequence to clip from 3p of each mate. In case only one value is given,
    it will be assumed the same for both mates.
  id: clip3pAdapterSeq
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --clip3pAdapterSeq
    shellQuote: false
  label: Clip 3p adapter sequence
  sbg:category: Read parameters
  sbg:toolDefaultValue: '-'
  type: string[]?
- doc: Number of bases to clip from 3p of each mate after the adapter clipping. In
    case only one value is given, it will be assumed the same for both mates.
  id: clip3pAfterAdapterNbases
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --clip3pAfterAdapterNbases
    shellQuote: false
  label: Clip 3p after adapter seq
  sbg:category: Read parameters
  sbg:toolDefaultValue: '0'
  type: int[]?
- doc: Number of bases to clip from 3p of each mate. In case only one value is given,
    it will be assumed the same for both mates.
  id: clip3pNbases
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --clip3pNbases
    shellQuote: false
  label: Clip 3p bases
  sbg:category: Read parameters
  sbg:toolDefaultValue: '0'
  type: int[]?
- doc: Number of bases to clip from 5p of each mate. In case only one value is given,
    it will be assumed the same for both mates.
  id: clip5pNbases
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --clip5pNbases
    shellQuote: false
  label: Clip 5p bases
  sbg:category: Read parameters
  sbg:toolDefaultValue: '0'
  type: int[]?
- doc: Number of CPUs to be used per job.
  id: cpu_per_job
  label: CPU per job
  sbg:category: Platform options
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Genome files created using STAR Genome Generate.
  id: in_index
  label: Genome files
  sbg:category: Basic
  sbg:fileTypes: TAR
  type: File
- doc: Name of the directory which contains genome files (when genome.tar is uncompressed).
  id: genomeDirName
  label: Genome dir name
  sbg:category: Basic
  sbg:toolDefaultValue: genomeDir
  type: string?
- doc: Maximum available RAM for sorting BAM. If set to 0, it will be set to the genome
    index size.
  id: limitBAMsortRAM
  label: Limit BAM sorting memory
  sbg:category: Limits
  sbg:toolDefaultValue: '57000000000'
  type: int?
- doc: Max number of collapsed junctions.
  id: limitOutSJcollapsed
  inputBinding:
    position: 2
    prefix: --limitOutSJcollapsed
    shellQuote: false
  label: Collapsed junctions max number
  sbg:category: Limits
  sbg:toolDefaultValue: '1000000'
  type: int?
- doc: Max number of junctions for one read (including all multi-mappers).
  id: limitOutSJoneRead
  inputBinding:
    position: 2
    prefix: --limitOutSJoneRead
    shellQuote: false
  label: Junctions max number
  sbg:category: Limits
  sbg:toolDefaultValue: '1000'
  type: int?
- doc: Maximum number of junction to be inserted to the genome on the fly at the mapping
    stage, including those from annotations and those detected in the 1st step of
    the 2-pass run.
  id: limitSjdbInsertNsj
  inputBinding:
    position: 2
    prefix: --limitSjdbInsertNsj
    shellQuote: false
  label: Max insert junctions
  sbg:category: Limits
  sbg:toolDefaultValue: '1000000'
  type: int?
- doc: Amount of RAM memory to be used per job. Defaults to 2048MB for Single threaded
    jobs,and all of the available memory on the instance for multi-threaded jobs.
  id: mem_per_job
  label: Memory per job
  sbg:category: Platform options
  sbg:toolDefaultValue: '2048'
  type: int?
- doc: If this boolean argument is specified, no read groups will be set in the resulting
    BAM header.
  id: no_read_groups
  label: No read groups
  sbg:category: Read group
  sbg:toolDefaultValue: 'Off'
  type: boolean?
- doc: BAM compression level. -1=default compression (6), 0=no compression, 10=maximum
    compression.
  id: outBAMcompression
  inputBinding:
    position: 2
    prefix: --outBAMcompression
    shellQuote: false
  label: Output BAM compression
  sbg:category: Output
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: Number of genome bins fo coordinate-sorting. number of genome bins fo coordinate-sorting
  id: outBAMsortingBinsN
  inputBinding:
    position: 2
    prefix: --outBAMsortingBinsN
    shellQuote: false
  label: Output BAM sorting bins
  sbg:category: Output
  sbg:toolDefaultValue: '50'
  type: int?
- doc: "Number of threads for BAM sorting. 0 will default to min(6,\u2013runThreadN)."
  id: outBAMsortingThreadN
  inputBinding:
    position: 2
    prefix: --outBAMsortingThreadN
    shellQuote: false
  label: Output BAM sorting threads
  sbg:category: Output
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Prefix to be added to all output files.
  id: out_prefix
  label: Output file name prefix
  sbg:category: Output
  sbg:toolDefaultValue: sample_id
  type: string?
- doc: 'Filter alignment using their motifs. None: no filtering; RemoveNoncanonical:
    filter out alignments that contain non-canonical junctions; RemoveNoncanonicalUnannotated:
    filter out alignments that contain non-canonical unannotated junctions when using
    annotated splice junctions database. The annotated non-canonical junctions will
    be kept.'
  id: outFilterIntronMotifs
  inputBinding:
    position: 2
    prefix: --outFilterIntronMotifs
    shellQuote: false
  label: Motifs filtering
  sbg:category: Output filtering
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outFilterIntronMotifs
    symbols:
    - None
    - RemoveNoncanonical
    - RemoveNoncanonicalUnannotated
    type: enum
- doc: Remove alignments that have junctions with inconsistent strands. On by default.
  id: outFilterIntronStrands
  inputBinding:
    position: 2
    prefix: --outFilterIntronStrands
    shellQuote: false
  label: Filter intron strands
  sbg:category: Output filtering
  sbg:toolDefaultValue: RemoveInconsistentStrands
  type:
  - 'null'
  - name: outFilterIntronStrands
    symbols:
    - RemoveInconsistentStrands
    - None
    type: enum
- doc: Alignment will be output only if the number of matched bases is higher than
    this value.
  id: outFilterMatchNmin
  inputBinding:
    position: 2
    prefix: --outFilterMatchNmin
    shellQuote: false
  label: Min matched bases
  sbg:category: Output filtering
  sbg:toolDefaultValue: '0'
  type: int?
- doc: '''Minimum matched bases'' normalized to read length (sum of mates lengths
    for paired-end reads).'
  id: outFilterMatchNminOverLread
  inputBinding:
    position: 2
    prefix: --outFilterMatchNminOverLread
    shellQuote: false
  label: Min matched bases normalized
  sbg:category: Output filtering
  sbg:toolDefaultValue: '0.66'
  type: float?
- doc: Alignment will be output only if it has fewer mismatches than this value.
  id: outFilterMismatchNmax
  label: Max number of mismatches
  sbg:category: Output filtering
  sbg:toolDefaultValue: '10'
  type: int?
- doc: Alignment will be output only if its ratio of mismatches to *mapped* length
    is less than this value.
  id: outFilterMismatchNoverLmax
  inputBinding:
    position: 2
    prefix: --outFilterMismatchNoverLmax
    shellQuote: false
  label: Mismatches to *mapped* length
  sbg:category: Output filtering
  sbg:toolDefaultValue: '0.3'
  type: float?
- doc: Alignment will be output only if its ratio of mismatches to *read* length is
    less than this value.
  id: outFilterMismatchNoverReadLmax
  inputBinding:
    position: 2
    prefix: --outFilterMismatchNoverReadLmax
    shellQuote: false
  label: Mismatches to *read* length
  sbg:category: Output filtering
  sbg:toolDefaultValue: '1'
  type: float?
- doc: Read alignments will be output only if the read maps fewer than this value,
    otherwise no alignments will be output.
  id: outFilterMultimapNmax
  inputBinding:
    position: 2
    prefix: --outFilterMultimapNmax
    shellQuote: false
  label: Max number of mappings
  sbg:category: Output filtering
  sbg:toolDefaultValue: '10'
  type: int?
- doc: The score range below the maximum score for multimapping alignments.
  id: outFilterMultimapScoreRange
  label: Multimapping score range
  sbg:category: Output filtering
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Alignment will be output only if its score is higher than this value.
  id: outFilterScoreMin
  inputBinding:
    position: 2
    prefix: --outFilterScoreMin
    shellQuote: false
  label: Min score
  sbg:category: Output filtering
  sbg:toolDefaultValue: '0'
  type: int?
- doc: '''Minimum score'' normalized to read length (sum of mates'' lengths for paired-end
    reads).'
  id: outFilterScoreMinOverLread
  label: Min score normalized
  sbg:category: Output filtering
  sbg:toolDefaultValue: '0.66'
  type: float?
- doc: 'Type of filtering. Normal: standard filtering using only current alignment;
    BySJout: keep only those reads that contain junctions that passed filtering into
    SJ.out.tab.'
  id: outFilterType
  inputBinding:
    position: 2
    prefix: --outFilterType
    shellQuote: false
  label: Filtering type
  sbg:category: Output filtering
  sbg:toolDefaultValue: Normal
  type:
  - 'null'
  - name: outFilterType
    symbols:
    - Normal
    - BySJout
    type: enum
- doc: Random option outputs multiple alignments for each read in random order, and
    also also randomizes the choice of the primary alignment from the highest scoring
    alignments.
  id: outMultimapperOrder
  inputBinding:
    position: 2
    prefix: --outMultimapperOrder
    shellQuote: false
  label: Order of multimapping alignment
  sbg:category: Output
  sbg:toolDefaultValue: Old_2.4
  type:
  - 'null'
  - name: outMultimapperOrder
    symbols:
    - Random
    - Old_2.4
    type: enum
- doc: Add this number to the quality score (e.g. to convert from Illumina to Sanger,
    use -31).
  id: outQSconversionAdd
  inputBinding:
    position: 2
    prefix: --outQSconversionAdd
    shellQuote: false
  label: Quality conversion
  sbg:category: Output
  sbg:toolDefaultValue: '0'
  type: int?
- doc: 'Output of unmapped reads (besides SAM). None: no output; Fastx: output in
    separate fasta/fastq files, Unmapped.out.mate1/2.'
  id: outReadsUnmapped
  inputBinding:
    position: 2
    prefix: --outReadsUnmapped
    shellQuote: false
  label: Output unmapped reads
  sbg:category: Output
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outReadsUnmapped
    symbols:
    - None
    - Fastx
    type: enum
- doc: Start value for the IH attribute. 0 may be required by some downstream software,
    such as Cufflinks or StringTie.
  id: outSAMattrIHstart
  inputBinding:
    position: 2
    prefix: --outSAMattrIHstart
    shellQuote: false
  label: IH attribute start value
  sbg:category: Output
  sbg:toolDefaultValue: '1'
  type: int?
- doc: 'Desired SAM attributes, in the order desired for the output SAM. Standard
    - NH HI AS nM; All - NH HI AS nM NM MD jM jI MC ch; None - no attributes. The
    combination used in RSEM is: NH HI AS NM MD. Variants overlapping alignments attributes
    available as well: vA - variant allele; vG - genomic coordinate of the variant
    overlapped by the read; vW - 0/1 - alignment does not pass / passes WASP filtering.
    Requires --waspOutputMode SAMtag. Unsupported: rB - alignment block read/genomic
    coordinates; vR - read coordinate of the variant.'
  id: outSAMattributes
  inputBinding:
    position: 2
    prefix: --outSAMattributes
    shellQuote: false
  label: SAM attributes
  sbg:category: Output
  sbg:toolDefaultValue: Standard
  type: string?
- doc: Filter the output into main SAM/BAM files.
  id: outSAMfilter
  inputBinding:
    position: 2
    prefix: --outSAMfilter
    shellQuote: false
  label: Output filter
  sbg:category: Output
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outSAMfilter
    symbols:
    - KeepOnlyAddedReferences
    - None
    - KeepAllAddedReferences
    type: enum
- doc: Set specific bits of the SAM FLAG.
  id: outSAMflagAND
  inputBinding:
    position: 2
    prefix: --outSAMflagAND
    shellQuote: false
  label: AND SAM flag
  sbg:category: Output
  sbg:toolDefaultValue: '65535'
  type: int?
- doc: Set specific bits of the SAM FLAG.
  id: outSAMflagOR
  inputBinding:
    position: 2
    prefix: --outSAMflagOR
    shellQuote: false
  label: OR SAM flag
  sbg:category: Output
  sbg:toolDefaultValue: '0'
  type: int?
- doc: '@HD (header) line of the SAM header.'
  id: outSAMheaderHD
  inputBinding:
    position: 2
    prefix: --outSAMheaderHD
    shellQuote: false
  label: SAM header @HD
  sbg:category: Output
  sbg:toolDefaultValue: '-'
  type: string?
- doc: Extra @PG (software) line of the SAM header (in addition to STAR).
  id: outSAMheaderPG
  inputBinding:
    position: 2
    prefix: --outSAMheaderPG
    shellQuote: false
  label: SAM header @PG
  sbg:category: Output
  sbg:toolDefaultValue: '-'
  type: string?
- doc: MAPQ value for unique mappers (0 to 255).
  id: outSAMmapqUnique
  inputBinding:
    position: 2
    prefix: --outSAMmapqUnique
    shellQuote: false
  label: MAPQ value
  sbg:category: Output
  sbg:toolDefaultValue: '255'
  type: int?
- doc: 'Mode of SAM output. Full: full SAM output; NoQS: full SAM but without quality
    scores.'
  id: outSAMmode
  inputBinding:
    position: 2
    prefix: --outSAMmode
    shellQuote: false
  label: SAM mode
  sbg:category: Output
  sbg:toolDefaultValue: Full
  type:
  - 'null'
  - name: outSAMmode
    symbols:
    - Full
    - NoQS
    - None
    type: enum
- doc: Max number of multiple alignments for a read that will be output to the SAM/BAM
    files.
  id: outSAMmultNmax
  inputBinding:
    position: 2
    prefix: --outSAMmultNmax
    shellQuote: false
  label: Max number of multiple alignment
  sbg:category: Output
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: 'Type of sorting for the SAM output. Paired: one mate after the other for all
    paired alignments; PairedKeepInputOrder: one mate after the other for all paired
    alignments, the order is kept the same as in the input FASTQ files.'
  id: outSAMorder
  inputBinding:
    position: 2
    prefix: --outSAMorder
    shellQuote: false
  label: Sorting in SAM
  sbg:category: Output
  sbg:toolDefaultValue: Paired
  type:
  - 'null'
  - name: outSAMorder
    symbols:
    - Paired
    - PairedKeepInputOrder
    type: enum
- doc: 'Which alignments are considered primary - all others will be marked with 0x100
    bit in the FLAG. OneBestScore: only one alignment with the best score is primary;
    AllBestScore: all alignments with the best score are primary.'
  id: outSAMprimaryFlag
  inputBinding:
    position: 2
    prefix: --outSAMprimaryFlag
    shellQuote: false
  label: Primary alignments
  sbg:category: Output
  sbg:toolDefaultValue: OneBestScore
  type:
  - 'null'
  - name: outSAMprimaryFlag
    symbols:
    - OneBestScore
    - AllBestScore
    type: enum
- doc: 'Read ID record type. Standard: first word (until space) from the FASTx read
    ID line, removing /1,/2 from the end; Number: read number (index) in the FASTx
    file.'
  id: outSAMreadID
  inputBinding:
    position: 2
    prefix: --outSAMreadID
    shellQuote: false
  label: Read ID
  sbg:category: Output
  sbg:toolDefaultValue: Standard
  type:
  - 'null'
  - name: outSAMreadID
    symbols:
    - Standard
    - Number
    type: enum
- doc: 'Cufflinks-like strand field flag. None: not used; intronMotif: strand derived
    from the intron motif. Reads with inconsistent and/or non-canonical introns are
    filtered out.'
  id: outSAMstrandField
  inputBinding:
    position: 2
    prefix: --outSAMstrandField
    shellQuote: false
  label: Strand field flag
  sbg:category: Output
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outSAMstrandField
    symbols:
    - None
    - intronMotif
    type: enum
- doc: Calculation method for the TLEN field in the SAM/BAM files. 1 - leftmost base
    of the (+)strand mate to rightmost base of the (-)mate. (+)sign for the (+)strand
    mate; 2 - leftmost base of any mate to rightmost base of any mate. (+)sign for
    the mate with the leftmost base. This is different from 1 for overlapping mates
    with protruding ends.
  id: outSAMtlen
  inputBinding:
    position: 2
    prefix: --outSAMtlen
    shellQuote: false
  label: Out SAM TLEN
  sbg:category: Output
  sbg:toolDefaultValue: '1'
  type:
  - 'null'
  - name: outSAMtlen
    symbols:
    - '1'
    - '2'
    type: enum
- doc: Format of output alignments.
  id: outSAMtype
  label: Output format
  sbg:category: Output
  sbg:toolDefaultValue: BAM
  type:
  - 'null'
  - name: outSAMtype
    symbols:
    - SAM
    - BAM
    type: enum
- doc: 'Output of unmapped reads in the SAM format. None: no output Within: output
    unmapped reads within the main SAM file (i.e. Aligned.out.sam).'
  id: outSAMunmapped
  inputBinding:
    position: 2
    prefix: --outSAMunmapped
    shellQuote: false
  label: Write unmapped in SAM
  sbg:category: Output
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outSAMunmapped
    symbols:
    - None
    - Within
    - Within KeepPairs
    type: enum
- doc: Minimum total (multi-mapping+unique) read count per junction for each of the
    motifs. To set no output for desired motif, assign -1 to the corresponding field.
    Junctions are output if one of --outSJfilterCountUniqueMin OR --outSJfilterCountTotalMin
    conditions are satisfied. Does not apply to annotated junctions.
  id: outSJfilterCountTotalMin
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --outSJfilterCountTotalMin
    shellQuote: false
  label: Min total count
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: 3 1 1 1
  type: int[]?
- doc: Minimum uniquely mapping read count per junction for each of the motifs. To
    set no output for desired motif, assign -1 to the corresponding field. Junctions
    are output if one of --outSJfilterCountUniqueMin OR --outSJfilterCountTotalMin
    conditions are satisfied. Does not apply to annotated junctions.
  id: outSJfilterCountUniqueMin
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --outSJfilterCountUniqueMin
    shellQuote: false
  label: Min unique count
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: 3 1 1 1
  type: int[]?
- doc: Minimum allowed distance to other junctions' donor/acceptor for each of the
    motifs (int >= 0). Does not apply to annotated junctions.
  id: outSJfilterDistToOtherSJmin
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --outSJfilterDistToOtherSJmin
    shellQuote: false
  label: Min distance to other donor/acceptor
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: 10 0 5 10
  type: int[]?
- doc: 'Maximum gap allowed for junctions supported by 1,2,3...N reads (int >= 0)
    i.e. by default junctions supported by 1 read can have gaps <=50000b, by 2 reads:
    <=100000b, by 3 reads: <=200000. By 4 or more reads: any gap <=alignIntronMax.
    Does not apply to annotated junctions.'
  id: outSJfilterIntronMaxVsReadN
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --outSJfilterIntronMaxVsReadN
    shellQuote: false
  label: Max gap allowed
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: 50000 100000 200000
  type: int[]?
- doc: Minimum overhang length for splice junctions on both sides for each of the
    motifs. To set no output for desired motif, assign -1 to the corresponding field.
    Does not apply to annotated junctions.
  id: outSJfilterOverhangMin
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --outSJfilterOverhangMin
    shellQuote: false
  label: Min overhang SJ
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: 30 12 12 12
  type: int[]?
- doc: 'Which reads to consider for collapsed splice junctions output. All: all reads,
    unique- and multi-mappers; Unique: uniquely mapping reads only.'
  id: outSJfilterReads
  inputBinding:
    position: 2
    prefix: --outSJfilterReads
    shellQuote: false
  label: Collapsed junctions reads
  sbg:category: 'Output filtering: splice junctions'
  sbg:toolDefaultValue: All
  type:
  - 'null'
  - name: outSJfilterReads
    symbols:
    - All
    - Unique
    type: enum
- doc: Type of output sorting.
  id: outSortingType
  label: Output sorting type
  sbg:category: Output
  sbg:toolDefaultValue: Unsorted
  type:
  - 'null'
  - name: outSortingType
    symbols:
    - Unsorted
    - SortedByCoordinate
    type: enum
- doc: Type of normalization for the output wiggle signal. RPM - reads per million
    of mapped reads; None - no normalization, "raw" counts.
  id: outWigNorm
  label: Output wiggle normalization
  sbg:category: Output Wiggle
  sbg:toolDefaultValue: RPM
  type:
  - 'null'
  - name: outWigNorm
    symbols:
    - None
    - RPM
    type: enum
- doc: Prefix matching reference names to include in the output wiggle file, e.g.
    "chr". Default is "-", to include all references.
  id: outWigReferencePrefix
  label: Output wiggle reference prefix
  sbg:category: Output Wiggle
  sbg:toolDefaultValue: '-'
  type: string?
- doc: Strandedness of wiggle/bedGraph output. Stranded - separate strands, str1 and
    str2; Unstranded - collapsed strands.
  id: outWigStrand
  label: Output wiggle strand
  sbg:category: Output Wiggle
  sbg:toolDefaultValue: Stranded
  type:
  - 'null'
  - name: outWigStrand
    symbols:
    - Stranded
    - Unstranded
    type: enum
- doc: Type of wiggle signal output. Options are bedGraph and wiggle, with the second
    word indicating whether to include signal only from 5' of the 1st read (useful
    for CAGE/RAMPAGE etc) or only from the 2nd read, respectively.
  id: outWigType
  inputBinding:
    position: 2
    prefix: --outWigType
    shellQuote: false
  label: Output wiggle type
  sbg:category: Output Wiggle
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: outWigType
    symbols:
    - bedGraph
    - bedGraph read1_5p
    - bedGraph read2
    - wiggle
    - wiggle read1_5p
    - wiggle read2
    type: enum
- doc: Maximum proportion of mismatched bases in the overlap area (value must be between
    0 and 1).
  id: peOverlapMMp
  inputBinding:
    position: 2
    prefix: --peOverlapMMp
    shellQuote: false
  label: Paired end overlap max mismatches proportion
  sbg:category: Paired-End reads
  sbg:toolDefaultValue: '0.1'
  type: float?
- doc: Minimum number of overlap bases to trigger mates merging and realignment.
  id: peOverlapNbasesMin
  inputBinding:
    position: 2
    prefix: --peOverlapNbasesMin
    shellQuote: false
  label: Paired end overlap min bases number
  sbg:category: Paired-End reads
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Types of quantification requested. 'TranscriptomeSAM' option outputs SAM/BAM
    alignments to transcriptome into a separate file. With 'GeneCounts' option, STAR
    will count number of reads per gene while mapping.
  id: quantMode
  inputBinding:
    position: 2
    prefix: --quantMode
    shellQuote: false
  label: Quantification mode
  sbg:category: Quantification of Annotations
  sbg:toolDefaultValue: '-'
  type:
  - 'null'
  - name: quantMode
    symbols:
    - TranscriptomeSAM
    - GeneCounts
    - TranscriptomeSAM GeneCounts
    type: enum
- doc: 'Prohibit various alignment type. IndelSoftclipSingleend: prohibit indels,
    soft clipping and single-end alignments - compatible with RSEM; Singleend: prohibit
    single-end alignments.'
  id: quantTranscriptomeBan
  inputBinding:
    position: 2
    prefix: --quantTranscriptomeBan
    shellQuote: false
  label: Prohibit alignment type
  sbg:category: Quantification of Annotations
  sbg:toolDefaultValue: IndelSoftclipSingleend
  type:
  - 'null'
  - name: quantTranscriptomeBan
    symbols:
    - IndelSoftclipSingleend
    - Singleend
    type: enum
- doc: The length of the reads.
  id: read_length
  label: Read length
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Number of reads to map from the beginning of the file.
  id: readMapNumber
  inputBinding:
    position: 2
    prefix: --readMapNumber
    shellQuote: false
  label: Reads to map
  sbg:category: Read parameters
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: Equal/Not equal - lengths of names, sequences, qualities for both mates are
    the same/not the same. "Not equal" is safe in all situations.
  id: readMatesLengthsIn
  inputBinding:
    position: 2
    prefix: --readMatesLengthsIn
    shellQuote: false
  label: Reads lengths
  sbg:category: Read parameters
  sbg:toolDefaultValue: NotEqual
  type:
  - 'null'
  - name: readMatesLengthsIn
    symbols:
    - NotEqual
    - Equal
    type: enum
- doc: Read files, either in FASTQ or SAM/BAM formats.
  id: in_reads
  inputBinding:
    itemSeparator: ' '
    position: 12
    shellQuote: false
    valueFrom: "${\n    function get_meta_map(m, file, meta) {\n        if (meta in\
      \ file.metadata) {\n            return m[file.metadata[meta]];\n        } else\
      \ {\n            return m['Undefined'];\n        }\n    }\n\n    function create_new_map(map,\
      \ file, meta) {\n        if (meta in file.metadata) {\n            map[file.metadata[meta]]\
      \ = {}\n            return map[file.metadata[meta]];\n        } else {\n   \
      \         map['Undefined'] = {}\n            return map['Undefined'];\n    \
      \    }\n    }\n\n    var arr = [].concat(inputs.in_reads);\n    var ext = arr[0].path.split('.').pop().toLowerCase();\n\
      \n    // if bam input\n    if (ext == 'bam' || ext == 'sam') {\n        return\
      \ \"--readFilesType SAM $str --readFilesIn \" + arr[0].path\n    }\n\n    var\
      \ map = {};\n\n    if (arr.length == 1) {\n        return \"--readFilesIn \"\
      \ + arr[0].path;\n    }\n\n    for (i in arr) {\n    \n        var sm_map =\
      \ get_meta_map(map, arr[i], 'sample_id');\n        if (!sm_map) sm_map = create_new_map(map,\
      \ arr[i], 'sample_id')\n\n        var lb_map = get_meta_map(sm_map, arr[i],\
      \ 'library_id');\n        if (!lb_map) lb_map = create_new_map(sm_map, arr[i],\
      \ 'library_id')\n        var pu_map = get_meta_map(lb_map, arr[i], 'platform_unit_id');\n\
      \        if (!pu_map) pu_map = create_new_map(lb_map, arr[i], 'platform_unit_id')\n\
      \n        if ('file_segment_number' in arr[i].metadata) {\n            if (pu_map[arr[i].metadata['file_segment_number']])\
      \ {\n                var a = pu_map[arr[i].metadata['file_segment_number']];\n\
      \                var ar = [].concat(a);\n                ar = ar.concat(arr[i])\n\
      \                pu_map[arr[i].metadata['file_segment_number']] = ar\n     \
      \       } else {\n                pu_map[arr[i].metadata['file_segment_number']]\
      \ = [].concat(arr[i])\n            }\n        } else {\n            if (pu_map['Undefined'])\
      \ {\n                var a = pu_map['Undefined'];\n                var ar =\
      \ [].concat(a);\n                ar = ar.concat(arr[i])\n                pu_map['Undefined']\
      \ = ar\n            } else {\n                pu_map['Undefined'] = [].concat(arr[i])\n\
      \            }\n        }\n    }\n    var tuple_list = [];\n    var sm;\n  \
      \  var lb;\n    var pu;\n    var fsm;\n    for (sm in map)\n        for (lb\
      \ in map[sm])\n            for (pu in map[sm][lb]) {\n                var list\
      \ = [];\n                for (fsm in map[sm][lb][pu]) {\n                  \
      \  list = map[sm][lb][pu][fsm]\n                    tuple_list.push(list)\n\
      \                }\n            }\n    //return tuple_list[0][0]\n\n    var\
      \ pe_1 = [];\n    var pe_2 = [];\n    var se = [];\n    if (tuple_list[0].length\
      \ == 1) {\n        for (var i = 0; i < tuple_list.length; i++) {\n         \
      \   se = se.concat(tuple_list[i][0].path)\n        }\n    }\n    for (var i\
      \ = 0; i < tuple_list.length; i++) {\n        for (var j = 0; j < tuple_list[i].length;\
      \ j++) {\n            if (tuple_list[i][j].metadata.paired_end == 1) {\n   \
      \             pe_1 = pe_1.concat(tuple_list[i][j].path)\n            } else\
      \ if (tuple_list[i][j].metadata.paired_end == 2) {\n                pe_2 = pe_2.concat(tuple_list[i][j].path)\n\
      \            }\n        }\n    }\n    \n    var cmd;\n    var tmp;\n    if (pe_2.length\
      \ == 0) {\n        cmd = \"\"\n        if (se.length > 0) {\n            tmp\
      \ = se\n        } else if (pe_1.length > 0) {\n            tmp = pe_1\n    \
      \    }\n        for (var i = 0; i < tmp.length; i++) {\n            cmd += tmp[i]\
      \ + \" \"\n        }\n        return \"--readFilesIn \" + cmd\n    } else if\
      \ (pe_1.length > 0) {\n        var cmd1 = [];\n        var cmd2 = [];\n    \
      \    for (i = 0; i < pe_1.length; i++) {\n            cmd1.push(pe_1[i])\n \
      \           cmd2.push(pe_2[i])\n        }\n        return \"--readFilesIn \"\
      \ + cmd1.join(',') + \" \" + cmd2.join(',');\n    } else {\n        return \"\
      \";\n    }\n\n}"
  label: Read sequence
  sbg:category: Basic
  sbg:fileTypes: FASTA, FASTQ, FA, FQ, FASTQ.GZ, FQ.GZ, FASTQ.BZ2, FQ.BZ2, SAM, BAM
  type: File[]
- doc: Specify the library ID for RG line.
  id: rg_library_id
  label: Library ID
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Specify the median fragment length for RG line.
  id: rg_mfl
  label: Median fragment length
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Specify the version of the technology that was used for sequencing or assaying.
  id: rg_platform
  label: Platform
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type:
  - 'null'
  - name: rg_platform
    symbols:
    - LS 454
    - Helicos
    - Illumina
    - ABI SOLiD
    - Ion Torrent PGM
    - PacBio
    type: enum
- doc: Specify the platform unit ID for RG line.
  id: rg_platform_unit_id
  label: Platform unit ID
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Specify the sample ID for RG line.
  id: rg_sample_id
  label: Sample ID
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Specify the sequencing center for RG line.
  id: rg_seq_center
  label: Sequencing center
  sbg:category: Read group
  sbg:toolDefaultValue: Inferred from metadata
  type: string?
- doc: Number of threads to use.
  id: runThreadN
  label: Number of threads
  sbg:category: Run parameters
  sbg:toolDefaultValue: '32'
  type: int?
- doc: Deletion extension penalty per base (in addition to --scoreDelOpen).
  id: scoreDelBase
  inputBinding:
    position: 2
    prefix: --scoreDelBase
    shellQuote: false
  label: Deletion extension penalty
  sbg:category: Scoring
  sbg:toolDefaultValue: '-2'
  type: int?
- doc: Deletion open penalty.
  id: scoreDelOpen
  inputBinding:
    position: 2
    prefix: --scoreDelOpen
    shellQuote: false
  label: Deletion open penalty
  sbg:category: Scoring
  sbg:toolDefaultValue: '-2'
  type: int?
- doc: Gap open penalty.
  id: scoreGap
  inputBinding:
    position: 2
    prefix: --scoreGap
    shellQuote: false
  label: Gap open penalty
  sbg:category: Scoring
  sbg:toolDefaultValue: '0'
  type: int?
- doc: AT/AC and GT/AT gap open penalty (in addition to --scoreGap).
  id: scoreGapATAC
  inputBinding:
    position: 2
    prefix: --scoreGapATAC
    shellQuote: false
  label: AT/AC and GT/AT gap open
  sbg:category: Scoring
  sbg:toolDefaultValue: '-8'
  type: int?
- doc: GC/AG and CT/GC gap open penalty (in addition to --scoreGap).
  id: scoreGapGCAG
  inputBinding:
    position: 2
    prefix: --scoreGapGCAG
    shellQuote: false
  label: GC/AG and CT/GC gap open
  sbg:category: Scoring
  sbg:toolDefaultValue: '-4'
  type: int?
- doc: Non-canonical gap open penalty (in addition to --scoreGap).
  id: scoreGapNoncan
  inputBinding:
    position: 2
    prefix: --scoreGapNoncan
    shellQuote: false
  label: Non-canonical gap open
  sbg:category: Scoring
  sbg:toolDefaultValue: '-8'
  type: int?
- doc: 'Extra score logarithmically scaled with genomic length of the alignment: <int>*log2(genomicLength).'
  id: scoreGenomicLengthLog2scale
  inputBinding:
    position: 2
    prefix: --scoreGenomicLengthLog2scale
    shellQuote: false
  label: Log scaled score
  sbg:category: Scoring
  sbg:toolDefaultValue: '-0.25'
  type: float?
- doc: Insertion extension penalty per base (in addition to --scoreInsOpen).
  id: scoreInsBase
  inputBinding:
    position: 2
    prefix: --scoreInsBase
    shellQuote: false
  label: Insertion extension penalty
  sbg:category: Scoring
  sbg:toolDefaultValue: '-2'
  type: int?
- doc: Insertion open penalty.
  id: scoreInsOpen
  inputBinding:
    position: 2
    prefix: --scoreInsOpen
    shellQuote: false
  label: Insertion Open Penalty
  sbg:category: Scoring
  sbg:toolDefaultValue: '-2'
  type: int?
- doc: Maximum score reduction while searching for SJ boundaries in the stitching
    step.
  id: scoreStitchSJshift
  inputBinding:
    position: 2
    prefix: --scoreStitchSJshift
    shellQuote: false
  label: Max score reduction
  sbg:category: Scoring
  sbg:toolDefaultValue: '1'
  type: int?
- doc: Only pieces that map fewer than this value are utilized in the stitching procedure
    (int>=0).
  id: seedMultimapNmax
  inputBinding:
    position: 2
    prefix: --seedMultimapNmax
    shellQuote: false
  label: Filter pieces for stitching
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '10000'
  type: int?
- doc: Max number of one seed loci per window (int>=0).
  id: seedNoneLociPerWindow
  inputBinding:
    position: 2
    prefix: --seedNoneLociPerWindow
    shellQuote: false
  label: Max one-seed loci per window
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '10'
  type: int?
- doc: Max number of seeds per read (int>=0).
  id: seedPerReadNmax
  label: Max seeds per read
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '1000'
  type: int?
- doc: Max number of seeds per window (int>=0).
  id: seedPerWindowNmax
  label: Max seeds per window
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '50'
  type: int?
- doc: Defines the maximum length of the seeds, if =0 max seed length is infinite
    (int>=0).
  id: seedSearchLmax
  label: Max seed length
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '0'
  type: int?
- doc: Defines the search start point through the read - the read is split into pieces
    no longer than this value (int>0).
  id: seedSearchStartLmax
  label: Search start point
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '50'
  type: int?
- doc: SeedSearchStartLmax normalized to read length (sum of mates' lengths for paired-end
    reads).
  id: seedSearchStartLmaxOverLread
  inputBinding:
    position: 2
    prefix: --seedSearchStartLmaxOverLread
    shellQuote: false
  label: Search start point normalized
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '1.0'
  type: float?
- doc: Minimum length of the seed sequences split by Ns or mate gap. Changing this
    parameters to a value lower than the default (12), allows mapping of mates shorter
    than 12 base pairs.
  id: seedSplitMin
  inputBinding:
    position: 2
    prefix: --seedSplitMin
    shellQuote: false
  label: Seed split min
  sbg:category: Alignments and Seeding
  sbg:toolDefaultValue: '12'
  type: int?
- doc: List of splice junction coordinates in a tab-separated file.
  id: in_intervals
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --sjdbFileChrStartEnd
    shellQuote: false
  label: List of annotated junctions
  sbg:category: Basic
  sbg:fileTypes: TXT, SJDB, TAB
  type: File[]?
- doc: Prefix for chromosome names in a GTF file (e.g. 'chr' for using ENSEMBL annotations
    with UCSC genomes).
  id: sjdbGTFchrPrefix
  inputBinding:
    position: 2
    prefix: --sjdbGTFchrPrefix
    shellQuote: false
  label: Chromosome names
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: '-'
  type: string?
- doc: Feature type in GTF file to be used as exons for building transcripts.
  id: sjdbGTFfeatureExon
  inputBinding:
    position: 2
    prefix: --sjdbGTFfeatureExon
    shellQuote: false
  label: Set exons feature
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: exon
  type: string?
- doc: 'Gene model annotations and/or known transcripts. No need to include this input,
    except in case of using "on the fly" annotations. If you are providing a GFF3
    file and wish to use STAR results for further downstream analysis, a good idea
    would be to set the "Exons'' parents name" (id: sjdbGTFtagExonParentTranscript)
    option to "Parent".'
  id: in_gene_annotation
  inputBinding:
    itemSeparator: ' '
    position: 2
    prefix: --sjdbGTFfile
    shellQuote: false
  label: Gene annotation file
  sbg:category: Basic
  sbg:fileTypes: GTF, GFF, GFF2, GFF3
  type: File?
- doc: Tag name to be used as exons gene-parents.
  id: sjdbGTFtagExonParentGene
  inputBinding:
    position: 2
    prefix: --sjdbGTFtagExonParentGene
    shellQuote: false
  label: Gene name
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: gene_id
  type: string?
- doc: Tag name to be used as exons transcript-parents.
  id: sjdbGTFtagExonParentTranscript
  inputBinding:
    position: 2
    prefix: --sjdbGTFtagExonParentTranscript
    shellQuote: false
  label: Exons' parents name
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: transcript_id
  type: string?
- doc: 'Which files to save when sjdb junctions are inserted on the fly at the mapping
    step. None: not saving files at all; Basic: only small junction/transcript files;
    All: all files including big Genome, SA and SAindex. These files are output as
    archive.'
  id: sjdbInsertSave
  inputBinding:
    position: 2
    prefix: --sjdbInsertSave
    shellQuote: false
  label: Save junction files
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: sjdbInsertSave
    symbols:
    - Basic
    - All
    - None
    type: enum
- doc: Length of the donor/acceptor sequence on each side of the junctions, ideally
    = (mate_length - 1) (int >= 0), if int = 0, splice junction database is not used.
  id: sjdbOverhang
  label: '"Overhang" length'
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: '100'
  type: int?
- doc: Extra alignment score for alignments that cross database junctions.
  id: sjdbScore
  inputBinding:
    position: 2
    prefix: --sjdbScore
    shellQuote: false
  label: Extra alignment score
  sbg:category: Splice junctions database
  sbg:toolDefaultValue: '2'
  type: int?
- doc: Legacy - in old versions of STAR, unmapped reads were sometime not sorted properly
    by read ID. Specifying this option introduced some Seven Bridges code to properly
    sort unmapped reads. As of version 2.6.1d, this option is no longer necessary.
  id: sortUnmappedReads
  label: Sort unmapped reads
  sbg:category: Output
  sbg:toolDefaultValue: 'False'
  type: boolean?
- doc: Run the STARlong algorithm instead of the standard STAR. STARlong version uses
    a more efficient seed stitching algorithm for long reads (>200b), and also uses
    different array allocations. Selecting this boolean option will also automatically
    change some of the parameters of STAR to comply with long read alignment best
    practices.
  id: starlong
  label: STARlong
  sbg:category: General options
  sbg:toolDefaultValue: 'False'
  type: boolean?
- doc: 'Number of reads to process for the 1st step. 0: 1-step only, no 2nd pass;
    use very large number (or default -1) to map all reads in the first step (int>0).'
  id: twopass1readsN
  inputBinding:
    position: 2
    prefix: --twopass1readsN
    shellQuote: false
  label: Reads to process in 1st step
  sbg:category: 2-pass mapping
  sbg:toolDefaultValue: '-1'
  type: int?
- doc: '2-pass mapping mode. None: 1-pass mapping; Basic: basic 2-pass mapping, with
    all 1st pass junctions inserted into the genome indices on the fly.'
  id: twopassMode
  inputBinding:
    position: 2
    prefix: --twopassMode
    shellQuote: false
  label: Two-pass mode
  sbg:category: 2-pass mapping
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: twopassMode
    symbols:
    - None
    - Basic
    type: enum
- doc: Names of the unmapped output files.
  id: unmappedOutputName
  label: Unmapped output file names
  sbg:category: Output
  sbg:toolDefaultValue: '"Unmapped.out"'
  type: string?
- doc: VCF file that contains variation data.
  id: in_variants
  label: Variation VCF file
  sbg:category: Variation parameters
  sbg:fileTypes: VCF, VCF.GZ
  type: File?
- doc: If, for some reason, STAR produces an empty BAM file, the BAM index step will
    fail. Sometimes though, empty BAM files might be expected (if some contamination
    reference is used, for example), so in these cases, turning this option on will
    prevent samtools index from failing (en emtpy BAI file will also be created).
    )
  id: verbose_indexing
  label: Verbose indexing
  sbg:category: Output
  sbg:toolDefaultValue: 'False'
  type: boolean?
- doc: WASP allele-specific output type. This is re-implemenation of the original
    WASP mappability filtering by Bryce van de Geijn, Graham McVicker, Yoav Gilad
    & Jonathan K Pritchard.
  id: waspOutputMode
  inputBinding:
    position: 2
    prefix: --waspOutputMode
    shellQuote: false
  label: WASP output mode
  sbg:category: WASP parameters
  sbg:toolDefaultValue: None
  type:
  - 'null'
  - name: waspOutputMode
    symbols:
    - None
    - SAMtag
    type: enum
- doc: Max number of bins between two anchors that allows aggregation of anchors into
    one window (int>0).
  id: winAnchorDistNbins
  inputBinding:
    position: 2
    prefix: --winAnchorDistNbins
    shellQuote: false
  label: Max bins between anchors
  sbg:category: Windows, Anchors, Binning
  sbg:toolDefaultValue: '9'
  type: int?
- doc: Max number of loci anchors are allowed to map to (int>0).
  id: winAnchorMultimapNmax
  label: Max loci anchors
  sbg:category: Windows, Anchors, Binning
  sbg:toolDefaultValue: '50'
  type: int?
- doc: =log2(winBin), where winBin is the size of the bin for the windows/clustering,
    each window will occupy an integer number of bins (int>0).
  id: winBinNbits
  inputBinding:
    position: 2
    prefix: --winBinNbits
    shellQuote: false
  label: Bin size
  sbg:category: Windows, Anchors, Binning
  sbg:toolDefaultValue: '16'
  type: int?
- doc: =log2(winFlank), where win Flank is the size of the left and right flanking
    regions for each window (int>0).
  id: winFlankNbins
  inputBinding:
    position: 2
    prefix: --winFlankNbins
    shellQuote: false
  label: Flanking regions size
  sbg:category: Windows, Anchors, Binning
  sbg:toolDefaultValue: '4'
  type: int?
label: STAR Align
outputs:
- doc: Aligned sequence in SAM/BAM format.
  id: out_aligned_reads
  label: Aligned SAM/BAM
  outputBinding:
    glob: "${\n    var sam_name;\n    \n    if (inputs.outSortingType && inputs.outSortingType\
      \ == \"SortedByCoordinate\") {\n        var sort_name = \".sortedByCoord\";\n\
      \    } else {\n        var sort_name = \"\";\n    }\n    if (inputs.outSAMtype\
      \ && inputs.outSAMtype == \"SAM\") {\n        var sam_name = \"*.Aligned.out.sam\"\
      ;\n    } else {\n        var sam_name = \"*.Aligned\".concat(sort_name, \".out.bam\"\
      );\n    }\n    return sam_name;\n}"
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: SAM, BAM
  secondaryFiles:
  - .bai
  type: File?
- doc: Aligned Chimeric sequences SAM - if chimSegmentMin = 0, no Chimeric Alignment
    SAM and Chimeric Junctions outputs.
  id: out_chimeric_alignments
  label: Chimeric alignments
  outputBinding:
    glob: '*.Chimeric.out.sam'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: SAM
  type: File?
- doc: Chimeric junctions file. If chimSegmentMin in 'Chimeric Alignments' section
    is set to 0, 'Chimeric Junctions' won't be output.
  id: out_chimeric_junctions
  label: Chimeric junctions
  outputBinding:
    glob: '*Chimeric.out.junction'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: JUNCTION
  type: File?
- doc: Archive with genome files produced when annotations are included on the fly
    (in the mapping step).
  id: out_intermediate_genome
  label: Intermediate genome files
  outputBinding:
    glob: '*_STARgenome.tar'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: TAR
  type: File?
- doc: Log files produced during alignment.
  id: out_log_files
  label: Log files
  outputBinding:
    glob: '*Log*.out'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: OUT
  type: File[]?
- doc: File with number of reads per gene. A read is counted if it overlaps (1nt or
    more) one and only one gene.
  id: out_reads_per_gene
  label: Reads per gene
  outputBinding:
    glob: '*ReadsPerGene*'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: TAB
  type: File?
- doc: High confidence collapsed splice junctions in tab-delimited format. Only junctions
    supported by uniquely mapping reads are reported.
  id: out_splice_junctions
  label: Splice junctions
  outputBinding:
    glob: '*SJ.out.tab'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: TAB
  type: File?
- doc: Alignments translated into transcript coordinates.
  id: out_transcriptome_aligned_reads
  label: Transcriptome alignments
  outputBinding:
    glob: '*Transcriptome*'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: SAM, BAM
  type: File?
- doc: Unmapped reads in FASTQ format.
  id: out_unmapped_reads
  label: Unmapped reads
  outputBinding:
    glob: "${\n    if (inputs.unmappedOutputName) {\n        return \"*\" + inputs.unmappedOutputName\
      \ + \"*\";\n    } else {\n        return \"*Unmapped.out*\";\n    }\n\n}"
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: FASTQ
  type: File[]?
- doc: Wiggle output files (either wiggle or bedgraph, depending on which input parameter
    is set).
  id: out_wiggle_files
  label: Wiggle files
  outputBinding:
    glob: '{*.wig, *.bg}'
    outputEval: "${\n    return inheritMetadata(self, inputs.in_reads)\n\n}"
  sbg:fileTypes: WIG, BG
  type: File[]?
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${\n    return inputs.cpu_per_job ? inputs.cpu_per_job : 8\n}"
  ramMin: "${\n  var memory = 46080;\n  if(inputs.mem_per_job){\n  \t memory = inputs.mem_per_job\n\
    \  }\n return memory\n}"
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/veliborka_josipovic/star:2.5.3a_modified
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
sbg:cmdPreview: str='SE' && count=`samtools view -h /test-data/chr20sample_pe1.bam
  | head -n 500000 | samtools view -c -f 0x1 -` && if [ $count != 0 ]; then str='PE';
  fi; tar -xvf chr20genome.ext && STARlong --runThreadN 6 --readFilesCommand samtools
  view -h  --twopass1readsN -1  --outSAMattrRGline ID:SAMPLE_TEST PI:rg_mfl PL:Ion_Torrent_PGM
  PU:rg_platform_unit SM:rg_sample --outFileNamePrefix ./SAMPLE_TEST.twopass-basic.  --solotype
  Droplet  --readFilesType SAM $str --readFilesIn /test-data/chr20sample_pe1.bam  &&
  tar -vcf SAMPLE_TEST.twopass-basic._STARgenome.tar ./SAMPLE_TEST.twopass-basic._STARgenome   &&
  cat SAMPLE_TEST.twopass-basic.Unmapped.out.mate1 | sed 's/\t.*//' | paste - - -
  - | sort -k1,1 -S 10G | tr '\t' '\n' > SAMPLE_TEST.twopass-basic.Unmapped.out.mate1.fastq
  && rm SAMPLE_TEST.twopass-basic.Unmapped.out.mate1  && bash index_bam SAMPLE_TEST.twopass-basic.Aligned.sortedByCoord.out.bam
sbg:content_hash: aa91bd21a289b80c6555b27638d519f17cef5356588990f0181fcb308658c7a5f
sbg:contributors:
- nemanja.vucic
- veliborka_josipovic
sbg:createdBy: nemanja.vucic
sbg:createdOn: 1553263204
sbg:id: nemanja.vucic/star-2-5-3a-modified-demo/star-align-2-5-3a_modified/6
sbg:image_url: null
sbg:latestRevision: 6
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
sbg:modifiedOn: 1571322491
sbg:project: nemanja.vucic/star-2-5-3a-modified-demo
sbg:projectName: STAR 2.5.3a_modified - Demo
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: back to revision 2
sbg:revisionsInfo:
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1553263204
  sbg:revision: 0
  sbg:revisionNotes: null
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1553263777
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1559667867
  sbg:revision: 2
  sbg:revisionNotes: tested with cwltool
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1561561602
  sbg:revision: 3
  sbg:revisionNotes: added expression which adds metadata
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1561564707
  sbg:revision: 4
  sbg:revisionNotes: keep only platform info in expression
- sbg:modifiedBy: veliborka_josipovic
  sbg:modifiedOn: 1561633860
  sbg:revision: 5
  sbg:revisionNotes: added ID:1 in--outSAMattrRGline arg
- sbg:modifiedBy: nemanja.vucic
  sbg:modifiedOn: 1571322491
  sbg:revision: 6
  sbg:revisionNotes: back to revision 2
sbg:sbgMaintained: false
sbg:toolAuthor: Alexander Dobin/CSHL
sbg:toolkit: STAR
sbg:toolkitVersion: 2.5.3a_modified
sbg:validationErrors: []
