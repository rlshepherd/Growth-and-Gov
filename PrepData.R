# Loading our TS Data
library(quantmod)
library(plyr)

# GNI per capita (from World Bank)
GNI.pc <- read.table("/Users/russellshepherd/Documents/MIIS/2011 Fall/DS/data/gni_per_capita.txt",header=T,sep="\t",quote="",na.strings="NA", colClasses=c("factor","factor",rep("numeric",52)))

# What does the data look like?
head(GNI.pc)

#Get rid of the "X" prefix on year column headers
names(GNI.pc) <- c("Country.Name","Country.Code",as.character(1960:2011))

# Melt
GNI.pc <- melt(GNI.pc, id=1:2)

# Scrub the double quotes, rename variables
GNI.pc$Country.Name <- as.factor(gsub("\"", "", GNI.pc$Country.Name))
names(GNI.pc) <- c("Country.Name","Country.Code","Year","GNI.pc")

# Order by Country.Name, then Year (Time Series format)
GNI.pc<- sort(GNI.pc, by=~ Country.Name +Year)

# Load GDP per capita, and Openness (from PWT 7.0)
penn <- read.csv("/Users/russellshepherd/Documents/MIIS/2011 Fall/DS/data/penn_data.csv",header=T,quote="\"",na.strings="na")

# Penn has 190 countries, and more dense data. 

# Perhaps we can use Plyr to split up the RGDP numbers to get growth and change in growth?


