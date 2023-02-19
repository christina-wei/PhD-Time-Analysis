#### Preamble ####
# Purpose: Clean world economic outlook data into its components
# Author: Christina Wei
# Data: 19 February 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites:
  # 00-download_data.R

#### Workspace setup ####

library(tidyverse)
library(readxl)
library(janitor)

source("scripts/02-helper_functions.R")

#### UN World Economic Outlook Data ####

## Read data in

raw_world_economic_outlook_data = 
  read_excel("inputs/data/raw_un_world_economic_outlook.xls") |>
  clean_names()

colnames(raw_world_economic_outlook_data) =
  sub("x", "", colnames(raw_world_economic_outlook_data))

## Country code reference table

country_code = 
  raw_world_economic_outlook_data |>
  select(
    country,
    iso,
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

# 
# world_population_data =
#   raw_world_economic_outlook_data |>
#   filter(weo_subject_code == "LP") |>
#   select(
#     -weo_country_code,
#     -weo_subject_code,
#     -country,
#     -subject_descriptor,
#     -subject_notes,
#     -units,
#     -scale,
#     -country_series_specific_notes,
#     -estimates_start_after
#   )
# 
# # Clean up column names
# colnames(world_population_data) =
#   sub("x", "", colnames(world_population_data))
# 
# # Pivot data
# world_population_data =
#   world_population_data |>
#   pivot_longer(
#     cols = !iso,
#     names_to = "Year",
#     values_to = "Population",
#     values_transform = as.numeric
#   )  
# 
# world_population_data =
#   world_population_data |>
#   filter (Year <= 2021)