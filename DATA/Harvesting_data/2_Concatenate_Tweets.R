	#--------------------------------------------------------------------------------------------------
	#   
	#		The Surf-R Project | Part 2 | Concatenate tweets
	#
	#					Yan Holtz (yan.holtz.data@gmail.com)
	#
	#---------------------------------------------------------------------------------------------------

# IMPORTANT NOTE: this script relies on the twitteR library, which is deprecated. I strongly advise to use the rtweet library instead. 
# This document is a very good source of info to learn how to harvest tweets: http://bit.ly/2E4a8AD
	
# This script is the second part of the Surf-R project.
# Tweets have been recovered during several months every day (see part 1)
# I need to concatenate them together in one single file.


# read files 1 by 1 and concatenante them.
don=data.frame(matrix(0,0,16))
for(i in list.files(pattern="_recovery_tweets_") ){
	load(i)
	don=rbind(don, data)
	}

# delete redondant lines
don=unique(don)
	
# save it as an R environment
save(don , file="ANALYSE/Raw_data_SurferProject.R")




