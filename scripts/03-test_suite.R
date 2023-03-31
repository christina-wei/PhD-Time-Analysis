#### Preamble ####
# Purpose: Test suite to run the datasets
# Author: Christina Wei
# Data: 31 March 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites:
  # Run 01-data_cleaning.R to generate cleaned data

source("scripts/04-helper_tests.R")

# Reading in cleaned data
cleaned_time_sheet = read_csv(
  file = here("outputs/data/cleaned_time_sheet.csv"),
  show_col_types = FALSE
)

# Running different tests
check_class(cleaned_time_sheet)
check_complete(cleaned_time_sheet)
check_validity(cleaned_time_sheet)
