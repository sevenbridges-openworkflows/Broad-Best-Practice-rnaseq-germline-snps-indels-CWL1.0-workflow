# Broad-Best-Practice-rnaseq-germline-snps-indels-CWL1.0-workflow

This workflow represents the GATK Best Practices for SNP and INDEL calling on RNA-Seq data. 

Starting from an unmapped BAM file, it performs alignment to the reference genome, followed by marking duplicates, reassigning mapping qualities, base recalibration, variant calling and variant filtering. On the [GATK website](https://software.broadinstitute.org/gatk/documentation/article.php?id=3891), you can find more detailed information about calling variants in RNA-Seq.

###Common Use Cases
- If you have raw sequencing reads in FASTQ format, you should convert them to an unmapped BAM file using the **Picard FastqToSam** app before running the workflow.
- **BaseRecalibrator** uses **Known indels** and **Known SNPs** databases to mask out polymorphic sites when creating a model for adjusting quality scores. Also, the **HaplotypeCaller** uses the **Known SNPs** database to populate the ID column of the VCF output.
- The **HaplotypeCaller** app uses **Intervals list** to restrict processing to specific genomic intervals. You can set the **Scatter count** value in order to split **Intervals list** into smaller intervals. **HaplotypeCaller** processes these intervals in parallel, which will significantly reduce workflow execution time  in some cases.
- You can provide a pre-generated **STAR** reference index file or a genome reference file to the **Reference or STAR index** input.
- **Running a batch task**: Batching is performed by **Sample ID** metadata field on the **Unmapped BAM** input port. For running analyses in batches, it is necessary to set **Sample ID** metadata for each unmapped BAM file.


###Changes Introduced by Seven Bridges
This workflow represents the GATK Best Practices for SNP and indel calling on RNA-Seq data, and there are no modifications to the original workflow.


###Common Issues and Important Notes
- As the *(--known-sites)* is the required option for GATK BaseRecalibrator tool, it is necessary to provide at least one database file to the **Known INDELs** or **Known SNPs** input port.
- If you are providing pre-generated STAR reference index make sure it is created using the adequate version of STAR (check the STAR version in the original [WDL file](https://github.com/gatk-workflows/gatk3-4-rnaseq-germline-snps-indels/blob/master/rna-germline-variant-calling.wdl)).
- When converting FASTQ files to an unmapped BAM file using **Picard FastqToSam**, it is required to set the **Platform** (`PLATFORM=`) parameter.
- This workflow allows you to process one sample per task execution. If you are planning to process more than one sample, it is required to run multiple task executions in batch mode. More about batch analyses can be found [here](https://docs.sevenbridges.com/docs/about-batch-analyses).
 

###Performance Benchmarking
The default memory and CPU requirements for each app in the workflow are the same as in the original [GATK Best Practices WDL](https://github.com/gatk-workflows/gatk3-4-rnaseq-germline-snps-indels/blob/master/rna-germline-variant-calling.wdl). You can change the default runtime requirements for **STAR GenomeGenerate** and **STAR Align** apps. 

| Experiment type |  Input size | Paired-end | # of reads | Read length | Duration |  AWS Instance Cost (spot) | AWS Instance Cost (on-demand) | 
|:--------------:|:------------:|:--------:|:-------:|:---------:|:----------:|:------:|:------:|
|     RNA-Seq     |  1.3 GB |     Yes    |     16M     |     101     |   2h44min   | 0.79$ | 1.79$ | 
|     RNA-Seq     |  3.9 GB |     Yes    |     50M     |     101     |   4h38min   | 1.29$ | 2.71$ | 
|     RNA-Seq     | 6.5 GB |     Yes    |     82M    |     101     |  6h44min  | 1.85$ | 3.84$ | 
|     RNA-Seq     | 12.9 GB |     Yes    |     164M    |     101     |  12h4min  | 3.30$ | 6.99$ |


###API Python Implementation
The workflow's draft task can also be submitted via the API. To learn how to get your Authentication token and API endpoint for the corresponding platform, visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).
```python
from sevenbridges import Api

authentication_token, api_endpoint = "enter_your_token", "enter_api_endpoint"
api = Api(token=authentication_token, url=api_endpoint)
# Get project_id/workflow_id from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/workflow
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

task = api.tasks.create(name='GATK4 RNA-Seq Workflow - API Example', project=project_id, app=workflow_id, inputs=inputs, run=False)
#For running a batch task
task = api.tasks.create(name='GATK4 RNA-Seq Workflow - API Batch Example', project=project_id, app=workflow_id, inputs=inputs, run=False, batch_input='in_alignments', batch_by = { 'type': 'CRITERIA', 'criteria': [ 'metadata.sample_id'] })
```

Instructions for installing and configuring the API Python client are provided on GitHub. For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). More examples are available [here](https://github.com/sbg/okAPI).

Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).
