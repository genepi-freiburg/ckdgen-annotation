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

if [ "$OUTFN" == "" ]
then
	echo "Please give filter output file name as second parameter."
	echo "Usage: $0 <MetalIn> <FilterOut> [<nStud> [<hetISq> [<nEff> [<nTot>]]]]"
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

NSTUD="0"
if [ "$3" != "" ]
then
	NSTUD=$3
	echo "Use NSTUD filter from commandline: >= $NSTUD"
else
	echo "Use default NSTUD filter: >= $NSTUD"
fi

HETISQ="101"
if [ "$4" != "" ]
then
	HETISQ=$4
	echo "Use HetISq filter from commandline: < ${HETISQ}%"
else
	echo "Use default HetISq filter: < ${HETISQ}%"
fi

NEFF="0"
if [ "$5" != "" ]
then
        NEFF=$5
        echo "Use sum(n(effective)) filter from commandline: >= ${NEFF}"
else
        echo "Use default sum(n(effective)) filter: >= ${NEFF}"
fi

NTOT="0"
if [ "$6" != "" ]
then
        NTOT=$6
        echo "Use sum(n(total)) filter from commandline: >= ${NTOT}"
else
        echo "Use default sum(n(total)) filter: >= ${NTOT}}"
fi


FIND_COL=/shared/cleaning/scripts/find-column-index.pl
NSTUD_COL=`$FIND_COL HetDf $FN`
ISQ_COL=`$FIND_COL HetISq $FN`
SUM_EFF_COL=`$FIND_COL n_effective_sum $FN`
SUM_TOT_COL=`$FIND_COL n_total_sum $FN`
echo "Columns (0-based): n(studies) = $NSTUD_COL, sum(n(effective)) = $SUM_EFF_COL, sum(n(total)) = $SUM_TOT_COL"

cat $FN | awk -F $'\t' -v nstud_filter=$NSTUD -v hetisq_filter=$HETISQ -v neff_filter=$NEFF -v ntot_filter=$NTOT \
	-v nStudCol=$NSTUD_COL -v isqCol=$ISQCOL -v sumEffCol=$SUM_EFF_COL -v sumTotCol=$SUM_TOT_COL \
	'BEGIN {OFS = FS} { 
	if (FNR > 1) {
		isq = $(isqCol+1);
		nstud = $(nStudCol+1) + 1;
		sumeff = $(sumEffCol+1);
		sumtot = $(sumTotCol+1);
		if (nstud >= nstud_filter && isq < hetisq_filter && sumeff >= neff_filter && sumtot >= ntot_filter) {
			print $0;
		}
	} else {
		print $0;
	} }' > ${OUTFN}

wc -l $FN $OUTFN
