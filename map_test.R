# code to get lat and long for zip codes
# 

library(tidyverse)
library(readxl)
library(leaflet)


l = read_csv("uszips.csv")

s = read_csv("sdi_quin.csv")

glimpse(l)
glimpse(s)


l2 = l %>% select(zip, lng, lat) %>% rename(ZIP = zip)

s$ZIP = as.character(s$ZIP)

s2 = left_join(s, l2, by = "ZIP")

glimpse(s2)

summary(s2)

s3 = s2 %>% drop_na(lat)

glimpse(s3)

s3 = data.frame(s3)

#- want to map 44139 
#

#- get the coord for that from the table
#

t = s3[s3$ZIP == "44135", ]

t

m <- leaflet() %>% addTiles() %>% addMarkers(lng = t$lng, lat = t$lat)

m

