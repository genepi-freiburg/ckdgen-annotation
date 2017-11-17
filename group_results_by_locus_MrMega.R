## cols: MarkerName	Chromosome	Position	EA	NEA	EAF	Nsample	Ncohort	Effects	beta_0	se_0	beta_1	se_1	beta_2	se_2	beta_3	se_3	chisq_association	ndf_association	P-value_association	chisq_ancestry_het	ndf_ancestry_het	P-value_ancestry_het	chisq_residual_het	ndf_residual_het	P-value_residual_het	lnBF	Comments


args <- commandArgs(trailingOnly = TRUE)
infn = args[1]
outfn = args[2]
boundary = 500000
filterpval = 5e-8

print("Reading data...")
data = read.table(infn, h=T, sep="\t")

print("Subsetting and sorting...")
data = subset(data, data$P.value_association < filterpval)
data = data[order(data$P.value_association),]

regions = data.frame()
total_rows = nrow(data)

while (nrow(data) > 0) {
  top_row = data[1,]
  index_chr = top_row$Chromosome
  index_pos = top_row$Position
  prev_len = nrow(data)
  data = data[which(data$Chromosome != index_chr | 
                      data$Position < index_pos - boundary | 
                      data$Position > index_pos + boundary),]
  locus_size = prev_len - nrow(data)
    
  top_row$locus_size = locus_size
  regions = rbind(regions, top_row)
  
  status = round((1 - nrow(data) / total_rows) * 100, 0)
  print(paste("Found locus with ", locus_size, " SNPs (", index_chr, ":", 
              index_pos, ") - ",
              status, "%", sep=""))
}

write.table(regions, outfn, row.names=F, col.names=T, sep="\t", quote=F)
