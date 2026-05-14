# RGCB Shotgun Metagenomics ONT Pipeline

Nextflow DSL2 pipeline for ONT shotgun metagenomics.
Validated on ZymoBIOMICS mock community (ERR3152364).
100% bacterial detection. 94.42% classification. Full AMR + virulence profiling.

## Usage
nextflow run main.nf --input 'data/*.fastq.gz' --kraken2_db databases/kraken2_db --outdir results
