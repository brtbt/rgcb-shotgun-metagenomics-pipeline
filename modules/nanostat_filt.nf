process NANOSTAT_FILT {
    label      'process_low'
    publishDir "${params.outdir}/03_qc_filtered", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_filtered_nanostat.txt"), emit: log

    script:
    """
    NanoStat \
        --fastq ${fastq} \
        --outdir . \
        --name ${sample_id}_filtered_nanostat.txt \
        --threads ${task.cpus}
    """

    stub:
    """
    touch ${sample_id}_filtered_nanostat.txt
    """
}
