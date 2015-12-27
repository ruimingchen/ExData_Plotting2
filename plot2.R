################################################################################
# Course Title: Exploratory Data Analysis
# Course Project: 2
# Plot: 2
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
# Subset Baltimore City data
#-------------------------------------------------------------------------------
NEI_24510 <- NEI[NEI$fips=="24510", ]

#-------------------------------------------------------------------------------
# Aggregate data by year sum
#-------------------------------------------------------------------------------
NEI_24510_aggregate <- with(NEI_24510, 
                            aggregate(Emissions/1000, by = list(year), sum))
  
#-------------------------------------------------------------------------------
# Plot to png
#-------------------------------------------------------------------------------
png("plot2.png",width=640, height=480)
plot(NEI_24510_aggregate, 
     type = "l",
     xlab = "Year", 
     ylab = expression('Total PM'[2.5]*' Emissions (kilotons)'), 
     main = expression('Total PM'[2.5]*' Emissions in Baltimore City, Maryland'),
     col="red")
dev.off()
