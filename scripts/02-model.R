#### Preamble ####
# Purpose: Calibrating and using models to predict timelines
# Author: Christina Wei
# Date: 30 March 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites:
  # Run 01-data_cleaning.R to generate cleaned data

#### Workspace setup ####

library(tidyverse)
library(lubridate)

#### Calibrate model ####

calibrate_model <- function(from_date = NULL,
                            to_date = NULL, 
                            work_type = NULL) {
  
  #Read in cleaned timesheet
  cleaned_time_sheet <- read_csv(
    file = here("outputs/data/cleaned_time_sheet.csv"),
    show_col_types = FALSE 
  ) 
  
  #if from_date or to_date are not provided, set some default values
  if(is.null(from_date)) {
    from_date <- min(cleaned_time_sheet$start_date)
  }
  
  if(is.null(to_date)) {
    to_date <- max(cleaned_time_sheet$start_date)
  }

  #calculate timesheet to be used in calibration
  calibrate_time_sheet <-
    cleaned_time_sheet |>
    filter(start_date >= from_date, end_date <= to_date)
  
  if(!is.null(work_type)) {
    calibrate_time_sheet <-
      cleaned_time_sheet |>
      filter(type == work_type)
  }
  
  #calculate daily hours based on 
  daily_hours <-
    calibrate_time_sheet |>
    mutate(wkday = wday(calibrate_time_sheet$start_date, label = TRUE)) |>
    group_by(start_date, wkday) |>
    summarize(effort = sum(effort_hours)) |>
    ungroup() |>
    group_by(wkday) |>
    summarize(avg_effort = round(mean(effort),1))
  
  return(daily_hours)
}


#### Estimate number of hours ####

predict_hours_available <- function(model_param,
                          start_date = today(), 
                          end_date, 
                          pct_effort = 1, 
                          include_weekends = TRUE) {

  #calculate number of available days
  available_days <- tibble(
    date = seq(start_date, end_date, by = "day"),
    wkday = wday(date, label = TRUE))
  
  if(!include_weekends) {
    available_days <-
      available_days |>
      filter(!(wkday %in% c("Sat", "Sun")))
  }
 
  #compute detailed schedule of hours per day based on model parameters
  detailed_schedule <- 
    merge(model_param, available_days, by="wkday") |>
    mutate(hours = avg_effort * pct_effort) |>
    arrange(date) |>
    select(date, wkday, hours)
  
  return(
    list(
      total_hours = round(sum(detailed_schedule$hours),0),
      schedule = detailed_schedule
    )
  )
}

#### Estimate completion date ####

predict_completion_date <- function(model_param,
                                  start_date = today(), 
                                  effort_hours, 
                                  pct_effort = 1, 
                                  include_weekends = TRUE) {

  #calculate hours per week
  daily_hours <-
    model_param |>
    mutate(avg_effort = avg_effort * pct_effort)
  
  if(!include_weekends) {
    daily_hours <-
      daily_hours |>
      filter(!(wkday %in% c("Sat", "Sun")))
  }
  
  # generate a detailed daily timetable
  detailed_schedule <-
    tibble(
      date = seq(
        start_date, 
        by = "day", 
        length.out = ceiling(effort_hours / sum(daily_hours$avg_effort)) * 7),
      wkday = wday(date, label = TRUE)
    )
  
  detailed_schedule <- 
    merge(detailed_schedule, daily_hours, by = "wkday") |>
    arrange(date) |>
    mutate(
      hours = avg_effort,
      cumulative = cumsum(avg_effort)) |>
    select(date, wkday, hours, cumulative)
  
  slice_index = max(which(detailed_schedule$cumulative < effort_hours)) + 1
  slice_index = min(slice_index, nrow(detailed_schedule))

  detailed_schedule <-
    slice(detailed_schedule, 1:slice_index)

  return(
    list(
      completion_date = max(detailed_schedule$date),
      schedule = detailed_schedule
    )
  )
  
}