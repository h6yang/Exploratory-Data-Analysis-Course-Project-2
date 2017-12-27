library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Q2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? 
with(NEI[NEI$fips == "24510",], tapply(Emissions, year, FUN=sum))
aggregatedMarylandByYear <- aggregate(Emissions ~ year, NEI[NEI$fips == "24510",], sum)
barplot(height=aggregatedMarylandByYear$Emissions, names.arg=aggregatedMarylandByYear$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years in Maryland'))
dev.copy(png,"plot2.png",width=480,height=480)
dev.off()