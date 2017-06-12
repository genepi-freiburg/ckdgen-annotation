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

if [ "$PVAL_BOUNDARY" == "" ]
then
	PVAL_BOUNDARY=1E-6
	echo "Use default for pval-boundary parameter: $PVAL_BOUNDARY"
fi

echo "Input file: $INFN"
echo "Output file: $OUTFN"
echo "P-value boundary: <${PVAL_BOUNDARY}"

cat $INFN | awk -F $'\t' -v pval_boundary=$PVAL_BOUNDARY 'BEGIN {OFS = FS} {
        if (FNR > 1) {
		pval = $10;
                if (pval < pval_boundary) {
                        print $0;
                }
        } else {
             #   print $0;
        } }' > ${OUTFN}

echo "Sort output"
sort -k 1 $OUTFN > ${OUTFN}.sorted

echo "Add header"
head -n 1 $INFN > $OUTFN
cat ${OUTFN}.sorted >>$OUTFN
rm -f ${OUTFN}.sorted

wc -l $INFN $OUTFN
