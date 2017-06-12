if [ "$1" == "" ]
then
	echo "Please give METAL output file as parameter."
	exit 3
fi

FN=$1
if [ ! -f "$FN" ]
then
	echo "Input file not found: $FN"
	exit 3
fi

OUTFN=$2
if [ -f "$OUTFN" ]
then
	echo "Output file exists: $OUTFN"
	echo "Stop - please remove"
	exit 3
else
	echo "Use output file: $OUTFN"
fi

NSTUD="2"
if [ "$3" != "" ]
then
	NSTUD=$3
	echo "Use NSTUD filter from commandline: >= $NSTUD"
else
	echo "Use default NSTUD filter: >= $NSTUD"
fi

HETISQ="90"
if [ "$4" != "" ]
then
	HETISQ=$4
	echo "Use HetISq filter from commandline: <${HETISQ}%"
else
	echo "Use default HetISq filter: <${HETISQ}%"
fi

cat $FN | awk -F $'\t' -v nstud_filter=$NSTUD -v hetisq_filter=$HETISQ 'BEGIN {OFS = FS} { 
	if (FNR > 1) {
		isq = $12;
		nstud = $14 + 1;
		if (nstud >= nstud_filter && isq < hetisq_filter) {
			print $0;
		}
	} else {
		print $0;
	} }' > ${OUTFN}

wc -l $FN $OUTFN
