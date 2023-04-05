#### Preamble ####
# Purpose: Validation tests for dataset
# Author: Christina Wei
# Date: 31 March 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(testthat)

#### Validate class of each attribute ####

check_class <- function(cleaned_time_sheet) {
  test_that("Check class", {
    expect_is(cleaned_time_sheet$project, "character")
    expect_is(cleaned_time_sheet$description, "character")
    expect_is(cleaned_time_sheet$start_date, "Date")
    expect_is(cleaned_time_sheet$start_time, "hms")
    expect_is(cleaned_time_sheet$end_date, "Date")
    expect_is(cleaned_time_sheet$end_time, "hms")
    expect_is(cleaned_time_sheet$duration, "hms")
    expect_is(cleaned_time_sheet$type, "character")
    expect_is(cleaned_time_sheet$effort_hours, "numeric")
  })
}

#### Check for completeness of data ####

# other than project that could have NA values, everything else should be there
check_complete <- function(cleaned_time_sheet) {
  test_that("Check for data completeness", {
    expect_true(all(complete.cases(cleaned_time_sheet$description)))
    expect_true(all(complete.cases(cleaned_time_sheet$start_date)))
    expect_true(all(complete.cases(cleaned_time_sheet$start_time)))
    expect_true(all(complete.cases(cleaned_time_sheet$end_date)))
    expect_true(all(complete.cases(cleaned_time_sheet$end_time)))
    expect_true(all(complete.cases(cleaned_time_sheet$duration)))
    expect_true(all(complete.cases(cleaned_time_sheet$type)))
    expect_true(all(complete.cases(cleaned_time_sheet$effort_hours)))
  })
}

check_validity <- function(cleaned_time_sheet) {
  test_that("Check that data is valid", {
    expect_equal(sum(cleaned_time_sheet$start_date < as.Date("2022-08-01")), 0)
    expect_equal(sum(cleaned_time_sheet$start_date > today()), 0)
    expect_equal(sum(cleaned_time_sheet$end_date < as.Date("2022-08-01")), 0)
    expect_equal(sum(cleaned_time_sheet$end_date > today()), 0)
    expect_equal(sum(cleaned_time_sheet$effort_hours <= 0), 0)
    expect_lte(length(unique(cleaned_time_sheet$type)), 10)

  })
}
