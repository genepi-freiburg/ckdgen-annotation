#!/bin/bash

FN=$1

if [ "$FN" == "" ]
then
        echo "Please give GCTA CMA COJO file as first argument."
        exit 3
fi

if [ ! -f "$FN" ]
then
        echo "Input does not exist: $FN"
        exit 3
fi

OUT=$2

if [ "$OUT" == "" ]
then
	echo "Please give pseudo-EPACTS output file name as second argument."
	exit 3
fi

if [ -f "$OUT" ]
then
        echo "Output file exists, please remove first: $FN"
        exit 3
fi

# GCTA cojo: Chr     SNP     bp      refA    freq    b       se      p       n       freq_geno       bC      bC_se   pC
# EPACTS: "#CHROM", "BEGIN", "END", "MARKER_ID", "MAF", "PVALUE"

cat $FN | awk 'BEGIN { OFS="\t" } { 
	if (FNR > 1) {
		chr = $1;
		rsid = $2;
		pos = $3;
		af = $5;
		pval = $13;
		if (af > 0.5) {
			af = 1 - af;
		}
		print chr + 0, pos + 0, pos + 1, rsid, af, pval;
	} else {
		print "#CHROM", "BEGIN", "END", "MARKER_ID", "MAF", "PVALUE";
	} }' | sort -n -k1,2 > ${OUT}

