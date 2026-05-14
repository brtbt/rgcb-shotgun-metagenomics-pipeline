process KRONA {
    label      'process_low'
    publishDir "${params.outdir}/06_krona", mode: 'copy'

    input:
    tuple val(sample_id), path(kraken2_output)

    output:
    tuple val(sample_id), path("${sample_id}_krona.html"), emit: html

    script:
    """
    cut -f2,3 ${kraken2_output} > krona_input.txt
    ktImportTaxonomy krona_input.txt -o ${sample_id}_krona.html
    echo "Krona chart: ${sample_id}_krona.html"
    """

    stub:
    """
    touch ${sample_id}_krona.html
    """
}
