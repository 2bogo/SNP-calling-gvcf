REF=$1
OUTPUT=$2

bcftools merge -g ${REF} -m both -Oz -o ${OUTPUT}.gz ./gvcf/*.gvcf.gz &&
bcftools view -i 'F_MISSING < 0.05' -Oz -o ${OUTPUT}.missing.gz ${OUTPUT}.gz &&
bcftools view -e 'N_ALT!=0' -Oz -o ${OUTPUT}.alt.gz ${OUTPUT}.missing.gz &&
rm ${OUTPUT}.missing.gz &&
bcftools filter -sLowQual -g3 -G10 -e'%QUAL<10 || (RPB<0.1 && %QUAL<15) || (AC<2 && %QUAL<15)' -Oz -o ${OUTPUT}.filter.gz ${OUTPUT}.alt.gz &&
rm ${OUTPUT}.alt.gz

echo "finish"