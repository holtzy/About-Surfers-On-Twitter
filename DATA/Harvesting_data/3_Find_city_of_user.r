	#--------------------------------------------------------------------------------------------------
	#   
	#		The Surf-R Project | Part 3 | Find City
	#
	#					Yan Holtz (yan.holtz.data@gmail.com)
	#
	#---------------------------------------------------------------------------------------------------

# IMPORTANT NOTE: this script relies on the twitteR library, which is deprecated. I strongly advise to use the rtweet library instead. 
# This document is a very good source of info to learn how to harvest and deal with tweets: http://bit.ly/2E4a8AD
	
# This script is the third part of the Surf-R project.
# It aims, for each tweet, to recover the city of origin.
# Once more working with tweeter gets difficult because of the limitation rate of the API
# We need to wait between 2 sets of tweets.



# Load data
load("Raw_data_SurferProject.R")

# How many unique users do we have in total?
users=unique(don$screenName)
print("total number of users:")
print(length(users))

# library
library(twitteR)

# API access
api_key <- "OR92mqxxxxxxxxxxxxxxxxx"
api_secret <- "XgFCEqxxxxxxxxxxxxxxxxx"
access_token <- "70150qxxxxxxxxxxxxxxxxx"
access_token_secret <- "aKE8Dxqxxxxxxxxxxxxxxxxx"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# This script can bug because of API rate. User already done are saved here to avoid restarting from the beginning:
load("User_database.R")

# How many users are already known?
print("number of users with localization already known")
print(length(unique(output$user)))

# New account we need to study
users=users[-which(users %in% output$user)]
print("number of remaining account to study")
length(users)

# Let's split this list of users by slice of 20 users
f=rep_len(1:(length(users)/40) , length(users))
datasplit=split(users, f)
n=max(f)

# for each slice we find the location provided by the user
for(i in c(1:max(f))){

	# First, we need to check we have no limit problem with the API. If not, we wait.
	while( length(which(as.numeric(getCurRateLimitInfo()$remaining)<3))!=0 ){
		print("woooo, we need to wait")
		Sys.sleep(16*60)
		}	

	# give information
	print("Where are we in the loop?")
	print(paste(i," \ ",n,sep=""))
	print("nbr total de user avec loc connue:")
	print(dim(output))
	
	# get locations for this slice
	my_loc=sapply( lookupUsers(datasplit[[i]] , includeNA=F) , function(x){print(x) ; location(x)} ) 

	# add it to the bilan table
	bilan=data.frame(user=names(my_loc), loc=my_loc)
	output=rbind(output, bilan)

	# save it
	save(output , file="User_database.R")

}







