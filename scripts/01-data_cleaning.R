#### Preamble ####
# Purpose: Clean world economic outlook data into its components
# Author: Christina Wei
# Data: 19 February 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # 00-download_data.R
# Country sectors: https://www.imf.org/external/datamapper/FMEconGroup.xlsx

#### Workspace setup ####

library(tidyverse)
library(readxl)
library(janitor)

source("scripts/02-helper_functions.R")

#### UN World Economic Outlook Data ####

## Read data in

raw_world_economic_outlook_data = 
  read_excel("inputs/data/raw_un_world_economic_outlook.xls") |>
  clean_names() |>
  rename(country_iso = iso)

colnames(raw_world_economic_outlook_data) =
  sub("x", "", colnames(raw_world_economic_outlook_data))

## Country code reference table

reference_country = 
  raw_world_economic_outlook_data |>
  select(
    country,
    country_iso,
    weo_country_code
  ) |>
  distinct()

## Population

world_population_data = 
  filter_world_economic_outlook_data(
    raw_world_economic_outlook_data,
    "LP",
    "population"
)

## GDP Current Price in US Dollars

world_gdp_data =
  filter_world_economic_outlook_data(
    raw_world_economic_outlook_data,
    "NGDPD",
    "GDP"
  )


## Inflation - average consumer prices

world_inflation_data =
  filter_world_economic_outlook_data(
    raw_world_economic_outlook_data,
    "PCPI",
    "inflation"
  )

## Unemployment - percentage

world_unemployment_data =
  filter_world_economic_outlook_data(
    raw_world_economic_outlook_data,
    "LUR",
    "unemployment"
  )

## Combine them into one dataset

cleaned_world_economic_outlook_data =
  list(world_gdp_data, world_inflation_data, world_population_data, world_unemployment_data) |>
  reduce(
    inner_join,
    by=c("country_iso", "year")
  )

#### Write cleaned data to file and clean up working data ####

# Save to CSV
save_to_csv(reference_country, "reference_country.csv")
save_to_csv(cleaned_world_economic_outlook_data, "cleaned_world_economic_outlook_data.csv")

# Remove working variables
rm(raw_world_economic_outlook_data)
rm(world_inflation_data)
rm(world_population_data)
rm(world_unemployment_data)
rm(world_gdp_data)
