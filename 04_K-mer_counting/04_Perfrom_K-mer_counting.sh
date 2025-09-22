#!/usr/bin/env bash

#SBATCH --job-name=Perform_K_mer_counting
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=20G
#SBATCH --partition=pibu_el8

# define the path to the diffrent directories, including the container directory
WORKDIR=/data/users/jimhof/assembly_annotation_course
WGSDIR=$WORKDIR/02_FastP/WGS.fq.gz
WTSDIR_1=$WORKDIR/02_FastP/WTS.R1.fq.gz
WTSDIR_2=$WORKDIR/02_FastP/WTS.R2.fq.gz
OUTDIR=$WORKDIR/04_K-mer_counting
CONTAINERDIR=/containers/apptainer/jellyfish-2.2.6--0.sif

# run fastqc in the container using appainter
# the bind option gives access to the working directory 

# Count k-mers (k=21) with canonical representation
apptainer exec --bind $WORKDIR $CONTAINERDIR \
 jellyfish count -C -m 21 -s 5G -t 4 \
    <(zcat $WGSDIR) \
    -o $OUTDIR/reads.jf
 

# Generate k-mer histogram
apptainer exec --bind $WORKDIR $CONTAINERDIR \
 jellyfish histo -t 4 $OUTDIR/reads.jf > $OUTDIR/reads.histo