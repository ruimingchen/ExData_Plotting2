################################################################################
# Course Title: Exploratory Data Analysis
# Course Project: 2
# Plot: 3
################################################################################

setwd("~/School/Coursera/Exploratory_Data_Analysis")
library(plyr)
library(ggplot2)

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
# Summarize data by pollutant type and year
#-------------------------------------------------------------------------------
NEI_24510_type <- ddply(NEI_24510, .(type, year), 
                        summarize, Emissions = sum(Emissions))

#-------------------------------------------------------------------------------
# Plot to png
#-------------------------------------------------------------------------------
plot3<-qplot(year, Emissions, 
             data = NEI_24510_type, 
             group = type, 
             color = type, 
             geom = c("point", "line"), 
             xlab = "Year",
             ylab = expression('Total PM'[2.5]*' Emissions (kilotons)'), 
             main = expression('Total PM'[2.5]*' Emissions in Baltimore City, Maryland by Type of Pollutant'))
png("plot3.png",width=640, height=480)
print(plot3)
dev.off()
