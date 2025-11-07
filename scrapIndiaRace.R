get_libraries <- function(filenames_list) { 
  lapply(filenames_list,function(thelibrary){    
    if (do.call(require,list(thelibrary)) == FALSE) 
      do.call(install.packages,list(thelibrary)) 
    do.call(library,list(thelibrary))
  })
}
libraries_used=c("httr","XML","RCurl","rvest") 
get_libraries(libraries_used)


basePage <- "http://indiarace.com"

h <- handle(basePage)

GET(handle = h)
# ResultArchives.aspx
resBase <- GET(handle = h, path = URLencode("/ResultArchives.aspx"))
resBaseXML <- htmlParse(content(resBase, as = "text"))
# resLocation <- getNodeSet(resBaseXML, '//*/div/div[@class="SeaSonname1_Css"]//@href')
# resLocation2 <- getNodeSet(resBaseXML, '//*/div/div[@class="SeaSonname2_Css"]')
# Locations1 <-sapply(resLocation, xmlValue)

resLocation = xpathSApply(resBaseXML, '//*/div/div[@class="SeaSonname1_Css"]//@href')
resLocation2 = xpathSApply(resBaseXML, '//*/div/div[@class="SeaSonname2_Css"]//@href')

reslocation = c(resLocation, resLocation2)
allDates = NULL
for( i in c(1: length(reslocation))){
res1 <- GET(handle = h, path = reslocation[[i]])
resXML1 <- htmlParse(content(res1, as = "text"))
  resDate1 = xpathSApply(resXML1, '//*/div/div[@class="Calender-image"]//@href')
  allDates = c(allDates,resDate1)
 }
final_content = NULL
# URLencode("/Results.aspx?date=Dec 13 2016 &venue=Kolkata")
for( i in c(1: length(allDates))){
  
res <- GET(handle = h, path = URLencode(allDates[[i]]))
resXML <- htmlParse(content(res, as = "text"))

resRaceNames <- getNodeSet(resXML, '//*/div[@style= "font-size:30px;color:#000000;text-align:center;width:782px;line-height:30px;float:left;"]')
resLengths <-   getNodeSet(resXML, '//*/div[@style= "font-size:20px;color:#000000;text-align:right;width:100px;line-height:30px;float:left"]')
# resTable <- getNodeSet(resXML, '//*/table[@class="RaceCard-inside-Css"]/tr/td/div/span')
appNames <-sapply(resRaceNames, xmlValue)
appLengths = sapply(resLengths, xmlValue)
resName1 = xpathSApply(resXML, '//*/table[@class="RaceCard-inside-Css"]/tr/td/div//@href') 
appLinks = resName1 
 
resTable2 <- getNodeSet(resXML, '//*/table[@class="RaceCard-inside-Css"]/tr/td/div[@style="width:70px"]')
appRows2 <-sapply(resTable2, xmlValue)

resTable <- getNodeSet(resXML, '//*/table[@class="RaceCard-inside-Css"]/tr/td/span')
appRows <-sapply(resTable, xmlValue)
appNodes <-sapply(resTable, xmlAttrs)


resHeader <- getNodeSet(resXML, '//*/table[@class="RaceCard-inside-Css"]/tr/th')
appHeader <-sapply(resHeader, xmlValue)

try({
content <- as.data.frame(matrix(appHeader, ncol = 15, byrow = TRUE))
content1 <- as.data.frame(matrix(appRows, ncol = 9, byrow = TRUE))
content2 <- as.data.frame(matrix(appNodes, ncol = 9, byrow = TRUE))
content3 = as.numeric(substr(gsub("ctl00_ContentPlaceHolder1_Results_Grd_ctl","",content2[,1]),1,2))-1
content1[,10] = appLengths[content3]
content1[,11] =appNames[content3]
content1[,12] = gsub(" ","",appLinks)
content1[,13] = gsub(" ","",appRows2[c(1:length(appRows2))%%2==0])
content1[,14] = gsub(" ","",appRows2[c(1:length(appRows2))%%2==1])
content1[,13] = gsub("\r\n","",content1[,13])
content1[,14] = gsub("\r\n","",content1[,14])
content1[,15] = gsub(" ","",allDates[[i]])
content1
final_content= rbind(final_content,content1)})
}