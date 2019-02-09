#! /usr/bin/env Rscript

## Exploratory Data Analysis Course Project 2: Creating Plot 1
##
## Have total emissions from PM2.5 decreased in the United States from 1999 to
## 2008? Using the base plotting system, make a plot showing the total PM2.5
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.

## Load libraries
library(dplyr)

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

## Analyze data
df <- nei %>%
  select(year, Emissions) %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))

## Create plot
png(filename = "plot1.png")
plot(df$year, df$total, type = "l",
     main = "Total Emissions from All Sources",
     xlab = "Year",
     ylab = "Total Emissions")
dev.off()
