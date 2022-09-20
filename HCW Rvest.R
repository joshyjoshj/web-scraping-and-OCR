library(tidyverse)
library(rvest)
library(tesseract)

#Gets All Images from 
link.titles <- read_html("https://hcwco.com/transactions/")%>%
  html_nodes("img")

#Removing header images
link.titles <- link.titles[3:length(link.titles)]

#Creating function
get_info <- function(data){
  
#Image URL from html
url <- data%>%html_attr("src")

#Extracting name from URL
name <- substr(url,49,nchar(url))
name <- gsub("[[:punct:]]","",name)
name <- gsub('[[:digit:]]+', '', name)
name <- gsub("HCWjpg",'',name)
name <- gsub("HCW", '', name)
name <- gsub("jpg", '', name)


#Tesseract language
eng <- tesseract("eng")

#Reading text from image 
text <- ocr_data(url,engine = eng)$word

#Dollar amount fromimage text
dollar_amount <- text[grepl("$",text,fixed=TRUE)]

#Month
month <- text[text %in% month.name]

#year
year <- text[str_length(text) == 4]
year <- year[grepl('[[:digit:]]+',year)]

#day
day <- text[str_length(text)==2 | str_length(text)==3]
day <- day[grepl(",",day,fixed = TRUE)]
day <- day[grepl('[[:digit:]]+',day)]
day <- day[grepl("[[:punct:]]",day)]


#Does the text contain these phrases
atm <- any(grepl("At-The-Market",text))
pp <- any(grepl("Private Placement",text))
offering <- any(grepl("Offering",text))
follow_on <- any(grepl("Follow-On",text))


#Searching yahoo for name and scraping ticker
yahoo_ticker <- read_html(sprintf("https://search.yahoo.com/search?p=%s", name))%>%html_element(".ivml-3")%>%html_text()


#Creating dataframe
out <- data.frame(url_name = name,ticker = yahoo_ticker,day,month,year,dollar_amount,atm,pp,offering,follow_on)
out

}

#Applying over link list (first 5 used to save time)
df <- do.call(rbind, lapply(link.titles[1:5], get_info))

df

