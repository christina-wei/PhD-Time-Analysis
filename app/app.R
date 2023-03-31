#### Preamble ####
# Purpose: Application to calculate various estimates using the calibrated prediction models
# Author: Christina Wei
# Data: March 30, 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites:
  # 01-data_cleaning.R as the calibration model uses time sheet data

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(here)

source(here("scripts/02-model.R"))

model_choices <- list(
  "Number of Hours" = 1,
  "Completion Date" = 2
)

type_choices <- list(
  "All" = "All",
  "Research" = "Research",
  "Course Work" = "Course Work"
)

# Define UI for application that draws a histogram

ui <- fluidPage(
  titlePanel("Time Estimation Application"),
  sidebarPanel(
    
    # Calibration parameters
    h3("Calibration"),
    dateInput("calibration_from_date", "From Date", value = as.Date("2022-08-15")),
    dateInput("calibration_to_date", "To Date", value = as.Date("2023-03-13")),
    selectInput("type", "Type of Work", choices = type_choices),
    
    # Estimation parameters
    h3("Prediction Model"),
    selectInput("model", "Value to Estimate", choices = model_choices),
    numericInput("effort_hours", "Estimate effort (in hours)", value = 0),
    dateInput("model_start_date", "Start Date"),
    dateInput("model_end_date", "End Date"),
    checkboxInput("include_weekends", "Include Weekends?", value = TRUE),
    numericInput("pct_effort", "Percentage of Effort", value = 1),
    
    # Calculate button
    actionButton("run_model", label= "Calculate")
  ),
  mainPanel(
    # Show estimate value & project table
    textOutput("value", container = tags$h3),
    hr(),
    textOutput("value2", container = tags$h4),
    tableOutput('table'),
  )
)

server <- function(input, output) {
  
  observeEvent(input$run_model, {
    
    # Calibrate model

    model_param <- calibrate_model(
      from_date = input$calibration_from_date, 
      to_date = input$calibration_to_date,
      if(input$type == "All") {
        work_type = NULL
      } else{
        work_type = input$type
      }
    )
    
    # Run prediction
    prediction = NULL
    
    if (input$model == 1) {
      prediction <- 
        predict_hours_available(
          model_param,
          start_date = input$model_start_date,
          end_date = input$model_end_date,
          pct_effort = input$pct_effort,
          include_weekends = input$include_weekends
        )
      output$value <- renderText({paste("Estimated Hours Available: ", prediction$total_hours)})
    } 
    else {
      prediction <- 
        predict_completion_date(
          model_param,
          start_date = input$model_start_date,
          effort_hours = input$effort_hours,
          pct_effort = input$pct_effort,
          include_weekends = input$include_weekends
        )
      output$value <- renderText({paste("Estimated Completion Date: ", format(prediction$completion_date, format = "%B %d, %Y"))})
    }
    
    prediction$schedule$date = as.character(prediction$schedule$date)

    # Link values to output variables
    output$value2 <- renderText({"Projected Schedule"})
    output$table <- renderTable(prediction$schedule)
  })
}

#Run the application
shinyApp(ui, server)