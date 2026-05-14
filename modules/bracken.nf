process BRACKEN {
    label      'process_low'
    publishDir "${params.outdir}/05_bracken", mode: 'copy'

    input:
    tuple val(sample_id), path(report)
    path kraken2_db

    output:
    tuple val(sample_id), path("${sample_id}_bracken_species.txt"), emit: abundance

    script:
    """
    bracken \
        -d ${kraken2_db} \
        -i ${report} \
        -o ${sample_id}_bracken_species.txt \
        -r ${params.bracken_length} \
        -l ${params.bracken_level} \
        -t ${params.bracken_thresh}

    echo "--- Top 15 species by abundance ---"
    sort -t\$'\\t' -k6 -rn ${sample_id}_bracken_species.txt | \
        grep -v '^name' | head -15
    """

    stub:
    """
    touch ${sample_id}_bracken_species.txt
    """
}
