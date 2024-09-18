library(tidyverse)
library(janitor)

base_url <- "https://data.cityofnewyork.us/resource/wvxf-dwi5.csv"

# Construct the full URL with query parameters
query_url <- paste0(
  base_url,
  "?$where=inspectiondate BETWEEN '2022-07-01T00:00:00' AND '2024-06-31T23:59:59'",
  "&$limit=2000000"
)


violations <- read_csv(URLencode(query_url))
