



count_non_questionmarks = function (line, borders) {
	result = c()
	prev_border = 0
	my_borders = c(borders, nchar(line))

	#print("my_borders")
	#print(my_borders)

	for (border in my_borders) {
		subline = substr(line, prev_border, border - 1)
#		print("subline")
#		print(subline)
		non_questionmark = 0
		for (i in 1:nchar(subline)) {
			if (substr(subline, i, i) != "?") {
				non_questionmark = non_questionmark + 1
			}
		}
		result = c(result, non_questionmark)
		prev_border = border
	}
	result
}

#line = "+--+++-+-++++---+++-+?+-?++-+-++++-++--+++++++++++-++--++--+-+-+++-+-+++-+-++-+--+-++-++---++++++---++++++++-++--+++-++-+";
#borders = c(20,40,60)
#print(count_non_questionmarks(line, borders))
