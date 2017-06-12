INFN=$1
OUTFN=$2
ANNOTATE_FILE=/shared/annotation/data/SNP_HG19_Masterfile-170607.txt.gz

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

echo "Input file: $INFN"
echo "Output file: $OUTFN"
echo "Annotation file: $ANNOTATE_FILE"

# Process Substitution - unzip on-the-fly before joining
join $INFN <(zcat $ANNOTATE_FILE) -1 1 -2 3 > $OUTFN

wc -l $INFN $OUTFN


