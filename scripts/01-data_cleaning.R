#### Preamble ####
# Purpose: Clean up datasets related timesheets, sleep quality, and deliverables
# Author: Christina Wei
# Data: March 19, 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)


#### Timesheet data ####

cleaned_time_sheet <-
  read_csv(
    file = "inputs/data/time_entry.csv",
    show_col_types = FALSE
  )

cleaned_time_sheet <-
  cleaned_time_sheet |>
  select(-User, -Email, -Client, -Task, -Billable, -Tags, -`Amount ()`) |>
  clean_names()

# classify each project
cleaned_time_sheet <-
  cleaned_time_sheet |>
  mutate(type = case_when(

    grepl("Anastasia", description, fixed=TRUE) ~ "Research",
    project == "Industry DDN" ~ "Research",
    project == "Disfluency perception" ~ "Research",
    project == "OAPerception" ~ "Research",
    project == "Reading" ~ "Research",
    project == "Lit Review" ~ "Research",
    project == "Finance CA Marginalization" ~ "Research",
    project == "Research-General" ~ "Research",
    
    project == "INF2241" ~ "Course Work",
    project == "INF3001" ~ "Course Work",
    project == "INF3104" ~ "Course Work",
    project == "INF2169" ~ "Course Work",
    
    project == "TA-CCT419" ~ "TA",
    project == "TA-INF2208" ~ "TA",
    project == "TA-INF2192" ~ "TA",
    
    project == "CCT419" ~ "Learning",
    project == "INF2208" ~ "Learning",
    project == "writing course" ~ "Learning",
    project == "Talks" ~ "Learning",
    
    project == "Cookie Lab" ~ "Other Activities",
    project == "Service Work" ~ "Other Activities",
    project == "Professional" ~ "Other Activities",
    
    is.na(project) ~ "Admin",
    project == "Network" ~ "Admin",
    grepl("Admin", description, fixed=TRUE) ~ "Admin",
    grepl("NSERC", description, fixed=TRUE) ~ "Admin",
    grepl("Grant", description, fixed=TRUE) ~ "Admin",
  ))

write_csv(
  x = cleaned_time_sheet,
  file = "outputs/data/cleaned_time_sheet.csv"
)

#### Sleep data ####

cleaned_sleep_score <-
  read_csv(
    file = "inputs/data/sleep_score.csv",
    show_col_types = FALSE
  )


#### Due dates ####

cleaned_deliverables <-
  read_csv(
    file = "inputs/data/deliverables.csv",
    show_col_types = FALSE
  )
