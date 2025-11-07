#remove races with only 1 participant
validation_set2 = validation_set; single_races =0
races_list = unique(validation_set2$RaceCount)
validation_set2$only1=0
validation_set2$Probpredict = 0; validation_set2$Pospredict=0;
for ( j in c(1:length(races_list))){
  dim_set = validation_set2[which(validation_set2$RaceCount==races_list[j]),]
  if(nrow(dim_set)<4){validation_set2$only1[which(validation_set2$RaceCount==races_list[j])]=-1;single_races = single_races+1; }
  a = (dim_set$speedPredict)
  sim_length = 1000
  df_simTimes = matrix(nrow = sim_length,ncol = length(a),data = 0)
  for( i in c(1:length(a))){
    df_simTimes[,i] <- rpois(sim_length, as.numeric(a[i] ))
  }
  order_mat = 0*df_simTimes
  for( i in c(1:nrow(df_simTimes)))
  {
    order_mat[i,] = order(-df_simTimes[i,])
  }
  # print(t(table(order_mat[,1])/sim_length))
  validation_set2$Probpredict[which(validation_set2$RaceCount==races_list[j])]= (table(order_mat[,1])/sim_length)
  x = order(-(table(order_mat[,1])/sim_length))
  if(length(validation_set2$Probpredict[which(validation_set2$RaceCount==races_list[j])])!=length(x)){x = c(x,sum(c(1:length(a)))-sum(x))}
  
  validation_set2$Pospredict[which(validation_set2$RaceCount==races_list[j])][x]= seq(1,length(a))
  
  # validation_set2$Probpredict[which(validation_set2$RaceCount==races_list[j])]= a/sum(a)
  
}  

nrow(validation_set2[validation_set2$Pl==1&validation_set2$Pospredict==1&!(validation_set2$only1%in%c(-1)),])
print(single_races)

r = validation_set2$Probpredict
v2 = validation_set2[validation_set2$Pl==1,]
df_TRUEMAT=  data.frame(table(cut(r, breaks=seq(0, 1, 0.01)[c(1,2,3,6,8,10,12,14,16,21,31,41,101)])))
df_TRUEMAT$LowBound = breaks=seq(0, 1, 0.01)[c(1,2,3,6,8,10,12,14,16,21,31,41)]
df_TRUEMAT$UpBound = breaks=seq(0, 1, 0.01)[c(2,3,6,8,10,12,14,16,21,31,41,101)]
df_TRUEMAT$ExpOutcome = 0; df_TRUEMAT$ActualOutcome
for ( i in c(1:nrow(df_TRUEMAT)))
{
  df_TRUEMAT$ExpOutcome[i]=mean(r[r>df_TRUEMAT$LowBound[i]&r<=df_TRUEMAT$UpBound[i]])
  v2 = validation_set2[validation_set2$Probpredict>df_TRUEMAT$LowBound[i]&validation_set2$Probpredict<=df_TRUEMAT$UpBound[i],]
  
  df_TRUEMAT$ActualOutcome[i]=nrow(v2[v2$Pl==1,])/nrow(v2)
  
}
df_TRUEMAT
# 0 - 010
# .010-.025
# .025-,050
# .050-.1
# .1-. 150
# .150-.200
# .ZOO-.250
# .250-.300
# .300-.400
# > .400

nrow(validation_set2[validation_set2$Pl==1&validation_set2$Pospredict==1,])/4487
nrow(validation_set2[validation_set2$Pl==2&validation_set2$Pospredict==2,])/4487
nrow(validation_set2[validation_set2$Pl==3&validation_set2$Pospredict==3,])/4487

winners_predict = (validation_set2[validation_set2$Pl==3&validation_set2$Pospredict==3&!(validation_set2$only1%in%c(-1)),])
mean(na.omit(winners_predict$NumericOdds))

# f={p(b+1)-1}/b
# validation_set2$NumericOdds[validation_set2$NumericOdds>50]=1
first_pos = na.omit(validation_set2[validation_set2$Pospredict==1&!(validation_set2$only1%in%c(-1)),])
first_pos = na.omit(validation_set2)
first_pos$fraction = (first_pos$Probpredict*(first_pos$NumericOdds+1)-1)/first_pos$NumericOdds
# first_pos$fraction =1
first_pos_sub = first_pos[first_pos$fraction>0,]
mean(first_pos_sub$NumericOdds[first_pos_sub$Pl==1]*first_pos_sub$fraction[first_pos_sub$Pl==1])/mean(first_pos_sub$fraction)
mean(first_pos_sub$NumericOdds[first_pos_sub$Pl==1]); 
sum((1+first_pos_sub$NumericOdds[first_pos_sub$Pl==1])*first_pos_sub$fraction[first_pos_sub$Pl==1])-sum(first_pos_sub$fraction)
sum(first_pos_sub$fraction)
nrow(first_pos_sub[first_pos_sub$Pl==1,])/nrow(first_pos_sub)

post_test = 3
first_pos = na.omit(validation_set2[validation_set2$Pospredict==post_test&!(validation_set2$only1%in%c(-1)),])
first_pos$fraction = (first_pos$Probpredict*(first_pos$NumericOdds+1)-1)/first_pos$NumericOdds
first_pos_sub = first_pos[first_pos$fraction>0,]
mean(first_pos_sub$NumericOdds[first_pos_sub$Pl==post_test]*first_pos_sub$fraction[first_pos_sub$Pl==post_test])/mean(first_pos_sub$fraction)
mean(first_pos_sub$NumericOdds[first_pos_sub$Pl==post_test])
nrow(first_pos_sub[first_pos_sub$Pl==post_test,])/nrow(first_pos_sub)

sum((1+first_pos_sub$NumericOdds[first_pos_sub$Pl==post_test])*first_pos_sub$fraction[first_pos_sub$Pl==post_test])-sum(first_pos_sub$fraction)
sum(first_pos_sub$fraction)
