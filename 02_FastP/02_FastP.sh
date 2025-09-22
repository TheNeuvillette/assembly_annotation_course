#!/usr/bin/env bash

#SBATCH --job-name=FastQC
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16G
#SBATCH --partition=pibu_el8

# define the path to the diffrent directories, including the container directory
WORKDIR=/data/users/jimhof/assembly_annotation_course

WGSDIR=$WORKDIR/00_Sequencing_Data/Etna-2/ERR11437333.fastq.gz
WTSDIR_1=$WORKDIR/00_Sequencing_Data/RNAseq_Sha/ERR754081_1.fastq.gz
WTSDIR_2=$WORKDIR/00_Sequencing_Data/RNAseq_Sha/ERR754081_2.fastq.gz

OUTDIR=$WORKDIR/02_FastP
CONTAINERDIR=/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif

# run fastp in the container using appainter
# the bind option gives access to the working directory

# ---------------------------------------------------------------------------------------
# PacBio HiFi sequencing reads shouldn't be filtered, but fastp shoud be run to get the total 
# number of bases and to and ensure no bad reads remain.

# --disable_adapter_trimming or -A disables trimming.
# --disable_quality_filtering or -Q disables quality filtering options.
# --disable_length_filtering or -L disables length filtering options.
# -i is the input file
# -o is the output file

apptainer exec --bind $WORKDIR $CONTAINERDIR \
 fastp -i $WGSDIR -o $OUTDIR/WGS.fq.gz -A -Q -L
# ---------------------------------------------------------------------------------------
# For RNA-Seq (Illumina), we will filter and trim bad reads.

# -i and -I are the input files (R1 and R2 for paired-end).
# -o and -O are the output files (R1 and R2 trimmed).

# --detect_adapter_for_pe detects adapters for paired-end reads.
# --trim_poly_g trims poly-G tails.
# --cut_tail or -3 trims reads based on a quality score threshold. 
#       Move a sliding window from tail (3') to front, drop the bases in the window if its mean quality < threshold, stop otherwise.
# --length_required 50 ensures that only reads with a length greater than 50

apptainer exec --bind $WORKDIR $CONTAINERDIR \
 fastp -i $WTSDIR_1 -I $WTSDIR_2 -o $OUTDIR/WTS.R1.fq.gz -O $OUTDIR/WTS.R2.fq.gz --detect_adapter_for_pe --trim_poly_g -3 --length_required 50
# ---------------------------------------------------------------------------------------

