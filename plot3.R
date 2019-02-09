#! /usr/bin/env Rscript

## Exploratory Data Analysis Course Project 2: Creating Plot 3
##
## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in
## emissions from 1999–2008 for Baltimore City? Which have seen increases in
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot
## answer this question.

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

## Analyze data
df <- nei %>%
  select(year, Emissions, fips, type) %>%
  filter(fips == '24510') %>%
  mutate(type = as.factor(type)) %>%
  group_by(year, type) %>%
  summarize(total = sum(Emissions))

## Create plot
ggplot(df , aes(year, total)) +
  geom_point() +
  geom_line() +
  facet_grid(. ~ type) +
  labs(title = "Total Emissions in Baltimore by Year and Type",
       x = "Year",
       y = "Total Emission")

ggsave("plot3.png")
