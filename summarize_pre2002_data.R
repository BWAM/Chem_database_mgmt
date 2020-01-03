library(tidyverse)
input_dir <- "C:/Data/RIBS/From_L_drive/"

setwd(input_dir)

prehistoric_chem <- read.csv("C:/Data/RIBS/historic_pre-2002/RIBS_pre-2002_complete_2019-06-06.csv",stringsAsFactors=FALSE)

unique_params_short <- unique(prehistoric_chem$Short_Name)
unique_params_long <- unique(prehistoric_chem$Full_Name)

unique_station <- unique(prehistoric_chem$Station)
unique_stationname <- unique(prehistoric_chem$Station.Name)

prehistoric_chem$year <- substr(prehistoric_chem$SAMPLE_DATE, start = 1, stop = 4)

ribs.storet <- subset(prehistoric_chem, (!is.na(prehistoric_chem$STORET_Parameter)))
ribs.equis <- subset(prehistoric_chem, (!is.na(prehistoric_chem$EQUIS_Parameter)))
ribs.bill <- subset(prehistoric_chem, (!is.na(prehistoric_chem$BILL_Parameter)))

sort(unique(prehistoric_chem$year))
sort(unique(ribs.storet$year))
sort(unique(ribs.equis$year))
sort(unique(ribs.bill$year))

sort(unique(ribs.equis$EQUIS_Parameter))

sort(unique(ribs.bill$BILL_Parameter))
sort(unique(ribs.bill$BILL.Flags))
sort(unique(ribs.bill$BILL_UNITS))

sort(unique(ribs.storet$Short_Name))
sort(unique(ribs.storet$Full_Name))
sort(unique(ribs.storet$STORET_Parameter))
sort(unique(ribs.storet$STORET.Flags))
