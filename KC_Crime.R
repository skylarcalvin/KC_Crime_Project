# kC Crime Data Anaysis
# Created by Skylar Calvin
# Year 2018

# Load neccesary packages
library(RSocrata)
library(tidyverse)
library(RgoogleMaps)

df <- read.socrata(
  'https://data.kcmo.org/resource/nyg5-tzkz.json',
  app_token = '2BlqNquer3Zje80NhkrNCNJyU',
  email = 'rducky01@gmail.com',
  password = 'Fr3ude#23'
)

coord <- df$location.coordinates

for (i in 1:length(coord)) {
  lat[i] <- coord[[i]][2]
  lon[i] <- coord[[i]][1]
}

lat <- lapply(coord, fn_loc)

df <- df %>%
  select(report_no,
         description,
         offense,
         reported_date,
         reported_time,
         involvement,
         firearm_used_flag,
         race,
         sex,
         age,
         city,
         location_zip,
         beat,
         lat,
         lon,
         month)