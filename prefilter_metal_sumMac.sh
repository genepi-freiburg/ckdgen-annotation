if [ "$1" == "" ]
then
	echo "Please give METAL output file as first parameter."
	echo "Usage: $0 <MetalOut> <FilterOut> [<nStud> [<hetISq> [<nEff> [<nTot>]]]]"
	exit 3
fi

FN=$1
if [ ! -f "$FN" ]
then
	echo "Input file not found: $FN"
	exit 3
fi

OUTFN=$2
if [ "$OUTFN" == "" ]
then
	echo "Please give filter output file name as second parameter."
	echo "Usage: $0 <MetalIn> <FilterOut> [<nStud> [<hetISq> [<nEff> [<nTot>]]]]"
	exit 3
fi

if [ -f "$OUTFN" ]
then
        echo "Output file exists: $OUTFN"
        echo "Stop - please remove"
        exit 3
else
        echo "Use output file: $OUTFN"
fi

SUMMAC=$3
if [ "$3" == "" ]
then
	echo "Please give sum(mac) filter as third parameter."
	exit 3
fi

FIND_COL=/shared/cleaning/scripts/find-column-index.pl
SUM_MAC_COL=`$FIND_COL mac_sum $FN`
echo "Columns (0-based): sum(mac) = $SUM_MAC_COL"

cat $FN | awk -F $'\t' -v sumMacCol=$SUM_MAC_COL -v sumMacFilter=$SUMMAC \
	'BEGIN {OFS = FS} { 
	if (FNR > 1) {
		sumMac = $(sumMacCol+1);

		if (sumMac >= sumMacFilter) {
			print $0;
		}
	} else {
		print $0;
	} }' > ${OUTFN}

wc -l $FN $OUTFN
