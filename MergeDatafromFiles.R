files_list = list.files("~/Hobbies/horseracing/Data/", pattern = ".rds")
nr =0
df_full_data = NULL
for ( seq_id in c(1:length(files_list))){
test_data = readRDS(paste("~/Hobbies/horseracing/Data/",files_list[seq_id],sep=""))
# print(unique(test_data$V2))
race_data = test_data$raceTable[[1]]
if(nrow(race_data)<=2){next;}
nr = nr+nrow(race_data);
# print(nr)
L = (strsplit(gsub("([\n\\s])\\1+", "\\1", race_data$Horse.Pedigree, perl=TRUE),"\n",fixed = T))
L = lapply(L, function(x) x[!x %in% " "])
for ( i in c(1:length(L))){if(length(L[[i]])==2){L[[i]][3]=L[[i]][2];L[[i]][2]="" }}
L_name = matrix(unlist(L),nrow = nrow(race_data), byrow = T)
L_name[,1]=gsub(" ","",L_name[,1],fixed = T)

horse_data = test_data$hInfo[[1]]
H_data = matrix(unlist(strsplit(as.character(horse_data[,1]),"/", fixed = T)),nrow = nrow(horse_data), byrow = T)
H_data[,7]=gsub(" ","",H_data[,7],fixed = T)
H_data = H_data[,c(6,7)]
r_data = test_data$rInfo[[1]]
# if(nrow(r_data)!=nrow(race_data[race_data$Pl==1,])){print(seq_id);}

R= (strsplit(gsub("([\n\\s])\\1+", "\\1", r_data[,1], perl=TRUE),"\n",fixed = T))
R = lapply(R, function(x) x[!x %in% ""])
R = lapply(R, function(x) x[!x %in% " "])

R_data = matrix(unlist(R),nrow = nrow(r_data), byrow = T)
if(nrow(R_data)!=nrow(r_data)){print(seq_id);}

t_data = test_data$tInfo[[1]]
TINFO= (strsplit(gsub("([\n\\s])\\1+", "\\1", t_data[,1], perl=TRUE),"\n",fixed = T))
TINFO = lapply(TINFO, function(x) x[!x %in% c(""," ")])
T_data = matrix(unlist(TINFO),nrow = nrow(t_data), byrow = T)
if(nrow(T_data)!=nrow(t_data)){print(seq_id);}

x_data = cbind(R_data,T_data)
col_names = colnames(race_data)
race_data = cbind(race_data, L_name)
colnames(race_data) = c(col_names,"Hname","ExName","Pedigree")
H_dataS = H_data[H_data[,2]%in%race_data$Hname,]
race_data = cbind(race_data, H_dataS)
race_data$xino1=race_data$xino2=race_data$xino3=race_data$xino4=NA
seq_id_interest = race_data$seqID[race_data$Pl==1]
race_data$xino1[race_data$Pl==1]=x_data[seq_id_interest,1];if(is.na(race_data$xino1[1])){race_data$xino1[1]=""}; race_data$xino1 = na.locf(race_data$xino1)
race_data$xino2[race_data$Pl==1]=x_data[seq_id_interest,2];if(is.na(race_data$xino2[1])){race_data$xino2[1]=""}; race_data$xino2 = na.locf(race_data$xino2)
race_data$xino3[race_data$Pl==1]=x_data[seq_id_interest,3];if(is.na(race_data$xino3[1])){race_data$xino3[1]=""}; race_data$xino3 = na.locf(race_data$xino3)
race_data$xino4[race_data$Pl==1]=x_data[seq_id_interest,4];if(is.na(race_data$xino4[1])){race_data$xino4[1]=""}; race_data$xino4 = na.locf(race_data$xino4)
race_data$V1 = as.character(test_data$V1); race_data$V2 = as.character(test_data$V2); race_data$V3 = as.character(test_data$V3)
df_full_data = rbind(df_full_data, race_data)
}
# print(nr)
colnames(df_full_data)[colnames(df_full_data)==1]= "HID"
colnames(df_full_data)[colnames(df_full_data)==2]= "H_FULLNAME"
