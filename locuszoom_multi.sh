LOCUS_FILE=$1
EPACTS_FILE=$2

if [ "$#" -lt 2 ]
then
	echo "Usage: $0 <LocusFile> <EpactsFile> [<pop>]"
	echo "Plots all regions in <LocusFile> using LocusZoom"
	echo "Need .gz / .gz.tbi for <EpactsFile>"
	echo "Example: $0 myLoci.locus MetaResult.epacts.gz"
	exit 2
fi

echo "Got 2 or more arguments."

if [ ! -f "${LOCUS_FILE}" ]
then
	echo "Locus input file not found: $LOCUS_FILE"
	exit 3
fi

echo "Got LOCUS_FILE: $LOCUS_FILE"

if [ ! -f "$EPACTS_FILE" ]
then
	echo "EPACTS input file not found: $EPACTS_FILE"
	exit 3
fi

echo "Got EPACTS_FILE: $EPACTS_FILE"

if [ ! -f "${EPACTS_FILE}.tbi" ]
then
	echo "Tabix index for EPACTS input file not found: ${EPACTS_FILE}.tbi"
	exit 3
fi

echo "Plot loci from locus file $LOCUS_FILE using EPACTS file $EPACTS_FILE"

POP="EUR"
if [ "$3" != "" ]
then
	POP="$3"
fi
echo "Using population: $POP"

echo "Generate hitspec file"
/shared/annotation/scripts/locus_to_hitspec.sh $LOCUS_FILE

echo "Invoke LocusZoom"
locuszoom --epacts $EPACTS_FILE \
	--hitspec ${LOCUS_FILE%.*}.hitspec \
	--build hg19 \
	--pop $POP \
	--source 1000G_March2012 \
	--gwas-cat whole-cat_significant-only \
	--plotonly \
	--prefix locuszoom_plot_

echo "Move plots to subdirectory 'locuszoom_plots'"
rm -rf locuszoom_plots
mkdir -p locuszoom_plots
mv locuszoom_plot_* locuszoom_plots

echo "Extract page 1 of all plots"
for file in `ls locuszoom_plots/*.pdf`
do
	OUT="${file%.*}-page1.pdf"
	echo "Process $file -> $OUT"
	gs -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${OUT}" -dFirstPage=1 -dLastPage=1 "$file" 
done

echo "Combine PDF files"
gs -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="${LOCUS_FILE%.*}-LZ_Plots.pdf" locuszoom_plots/*-page1.pdf

echo "Cleanup"
#rm -rf locuszoom_plots
#rm -f ld_cache.db
