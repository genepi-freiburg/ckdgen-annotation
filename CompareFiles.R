args = commandArgs(trailingOnly=TRUE)
if (length(args) != 6) {
	print("Usage: inFile1 chrColName posColName inFile2 chrColName posColName")
	stop()
}

d1 = read.table(args[1], h=T, sep="\t")
d2 = read.table(args[4], h=T, sep="\t")

d1x = data.frame(CHR=as.factor(d1[,args[2]]), 
		 POS=as.numeric(d1[,args[3]]))
d2x = data.frame(CHR=as.factor(d2[,args[5]]), 
		 POS=as.numeric(d2[,args[6]]))

print("dimensions file 1")
dim(d1x)
#summary(d1x)

print("dimensions file 2")
dim(d2x)
#summary(d2x)

compare_sets = function (a, b) {
	c = data.frame()
	for (i in 1:nrow(a)) {
		chr = a[i, "CHR"]
		pos = a[i, "POS"]
		b1 = subset(b, b$CHR == chr)
		b1$DELTA = abs(b1$POS - pos)
		b1$POS_ORIG = pos
		b2 = b1[order(b1$DELTA),]
		c = rbind(c, b2[1,])
	}
	c
}

print("compare 1 to 2")
d12 = compare_sets(d1x, d2x)
print(d12)
print("delta < 100000")
print(length(which(d12$DELTA < 100000)))
print("delta == 0")
print(length(which(d12$DELTA == 0)))

print("compare 2 to 1")
d21 = compare_sets(d2x, d1x)
print(d21)
print("delta < 100000")
print(length(which(d21$DELTA < 100000)))
print("deltta == 0")
print(length(which(d21$DELTA == 0)))


