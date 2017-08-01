FN=$1

if [ "$FN" == "" ]
then
	echo "Please give METAL file as first argument."
	exit 3
fi

if [ ! -f "$FN" ]
then
	echo "Input does not exist: $FN"
	exit 3
fi

OUT=${FN}.epacts

if [ -f "$OUT" ] || [ -f "${OUT}.gz" ]
then
	echo "Output file exists: $OUT / ${OUT}.gz, please remove first!"
	exit 3
fi

echo "Convert METAL to EPACTS: $FN -> $OUT"

cat $FN | awk 'BEGIN { OFS="\t" } { 
	if (FNR > 1) {
		marker = $1;
		af = $4;
		pval = $10;
		if (af > 0.5) {
			af = 1 - af;
		}
		split(marker, marker_array, "_");
		chr = marker_array[1];
 		pos = marker_array[2];
		print chr + 0, pos + 0, pos + 1, marker, af, pval;
	} else {
		print "#CHROM", "BEGIN", "END", "MARKER_ID", "MAF", "PVALUE";
	} }' | sort -n -k1,2 > ${OUT}

echo "Sort file $OUT"
head -n1 $OUT > ${OUT}.sorted
tail -n+2 $OUT | sort -k1n -k2n >> ${OUT}.sorted
wc -l ${OUT}.sorted ${OUT}
mv ${OUT}.sorted ${OUT}

echo "bgzip $OUT"
bgzip $OUT

echo "tabix $OUT.gz"
/shared/annotation/bin/htslib/tabix -h -s 1 -b 2 -e 3 -f ${OUT}.gz

