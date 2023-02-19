#### Preamble ####
# Purpose: Download datasets needed for analysis
# Author: Christina Wei
# Date: 19 February 2023
# Contact: christina.wei@mail.utoronto.ca
# License: MIT
# Prerequisites: none
# Datasets:
  # UN World Economic Outlook https://www.imf.org/-/media/Files/Publications/WEO/WEO-Database/2022/WEOOct2022all.ashx


#### Workspace setup ####

library(tidyverse)


#### Download Raw Data Files ####

# Download World Economic Outlook Database, updated as of October 2022
download.file(
  "https://www.imf.org/-/media/Files/Publications/WEO/WEO-Database/2022/WEOOct2022all.ashx",
  "inputs/data/raw_un_world_economic_outlook.xls")

