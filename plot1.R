library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Q1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
with(NEI, tapply(Emissions, year, FUN=sum))
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)
barplot(height=aggregatedTotalByYear$Emissions, names.arg=aggregatedTotalByYear$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years'))
dev.copy(png,"plot1.png",width=480,height=480)
dev.off()