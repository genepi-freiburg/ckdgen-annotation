LOCUS_FILE=$1

HITSPEC_FILE="${LOCUS_FILE%.*}"
HITSPEC_FILE="${HITSPEC_FILE}.hitspec"

echo "$LOCUS_FILE -> $HITSPEC_FILE"

# MARKER_ALL	MarkerName	Allele1	Allele2	Freq1	FreqSE	MinFreq	MaxFreq	Effect	StdErr	P.value	Direction	HetISq	HetChiSq	HetDf	HetPVal	n_total_sum	n_effective_sum	mac_sum	oevar_imp_sum	ID	SNP	MARKER	chr	position	ref	alt	is_SNP	RSID	Function	GeneName	GeneDist	Genes100kb	is_HRCv11	is_HRCv10	is_TGv3	is_TGv5	HRCv11_ALL	HRCv11_AFAM	HRCv11_ASN	HRCv11_CAUC	HRCv10_ALL	HRCv10_AFAM	HRCv10_ASN	HRCv10_CAUC	TGv3_ALL	TGv3_AFAM	TGv3_ASN	TGv3_CAUC	TGv5_ALL	TGv5_AFAM	TGv5_ASN	TGv5_CAUC	locus_size	region_begin	region_end	is_known	paper	trait

FIND_COL="/shared/cleaning/scripts/find-column-index.pl"
SNP_COL=`$FIND_COL 'RSID' $LOCUS_FILE`
CHR_COL=`$FIND_COL 'chr' $LOCUS_FILE`
POS_COL=`$FIND_COL 'position' $LOCUS_FILE`

echo "SNP column: $SNP_COL"
echo "CHR column: $CHR_COL"
echo "POS column: $POS_COL"

cat $LOCUS_FILE | awk -v snpCol=$SNP_COL -v chrCol=$CHR_COL -v posCol=$POS_COL 'BEGIN {
	OFS = "\t";
	print "snp", "chr", "start", "end", "flank", "run", "m2zargs";
} { if (FNR > 1) {
	print $(snpCol+1), "NA", "NA", "NA", "500KB", "yes", "";	
	#print "NA", $(chrCol+1), $(posCol+1)-250000, $(posCol+1)+250000, "NA", "yes", "";	
} 
}' > $HITSPEC_FILE

echo "Generated hitspec file."
wc -l $LOCUS_FILE $HITSPEC_FILE
