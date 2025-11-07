# LogOdcls
# WtCarried
# WtCarriedByLogDist
# LogHWgt
# LogWeightByDist
# AgeT
# DaySince
# SqrtDaySince
# LogDaySince
# LogDaySinceT
# LogHWgtChg horse weight change;
# SqrtLHNR
# LogLHNR the number of races participated by the horse + 1;
# AveStdRank

summary(horse_racing_cleanData$Speed)

pred_data_HR = horse_racing_cleanData[horse_racing_cleanData$Speed>800&horse_racing_cleanData$Speed<1200,]
pred_data_HR = pred_data_HR[order(pred_data_HR$RealDate),]
# dfDRanknRanking2 = group_by(pred_data_HR, hId) %>% summarize(mean_cont = n(), stddev_cont = max(Speed))%>%arrange(mean_cont)
pred_data_HR = pred_data_HR[pred_data_HR$V3=="-"|abs(as.numeric(as.character(pred_data_HR$V3)))<10,]
pred_data_HR$V3 = ifelse(pred_data_HR$V3=="-",0,pred_data_HR$V3)
pred_data_HR$V3 = as.numeric(as.character(pred_data_HR$V3))
pred_data_HR$NewDist = 0
for( i in c(1:nrow(pred_data_HR)))
{
  hId = as.numeric(pred_data_HR$hId[i]); dateId = pred_data_HR$RealDate[i];distId = as.numeric(pred_data_HR$Distance[i])
  sub_set = na.omit(pred_data_HR[as.numeric(pred_data_HR$hId)==hId&pred_data_HR$RealDate<dateId&as.numeric(pred_data_HR$Distance==distId),])
  if(nrow(sub_set)>0){pred_data_HR$NewDist[i]=1}  
}
# pred_data_HR = pred_data_HR[1:150000,]
# pred_data_HR$Distance=as.numeric(pred_data_HR$Distance)
# pred_data_HR$Distance = as.factor(pred_data_HR$Distance)
fit = (lm(Speed~Distance+UVar1+Weight+Venue+V3+NewDist, data =pred_data_HR ))
summary(fit)

pred_data_HR1 = na.omit(pred_data_HR[pred_data_HR$Distance==unique(pred_data_HR$Distance)[14],])
fit = (lm(Speed~Distance+UVar1+Weight+Venue+V3+NewDist, data =pred_data_HR1 ))
summary(fit)
nrow(pred_data_HR1) 

 
aov(Speed~Distance+UVar1+Weight+Venue+V3+NewDist, data =pred_data_HR)
qqnorm(residuals(fit)) # Save the residual values

g = pred_data_HR$Speed
hist(g, breaks = 100)
myhist <- hist(g, breaks = 100)
multiplier <- myhist$counts / myhist$density

xfit <- seq(min(g), max(g), length = 1000) 
yfit <- dnorm(xfit, mean = mean(g), sd = sd(g)) 

lines(xfit, yfit* multiplier[1], col = "blue", lwd = 2)
