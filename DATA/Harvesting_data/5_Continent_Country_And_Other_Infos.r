	#--------------------------------------------------------------------------------------------------
	#   
	#		The Surf-R Project | Part 5 | Merge all info + add country, continent and other info
	#
	#					Script proposed by Yan Holtz (yan.holtz.data@gmail.com)
	#
	#---------------------------------------------------------------------------------------------------

# This script is the fifth part of the Surf-R project.
# It aims to concatenate info we get in the four first parts
# We add other informations like country, continent..


# work on CC2
cd /homedir/holtz/work/TWEETER/GET_SURF_EVERY_DAY/ANALYSE3

# get back work done on part 1, 2, 3 and 4
R
load("../ANALYSE/Raw_data_SurferProject.R")
load("../ANALYSE/User_database.R")
load("../ANALYSE2/GPS_des_loc.R")

# merge informations:
final=merge(output, final, by.x="loc", by.y="loc")
data=merge(don, final, by.x="screenName" , by.y="user", all.x=T)

# Coordinate must be numeric
data$longitude=as.numeric(data$longitude)
data$latitude=as.numeric(data$latitude)

# add a "day" column
data$day=as.Date(data$created, format='%m/%d/%Y')
data$weekday=weekdays(data$created)
data$month=months(data$created)
data$week=as.numeric(format(as.Date(data$created), "%U"))

# Find countries and continent
# http://stackoverflow.com/questions/14334970/convert-latitude-and-longitude-coordinates-to-country-name-in-r
library(rworldmap)
library(sp)
coords2country = function(points){  
  countriesSP <- getMap(resolution='low')
  pointsSP = SpatialPoints(points, proj4string=CRS(proj4string(countriesSP)))  
  indices = over(pointsSP, countriesSP)
  return( data.frame(country=as.character(indices$ADMIN) , continent=as.character(indices$REGION) ))
}
home=coords2country(na.omit(data[ , c("lon","lat")]) )
travel=coords2country(na.omit(data[ , c("longitude","latitude")]) )
# rempli data
data$homecountry=data$homecontinent=NA
data$homecountry[!is.na(data$lon)]=as.character(home[,1])
data$homecontinent[!is.na(data$lon)]=as.character(home[,2])
data$travelcountry=data$travelcontinent <- NA
data$travelcountry[!is.na(data$longitude)]=as.character(travel[,1])
data$travelcontinent[!is.na(data$longitude)]=as.character(travel[,2])

# rename columns
colnames(data)[15:19]=c("travellon","travellat","homename","homelat","homelon")

# On ajoute 3 colonnes: kite surf et wind selon si le hashtag y est!
data$kite=data$wind=data$surf=0
data$kite[ grep("#kite" , data$text, ignore.case = T) ]=1
data$wind[ grep("#wind" , data$text, ignore.case = T) ]=1
data$surf[ grep("#surf" , data$text, ignore.case = T) ]=1

# On calcule la distance entre home et travel lorsque c'est possible:
library(sp)
tmp=subset(data, !is.na(homelon) & !is.na(travellon))
km <- sapply(1:nrow(tmp),function(i) spDistsN1(as.matrix(tmp[i,c("homelon","homelat")]),as.matrix(tmp[i,c("travellon","travellat")]),longlat=T))
data$km=NA
data$km[ which( !is.na(data$homelon) & !is.na(data$travellon))]=km             
                
# On peut sauvegarder ce tableau qui est maintenant complet.
save(data , file="Data_ready_for_anayses.R")

# Et on balance en local pour la dataviz!
cd /Users/yan/Dropbox/TweetR_and_surfR/DATA
scp holtz@CC2-login.cirad.fr://homedir/holtz/work/TWEETER/GET_SURF_EVERY_DAY/ANALYSE3/Data_ready_for_anayses.R .


