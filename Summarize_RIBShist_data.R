# Sandbox for analyzing and subsetting simpleRIBS.csv and RIBS.csv.

library(tidyverse)
input_dir <- "C:/Data/RIBS/From_L_drive/"

setwd(input_dir)

#Alene's param list
param_list <- read.csv("RIBS.Parameters.csv", stringsAsFactors = FALSE) %>% 
  select(Name, STORET.1.parameter, EQUIS.1.parameter)

# STORET param list - from https://www3.epa.gov/storet/legacy/ref_tables.htm
STORET_params <- read.csv("STORET_parameters.csv", stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM")
  
RIBS_input <- read.csv("RIBS.csv",stringsAsFactors=FALSE)
RIBSsimple_input <- read.csv("simpleRIBS.csv",stringsAsFactors=FALSE)

# Where was RIBS.csv data sourced from from (by year)?
RIBS_input$year <- substr(RIBS_input$SAMPLE_DATE, start = 1, stop = 4)

ribs.storet <- subset(RIBS_input, (!is.na(RIBS_input$STORET_Parameter)))
ribs.equis <- subset(RIBS_input, (!is.na(RIBS_input$EQUIS_Parameter)))
ribs.bill <- subset(RIBS_input, (!is.na(RIBS_input$BILL_Parameter)))

sort(unique(RIBS_input$year))
sort(unique(ribs.storet$year))
sort(unique(ribs.equis$year))
sort(unique(ribs.bill$year))

# List flags present
sort(unique(RIBS_input$EQUIS_IFLAG))
  #  ""    "*"   "*E"  "*EJ" "*J"  "B"   "C"   "E"   "EJ"  "H"   "J"   "KK"  "L"   "LL"  "N"   "N*"  "N*J" "NE"  "NEJ" "NJ"  "Q"   "U"   "UN"   
sort(unique(RIBS_input$EQUIS_LFLAG))
  #  ""    "*"   "*E"  "*EJ" "*J"  "B"   "E"   "EJ"  "H"   "J"   "N"   "N*"  "N*J" "NE"  "NEJ" "NJ"  "U"   "UN" 
sort(unique(RIBS_input$EQUIS_VFLAG))
  #  ""  "H" "J" "L"

# Look for undetects
undetects.na <- subset(RIBS_input, is.na(RIBS_input$Result.Value))
undetects.U1 <- subset(RIBS_input, RIBS_input$EQUIS_IFLAG == "U")
undetects.U2 <- subset(RIBS_input, RIBS_input$EQUIS_LFLAG == "U")
undetects.U3 <- subset(RIBS_input, RIBS_input$EQUIS_VFLAG == "U")

unique(undetects.na$year)
  # No "NA" result values present.
unique(undetects.U1$year)
  # Several present, but all have result values. Only 2015 and 2011.
unique(undetects.U2$year)
  # "2015"
unique(undetects.U3$year)
  # None present.


# Format date for queries
RIBSsimple_input$SAMPLE_DATE <- as.Date(RIBSsimple_input$SAMPLE_DATE, "%Y-%m-%d")
RIBSsimple_input$year <- lubridate::year(RIBSsimple_input$SAMPLE_DATE)

#List years available
RIBSinputYears <- unique(RIBSsimple_input$year)
sort(RIBSinputYears)

# Subset 2008-2016 data and write to table
RIBS_2008_to_2016 <- RIBSsimple_input[RIBSsimple_input$year>=2008 ]
RIBS_2008_to_2016 <- subset(RIBSsimple_input,RIBSsimple_input$year>=2008)
write.table(RIBS_2008_to_2016, file="RIBS_2008_to_2016.csv",sep=",", row.names = FALSE)

#Subset by station
station.subset <- subset(RIBS_input, grepl(12010049, RIBS_input$Station))

#Subset by name search
HudsonSamples <- subset(RIBSsimple_input, grepl("Waterford", RIBSsimple_input$Station.Name))

# Subset by latitude
SamplesByLat <- subset(RIBSsimple_input, grepl("42.78861", RIBSsimple_input$Latitude))

# Subset single year
ribsYear <- subset(RIBSsimple_input, format.Date(SAMPLE_DATE, "%Y")=="2016")

# Subset from year onward
yearBeyond <- subset(RIBSsimple_input, format.Date(SAMPLE_DATE, "%Y")>="2000")

# Create lat_long field
RIBSsimple_input$LatLong <- paste(RIBSsimple_input$Latitude,RIBSsimple_input$Longitude, sep="_")

# List unique locations by lat_long
uniqueLatLong <- RIBSsimple_input[!duplicated(RIBSsimple_input$LatLong),] 
  # Some locations are same but slightly different coords

# List various unique attributes
uniqueSites <- RIBSsimple_input[!duplicated(RIBSsimple_input$Station),] 
uniqueNames <- RIBSsimple_input[!duplicated(RIBSsimple_input$Station.Name),] 
uniqueLats <- RIBSsimple_input[!duplicated(RIBSsimple_input$Latitude),] 
uniqueLong <- RIBSsimple_input[!duplicated(RIBSsimple_input$Longitude),] 

# Find common station IDs between RIBS and simpleRIBS files.
common_stations <- intersect(RIBS_input$Station,RIBSsimple_input$Station)
length(common_stations)
RIBS_stations <- unique(RIBS_input$Station)
simple_stations <- unique(RIBSsimple_input$Station)
length(simple_stations)
extrasInSimpleRibs <- simple_stations[is.na(match(simple_stations,common_stations))]

#Subset records with site IDs that are unique to simpleRIBS
simpleRIBSunique <- RIBSsimple_input[RIBSsimple_input$Station %in% extrasInSimpleRibs, ]
table(simpleRIBSunique$year)


length(extrasInSimpleRibs)
  # RIBS.csv is missing 20 site IDs that simpleRIBS has. Are these 2016 sites?

x <- lapply(extrasInSimpleRibs, function(x){subset(RIBSsimple_input, Station == x)})



write.table(uniqueSites, file="simpleRIBS_Sites.csv",sep=",", row.names = FALSE)
write.table(uniqueNames, file="simpleRIBS_Names.csv",sep=",", row.names = FALSE)

write.table(uniqueLats, file="uniqueLats.csv",sep=",", row.names = FALSE)
write.table(uniqueLong, file="uniqueLong.csv",sep=",", row.names = FALSE)
write.table(extrasInSimpleRibs, file="SRextrastations.csv",sep=",", row.names = FALSE)

write.table(RIBS_input, file="RIBS_R_output.csv",sep=",", row.names = FALSE)


setkey(RIBS_input)

# Get Unique lines in the data table
unique_latlongs2 <- unique( RIBS_input[list("Longitude", "Latitude"), nomatch = 0]  ) 