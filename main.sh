while getopts s:f:d:t:o: flag
do
    case "${flag}" in
        s) sample=${OPTARG};;
        f) ref=${OPTARG};;
        d) depth=${OPTARG};;
        t) thread=${OPTARG};;
        o) output=${OPTARG};;
        *)
          echo "script usage: $(basename $0) [-s sample list text file] [-f reference genome path] [-d depth ranges specified (integer)] [-t number of threads] [-o output file name]"
          exit 1 ;;
    esac
done

if [ "$sample" ] && [ "$ref" ] && [ "$depth" ] && [ "$thread" ] && [ "$output" ]
then
  echo "sample list path: $sample";
  echo "reference genome: $ref";
  echo "depth range: $depth";
  echo "Number of threads: $thread";
  echo "output file name: $output";

  parallel -j 1 "sh ./script/makeBam.sh {.} $ref $thread" :::: $sample &&
  parallel -j $thread "sh ./script/calling.sh {.} $ref $depth" :::: $sample &&
  sh ./script/merge.sh $ref $output
else
  echo "script usage: $(basename $0) [-s sample list text file] [-f reference genome path] [-d depth ranges specified (integer)] [-t number of threads] [-o output file name]"
  exit 1
fi

