#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input          = "data/*.fastq.gz"
params.outdir         = "results"
params.kraken2_db     = "databases/kraken2_db"
params.min_quality    = 8
params.min_length     = 500
params.max_length     = 100000
params.bracken_length = 300
params.bracken_level  = "S"
params.bracken_thresh = 10
params.help           = false

include { NANOSTAT_RAW  } from './modules/nanostat_raw'
include { NANOFILT      } from './modules/nanofilt'
include { NANOSTAT_FILT } from './modules/nanostat_filt'
include { KRAKEN2       } from './modules/kraken2'
include { BRACKEN       } from './modules/bracken'
include { KRONA         } from './modules/krona'
include { FLYE          } from './modules/flye'
include { ABRICATE      } from './modules/abricate'
include { MULTIQC       } from './modules/multiqc'

workflow {

    if (params.help) {
        log.info """
        RGCB Shotgun Metagenomics ONT Pipeline v1.0.0
        Usage: nextflow run main.nf --input 'data/*.fastq.gz' --kraken2_db databases/kraken2_db
        """.stripIndent()
        exit 0
    }

    log.info """
    ==============================================
      RGCB Shotgun Metagenomics ONT Pipeline
    ==============================================
    input      : ${params.input}
    outdir     : ${params.outdir}
    kraken2_db : ${params.kraken2_db}
    min_quality: ${params.min_quality}
    min_length : ${params.min_length}
    """.stripIndent()

    ch_reads = Channel
        .fromPath(params.input, checkIfExists: true)
        .map { f ->
            def sid = f.name
                       .replaceAll(/\.fastq\.gz$/, '')
                       .replaceAll(/\.fastq$/, '')
                       .replaceAll(/\.fq\.gz$/, '')
                       .replaceAll(/\.fq$/, '')
            tuple(sid, f)
        }

    ch_db = Channel.value(file(params.kraken2_db, checkIfExists: true))

    // QC and filtering
    NANOSTAT_RAW  (ch_reads)
    NANOFILT      (ch_reads)
    NANOSTAT_FILT (NANOFILT.out.filtered)

    // Taxonomy
    KRAKEN2 (NANOFILT.out.filtered, ch_db)
    BRACKEN (KRAKEN2.out.report, ch_db)
    KRONA   (KRAKEN2.out.output)

    // Assembly and AMR
    FLYE     (NANOFILT.out.filtered)
    ABRICATE (FLYE.out.assembly)

    // MultiQC - extract only the path from tuples
    ch_multiqc = NANOSTAT_RAW.out.log
        .map { sample_id, log_file -> log_file }
        .mix(
            NANOSTAT_FILT.out.log.map { sample_id, log_file -> log_file }
        )
        .collect()

    MULTIQC(ch_multiqc)
}
