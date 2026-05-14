process KRAKEN2 {
    label      'process_high'
    publishDir "${params.outdir}/04_kraken2", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)
    path kraken2_db

    output:
    tuple val(sample_id), path("${sample_id}_kraken2_report.txt"), emit: report
    tuple val(sample_id), path("${sample_id}_kraken2_output.txt"), emit: output

    script:
    """
    kraken2 \
        --db ${kraken2_db} \
        --threads ${task.cpus} \
        --report ${sample_id}_kraken2_report.txt \
        --output ${sample_id}_kraken2_output.txt \
        --gzip-compressed \
        ${fastq}

    echo "--- Top 20 taxonomy hits ---"
    head -20 ${sample_id}_kraken2_report.txt
    """

    stub:
    """
    touch ${sample_id}_kraken2_report.txt ${sample_id}_kraken2_output.txt
    """
}
