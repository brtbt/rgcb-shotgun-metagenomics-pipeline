process NANOFILT {
    label      'process_low'
    publishDir "${params.outdir}/02_filtered", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_filtered.fastq.gz"), emit: filtered
    tuple val(sample_id), path("${sample_id}_nanofilt.log"),      emit: log

    script:
    """
    zcat ${fastq} | \
    NanoFilt \
        --quality ${params.min_quality} \
        --length ${params.min_length} \
        --maxlength ${params.max_length} \
        2> ${sample_id}_nanofilt.log | \
    gzip > ${sample_id}_filtered.fastq.gz

    echo "Raw reads    : \$(zcat ${fastq} | grep -c '^@')"                    >> ${sample_id}_nanofilt.log
    echo "Filtered reads: \$(zcat ${sample_id}_filtered.fastq.gz | grep -c '^@')" >> ${sample_id}_nanofilt.log
    """

    stub:
    """
    touch ${sample_id}_filtered.fastq.gz ${sample_id}_nanofilt.log
    """
}
