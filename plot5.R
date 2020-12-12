library(data.table)
library(reshape2)
library(png)
library(dplyr)
library(fs)
library(lubridate)
library(ggplot2)

path <- file.path(getwd(), "data/")
fs::dir_create(path = path)

url <-
  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = file.path(path, "dataFiles.zip"), exdir = path)

SCC <- data.table::as.data.table(x = readRDS(file = file.path(path, "Source_Classification_Code.rds")))
NEI <- data.table::as.data.table(x = readRDS(file = file.path(path, "summarySCC_PM25.rds")))

# Gather the subset of the NEI data which corresponds to vehicles
vehiclesSCC <- SCC[grepl("vehicle", SCC.Level.Two, ignore.case=TRUE)
                   , SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fip
baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510",]

png("plot5.png")

ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill ="#FF9999" ,width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()
