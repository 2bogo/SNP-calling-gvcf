while getopts s: flag
do
    case "${flag}" in
        s) sample=${OPTARG};;
        *)
          echo "script usage: $(basename $0) [-s sample list text file]"
          exit 1 ;;
    esac
done
if [ "$sample" ]
then
  echo "sample list path: $sample";

  parallel -j 1 "fasterq-dump --split-files {.} -O ./fastq/" :::: $SAMPLE
else
  echo "script usage: $(basename $0) [-s sample list text file]"
  exit 1
fi