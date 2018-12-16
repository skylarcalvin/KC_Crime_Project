# Data Miner
# Pulls data from https://data.kcmo.org
# 
# KCPD Crime Data
# 
# Removes unneeded fields and loads resulting data into the datascience database.
#
# Developed by Skylar Calvin
# Year: 2018

# Load neccesary packages.
library(RSocrata)
library(tidyverse)
library(purrr)
library(lubridate)
library(RMySQL)

# Connect to JSON and parse data into dataframe.
KC_Crime <- read.socrata(
    "https://data.kcmo.org/resource/nyg5-tzkz.json",
    app_token = "2BlqNquer3Zje80NhkrNCNJyU",
    email = "rducky01@gmail.com",
    password = "Fr3ude#23"
)

KC_Crime <- as.tibble(KC_Crime)

# Flatten latitude and longitue coordinates into single variables.
KC_Crime$lat <- KC_Crime$location.coordinates %>% map(2, .null = NA) %>% unlist

KC_Crime$lon <- KC_Crime$location.coordinates %>% map(1, .null = NA) %>% unlist

# Select and rearrange the variables we want to keep
KC_Crime = KC_Crime %>%
            select(
                report_no,
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
                lon
            ) %>% 
            mutate(month = month(reported_date,label = TRUE)) %>%
            as_factor(month)

# Format variables.
KC_Crime$offense <- as.integer(KC_Crime$offense)
KC_Crime$age <- as.integer(KC_Crime$age)
KC_Crime$location_zip <- as.integer(KC_Crime$location_zip)
KC_Crime$beat <- as.integer(KC_Crime$beat)
KC_Crime$lat <- as.numeric(KC_Crime$lat)
KC_Crime$lon <- as.numeric(KC_Crime$lon)

# Categorize the descriptions as a factor
KC_Crime$description <- as_factor(KC_Crime$description)

# Clean up factor levels.
KC_Crime$description <- fct_collapse(
    KC_Crime$description,
    `Agg Assault` = c('agg assault', 'Agg Assault', 'AGG ASSAULT', 'Agg Assault - Domest', 'Agg Assault - Drive-', 'Aggravated Assault ('),
    `Auto Theft` = c('Auto Theft', 'Auto Theft Outside S'),
    `Driving Under Influence` = c('`', 'Driving Under Influence', 'Driving Under Influe'),
    `Attempted Suicide` = c('Attempt Suicide by C', 'Attempt Suicide by D', 'Attempt Suicide by H', 'Attempt Suicide by J', 'Attempt Suicide by O', 'Attempt Suicide by P', "Attempt Suicide by S"),
    'Burglary' = c('Burglary - Non Resid', 'Burglary - Residence'),
    `Family Offense` = c('Family Disturbance', 'Family Offense'),
    'Homicide' = c('HOMICIDE/Non Neglige', 'Justifiable Homicide'),
    'Misc' = c('misc', 'Misc Offense', 'Misc Violation'),
    `Non Agg Assault` = c('Non Agg Assault Dome', 'non aggravated assau', 'Non Aggravated Assau'),
    'Possession' = c('Possession of Drug E', 'Possession/Sale/Dist'),
    'Prostitution' = c('Promoting Prostituti', 'Prostitution/Patroni', 'Prostitution/Solicit'),
    `Sex Offense` = c('Sex Off Indecent Con', 'Sex Off Indecent Exp', 'Sex Off Misconduct', 'Sex Offense -others', 'Sexual Assault with', 'Statutory Rape', 'Rape', 'Forcible Fondling', 'Forcible Sodomy', 'Sex Off Follow/Entic', 'Sex Off Fondle - mol', 'Sex Off Incest'),
    'Stealing' = c('stealing from buildi', 'Stealing from Buildi', 'Stealing Pickpocket', 'Stealing Purse Snatc', 'Stealing Shoplifting', 'Stolen Property OFFE', 'Stealing All Other', 'Stealing Auto Parts', 'Stealing Auto Parts/', 'Stealing Bicycles', 'Stealing Coin Operat', 'Stealing From Auto'),
    'Suicude' = c('Suicide By Hanging', 'Suicide by Other Mea', 'Suicide By Shooting', 'Suicide By Sleeping')
)

# Prompt for a password
pwd <- .rs.askForPassword('Please enter your Socrata password')

# Open a database connection with the local MySQL database
mydb <- dbConnect(
    MySQL(),
    user = 'rducky',
    password = pwd,
    dbname = 'datascience',
    host = 'calvin-tech.net'
)

# Check if the KC_Crime Table exists, drop it if so, create a new KC_Crome table then load the dataframe into it.
dbSendQuery(mydb, 'DROP TABLE IF EXISTS KC_Crime')

dbWriteTable(mydb, 'KC_Crime', KC_Crime)

dbDisconnect(mydb)
