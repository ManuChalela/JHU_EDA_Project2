library(data.table)
library(reshape2)
library(png)
library(dplyr)
library(fs)
library(lubridate)
path <- file.path(getwd(), "data/")
fs::dir_create(path = path)

url <-
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = file.path(path, "dataFiles.zip"), exdir = path)

SCC <- data.table::as.data.table(x = readRDS(file = file.path(path, "Source_Classification_Code.rds")))
NEI <- data.table::as.data.table(x = readRDS(file = file.path(path, "summarySCC_PM25.rds")))

# Prevents histogram from printing in scientific notation
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

barplot(totalNEI[, Emissions]
        , names = totalNEI[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")
