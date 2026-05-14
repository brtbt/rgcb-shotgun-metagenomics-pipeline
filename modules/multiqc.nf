process MULTIQC {
    label      'process_low'
    publishDir "${params.outdir}/09_multiqc", mode: 'copy'

    input:
    path logs

    output:
    path "multiqc_report.html",      emit: report
    path "multiqc_report_data/",     emit: data

    script:
    """
    multiqc . -o . --filename multiqc_report.html
    echo "MultiQC report generated"
    """

    stub:
    """
    mkdir -p multiqc_report_data
    touch multiqc_report.html
    touch multiqc_report_data/multiqc_general_stats.txt
    """
}
