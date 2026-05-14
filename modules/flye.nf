process FLYE {
    label      'process_high'
    publishDir "${params.outdir}/07_assembly", mode: 'copy'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_assembly.fasta"), emit: assembly
    path "${sample_id}_assembly_info.txt",                      emit: info

    script:
    """
    flye \
        --nano-raw ${fastq} \
        --meta \
        --out-dir ${sample_id}_flye \
        --threads ${task.cpus}

    cp ${sample_id}_flye/assembly.fasta     ${sample_id}_assembly.fasta
    cp ${sample_id}_flye/assembly_info.txt  ${sample_id}_assembly_info.txt

    echo "--- Assembly summary ---"
    echo "Contigs: \$(grep -c '>' ${sample_id}_assembly.fasta)"
    """

    stub:
    """
    touch ${sample_id}_assembly.fasta ${sample_id}_assembly_info.txt
    """
}
