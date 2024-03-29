# Analysis of My Time Allocations as a PhD Student

## Overview of Paper

Various studies have shown that PhD students are having trouble with their work-life balance and coping with the stress of their workloads. To understand my own time management skills, I analyzed my timesheet data to understand my behavioural patterns over the first two semesters of my PhD journey. I found that I am spending about 40 hours a week, with most of my time spent on research, course work, and teach assistant related activities. There is evidence of improper work-life balance based on my tendency to work in late evenings as well as on weekends. To strive for better balance, I have outlined several suggestions to purposefully plan for each day, as well as created prediction models to estimate and plan for upcoming projects.

## File Structure

The repo is structured as the following:

-   `inputs/data` contains the raw time entry spreadsheet.

-   `outputs/data` contains the cleaned timesheet data to be used in analysis.

-   `outputs/paper` contains the files used to generate the paper, including the Quarto document, graphics, bibliography file, and the PDF version of this paper.

-   `scripts` contains the R scripts used to simulate, clean and validate data, as well as helper functions used in these routines.

-   `app` contains the application built using Shiny to generate predicted hours / completion dates.

## How to Run Quarto Report

1.  Run `scripts/01-data_cleaning.R` to clean up raw time entry data

2.  Run `scripts/03-test_suite.R` to validate data integrity

3.  Run `outputs/paper/timesheet_analysis.qmd` to generate the PDF of the paper

## How to Run Shiny App

Type in the command `runApp('app')` in the root directory to run the application.

![](https://github.com/christina-wei/INF3104-UN-World-Economic-Outlook/blob/main/outputs/paper/shiny_app_screenshot.png)
