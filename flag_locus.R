args <- commandArgs(trailingOnly = TRUE)
infn = args[1]
outfn = args[2]

known_loci_fn = "/shared/annotation/data/Known_Loci_20170717.txt"
boundary = 500000

print("Reading data...")
data = read.table(infn, h=T, sep="\t")

print("Reading known loci...")
known = read.table(known_loci_fn, h=T, sep="\t")

print("Flagging...")
for (i in 1:nrow(data)) {
	my_begin = data[i, "position"] - boundary
	my_end = data[i, "position"] + boundary
	data[i, "region_begin"] = my_begin
	data[i, "region_end"] = my_end
	known_idx = which(known$Chr == data[i, "chr"] &
		known$Pos_b37 > my_begin &
		known$Pos_b37 < my_end)
	if (length(known_idx) > 0) {
		data[i, "is_known"] = 1
		data[i, "paper"] = paste(known[known_idx, "Reference"], collapse=";")
		data[i, "trait"] = paste(known[known_idx, "Trait"], collapse=";")
	} else {
		data[i, "is_known"] = 0
		data[i, "paper"] = ""
		data[i, "trait"] = ""
	}
}

print("Writing output...")
write.table(data, outfn, row.names=F, col.names=T, sep="\t", quote=F)
