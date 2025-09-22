#!/usr/bin/env bash

#SBATCH --job-name=FastQC
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=pibu_el8

# define the path to the diffrent directories, including the container directory
WORKDIR=/data/users/jimhof/assembly_annotation_course
WTSDIR_1=$WORKDIR/00_Sequencing_Data/RNAseq_Sha/ERR754081_1.fastq.gz
WTSDIR_2=$WORKDIR/00_Sequencing_Data/RNAseq_Sha/ERR754081_2.fastq.gz
OUTDIR=$WORKDIR/01_FastQC_MultiQC
CONTAINERDIR=/containers/apptainer/fastqc-0.12.1.sif

# run fastqc in the container using appainter
# the bind option gives access to the working directory 
apptainer exec --bind $WORKDIR $CONTAINERDIR \
 fastqc -t 2 -o $OUTDIR $WTSDIR_1 $WTSDIR_2