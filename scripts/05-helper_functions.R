#### Preamble ####
# Purpose: Collection of helper functions
# Author: Christina Wei
# Date: 19 February 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workspace setup ####

library(tidyverse)

# Convert HMS to hours
convert_hms_to_hours <- function(time) {
  as.numeric(time) / 3600
}

# Generate time series graph with linear regression
generate_time_series_graph <- function(
    ggplot_data,
    xlabel = NULL,
    ylabel = NULL,
    color_label = NULL,
    position = "bottom",
    nrow = NULL,
    yscale = scales::number #scales::percent
) {

  ggplot_data +
    geom_line() +
    scale_y_continuous(labels = yscale) +
    theme_minimal() +
    theme(legend.position = position) +
    #reference: https://datavizpyr.com/fold-legend-into-two-rows-in-ggplot2/
    guides(color = guide_legend(nrow = nrow, byrow = TRUE)) +
    labs(
      x = xlabel,
      y = ylabel,
      color = color_label
    )
}

generate_compare_bar_graph <- function(
    ggplot_data,
    position, # "dodge" for side by side, "stack" for stacked
    xlabel = NULL,
    ylabel = NULL,
    fill_label = NULL,
    angle = NULL,
    hjust = NULL,
    vjust = NULL,
    nrow = NULL,
    yscale = scales::number #scales::percent
) {

  ggplot_data +
    geom_bar(stat = "identity", position = position) +
    scale_y_continuous(labels = yscale) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = angle, vjust = vjust, hjust = hjust)
    ) +
    theme(legend.position = "bottom") +
    guides(fill = guide_legend(nrow = nrow, byrow = TRUE)) +
    labs(
      x = xlabel,
      y = ylabel,
      fill = fill_label
    )
}
