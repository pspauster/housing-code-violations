library(tidyverse)
library(janitor)
library(sf)

base_url <- "https://data.cityofnewyork.us/resource/wvxf-dwi5.csv"

# Construct the full URL with query parameters
query_url <- paste0(
  base_url,
  "?$where=inspectiondate BETWEEN '2022-07-01T00:00:00' AND '2024-06-30T23:59:59'",
  "&$limit=2000000"
)

violations <- read_csv(URLencode(query_url))

violations_clean <- violations %>% 
  mutate(fiscal_year = ifelse(month(inspectiondate) >= 7, year(inspectiondate) + 1, year(inspectiondate)))

violations_clean %>% 
  group_by(fiscal_year) %>% 
  summarize(n = n(),
            )

#################################

# Define the NYC Open Data API endpoint for PLUTO dataset
pluto <- read_csv("https://data.cityofnewyork.us/resource/64uk-42ks.csv?$select%20bbl%20ntaname")

wrong_nta <- violations_clean %>% 
  filter(!nta %in% ntas$ntaname) %>% 
  pull(bbl)

missing_ntas <- read_csv(pluto_url)

ntas <- read_sf("https://data.cityofnewyork.us/resource/9nt8-h7nd.geojson")

violations_nta <- violations_clean %>% 
  filter(nta %in% ntas$ntaname) %>% 
  group_by(nta) %>% 
  summarize(Violations=n())

violations_cd <- violations_clean %>% 
  mutate(boro_cd_code = paste0(boroid, str_pad(communityboard,2, "left", pad = "0"))) %>% 
  group_by(boro_cd_code) %>% 
  summarize(Violations=n())

violations_cd %>% write_csv("cd_count.csv")

violations_nta_sf <- full_join(ntas, violations_nta, by = c("ntaname"="nta"))

difference <- anti_join(violations_nta, ntas, by = c("nta"="ntaname"))
