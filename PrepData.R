# Loading our TS Data
library(quantmod)
library(plyr)
library(reshape)

# GNI per capita (from World Bank)
GNI.pc <- read.table("data/gni_per_capita.txt",header=T,sep="\t",quote="",na.strings="NA", colClasses=c("factor","factor",rep("numeric",52)))

# What does the data look like?
head(GNI.pc)

#Get rid of the "X" prefix on year column headers
names(GNI.pc) <- c("Country.Name","Country.Code",as.character(1960:2011))

# Melt
GNI.pc <- melt(GNI.pc, id=1:2)

# Scrub the double quotes, rename variables
GNI.pc$Country.Name <- as.factor(gsub("\"", "", GNI.pc$Country.Name))
names(GNI.pc) <- c("Country.Name","Country.Code","Year","GNI.pc")

# Order by Country.Name, then Year (Time Series format).
#GNI.pc <- sort(GNI.pc, by=~ Country.Name+ Year) # THIS BROKE ON UPDATE 2.13 > 2.15 -- needs fixing.

# Load GDP per capita, and Openness (from PWT 7.0)
penn <- read.csv("data/penn_data.csv",header=T,quote="\"",na.strings="na")

# Use Plyr's ddply and Quantmod's Delt to get growth rates per country slice.
penn1 <- penn
penn1 <- ddply(penn1, .(Country.Code), transform, valdiff=Delt(GDP.pc))

