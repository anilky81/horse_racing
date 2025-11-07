odds_Set = horceRacingdata$Odds
unique(odds_Set)[order(unique(odds_Set))]

odds_Set = gsub("\\(", "",odds_Set)
odds_Set = gsub("\\)", "",odds_Set)
odds_Set = gsub("//", "/",odds_Set)

odds_Set[odds_Set%in%unique(odds_Set)[order(unique(odds_Set))][16:52]]=0
odds_Set = gsub("-", "",odds_Set)
odds_Set = gsub("*", "",odds_Set)
odds_Set = gsub("~", "",odds_Set)
unique(odds_Set)[order(unique(odds_Set))]
odds_Set = gsub("194", "19/4",odds_Set)
odds_Set = gsub("1000", "100",odds_Set)
odds_Set = gsub("*118", "0",odds_Set)
odds_Set[odds_Set%in%unique(odds_Set)[order(unique(odds_Set))][c(350:352,360:362)]]=0
odds_Set[odds_Set%in%unique(odds_Set)[order(unique(odds_Set))][c(350:356)]]=1
odds_Set = gsub(";", "/",odds_Set)
odds_Set[odds_Set%in%c("51","52.5","53.5","54","55.5","56","57","60")]=0
odds_Set = gsub("*", "",odds_Set)
odds_Set = gsub("`", "",odds_Set)
odds_Set = gsub("7/0", "7/10",odds_Set)
odds_Set = gsub("9/112/1", "0",odds_Set)
odds_Set = gsub("9/112/1", "0",odds_Set)
odds_Set = gsub("92/", "0",odds_Set)
odds_Set = gsub("0/0", "0",odds_Set)
odds_Set = gsub("0/1", "0",odds_Set)
odds_Set = gsub("0100", "0",odds_Set)
odds_Set = gsub("8000", "0",odds_Set)
odds_Set = gsub(" ", "/",odds_Set)


predict2odds = strsplit(odds_Set,"/",fixed = T)
numeric_predict2odds = predict2odds

for ( k in c(1:length(predict2odds)))
{
  if(length(predict2odds[[k]])==0){numeric_predict2odds[k] = 0}
  if(length(predict2odds[[k]])==1){numeric_predict2odds[k] = as.numeric(as.character(predict2odds[[k]][1]))}
  if(length(predict2odds[[k]])==2){numeric_predict2odds[k] = as.numeric(as.character(predict2odds[[k]][1]))/as.numeric(as.character(predict2odds[[k]][2]))}
  if(length(predict2odds[[k]])==3){numeric_predict2odds[k] =as.numeric(as.character(predict2odds[[k]][1]))+ as.numeric(as.character(predict2odds[[k]][2]))/as.numeric(as.character(predict2odds[[k]][2]))}
  if(length(predict2odds[[k]])>3){print(k);}
}

horceRacingdata$NumericOdds = unlist(numeric_predict2odds)
horceRacingdata$NumericOdds[horceRacingdata$NumericOdds==0]=NA
horceRacingdata$NumericOdds[is.infinite(horceRacingdata$NumericOdds)]=NA
horceRacingdata$NumericOdds[horceRacingdata$NumericOdds>50] = NA
