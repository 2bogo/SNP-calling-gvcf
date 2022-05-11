SAMPLENAME=$1
REF=$2
DEPTH=$3

# Generate VCF containing genotype likelihoods for one or multiple alignment (BAM or CRAM) files.
# -g: output gVCF blocks of homzygous REF  calls, with depth (DP-number of high-quality bases) ranges specified by the list of integers.
bcftools mpileup -g $DEPTH -Oz -o ./gvcf/${SAMPLENAME}.gvcf.gz -f ${REF} ./sortBam/${SAMPLENAME}.sort.bam &&

# SNP/indel calling
# -m: alternative model for multiallelic and rare-variant calling
bcftools call -g $DEPTH -m -Oz -o ./gvcf/${SAMPLENAME}.call.gvcf.gz ./gvcf/${SAMPLENAME}.gvcf.gz &&
rm ./gvcf/${SAMPLENAME}.gvcf.gz &&

#normalize indels
bcftools norm --fasta-ref ${REF} ./gvcf/${SAMPLENAME}.call.gvcf.gz -Oz -o ./gvcf/${SAMPLENAME}.gvcf.gz &&
rm ./gvcf/${SAMPLENAME}.call.gvcf.gz &&

# indexing
bcftools index ./gvcf/${SAMPLENAME}.gvcf.gz