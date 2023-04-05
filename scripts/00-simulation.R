#### Preamble ####
# Purpose: Simulate timesheet data
# Author: Christina Wei
# Date: 31 March 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####

# assumptions
type_of_work <- c("Research", "Learning", "TA", "Other")
num_simulation <- 365
session_avg <- 1.5
session_sd <- 1

set.seed(311)

# simulate
simulated_data <-
  tibble(
    date = rep(
      seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "day"),
      each = 4),
    type = rep(type_of_work, times = num_simulation),
    time = rnorm(n = num_simulation * 4, mean = session_avg, sd = session_sd)
  )

# remove the negative values
simulated_data <-
  simulated_data |>
  mutate(time = ifelse(time < 0.1, 0.1, time))
