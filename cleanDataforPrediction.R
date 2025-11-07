get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}
libraries_used=c("httr","XML","RCurl","rvest","jsonlite","TTR","xts","tidyverse","combinat", "tseries") 
get_libraries(libraries_used)


ncol(df_full_data)
colnames(df_full_data)
for( i in c(7:ncol(df_full_data[,c(1:7)]))){
  print(unique(df_full_data[,i]))
}

print(unique(df_full_data$Time))
print(unique(df_full_data$HID))
print(unique(df_full_data$Pl))
print(unique(df_full_data$Wt))

#withdrawn df_full_data[,i]==-1|W
#withdrawn df_full_data[,i]==70 set to 1, 112to 12, 115 to 15 114 to 14, 410 to 10
# [,2]==0 =>PL="W"

# [,7] A|a|-|0|NSB
# [,7] replace 54.5( with 54.5 56 - with 56 -55 with 55

# remove V2=7, v5 = 95

# df_full_data = df_full_data[!(df_full_data$V2=="7"&df_full_data$V3=="95"),]
df_full_data = df_full_data[df_full_data$Pl!="W",]
df_full_data = df_full_data[df_full_data$Pl!="-1",]

df_full_data$Pl[df_full_data$Pl=="70"] ="1" 
df_full_data$Pl[df_full_data$Pl=="112"] ="12" 
df_full_data$Pl[df_full_data$Pl=="115"] ="15" 
df_full_data$Pl[df_full_data$Pl=="114"] ="14" 
df_full_data$Pl[df_full_data$Pl=="410"] ="10" 
df_full_data$Pl[df_full_data$Pl=="110"] ="10" 


df_full_data$Wt[df_full_data$Wt=="54.5("] ="54.5" 
df_full_data$Wt[df_full_data$Wt=="56-"] ="56" 
df_full_data$Wt[df_full_data$Wt=="60..5"] ="60.5" 

df_full_data$Wt = as.numeric(as.character(df_full_data$Wt))

df_full_data = df_full_data[df_full_data$Wt>33.50,]

df_full_data$Trainer=gsub(" ","",df_full_data$Trainer)
df_full_data$Jockey=gsub(" ","",df_full_data$Jockey)


df_full_data = df_full_data[(!is.na(df_full_data$H_FULLNAME)),]

L_age = strsplit(df_full_data$Desc," ", fixed = T)
s1 = unlist(lapply(L_age, '[[', 1))

df_full_data$age = s1
df_full_data$age = sub("y","",df_full_data$age)
df_full_data$age = substr(df_full_data$age,1,1)
df_full_data$age = as.numeric(as.character(df_full_data$age))

df_full_data$xino3 = gsub(" ","",df_full_data$xino3)
df_full_data$xino3 = gsub("M","",df_full_data$xino3)
df_full_data$xino3 = as.numeric(as.character(df_full_data$xino3))
df_full_data = df_full_data[!is.na(df_full_data$xino3),]
df_full_data = df_full_data[df_full_data$xino3>5,]


tx = df_full_data$Time
tx = gsub("\\.",":",tx)
tx = gsub("-",":",tx)
tx = gsub(" ",":",tx)
tx = gsub("::",":",tx)
tx = gsub(";",":",tx)
tx = gsub("!",":",tx)

tx = gsub(":16:842:1:16:842","1:16:842",tx)
tx = gsub("\\\\1:15:04","1:15:04",tx)

skip_time_list = c(unique(tx)[order(unique(tx))][c(1,2,3,11,12,13,14,15)],tail(unique(tx)[order(unique(tx))],102))
tx[tx%in%skip_time_list]="0:0:0"
tx = gsub("::",":",tx)
tx[tx=="1:"]="0:0:0"
tx[tx==":1:15:68"]="1:15:68"
tx[tx==":10:02"]="1:10:02"
tx[tx==":14:67"]="1:14:67"
tx[tx==":16:30"]="1:16:30"
tx[tx==":24:47"]="1:24:47"
tx[tx==":29:14"]="1:29:14"
tx[tx==":29:838"]="1:29:838"
tx[tx=="0:01:91"]="1:01:91"
tx[tx=="0:14:74"]="1:14:74"
tx[tx=="0:29:11"]="1:29:11"
tx[tx=="0:29:59"]="1:29:59"
tx[tx=="0:39:71"]="1:39:71"
tx[tx=="1:40"]="1:40:00"
tx[tx=="1:42"]="1:42:00"
tx[tx=="119:27"]="1:19:27"
tx[tx=="115:97"]="1:15:97"
tx[tx=="146:72"]="1:46:72"
tx[tx=="139:77"]="1:39:77"
tx[tx=="127:40"]="1:27:40"
tx[tx=="1:1635"]="1:16:35"
tx[tx=="1:12,47"]="1:12:47"
tx[tx=="1:31,18"]="1:31:18"
tx[tx=="1:16,93"]="1:16:93"
tx[tx=="1:12,47"]="1:12:47"
tx[tx=="1:31,18"]="1:31:18"
tx[tx=="115:45"]="1:15:45"
tx[tx=="1:13,68"]="1:13:68"

tx[tx=="116:66"]="1:16:66"
tx[tx=="1:27:"]="1:27:0"
tx[tx=="1:0096"]="1:00:96"
tx[tx=="1:1488"]="1:14:88"
tx[tx=="1:15"]="1:15:00"
tx[tx=="109:20"]="1:09:20"

tx[tx=="2:0:0:25"]="2:00:25"
tx[tx=="1\"29:84"]="1:29:84"
tx[tx=="1:20:08:2:1/2"]="1:20:082.5"
tx[tx=="2:38:78:7:1/2"]="2:38:787.5"
tx[tx=="1:16:853:1/2"]="1:16:853.5"

tx[tx=="3:1/4"]="1:14:989.5"



L_time = strsplit(tx,":")
# m=1
# for(k in c(1:length(L_time)))
# {
# if(length(L_time[[k]])==3){next;}
# m= c(m,k);
# }


dfTime = matrix(unlist(L_time), byrow = T,nrow = nrow(df_full_data))

df_full_data$RaceTime1 = dfTime[,1]
df_full_data$RaceTime2 = dfTime[,2]
df_full_data$RaceTime3 = dfTime[,3]

df_full_data$nCRaceTime3= nchar(df_full_data$RaceTime3)
df_full_data$dRaceTime3 = ifelse(df_full_data$nCRaceTime3<=2, as.numeric(as.character(df_full_data$RaceTime3))/100,as.numeric(as.character(df_full_data$RaceTime3))/1000)
df_full_data$mRaceTime2 = (as.numeric(as.character(df_full_data$RaceTime2))+df_full_data$dRaceTime3)/60
df_full_data$hRaceTime = as.numeric(as.character(df_full_data$RaceTime1))+df_full_data$mRaceTime2

df_full_data = df_full_data[df_full_data$hRaceTime>0,]


horceRacingdata = df_full_data[,c(1,2,5,6,7,8,9,10,13,14,16,17,19,22,25,31,38)]
