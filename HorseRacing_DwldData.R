get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}
libraries_used=c("dplyr","magrittr","stringr","ggplot2","RCurl") 
get_libraries(libraries_used)



conv_times <- function(times, regex = NULL) {
  
  # if no regex is included use default
  if(is.null(regex)) {
    regex <- "[[:punct:]]\\s?|\\s?[[:alpha:]]+\\s?|\\s+"
  }
  
  # check if times are in character format
  if(is.factor(times)) {
    times <- as.character(times)
  }
  
  # split times according to regex
  split_times <- strsplit(times, regex)
  
  # for each splited time, call the mmss_ss function
  new_times <- sapply(split_times, mmss_ss)
  
  return(new_times)
}

mmss_ss <- function(time) {
  
  # length of time
  len <- length(time)
  
  # if length is 3 then assumes it's in minutes:seconds:milliseconds
  if(len == 3) {
    # convert minutes to seconds (*60) and milliseconds to seconds (/100)
    mins <- as.numeric(time[1]) * 60
    seconds <- as.numeric(time[2])
    
    milliseconds <- substring(time[3], 1, 2)
    if(nchar(milliseconds) == 1) milliseconds <- paste0(milliseconds, "0")
    milliseconds <- as.numeric(milliseconds) / 100
    
    time <- mins + seconds + milliseconds
  }
  # if length is 2 then assumes it's in seconds:milliseconds
  if(len == 2) {
    time <- as.numeric(time)
    time <- (time[1]) + (time[2]/100)
  }
  
  return(time)
}



# # library(RcappeR)
# library(dplyr)     # for speedy manipulation of dataframes
# library(magrittr)  # for %<>%
# library(stringr)   # for manipulating strings
# library(ggplot2)   # for plotting

df <- RCurl::getURL(url = "https://raw.githubusercontent.com/maithuvenkatesh/University-Project/master/Data/born98.csv",
                    ssl.verifypeer = 0L, followlocation = 1L)
df <- read.csv(text = df, fill = TRUE, sep = "\t", stringsAsFactors = FALSE)
str(df)


races <- df %>%
  group_by(race_date, race_time, track) %>%
  mutate(n = n()) %>%
  filter(n == number_of_runners)


races %>% filter(stall == 0) %>%
  group_by(race_date, race_time, track, race_name) %>%
  summarise(n = n()) %>%
  select(race_name, n)


races %<>% filter(stall != 0)
races %<>% mutate(wintime = conv_times(times = comptime))
head(unique(races$wintime))
table(races$place)
races$place %<>% str_replace_all(pattern = "[[:alpha:]]", replacement = "") %>%
  as.numeric()

table(races$place, useNA = "ifany")
races %<>% filter(!is.na(place))
