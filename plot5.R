library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Q5 How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
# Subset motor combustion related NEI data
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fip
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips=="24510",]

ggplot(data = baltimoreVehiclesNEI, aes(y=Emissions, x=as.character(year))) +
  stat_summary(fun.y = sum, geom = "bar") 
dev.copy(png,"plot5.png",width=480,height=480)
dev.off()