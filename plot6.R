library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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