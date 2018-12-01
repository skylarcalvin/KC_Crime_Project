# Data Analysis
# Analyses Data from the KC_Crime table in the datascience database.
# 
# KCPD Crime Data
#
# Developed by Skylar Calvin
# Year: 2018

# Load required tables.
library(RMySQL)
library(tidyverse)
library(ggmap)

# Establish database connection and load crime data to data frame.
mydb <- dbConnect(
    MySQL(),
    user = 'rducky',
    password = 'Fr3ude#23',
    dbname = 'datascience',
    host = 'localhost'
)

kc_crime <- dbReadTable(mydb,name = "KC_Crime")

dbDisconnect(mydb)

# convert to Tibble
kc_crime <- as.tibble(kc_crime)

# Format variables
kc_crime$reported_date <- as.POSIXct(kc_crime$reported_date)

kc_crime$offense <- as.integer(kc_crime$offense)
kc_crime$age <- as.integer(kc_crime$age)
kc_crime$location_zip <- as.integer(kc_crime$location_zip)
kc_crime$lat <- as.numeric(kc_crime$lat)
kc_crime$lon <- as.numeric(kc_crime$lon)

kc_crime$description <- as_factor(kc_crime$description)
kc_crime$month <- as_factor(kc_crime$month)

# What are the top five so far in Kansas City?
top_five <- kc_crime %>%
    count(description) %>%
    top_n(n = 5) %>%
    arrange(n)

top_five$description <- factor(top_five$description, levels = top_five$description[order(top_five$n, decreasing = TRUE)], ordered = TRUE)

# Plot the top five in a bar chart.
top_five_crimes <- ggplot(top_five, aes(description, n)) +
    theme_bw() +
    geom_bar(stat = "identity") +
    geom_text(aes(label = n), vjust = -1) +
    labs(title = "Kansas City's Top Five Crimes in 2018",
         x = "",
         y = "Number of Crimes")

# Summarize the arrests
KC_Arrest_Summary <- kc_crime %>%
    filter(involvement == 'ARR') %>%
    group_by(description,month) %>%
    summarize(Count = n(),
              `Avg Age` = mean(age, na.rm = TRUE),
              `Gun Related` = sum(firearm_used_flag == "Y")
              )

# Get a map of the KC Metro area.
kc_metro <- get_map(location = 'Kansas City', zoom = 11, maptype = "roadmap")

# Get latitude and longitude of arrests.
arrest_locations <- kc_crime %>%
    filter(involvement == "ARR") %>%
    select(beat, lat, lon)

# Plot the arrests on a map.
arrest_map <- ggmap(kc_metro) +
    geom_point(data = arrest_locations, 
               aes(x = as.numeric(lon), y = as.numeric(lat)), 
               color = "yellow") +
    labs(title = "2018 Kansas City Arrests")

