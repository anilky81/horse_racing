Races_form = read.csv("~/Hobbies/horseracing/VenueDateSession.csv", header = F)
Races_form$V2=as.character(Races_form$V2)
dest_location = which(Races_form$V2==Races_form$V2[2])[seq(1,16,by = 2)]-1

Races_form$V2[dest_location]= c("1","3","4","7","8","10","11","2")
dest_map = Races_form[dest_location,]
Races_form$V1=as.character(Races_form$V1)

dest_map$SeasonListStart=0; dest_map$SeasonListEnd=0
dest_map$SeasonListStart = which(Races_form$V2==Races_form$V2[2])[seq(1,16,by = 2)]+1
dest_map$SeasonListEnd = which(Races_form$V2==Races_form$V2[2])[seq(2,16,by = 2)]-1

dest_map$DateListStart=0; dest_map$DateListEnd=0
dest_map$DateListStart =  which(Races_form$V2==Races_form$V2[2])[seq(2,16,by = 2)]+1
dest_map$DateListEnd = c(which(Races_form$V2==Races_form$V2[2])[seq(3,16,by = 2)]-1,nrow(Races_form))

# <option value="1"  >KOLKATA</option>
#   <option value="3"  >BANGALORE</option>
#   <option value="4"  >CHENNAI</option>
#   <option value="7"  >DELHI</option>
#   <option value="8"  >MYSORE</option>
#   <option value="10"  >PUNE</option>
#   <option value="11"  >HYDERABAD</option>

url_venueseason <- "http://www.indiarace.com/index.php?/Home/SeasonbyVenue"
SeasonVenueMap = as.data.frame(fromJSON(url_venueseason)[[1]])
dfSeaVen = SeasonVenueMap
dfSeaVen$seasonEndDate = ifelse(is.na(dfSeaVen$seasonEndDate),dfSeaVen$seasonStartDate,dfSeaVen$seasonEndDate)
dfSeaVen$seasonEndDate = na.locf(dfSeaVen$seasonEndDate)
dfSeaVen$seasonStartDate = na.locf(dfSeaVen$seasonStartDate)

dfRaces_form = Races_form
dfRaces_form$Dest = ifelse(dfRaces_form$V1%in%dest_map$V1,dfRaces_form$V2,NA)
dfRaces_form$Dest = na.locf(dfRaces_form$Dest)
date_loc =  paste(paste(dest_map$DateListStart,dest_map$DateListEnd,sep=":"), collapse = ",")

date_dest_map = (dfRaces_form[c(48:616,657:1298,1306:1376,1391:1903,1961:2534,2556:2875,2915:3624,3645:4089),])
head(dfSeaVen)
head(date_dest_map)