args <- commandArgs(trailingOnly = TRUE)
infn = args[1]
outfn = args[2]
boundary = 500000
filterpval = 5e-8

print("Reading data...")
data = read.table(infn, h=T, sep="\t")

print("Subsetting and sorting...")
data = subset(data, data$P.value < filterpval)
data = data[order(data$P.value),]

regions = data.frame()
total_rows = nrow(data)

while (nrow(data) > 0) {
  top_row = data[1,]
  index_chr = top_row$chr
  index_pos = top_row$position
  prev_len = nrow(data)
  data = data[which(data$chr != index_chr | 
                      data$position < index_pos - boundary | 
                      data$position > index_pos + boundary),]
  locus_size = prev_len - nrow(data)
    
  top_row$locus_size = locus_size
  regions = rbind(regions, top_row)
  
  status = round((1 - nrow(data) / total_rows) * 100, 0)
  print(paste("Found locus with ", locus_size, " SNPs (", index_chr, ":", 
              index_pos, ", ", top_row$RSID, ", ", top_row$GeneName, ") - ",
              status, "%", sep=""))
}

write.table(regions, outfn, row.names=F, col.names=T, sep="\t", quote=F)
