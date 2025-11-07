url = "http://www.indiarace.com/Home/racingCenterEvent?venueId=11&event_date=2018-11-19&race_type=RACECARD"
d = html_session(url)
z= html_nodes(read_html(d), xpath = '//*[@id="race-1"]')
zTime= html_nodes(read_html(d), xpath = '//*[@class="archive_time"]')%>%html_nodes("h4")%>%html_text()
dfTime = data.frame(matrix(zTime, ncol = 2, byrow = T))
z1 = html_nodes(read_html(d), xpath = '//*[@class="race_card_td"]')
zTable = html_nodes(read_html(d), xpath = '//*[@class="table table-striped statistics_table race_card_tab"]')%>%html_table()

for ( i in 1: nrow(dfTime))
{
  dfRace = zTable[[i]]
  HNo = matrix(as.numeric(gsub(")","",unlist(strsplit(dfRace$No,"(",fixed = T)))),ncol=2, byrow = T)
  dfRace$Hno = HNo[,1]
  dfRace$Dr = HNo[,2]
  dfRace$Race = i
  dfRace$Trainer = gsub(" ","",dfRace$Trainer)
  dfRace$Jockey = gsub(" ","",dfRace$Jockey)
  dfRace$Rtg = substr(dfRace$Rtg,1,2)
  dfRace$Age = gsub("y","",substr(dfRace$Desc,1,2))
  dfRace$Wt = as.numeric(as.character(dfRace$Wt))
  dfRace$xino3 = gsub(" M","",dfTime[i,1])
  dfRace$Venue = "11"
  zTable[[i]] = dfRace 
}