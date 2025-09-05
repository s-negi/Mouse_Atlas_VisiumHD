#!/bin/bash
#$ -N sr_c_multi
#$ -cwd
#$ -j y
#$ -o logs/sr_count_multi_$TASK_ID.out
#$ -M soumya.negi@lilly.com
#$ -m beas
#$ -t 1-12
#$ -pe smp 8 



module load spaceranger/4

transcriptome="/lrlhps/data/NGTx/genomes/mm10/GRCm39_10xgenomics/"  

samples=(
    25116-01-01
    25116-01-02
    25116-01-03
    25116-01-04
    25116-01-05
    25116-01-06
    25116-01-07
    25116-01-08
    25116-01-09
    25116-01-10
    25116-01-11
    25116-01-12
)

sample=${samples[$((SGE_TASK_ID - 1))]}

fastqs="/lrlhps/data/NGTx/SpatialTranscriptomics-mouse-atlas-oligo702/25116-01-fastq/" 
transcriptome="/lrlhps/data/NGTx/genomes/mm10/GRCm39_10xgenomics/refdata-gex-GRCm39-2024-A"
images="/lrlhps/data/NGTx/SpatialTranscriptomics-mouse-atlas-oligo702/25116-01-Images"
output="/lrlhps/data/NGTx/SpatialTranscriptomics-mouse-atlas-oligo702/outputs/brain"

mkdir -p ${output}/${sample}

spaceranger count   --id=${sample} \
                    --sample=${sample} \
                    --fastqs=${fastqs} \
                    --transcriptome=${transcriptome} \
                    --probe-set=/lrlhps/data/NGTx/genomes/mm10/GRCm39_10xgenomics/Visium_Mouse_Transcriptome_Probe_Set_v2.1.0_GRCm39-2024-A.csv \
                    --create-bam=true \
                    --image=${images}/${sample}_mouse_tissue_imageV2.btf \
                    --cytaimage=${images}/${sample}_Cytassist_image.tif \
                    --output-dir=${output}/${sample} \
                    --localcores=${NSLOTS}

echo "Spaceranger count completed for sample: ${sample}"
date
echo "Job ID: ${JOB_ID}, Task ID: ${SGE_TASK_ID}, Cores: ${NSLOTS}"
echo "Output directory: ${output}/${sample}"
echo "Transcriptome: ${transcriptome}"
echo "Fastqs: ${fastqs}"
echo "Images: ${images}"
