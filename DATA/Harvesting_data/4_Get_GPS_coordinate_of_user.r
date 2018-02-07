	#--------------------------------------------------------------------------------------------------
	#   
	#		The Surf-R Project | Part 4 | Find Coordinates
	#
	#					Yan Holtz (yan.holtz.data@gmail.com)
	#
	#---------------------------------------------------------------------------------------------------

# This script is the fourth part of the Surf-R project.
# It aims, for each tweet, to recover the GPS coordinate of users.
# It follows the part 3, where we found the city name provided by users.
# We need to ask to the google API the coordinate of these cities.



# 1/ ------------- PREPARE -----------

# library ggmap 
library(ggmap)
# LIMIT=2500 Per day

# This script can bug because of API rate. User already done are saved iteration per 
# iteration in a file to avoid restarting from the beginning. If a unfinished file exists,
# we have to load it:
if (file.exists("GPS_des_loc.R")){
	
	print("Found temp file - Loading it")
	load("GPS_des_loc.R")

	print("How many locations have already been treated?")
	length(unique(final$loc))
	}


# Get back the cities of users, we found it in part 3
load("../ANALYSE/User_database.R")

# We deduce the locations we still have to study
myloc=unique(output$loc)
print("Number of loc to study in total:")
ntot=length(myloc)
print(ntot)
myloc=myloc[ -which(final$loc %in% output$loc)]
print("Number of loc remaining")
nremain=length(myloc)
print(nremain)







# 2/ ------------- IMPROVED GEOCODE FUNCTION -----------

# An improved version of the geocode function. It will wait when over the query limit! It is
# inspired from http://www.shanelynn.ie/massive-geocoding-with-r-and-google-maps/
getGeoDetails <- function(address){   

	# ask google where it is. I place this is try.catch because sometimes people use emoticone 
	# in the text and it makes a bug
	geo_reply = tryCatch( 
		{  geocode( as.character(address), output='all', messaging=TRUE, override_limit=TRUE) },
		error = function(e) { return("error") } 
		)
	if(length(geo_reply)==1){ 
		res=data.frame(loc=address, lat=NA	, lon=NA)
		return(res)
		}
		
	# if we are over the query limit - want to pause for an hour
	my_status <- geo_reply$status
	while(my_status == "OVER_QUERY_LIMIT"){
		print("OVER QUERY LIMIT - Pausing for 1 hour at:") 
		time <- Sys.time()
		print(as.character(time))
		Sys.sleep(60*60)
		geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
		my_status <- geo_reply$status
		}
 
	# return Na's if we didn't get a match:
	if (geo_reply$status != "OK"){
		res=data.frame(loc=address, lat=NA	, lon=NA)
		return(res)
		}
      
	# else, extract what we need from the Google server reply into a dataframe:
	my_lat <- geo_reply$results[[1]]$geometry$location$lat
	my_lon <- geo_reply$results[[1]]$geometry$location$lng   
 	res=data.frame(loc=address, lat=my_lat, lon=my_lon)
 	return(res)
 	
 	}





# 3/ ------------- APPLY THE FUNCTION -----------


for( address in myloc){

	# get geocode
	res=getGeoDetails( as.character(address) )
 	
	# save the answer
	final=rbind(final, res)
	save(final, file="GPS_des_loc.R")
	
	# tell the user how much remains
	nremain=nremain-1
	print(paste( " ------- number of loc remaining : ", nremain, " (There were ", ntot, " locations at the beginning)",sep=""))
	
	}




















