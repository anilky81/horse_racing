get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}
libraries_used=c("httr","XML","RCurl","rvest","jsonlite","TTR","xts") 
get_libraries(libraries_used)
url <- "http://www.indiarace.com/Home/raceArchives?page=results_archive"

# 
# website1 <- GET(url)
# print(content(website1))
# tbls <- html_nodes(content(website1), "form")
head(dfSeaVen)
head(date_dest_map)

hInfo = list(); rInfo = list(); tInfo = list(); raceTable = list();
pgsession <- html_session(url)
pgform <- html_form(read_html(pgsession))[[2]]  

for ( k in c(1:nrow(dfSeaVen))){
  data_final=NULL
  
  venue_id = dfSeaVen$venueId[k]; 
  season_id = dfSeaVen$seasonId[k];
  season_start = dfSeaVen$seasonStartDate[k]
  season_end = dfSeaVen$seasonEndDate[k]
  
  date_list = date_dest_map$V1[date_dest_map$Dest==venue_id&date_dest_map$V1>=season_start&date_dest_map$V1<=season_end]
  if(length(date_list)==0){next}
  for(j in date_list)
  {
    event_date  = j                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    filled_form <-set_values(pgform,"venue_id" = venue_id,"season_id" = season_id,"event_date"  = event_date)
    d <- submit_form(session=pgsession, form=filled_form)
    # z= html_nodes(read_html(d), xpath = '//*[@class="table  table-hover result-table-new1 "]')%>%html_table()
    z= html_nodes(read_html(d), xpath = '//*[@class="table  table-hover result-table-new1 "]')
    
    if(length(z)==0){next;}
    z1 = as.data.frame(html_text(html_nodes(read_html(d), xpath = '//*[@class="center_heading"]')))
    z2 = as.data.frame(html_text(html_nodes(read_html(d), xpath = '//*[@class="archive_time"]')))
    # zTime= html_nodes(read_html(d), xpath = '//*[@class="archive_time"]')%>%html_nodes("h4")%>%html_text()
    
    z3 =as.data.frame(html_text(html_nodes(read_html(d), xpath = '//*[@class="race_card_td"]//@href')))
    data_merge=NULL
    
    for( i in c(1:length(z))){
      y= as.data.frame(html_table(z[i], fill = TRUE))
      if(nrow(y)==0|ncol(y)!=15){next;}
      y$EventDate = event_date
      y$Venue = venue_id  
      y$seqID = i
      data_merge = rbind(data_merge,y)
    }
    hInfo[[1]] = z3; rInfo[[1]] = z1; tInfo[[1]] = z2; 
    raceTable[[1]] = data_merge
    
    if(length(raceTable)!=0){
      data_final = as.data.frame(t(c(event_date, venue_id, season_id)))
      data_final$raceTable = raceTable; data_final$hInfo = hInfo; data_final$rInfo = rInfo;data_final$tInfo = tInfo;
    }
    file_name_save = paste("~/Hobbies/horseracing/Data/hrSeason", season_id,event_date,".rds",sep = "")
    if(!is.null(data_final)){
      saveRDS(data_final, file_name_save)
    }    
    Sys.sleep(1)
  }

}
