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


#MarkerName      Allele1 Allele2 Freq1   FreqSE  MinFreq MaxFreq Effect  StdErr  P-va
#01_160620151_S  a       g       0.8441  0.0182  0.7319  0.8729  -0.0002 0.0006  0.7

cat $INFN | \
	awk -v flip=$FLIP '{ 
		if (FNR>1) {
			split($1, parts, "_"); 
			if (flip == 1) {
				print parts[1] "_" parts[2] "_" toupper($2) "_" toupper($3) "\t" $0 
			} else {
				print parts[1] "_" parts[2] "_" toupper($3) "_" toupper($2) "\t" $0 
			}
		} else { 
			print "MARKER_ALL\t" $0 
		} 
	}' > $OUTFN
