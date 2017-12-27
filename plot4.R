library(ggplot2)
library(gridExtra)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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