#!/usr/bin/env bash

#SBATCH --job-name=FastQC
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --partition=pibu_el8

# define the path to the diffrent directories, including the container directory
WORKDIR=/data/users/jimhof/assembly_annotation_course
WGSDIR=$WORKDIR/02_FastP/WGS.fq.gz
WTSDIR_1=$WORKDIR/02_FastP/WTS.R1.fq.gz
WTSDIR_2=$WORKDIR/02_FastP/WTS.R2.fq.gz
OUTDIR=$WORKDIR/03_FastQC_after_FastP
CONTAINERDIR=/containers/apptainer/fastqc-0.12.1.sif

# run fastqc in the container using appainter
# the bind option gives access to the working directory 

# PacBio HiFi (WGS)
apptainer exec --bind $WORKDIR $CONTAINERDIR \
 fastqc -t 2 -o $OUTDIR $WGSDIR

# Illumina (RNA-Seq)
apptainer exec --bind $WORKDIR $CONTAINERDIR \
 fastqc -t 2 -o $OUTDIR $WTSDIR_1 $WTSDIR_2