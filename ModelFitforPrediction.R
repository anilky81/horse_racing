horceRacingdata$hRaceTime[which(horceRacingdata$hRaceTime>10)] = c(1.28117,1.29300,1.18533,2.16383,1.48367,1.49833)
horceRacingdata$Speed = horceRacingdata$xino3/horceRacingdata$hRaceTime
horceRacingdata = (horceRacingdata[!is.na(horceRacingdata$Speed),])
interest_Set = which(horceRacingdata$xino3>1700&horceRacingdata$hRaceTime<2&horceRacingdata$Speed>1500)
horceRacingdata$hRaceTime[c(interest_Set)] = 1+horceRacingdata$hRaceTime[c(interest_Set)]
horceRacingdata$Speed = horceRacingdata$xino3/horceRacingdata$hRaceTime

interest_Set = which(horceRacingdata$Speed>1150&horceRacingdata$xino3>1000)
horceRacingdata[interest_Set,]
interest_Set_Sub =interest_Set[c(1:25,31:34,44:51,56:63,76:89,93:103)]

horceRacingdata$hRaceTime[interest_Set_Sub] = horceRacingdata$hRaceTime[interest_Set_Sub]+1
horceRacingdata$Speed = horceRacingdata$xino3/horceRacingdata$hRaceTime
interest_Set = which(horceRacingdata$Speed>1150)

horceRacingdata[c(interest_Set,interest_Set+1)[ order(c(interest_Set,interest_Set+1))],]
m1 = cbind(horceRacingdata[c(interest_Set),],horceRacingdata[c(interest_Set+1),c("hRaceTime","EventDate","Speed")])
m1 = m1[m1[,20]<1000,]
horceRacingdata[rownames(m1),]$hRaceTime = m1[,18]
horceRacingdata$Speed = horceRacingdata$xino3/horceRacingdata$hRaceTime
interest_Set = which(horceRacingdata$Speed>1150|horceRacingdata$Speed<700)
horceRacingdata = horceRacingdata[-interest_Set,]

horceRacingdata$Dr = as.numeric(as.character(horceRacingdata$Dr))
horceRacingdata = horceRacingdata[horceRacingdata$Dr>0&horceRacingdata$Dr<23,]

horceRacingdata$Al = as.numeric(as.character(horceRacingdata$Al))
horceRacingdata = horceRacingdata[horceRacingdata$Al%in%(c(NA,unique(horceRacingdata$Al)[order(unique(horceRacingdata$Al))][1:23])),]
horceRacingdata$Al[is.na(horceRacingdata$Al)]="X"
horceRacingdata$Al = as.factor(horceRacingdata$Al)
horceRacingdata$Rtg = as.numeric(as.character(horceRacingdata$Rtg))
horceRacingdata$Rtg = ifelse(horceRacingdata$Rtg<0, -horceRacingdata$Rtg,horceRacingdata$Rtg)
# horceRacingdata$Rtg[is.na(horceRacingdata$Rtg)]=0
horceRacingdata$Rtg2 = (floor(horceRacingdata$Rtg/10))
horceRacingdata$Rtg2[is.na(horceRacingdata$Rtg2)]="X"
horceRacingdata$Rtg2 = as.factor(horceRacingdata$Rtg2)
# which(duplicated(horceRacingdata))
horceRacingdata = (horceRacingdata[!(duplicated(horceRacingdata)),])
horceRacingdata = horceRacingdata[-which((is.na(horceRacingdata$HID))),]

fit = (lm(Speed~xino3+age+Wt+Venue+Dr+Al+Rtg2, data =horceRacingdata )) # too many with not rating
summary(fit)

# horceRacingdata$Jockey = df_full_data[rownames(horceRacingdata),]$Jockey

hRankingDataset = as.data.frame((unique(horceRacingdata$HID))); colnames(hRankingDataset)= c("HID"); hRankingDataset$HID = as.character(hRankingDataset$HID)
jRankingDataset = as.data.frame((unique(horceRacingdata$Jockey))); colnames(jRankingDataset)= c("Jockey"); jRankingDataset$Jockey = as.character(jRankingDataset$Jockey) 
tRankingDataset = as.data.frame((unique(horceRacingdata$Trainer))); colnames(tRankingDataset)= c("Trainer"); tRankingDataset$Trainer = as.character(tRankingDataset$Trainer)

tRankingDataset$Trainer[tRankingDataset$Trainer%in%c("")]="None"
tRankingDataset$Trainer[tRankingDataset$Trainer%in%c("-")]="None2"
tRankingDataset$Trainer[is.na(tRankingDataset$Trainer)]="None3"

L_horse = list(); hRankingDataset$Races = ""
L_jockey = list(); jRankingDataset$Races = ""
L_trainer = list(); tRankingDataset$Races = ""

for ( i in c(1: nrow(hRankingDataset)))
{
  subset = horceRacingdata[as.character(horceRacingdata$HID)==as.character(hRankingDataset$HID[i]),]
  subset = subset[order(subset$EventDate),c("Pl","EventDate","xino3","Wt","Speed")]
  L_horse[[1]] = subset
  hRankingDataset$Races[i] = L_horse
}


for ( i in c(1: nrow(jRankingDataset)))
{
  subset = horceRacingdata[as.character(horceRacingdata$Jockey)==as.character(jRankingDataset$Jockey[i]),]
  subset = subset[order(subset$EventDate),c("Pl","EventDate","xino3","Wt","Speed")]
  L_jockey[[1]] = subset
  jRankingDataset$Races[i] = L_jockey
}


for ( i in c(1: nrow(tRankingDataset)))
{
  subset = horceRacingdata[as.character(horceRacingdata$Trainer)==as.character(tRankingDataset$Trainer[i]),]
  subset = subset[order(subset$EventDate),c("Pl","EventDate","xino3","Wt","Speed")]
  L_trainer[[1]] = subset
  tRankingDataset$Races[i] = L_trainer
}

rownames(hRankingDataset) = as.character(hRankingDataset$HID)
rownames(jRankingDataset) = as.character(jRankingDataset$Jockey)

rownames(tRankingDataset) = as.character(tRankingDataset$Trainer)

horceRacingdata$JOCKEYWIN = 0; horceRacingdata$ITMW = 0; horceRacingdata$WtCha = 0; horceRacingdata$DSLAST = 0
horceRacingdata$NRACES = 0;horceRacingdata$NewDist=0; horceRacingdata$HORSEWIN=0
horceRacingdata$TRAINERWIN = 0;
horceRacingdata$EventDate = as.Date(horceRacingdata$EventDate)
for ( i in c(1:nrow(horceRacingdata))){
  jockey_sub = ((jRankingDataset[as.character(horceRacingdata$Jockey[i]),]$Races[[1]]))
  jockey_sub_date = jockey_sub[as.Date(jockey_sub$EventDate)<horceRacingdata$EventDate[i],]
  total_races = nrow(jockey_sub_date); totalWin = nrow(jockey_sub_date[jockey_sub_date$Pl<3,])
  if(total_races>0){horceRacingdata$JOCKEYWIN[i]= totalWin/total_races}

    if(!horceRacingdata$Trainer[i]%in%c("-","")) {
    if(!is.na(horceRacingdata$Trainer[i])){
      trainer_sub = ((tRankingDataset[as.character(horceRacingdata$Trainer[i]),]$Races[[1]]))
      trainer_sub_date = trainer_sub[as.Date(trainer_sub$EventDate)<horceRacingdata$EventDate[i],]
      total_racesT = nrow(trainer_sub_date); totalWinT = nrow(trainer_sub_date[trainer_sub_date$Pl<3,])
      if(total_racesT>0){horceRacingdata$TRAINERWIN[i]= totalWinT/total_racesT}
      
    }
  }
  
  horse_sub = ((hRankingDataset[as.character(horceRacingdata$HID[i]),]$Races[[1]]))
  horse_sub_date = horse_sub[as.Date(horse_sub$EventDate)<horceRacingdata$EventDate[i],]
  total_racesH = nrow(horse_sub_date); totalWinH = nrow(horse_sub_date[horse_sub_date$Pl<3,])
  
  if(nrow(horse_sub_date)>0){
    horceRacingdata$DSLAST[i] = as.numeric(as.Date(horceRacingdata$EventDate[i]))-as.numeric(tail(as.Date(horse_sub_date$EventDate),1))
    # horceRacingdata$WtCha[i]  = as.numeric(horceRacingdata$Wt[i]) - tail((horse_sub_date$Wt),1)
    horceRacingdata$NRACES[i] = nrow(horse_sub_date)
    horceRacingdata$HORSEWIN[i] = totalWinH/total_racesH
    if(nrow(horse_sub_date[horse_sub_date$xino3==horceRacingdata$xino3[i],])>2){horceRacingdata$NewDist[i]=1}
  }
}

horceRacingdata$DAYSGTWEEK = ifelse(horceRacingdata$DSLAST>0&horceRacingdata$DSLAST<5,1,0)
horceRacingdata$DAYSGTWEEK = ifelse(horceRacingdata$DSLAST>100,2,horceRacingdata$DAYSGTWEEK)
horceRacingdata$DAYSGTWEEK = as.factor(horceRacingdata$DAYSGTWEEK)
horceRacingdata$xino4 = as.factor(horceRacingdata$xino3)

horceRacingdata$raceWinner=0
horceRacingdata$raceWinner[which(horceRacingdata$Pl==1)]=1
horceRacingdata$RaceCount = cumsum(horceRacingdata$raceWinner)

horceRacingdata$Sh[horceRacingdata$Sh%in%c("0","1","2","3","4","5","6","7","8","9")]="-"

horceRacingdata = horceRacingdata[-which(horceRacingdata$Venue==4),]
horceRacingdata$Sh[horceRacingdata$Sh=="X"]= "-"

training_set = horceRacingdata[which(as.Date(horceRacingdata$EventDate)<as.Date("2016-01-01")),]
validation_set=horceRacingdata[which(as.Date(horceRacingdata$EventDate)>=as.Date("2016-01-01")),]



fit = (lm((Speed)~Sh+Rtg2+(xino4)+age+Wt+Venue+Dr+as.numeric(Al)+JOCKEYWIN+DAYSGTWEEK+NRACES+NewDist+HORSEWIN+TRAINERWIN, data =training_set )) # too many with not rating
summary(fit)

fit2 = (lm((Speed)~Sh+Rtg2+age+Wt+Dr+as.numeric(Al)+JOCKEYWIN+DAYSGTWEEK+NRACES+NewDist+HORSEWIN+TRAINERWIN, data =training_set )) # too many with not rating
summary(fit2)

fit3x = (lm((Speed)~Sh+Rtg2+(xino4)+age+Wt+Venue+Dr+as.numeric(Al)+JOCKEYWIN+DAYSGTWEEK+NRACES+NewDist+HORSEWIN+TRAINERWIN, data =training_set )) # too many with not rating
summary(fit3x)

speed_predict <- predict(fit3x, newdata = validation_set)
horceRacingdata$HSE=0
horceRacingdata[rownames(training_set),]$HSE = fit3x$residuals
horceRacingdata[rownames(validation_set),]$HSE = validation_set$Speed-speed_predict

horseSpecific = horceRacingdata[,c("HID","EventDate","xino3","Pl","HSE")] 
horseSpecificDataset = as.data.frame((unique(horseSpecific$HID))); colnames(horseSpecificDataset)= c("HID"); horseSpecificDataset$HID = as.character(horseSpecificDataset$HID)
L_horseSE = list()
for ( i in c(1:nrow(horseSpecificDataset))){
  horse_sub = horseSpecific[horseSpecific$HID==as.character(horseSpecificDataset$HID[i]),]
  horse_sub = horse_sub[order(horse_sub$EventDate),]
  L_horseSE[[1]] = horse_sub
  horseSpecificDataset$HSE[i] = L_horseSE  
}
rownames(horseSpecificDataset) = as.character(horseSpecificDataset$HID)

training_set$HSEmean = 0; training_set$HSEstdDev=1;training_set$HSEmean2 = 0; training_set$HSEstdDev2=1
for ( i in c(1:nrow(training_set))){
  horse_sub = ((horseSpecificDataset[as.character(training_set$HID[i]),]$HSE[[1]]))
  horse_sub_date = horse_sub[as.Date(horse_sub$EventDate)<training_set$EventDate[i],]
  if(nrow(horse_sub_date)>2){
    res1 = lm(HSE~as.numeric(xino3), data = horse_sub_date)
    training_set$HSEmean[i] = mean(horse_sub_date$HSE)
    training_set$HSEstdDev[i] = sd(horse_sub_date$HSE)
# 
#     training_set$HSEmean2[i] = summary(res1)[4][[1]][2]
#     training_set$HSEstdDev2[i] = summary(res1)[4][[1]][4]
  }
}

validation_set$HSEmean = 0; validation_set$HSEstdDev=1;validation_set$HSEmean2 = 0; validation_set$HSEstdDev2=1
for ( i in c(1:nrow(validation_set))){
  horse_sub = ((horseSpecificDataset[as.character(validation_set$HID[i]),]$HSE[[1]]))
  horse_sub_date = horse_sub[as.Date(horse_sub$EventDate)<validation_set$EventDate[i],]
  if(nrow(horse_sub_date)>2){
    res1 = lm(HSE~as.numeric(xino3), data = horse_sub_date)
    validation_set$HSEmean[i] = mean(horse_sub_date$HSE)
    validation_set$HSEstdDev[i] = sd(horse_sub_date$HSE)
  }
}

fit3 = (lm((Speed)~Sh+Rtg2+(xino4)+age+Wt+Venue+Dr+as.numeric(Al)+JOCKEYWIN+DAYSGTWEEK+NRACES+NewDist+HORSEWIN+TRAINERWIN+HSEmean, data =training_set )) # too many with not rating
summary(fit3)

speed_predict <- predict(fit3, newdata = validation_set)
validation_set$speedPredict = speed_predict

# training_set2 = training_set
# training_set2$age2 =abs(training_set2$age)^2
# # training_set2$age2[training_set2$age2==2]= NA
# 
# training_set2$Wt2 =abs(training_set2$Wt)^2
# # training_set2$Wt2[training_set2$Wt2==55]= NA
# training_set2$xino5 =abs(as.numeric(training_set2$xino3))^2
# fit4 = (lm((Speed)~Sh+Rtg2+(xino3)+age+age2+Wt+Wt2+Venue+Dr+as.numeric(Al)+JOCKEYWIN+DAYSGTWEEK+NRACES+NewDist+HORSEWIN+TRAINERWIN+HSEmean, data =training_set2 )) # too many with not rating
# summary(fit4)



HSERanking = group_by(horceRacingdata, HID) %>% summarize(mean = mean(HSE), var = (sd(HSE))^2)

# dfDRanknRanking2 = group_by(horceRacingdata, xino3) %>% summarize(mean = mean(Speed), var = (sd(Speed))^2)
# dfDRanknRanking2$X = dfDRanknRanking2$var/dfDRanknRanking2$mean^2
