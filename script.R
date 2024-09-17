library(tidyverse)
library(janitor)

#this is a comment

squirrel <- read_csv("2018_Central_Park_Squirrel_Census_-_Squirrel_Data_20240916.csv") #this line reads in the data

clean_squirrel <- squirrel %>% 
  clean_names() %>% #this line cleans the names
  rename(longitude = x, #separate arguments with a comma
         latitude = y)


