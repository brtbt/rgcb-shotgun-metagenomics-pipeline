process NANOSTAT_RAW {
    label      'process_low'
    publishDir "${params.outdir}/01_qc_raw", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_raw_nanostat.txt"), emit: log

    script:
    """
    NanoStat \
        --fastq ${fastq} \
        --outdir . \
        --name ${sample_id}_raw_nanostat.txt \
        --threads ${task.cpus}
    """

    stub:
    """
    touch ${sample_id}_raw_nanostat.txt
    """
}
