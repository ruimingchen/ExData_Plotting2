################################################################################
# Course Title: Exploratory Data Analysis
# Course Project: 2
# Plot: 5
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
# Get Baltimore City data
#-------------------------------------------------------------------------------
NEI_24510 <- NEI[which(NEI$fips == "24510"), ]

#-------------------------------------------------------------------------------
# Get records for motor vehicle
#-------------------------------------------------------------------------------
SCC_motor <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC_motor <- SCC[SCC_motor, ]
SCC_codes <- as.character(SCC_motor$SCC)
NEI_24510$SCC <- as.character(NEI_24510$SCC)
NEI_motor_24510 <- NEI_24510[NEI_24510$SCC %in% SCC_codes, ]

#-------------------------------------------------------------------------------
# Aggregate emission related with motor vehicle by year sum
#-------------------------------------------------------------------------------
aggregate_motor_24510 <- with(NEI_motor_24510, 
                       aggregate(Emissions/1000, by = list(year), sum))

#-------------------------------------------------------------------------------
# Rename columns for Baltimore City data frame
#-------------------------------------------------------------------------------
colnames(aggregate_motor_24510) <- c("year", "Emissions")

#-------------------------------------------------------------------------------
# Plot to png
#-------------------------------------------------------------------------------
png("plot5.png",width=640, height=480)
plot(aggregate_motor_24510,
     type = "l", 
     xlab = "Year", 
     ylab = expression('Total PM'[2.5]*' Emissions (kilotons)'), 
     main = expression('Total PM'[2.5]*' Emissions from motor vehicle sources in the United States'),
     col="red")
dev.off()
