#! /usr/bin/env Rscript

## Exploratory Data Analysis Course Project 2: Creating Plot 5
##
## How have emissions from motor vehicle sources changed from 1999–2008 in
## Baltimore City?

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
vehicles <- scc %>%
  filter(EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" |
         EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" |
         EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" |
         EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles")

## Analyze data
df <- nei %>%
  select(year, fips, Emissions, SCC) %>%
  filter(fips == '24510' & SCC %in% vehicles$SCC) %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))

## Create plot
ggplot(df , aes(year, total)) +
  geom_point() +
  geom_line() +
  labs(title = "Total Emissions for Motor Vehicles in Baltimore by Year",
       x = "Year",
       y = "Total Emission")

ggsave("plot5.png")
