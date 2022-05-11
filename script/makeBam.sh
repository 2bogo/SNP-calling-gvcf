SAMPLENAME=$1
REF=$2
THREAD=$3

# mapping low-divergent sequences against a large reference genome
bwa mem -t $THREAD $ $REF ./fastq/${SAMPLENAME}_1.fastq ./fastq/${SAMPLENAME}_2.fastq -o ./tmp/${SAMPLENAME}.sam &&

# mapping 과정에서 생긴 잘못된 FLAG 값 수정
samtools fixmate -O bam ./tmp/${SAMPLENAME}.sam ./tmp${SAMPLENAME}.bam &&
rm ./tmp/${SAMPLENAME}.sam &&

# coordinate(좌표) 기준으로 sorting 해주는 과정
sambamba sort -t $THREAD -o ./sortBam/${SAMPLENAME}.sort.bam ./tmp/${SAMPLENAME}.bam --tmpdir ./tmp &&
rm ./tmp/${SAMPLENAME}.bam