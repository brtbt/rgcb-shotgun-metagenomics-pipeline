process ABRICATE {
    label      'process_low'
    publishDir "${params.outdir}/08_amr", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)

    output:
    tuple val(sample_id), path("${sample_id}_amr_card.txt"),       emit: card
    tuple val(sample_id), path("${sample_id}_amr_resfinder.txt"),  emit: resfinder
    tuple val(sample_id), path("${sample_id}_virulence.txt"),       emit: virulence

    script:
    """
    abricate --db card      ${assembly} > ${sample_id}_amr_card.txt
    abricate --db resfinder ${assembly} > ${sample_id}_amr_resfinder.txt
    abricate --db vfdb      ${assembly} > ${sample_id}_virulence.txt

    echo "--- AMR summary (CARD) ---"
    wc -l ${sample_id}_amr_card.txt

    echo "--- Virulence summary (VFDB) ---"
    wc -l ${sample_id}_virulence.txt
    """

    stub:
    """
    touch ${sample_id}_amr_card.txt \
          ${sample_id}_amr_resfinder.txt \
          ${sample_id}_virulence.txt
    """
}
