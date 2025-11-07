get_libraries <- function(filenames_list) {
  lapply(filenames_list,function(thelibrary){   
    if (do.call(require,list(thelibrary)) == FALSE)
      do.call(install.packages,list(thelibrary))
    do.call(library,list(thelibrary))
  })
}
libraries_used=c("plyr","tidyverse","MASS","arm","MNP","PlackettLuce")
get_libraries(libraries_used)


horse_racing_rawdata = read.csv("~/Hobbies/horseracing/HorRacingHistory.csv")
data_set1 = matrix(unlist(strsplit(as.character(horse_racing_rawdata$V12),split = "&",fixed = TRUE)), ncol = 2, byrow = T)
data_set2 = matrix(unlist(strsplit(as.character(data_set1[,1]),split = "=",fixed = TRUE)), ncol = 2, byrow = T)

horse_racing_rawdata$hId = data_set2[,2]
horse_racing_rawdata$h2 = data_set1[,2]
horse_racing_rawdata$h2 = gsub("hname=","",horse_racing_rawdata$h2)

data_set3 = matrix(unlist(strsplit(as.character(horse_racing_rawdata$V15),split = "&",fixed = TRUE)), ncol = 2, byrow = T)
data_set4 = matrix(unlist(strsplit(as.character(data_set3[,1]),split = "=",fixed = TRUE)), ncol = 2, byrow = T)

horse_racing_rawdata$Date = data_set4[,2]
horse_racing_rawdata$Venue =  data_set3[,2]
horse_racing_rawdata$Venue = gsub("venue=","",horse_racing_rawdata$Venue)
horse_racing_rawdata$Date = gsub(" ","",horse_racing_rawdata$Date)
horse_racing_rawdata$Date = strptime(horse_racing_rawdata$Date,format = "%b%d%Y")


time_df = gsub(" \t","", horse_racing_rawdata[,10])
time_df = gsub("\t","", time_df)
time_df = gsub(" ","", time_df)
time_df = gsub(":",".", time_df)


horstime = (as.data.frame(time_df) %>% separate(time_df, into = paste("V", 1:3, sep = ".")))
horstime[,4] =substr(horstime[,3],1,2) 
horstime$time = (as.numeric(as.character(horstime[,4]))/100+as.numeric(as.character(horstime[,2])))/60+as.numeric(as.character(horstime[,1]))
horse_racing_rawdata$decimatlTime =horstime$time
dist_df = as.character(horse_racing_rawdata$V10)
distance = (as.data.frame(dist_df) %>% separate(dist_df, into = paste("V", 1:2, sep = " ")))

horse_racing_rawdata$Distance = distance[,1]
horse_racing_rawdata$RaceName = as.character(horse_racing_rawdata$V11)
horse_racing_rawdata$Rank = as.numeric(as.character(horse_racing_rawdata$X))
horse_racing_rawdata$StartPos = as.numeric(as.character(horse_racing_rawdata$V1))
horse_racing_rawdata$Weight = as.numeric(as.character(horse_racing_rawdata$V2))
horse_racing_rawdata$Weight[horse_racing_rawdata$Weight<40] <- NA

dates_set = as.data.frame(horse_racing_rawdata$Date)
dates_set$D2 = substr(dates_set[,1],1,3)
dates_set$Y2 = substr(dates_set[,1],(nchar(as.character(dates_set[,1]))-3),nchar(as.character(dates_set[,1])))
dates_set$D1 = substr(dates_set[,1],4,(nchar(as.character(dates_set[,1]))-4))
dates_set$Date = as.Date(paste(dates_set$D1,dates_set$D2,dates_set$Y2,sep = "-"), format = "%d-%b-%Y" ) 

horse_racing_rawdata$RealDate = dates_set$Date
horse_racing_rawdata$Speed = as.numeric(horse_racing_rawdata$Distance)/horse_racing_rawdata$decimatlTime

horse_racing_cleanData = horse_racing_rawdata[!is.na(horse_racing_rawdata$Speed),]
horse_racing_cleanData = horse_racing_cleanData[is.finite(horse_racing_cleanData$Speed),]

dfHRanknRanking2 = group_by(horse_racing_cleanData, hId) %>% summarize(mean_cont = mean(Speed), stddev_cont = sd(Speed))%>%arrange(mean_cont)
nrow(dfHRanknRanking2)


horse_racing_cleanData$UID = paste(horse_racing_cleanData$Venue,horse_racing_cleanData$RaceName,horse_racing_cleanData$RealDate, sep="_")
horse_racing_cleanData$UID = gsub(" ","_",horse_racing_cleanData$UID)
horse_racing_cleanData$UID = gsub("__","_",horse_racing_cleanData$UID)


horse_racing_cleanData$UVar1Rank = horse_racing_cleanData$V4
horse_racing_cleanData = horse_racing_cleanData[horse_racing_cleanData$UVar1Rank<31,]


horse_racing_cleanData$UVar2Rank = horse_racing_cleanData$V7





race_info = as.data.frame((unique(horse_racing_cleanData$UID)))
colnames(race_info) = "race_info"
race_info$race_info = as.character(race_info$race_info)
race_info$date = substr(race_info$race_info,(nchar(race_info$race_info)-9),nchar(race_info$race_info))

odds_data = horse_racing_cleanData[horse_racing_cleanData$V8!="",]
odds_data = (odds_data[!grepl(":|-|Dist|dist|HEAD|Shd|SHD", odds_data$V8),])

unique(odds_data$V8)[order(unique(odds_data$V8))]
nrow(odds_data)
odds_data$V8 = gsub(" \t","", odds_data$V8)
odds_data$V8 = gsub("\t","", odds_data$V8)
odds_data$V8 = gsub(" ","", odds_data$V8)
odds_data$V8 = gsub("\\("," ", odds_data$V8)
odds_data$V8 = gsub("\\)"," ", odds_data$V8)
odds_data$V8 = gsub("//","/", odds_data$V8,fixed=TRUE)
odds_data$V8 = gsub(" ","", odds_data$V8)
odds_data$V8 = gsub(";","/", odds_data$V8)

df = as.data.frame(odds_data$V8)
skip = unique(odds_data$V8)[order(unique(odds_data$V8))][c(1:8,344:351)]
df[] <- apply(df, c(1, 2), function(x) if(x %in% skip){NA} else {eval(parse(text = x))}) 
