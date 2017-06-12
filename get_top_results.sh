INFN=$1
OUTFN=$2
TOPN=$3

if [ ! -f "$INFN" ]
then
	echo "Input file does not exist: $INFN"
	exit 3
fi

if [ -f "$OUTFN" ]
then
	echo "Output file exists - please remove: $OUTFN"
	exit 3
fi

if [ "$TOPN" == "" ]
then
	TOPN=10000
	echo "Use default for TopN parameter: 10000"
fi

echo "Retrieve top $TOPN rows"
echo "Input file: $INFN"
echo "Output file: $OUTFN"

# keep header
#head -n 1 $INFN > $OUTFN

# sort -g can sort exponential numbers
# first line is header (because of sort order)

sort -g -k 10 $INFN | head -n $TOPN > $OUTFN

