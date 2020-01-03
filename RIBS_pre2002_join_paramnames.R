# File: RIBS_pre2002_join_paramnames.R
# Purpose: Joining parameter names to old RIBS.csv (which had just STORET paramter keys)
# Author: Gavin lemley
# Created and ran: 06/06/2019

library(tidyverse)
input_dir <- "C:/Data/RIBS/From_L_drive/"

setwd(input_dir)

# STORET param list - from https://www3.epa.gov/storet/legacy/ref_tables.htm
STORET_params <- read.csv("STORET_parameters.csv", stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM") %>% 
  select(Parameter_No, Short_Name, Full_Name) %>%
  rename(STORET_Parameter = Parameter_No) %>% 
  mutate(STORET_Parameter = as.character(STORET_Parameter))

# Load data
RIBS_input <- read.csv("RIBS.csv",stringsAsFactors=FALSE) %>% 
  mutate(STORET_Parameter = as.character(STORET_Parameter))

# Join parameter names by parameter keys
RIBS_input <- RIBS_input %>%
  left_join(STORET_params, by = "STORET_Parameter")

# Clean up table and export
output <- RIBS_input %>% 
  select(Station, Station.Name, Longitude, Latitude, SAMPLE_DATE, Short_Name, Full_Name, Result.Value, STORET_Parameter, STORET.Flags, EQUIS_Parameter, EQUIS_FRACTION, EQUIS_VFLAG, EQUIS_LFLAG, EQUIS_UNITS, EQUIS_IFLAG, BILL_Parameter, BILL_UNITS, BILL.Flags)

write.csv(output, "C:/Data/RIBS/historic_pre-2002/RIBS_pre-2002_complete_2019-06-06.csv", row.names = FALSE)
