INFN=$1
OUTFN=$2
ANNOTATE_FILE=/shared/annotation/data/SNP_Jointable.txt.gz

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

if [ "$OUTFN" == "" ]
then
	echo "Please give output file name."
	exit 3
fi

echo "Input file: $INFN"
echo "Output file: $OUTFN"
echo "Annotation file: $ANNOTATE_FILE"

echo
echo "Join to output file"
echo "-------------------"
# generate header
INFN_HEADER=`head -n 1 $INFN`
ANNO_HEADER=`zcat $ANNOTATE_FILE | head -n 1`
ANNO_HEADER2=`echo $ANNO_HEADER | sed 's/MARKER//'` # | sed 's/ /	/g'
echo "$INFN_HEADER	$ANNO_HEADER2" > $OUTFN

# Process Substitution - unzip on-the-fly before joining
# file 1: col 1, keep unpairable lines; file 2: col 1
echo "Join files"
join <(cat ${INFN} | tail -n+2 | sort -k1) <(zcat $ANNOTATE_FILE | tail -n+2) -1 1 -2 1 -t'	' >> $OUTFN

#echo "Sort $OUTFN"
#(head -n 1 $OUTFN && tail -n +2 $OUTFN | sort -k1,2.1) > ${OUTFN}.sorted
#mv ${OUTFN}.sorted $OUTFN

echo "Done"
