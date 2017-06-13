INFN=$1
OUTFN=$2
ANNOTATE_FILE=/shared/annotation/data/tabix/SNP_HG19_Masterfile-170607.txt.gz

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
INFN_HEADER=`head -n 1 $INFN`
ANNO_HEADER=`zcat $ANNOTATE_FILE | head -n 1`
ANNO_HEADER2=`echo $ANNO_HEADER | sed 's/MARKER //' | sed 's/ /	/g'`
echo "$INFN_HEADER	$ANNO_HEADER2" > $OUTFN

# file 1: col 1, keep unpairable lines; file 2: col 3
join <(tail -n+2 $INFN) <(zcat $ANNOTATE_FILE | tail -n+2) -1 1 -2 3 -a 1 -t'	' >> $OUTFN

wc -l $INFN $OUTFN


