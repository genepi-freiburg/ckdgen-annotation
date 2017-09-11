INFN=$1
OUTFN=$2
FLIP=$3

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

if [ "$FLIP" == "1" ]
then
	echo "Build flipped MARKER_ALL"
else
	echo "Build regular MARKER_ALL"
	FLIP="0"
fi

echo "Input file: $INFN"
echo "Output file: $OUTFN"


# MRMEGA
#MarkerName      Chromosome      Position        EA      NEA     EAF     Nsample Ncohort Effects beta_0  se_0    beta_1  se_1    beta_2  se_2    beta_3  se_3    beta_4  se_4    chisq_association       ndf_association P-value_association
     chisq_ancestry_het      ndf_ancestry_het        P-value_ancestry_het    chisq_residual_het      ndf_residual_het        P-value_residual_het    lnBF    Comments

cat $INFN | \
	awk -v flip=$FLIP '{ 
		if (FNR>1) {
			split($1, parts, "_"); 
			if (flip == 1) {
				print parts[1] "_" parts[2] "_" toupper($4) "_" toupper($5) "\t" $0 
			} else {
				print parts[1] "_" parts[2] "_" toupper($5) "_" toupper($4) "\t" $0 
			}
		} else { 
			print "MARKER_ALL\t" $0 
		} 
	}' > $OUTFN
