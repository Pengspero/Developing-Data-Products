library(leaflet)
library(dplyr)
library(readxl)

location<-read_xlsx("University data.xlsx")
location %>% leaflet() %>%
        addTiles() %>%
        addMarkers(
                lat = location$Latitude, 
                lng = location$Longitude, 
                popup = paste(location$Location, "<br>", "Rank:", location$Rank),
                clusterOptions = markerClusterOptions())