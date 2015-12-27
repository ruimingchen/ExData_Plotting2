################################################################################
# Course Title: Exploratory Data Analysis
# Course Project: 2
# Plot: 4
################################################################################

setwd("~/School/Coursera/Exploratory_Data_Analysis")
library(plyr)

#-------------------------------------------------------------------------------
# Read Data
#-------------------------------------------------------------------------------
if (!exists("NEI")) {
	NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
}
if (!exists("SCC")) {
	SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
}

#-------------------------------------------------------------------------------
# Get records for coal combustions
#-------------------------------------------------------------------------------
SCC_coal <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
SCC_coal <- SCC[SCC_coal, ]
SCC_codes <- as.character(SCC_coal$SCC)
NEI$SCC <- as.character(NEI$SCC)
NEI_coal <- NEI[NEI$SCC %in% SCC_codes, ]

#-------------------------------------------------------------------------------
# Aggregate emission related with coal combustion by year sum
#-------------------------------------------------------------------------------
aggregate_coal <- with(NEI_coal, 
                       aggregate(Emissions/1000, by = list(year), sum))

#-------------------------------------------------------------------------------
# Rename columns for Baltimore City data frame
#-------------------------------------------------------------------------------
colnames(aggregate_coal) <- c("year", "Emissions")

#-------------------------------------------------------------------------------
# Plot to png
#-------------------------------------------------------------------------------
png("plot4.png",width=640, height=480)
plot(aggregate_coal,
     type = "l", 
     xlab = "Year", 
     ylab = expression('Total PM'[2.5]*' Emissions (kilotons)'), 
     main = expression('Total PM'[2.5]*' Emissions from coal combustion-related sources in the United States'),
     col="red")
dev.off()
