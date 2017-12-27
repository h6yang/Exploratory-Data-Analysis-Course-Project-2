library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Q3. Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?
ggplot(data = NEI[NEI$fips == "24510",], aes(y=Emissions, x=as.character(year))) + 
  stat_summary(fun.y = sum, geom = "bar") +
  facet_grid(~type)
dev.copy(png,"plot3.png",width=480,height=480)
dev.off()