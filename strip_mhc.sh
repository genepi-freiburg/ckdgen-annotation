if [ ! -f "$1" ]
then
	echo "Expect input file as first parameter."
	exit 3
fi

FN="$1"
FN_NO_MHC="${FN}.noMHC.txt"
FN_ONLY_MHC="${FN}.onlyMHC.txt"

FIND_COL=/shared/cleaning/scripts/find-column-index.pl
MARKER_COL=`$FIND_COL MarkerName $FN`

echo "Marker name column (0-based): $MARKER_COL"

echo "Write non-MHC region lines to: $FN_NO_MHC"
echo "Strip MHC region to: $FN_ONLY_MHC"

cat $FN | awk -F $'\t' \
	-v markerCol=$MARKER_COL \
	-v fnNoMhc=$FN_NO_MHC \
	-v fnOnlyMhc=$FN_ONLY_MHC \
	'BEGIN { OFS = FS } 
	{
	        if (FNR > 1) {
			split($(markerCol+1), chrPos, "_");
			chr = chrPos[1];
			pos = chrPos[2];
			# 25.5-34.0Mb
			if (chr == 6 && pos >= 25500000 && pos < 34000000) {
				print $0 > fnOnlyMhc;
			} else {
				print $0 > fnNoMhc;
			}
        	} else {
			print $0 > fnNoMhc;
			print $0 > fnOnlyMhc;
        	} 
	}' 

if [[ "$FN" =~ locus ]]
then
	FN_BEST_MHC="${FN}.MHC.txt"
	echo "Detected *.locus file. Add best p-value to: $FN_BEST_MHC"
	PVAL_COL=`$FIND_COL P.value $FN`
	PVAL_COL=$((PVAL_COL + 1))
	echo "P-value column (1-based): $PVAL_COL"
	cp $FN_NO_MHC $FN_BEST_MHC
	cat $FN_ONLY_MHC | tail -n+2 | sort -g -k $PVAL_COL | head -n 1 >> $FN_BEST_MHC
	cat $FN_BEST_MHC | tail -n+2 | sort -k $((MARKER_COL+1)) > ${FN_BEST_MHC}.sorted
	head -n 1 $FN_ONLY_MHC > $FN_BEST_MHC
	cat ${FN_BEST_MHC}.sorted >> $FN_BEST_MHC
	rm ${FN_BEST_MHC}.sorted
	wc -l $FN_BEST_MHC
fi

echo "Should sum up (add additional header line)"
wc -l $FN
wc -l $FN_NO_MHC $FN_ONLY_MHC
echo "Done."
