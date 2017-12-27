library(ggplot2)
library(gridExtra)

setwd("/Users/hai/Documents/Personal/Data_Scientist_Learning/Course 4 Exploratory Data Analysis/project_2")
list.files()
#rm(list=ls())

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
head(NEI)
str(NEI)
head(SCC)

hist(NEI[NEI$year == 1999,]$Emissions)
summary(NEI$Emissions)
tail(sort(NEI$Emissions))

# Q1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
with(NEI, tapply(Emissions, year, FUN=sum))
aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)
barplot(height=aggregatedTotalByYear$Emissions, names.arg=aggregatedTotalByYear$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years'))
dev.copy(png,"plot1.png",width=480,height=480)
dev.off()

# Q2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? 
with(NEI[NEI$fips == "24510",], tapply(Emissions, year, FUN=sum))
aggregatedMarylandByYear <- aggregate(Emissions ~ year, NEI[NEI$fips == "24510",], sum)
barplot(height=aggregatedMarylandByYear$Emissions, names.arg=aggregatedMarylandByYear$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years in Maryland'))
dev.copy(png,"plot2.png",width=480,height=480)
dev.off()

# Q3. Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?

ggplot(data = NEI[NEI$fips == "24510",], aes(y=Emissions, x=as.character(year))) + 
  stat_summary(fun.y = sum, geom = "bar") +
  facet_grid(~type)
dev.copy(png,"plot3.png",width=480,height=480)
dev.off()

# Q4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Subset coal combustion related NEI data
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

ggplot(data = combustionNEI, aes(y=Emissions, x=as.character(year))) +
  stat_summary(fun.y = sum, geom = "bar") 
dev.copy(png,"plot4.png",width=480,height=480)
dev.off()

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

# Q6 Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen greater changes over time in motor vehicle emissions?
baltimoreVehiclesNEI_BaLa <- vehiclesNEI[vehiclesNEI$fips %in% c("24510","06037"),]
baltimoreVehiclesNEI_BaLa$city <- ifelse(baltimoreVehiclesNEI_BaLa$fips == "24510", "Baltimore", "Los Angeles" )
  
ggplot(data = baltimoreVehiclesNEI_BaLa, aes(y=Emissions, x=as.character(year))) +
  stat_summary(fun.y = sum, geom = "bar") +
  facet_grid(~city) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))
dev.copy(png,"plot6.png",width=480,height=480)
dev.off()
