# RGCB Shotgun Metagenomics ONT Pipeline

Nextflow DSL2 pipeline for ONT shotgun metagenomics.
Validated on ZymoBIOMICS mock community (ERR3152364).

## Steps
1. NanoStat raw QC
2. NanoFilt quality filtering
3. NanoStat filtered QC
4. Kraken2 taxonomy classification
5. Bracken abundance estimation
6. Krona interactive visualization
7. Flye metagenomic assembly
8. Abricate AMR + virulence detection
9. MultiQC aggregate report

## Usage
nextflow run main.nf --input 'data/*.fastq.gz' --kraken2_db databases/kraken2_db --outdir results
