#! /usr/bin/env Rscript

## Exploratory Data Analysis Course Project 2: Creating Plot 4
##
## Across the United States, how have emissions from coal combustion-related
## sources changed from 1999–2008?

## Load libraries
library(dplyr)
library(ggplot2)

## Set working directory and file names
setwd("./")
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file <- file.path("data", "nei.zip")
nei_file <- file.path("data", "summarySCC_PM25.rds")
scc_file <- file.path("data", "Source_Classification_Code.rds")

## Create data directory
if(!file.exists("data")) {
  dir.create("data")
}

## Retrieve data file
if(!file.exists(nei_file) || !file.exists(scc_file)) {
  download.file(fileUrl, destfile = file, method = "curl")
  dateDownloaded <- date()
  dateDownloaded
  unzip(file, exdir = "data")
  file.remove(file)
}

## Load data
nei <- readRDS(nei_file)
scc <- readRDS(scc_file)

## Get SCC codes for coal fuel combustion
coal <- scc %>%
  filter(EI.Sector == "Fuel Comb - Electric Generation - Coal" |
         EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal" |
         EI.Sector == "Fuel Comb - Comm/Institutional - Coal") %>%
  select(SCC)

## Analyze data
df <- nei %>%
  select(year, Emissions, SCC) %>%
  filter(SCC %in% coal$SCC) %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))

## Create plot
ggplot(df , aes(year, total)) +
  geom_point() +
  geom_line() +
  labs(title = "Total Emissions for Coal Combustion Sources by Year",
       x = "Year",
       y = "Total Emission")

ggsave("plot4.png")
