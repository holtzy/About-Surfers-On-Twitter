	#--------------------------------------------------------------------------------------------------
	#   
	#		The Surf-R Project | Part 1 | Recover tweets
	#
	#					Yan Holtz (yan.holtz.data@gmail.com)
	#
	#---------------------------------------------------------------------------------------------------

# IMPORTANT NOTE: this script relies on the twitteR library, which is deprecated. I strongly advise to use the rtweet library instead. 
# This document is a very good source of info to learn how to harvest tweets: http://bit.ly/2E4a8AD


# This script is the first part of the Surf-R project.
# It aims to recover tweets containing #surf, #windsurf and #kitesurf every day.


# library
library(twitteR)

# you need an access to the tweeter api first. Once you have it, give your access token
api_key <- "OR92mqxxxxxxxxxxxxxxxxx"
api_secret <- "XgFCEqxxxxxxxxxxxxxxxxx"
access_token <- "70150qxxxxxxxxxxxxxxxxx"
access_token_secret <- "aKE8Dxqxxxxxxxxxxxxxxxxx"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# Every day during one year I am going to:
num=0
for(i in c(1:365)){

	# print today date:
	num=num+1
	print(as.character(Sys.Date()))
	print(num)
	
	# get tweets containing #surf: 
	my_tweets=searchTwitter("#surf" , since=as.character(Sys.Date()-2) , until=as.character(Sys.Date()-1) ,n=5000)
	data=twListToDF(my_tweets)
	my_file_name=paste(num,"_surf_recovery_tweets_" , as.character(Sys.Date()) , ".R" , sep="" )
	save(data , file=my_file_name)

	# #kite: 
	my_tweets=searchTwitter("#kite" , since=as.character(Sys.Date()-2) , until=as.character(Sys.Date()-1) ,n=5000)
	data=twListToDF(my_tweets)
	my_file_name=paste(num,"_kite_recovery_tweets_" , as.character(Sys.Date()) , ".R" , sep="" )
	save(data , file=my_file_name)

	# #windsurf: 
	my_tweets=searchTwitter("#windsurf" , since=as.character(Sys.Date()-2) , until=as.character(Sys.Date()-1) ,n=5000)
	data=twListToDF(my_tweets)
	my_file_name=paste(num,"_windsurf_recovery_tweets_" , as.character(Sys.Date()) , ".R" , sep="" )
	save(data , file=my_file_name)

  # Wait one day (~86400 secondes) :
  Sys.sleep(86380)
    
	}
	
# This script will produce 3 R files every day, one for each hashtag selected.
# See next script to analyse them.

	

