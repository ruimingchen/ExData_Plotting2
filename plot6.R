################################################################################
# Course Title: Exploratory Data Analysis
# Course Project: 2
# Plot: 6
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
# Get Baltimore City and Los Angeles data
#-------------------------------------------------------------------------------
NEI_zips <- NEI[NEI$fips == "24510"| NEI$fips == "06037", ]

#-------------------------------------------------------------------------------
# Get records for motor vehicle
#-------------------------------------------------------------------------------
SCC_motor <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC_motor <- SCC[SCC_motor, ]
SCC_codes <- as.character(SCC_motor$SCC)
NEI_zips$SCC <- as.character(NEI_zips$SCC)
NEI_motor_zips <- NEI_zips[NEI_zips$SCC %in% SCC_codes, ]

#-------------------------------------------------------------------------------
# Summarize data by zip and year
#-------------------------------------------------------------------------------
NEI_2county <- ddply(NEI_motor_zips, .(fips, year), 
                        summarize, Emissions = sum(Emissions))
NEI_2county$fips[NEI_2county$fip == "24510"] <- "Baltimore County"
NEI_2county$fips[NEI_2county$fip == "06037"] <- "Los Angeles County"


#-------------------------------------------------------------------------------
# Rename columns for Baltimore City data frame
#-------------------------------------------------------------------------------
colnames(NEI_2county) <- c("County", "Year", "Emissions")

#-------------------------------------------------------------------------------
# Plot to png
#-------------------------------------------------------------------------------
plot6 <- qplot(Year, Emissions, 
               data = NEI_2county, 
               group = County, 
               color = County, 
               geom = c("point", "line"), 
               xlab = "Year",
               ylab = expression('Total PM'[2.5]*' Emissions (tons)'),
               main = expression('Comparison of Total PM'[2.5]*' Emissions by County'))
png("plot6.png",width=640, height=480)
print(plot6)
dev.off()
