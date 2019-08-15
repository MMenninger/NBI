library(tidyverse)
library(readr)
library(measurements)

##Define years and state you want
years <- 1992:2018
state <- "IL"

getwd()
#setwd("S:/AdminGroups/PerformanceProgramming/RegionalTransportationPerformanceMeasures/Bridge_Analysis")

# Download all the text files for those years
download.file(url = paste("https://www.fhwa.dot.gov/bridge/nbi/", years, "/", state, substring(years, 3), ".txt", sep = ""), 
              destfile = paste("NBI", state, years, ".txt", sep = ""), method = "libcurl")

##Needed to set up loop. Should rewrite to eliminate need for this. 
temp<- data.frame(read.fwf(file = paste("NBI", state, "2010", ".txt", sep = ""), 
                           widths = c(3,15,1,1,1,5,1,2,3,5,24,1,18,25,4,7,1,10,2,8,9,3,1,2,2,2,4,2,2,6,4,1,4,1,2,1,1,1,1,1,1,1,4,5,1,1,1,1,2,1,2,3,4,3,5,6,3,3,4,4,4,1,4,1,3,3,1,1,1,1,1,1,3,1,3,1,1,1,1,1,1,2,1,6,4,2,3,3,3,4,4,4,6,6,6,4,3,2,15,1,1,1,1,1,1,4,1,1,1,1,2,1,1,1,1,6,4,4,1,5,1,1,21,2,1,1,1,1,1,1,1,1,4,1,1,1,10), 
                           col.names = c('STATE_CODE_001', 'STRUCTURE_NUMBER_008', 'RECORD_TYPE_005A', 'ROUTE_PREFIX_005B', 'SERVICE_LEVEL_005C', 'ROUTE_NUMBER_005D', 'DIRECTION_005E', 'HIGHWAY_DISTRICT_002', 'COUNTY_CODE_003', 'PLACE_CODE_004', 'FEATURES_DESC_006A', 'CRITICAL_FACILITY_006B', 'FACILITY_CARRIED_007', 'LOCATION_009', 'MIN_VERT_CLR_010', 'KILOPOINT_011', 'BASE_HWY_NETWORK_012', 'LRS_INV_ROUTE_013A', 'SUBROUTE_NO_013B', 'LAT_016', 'LONG_017', 'DETOUR_KILOS_019', 'TOLL_020', 'MAINTENANCE_021', 'OWNER_022', 'FUNCTIONAL_CLASS_026', 'YEAR_BUILT_027', 'TRAFFIC_LANES_ON_028A', 'TRAFFIC_LANES_UND_028B', 'ADT_029', 'YEAR_ADT_030', 'DESIGN_LOAD_031', 'APPR_WIDTH_MT_032', 'MEDIAN_CODE_033', 'DEGREES_SKEW_034', 'STRUCTURE_FLARED_035', 'RAILINGS_036A', 'TRANSITIONS_036B', 'APPR_RAIL_036C', 'APPR_RAIL_END_036D', 'HISTORY_037', 'NAVIGATION_038', 'NAV_VERT_CLR_MT_039', 'NAV_HORR_CLR_MT_040', 'OPEN_CLOSED_POSTED_041', 'SERVICE_ON_042A', 'SERVICE_UND_042B', 'STRUCTURE_KIND_043A', 'STRUCTURE_TYPE_043B', 'APPR_KIND_044A', 'APPR_TYPE_044B', 'MAIN_UNIT_SPANS_045', 'APPR_SPANS_046', 'HORR_CLR_MT_047', 'MAX_SPAN_LEN_MT_048', 'STRUCTURE_LEN_MT_049', 'LEFT_CURB_MT_050A', 'RIGHT_CURB_MT_050B', 'ROADWAY_WIDTH_MT_051', 'DECK_WIDTH_MT_052', 'VERT_CLR_OVER_MT_053', 'VERT_CLR_UND_REF_054A', 'VERT_CLR_UND_054B', 'LAT_UND_REF_055A', 'LAT_UND_MT_055B', 'LEFT_LAT_UND_MT_056', 'DECK_COND_058', 'SUPERSTRUCTURE_COND_059', 'SUBSTRUCTURE_COND_060', 'CHANNEL_COND_061', 'CULVERT_COND_062', 'OPR_RATING_METH_063', 'OPERATING_RATING_064', 'INV_RATING_METH_065', 'INVENTORY_RATING_066', 'STRUCTURAL_EVAL_067', 'DECK_GEOMETRY_EVAL_068', 'UNDCLRENCE_EVAL_069', 'POSTING_EVAL_070', 'WATERWAY_EVAL_071', 'APPR_ROAD_EVAL_072', 'WORK_PROPOSED_075A', 'WORK_DONE_BY_075B', 'IMP_LEN_MT_076', 'DATE_OF_INSPECT_090', 'INSPECT_FREQ_MONTHS_091', 'FRACTURE_092A', 'UNDWATER_LOOK_SEE_092B', 'SPEC_INSPECT_092C', 'FRACTURE_LAST_DATE_093A', 'UNDWATER_LAST_DATE_093B', 'SPEC_LAST_DATE_093C', 'BRIDGE_IMP_COST_094', 'ROADWAY_IMP_COST_095', 'TOTAL_IMP_COST_096', 'YEAR_OF_IMP_097', 'OTHER_STATE_CODE_098A', 'OTHER_STATE_PCNT_098B', 'OTHR_STATE_STRUC_NO_099', 'STRAHNET_HIGHWAY_100', 'PARALLEL_STRUCTURE_101', 'TRAFFIC_DIRECTION_102', 'TEMP_STRUCTURE_103', 'HIGHWAY_SYSTEM_104', 'FEDERAL_LANDS_105', 'YEAR_RECONSTRUCTED_106', 'DECK_STRUCTURE_TYPE_107', 'SURFACE_TYPE_108A', 'MEMBRANE_TYPE_108B', 'DECK_PROTECTION_108C', 'PERCENT_ADT_TRUCK_109', 'NATIONAL_NETWORK_110', 'PIER_PROTECTION_111', 'BRIDGE_LEN_IND_112', 'SCOUR_CRITICAL_113', 'FUTURE_ADT_114', 'YEAR_OF_FUTURE_ADT_115', 'MIN_NAV_CLR_MT_116', 'FED_AGENCY', 'DATE_LAST_UPDATE', 'TYPE_LAST_UPDATE', 'DEDUCT_CODE', 'REMARKS', 'PROGRAM_CODE', 'PROJ_NO', 'PROJ_SUFFIX', 'NBI_TYPE_OF_IMP', 'DTL_TYPE_OF_IMP', 'SPECIAL_CODE', 'STEP_CODE', 'STATUS_WITH_10YR_RULE', 'SUFFICIENCY_ASTERC', 'SUFFICIENCY_RATING', 'STATUS_NO_10YR_RULE', 'CAT10', 'CAT23', 'CAT29'),
                           header= FALSE,  
                           fill = TRUE, #this fills in values that are missing
                           # n = 200, 
                           colClasses = c("character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character")))

temp$NBI_Year = 2010 #add a column that indicates inventory year
NBIAll <-  temp

#Loop to import data
######## I think I need to build the shell of NBIAll for this to work. ######
for (i in years){
  NBIAll <- filter(NBIAll, NBIAll$NBI_Year != i) #cleares out old data - what happenes if I change to !=  ???
  temp<- data.frame(read.fwf(file = paste("NBI", state, i, ".txt", sep = ""), 
                             widths = c(3,15,1,1,1,5,1,2,3,5,24,1,18,25,4,7,1,10,2,8,9,3,1,2,2,2,4,2,2,6,4,1,4,1,2,1,1,1,1,1,1,1,4,5,1,1,1,1,2,1,2,3,4,3,5,6,3,3,4,4,4,1,4,1,3,3,1,1,1,1,1,1,3,1,3,1,1,1,1,1,1,2,1,6,4,2,3,3,3,4,4,4,6,6,6,4,3,2,15,1,1,1,1,1,1,4,1,1,1,1,2,1,1,1,1,6,4,4,1,5,1,1,21,2,1,1,1,1,1,1,1,1,4,1,1,1,10), 
                             col.names = c('STATE_CODE_001', 'STRUCTURE_NUMBER_008', 'RECORD_TYPE_005A', 'ROUTE_PREFIX_005B', 'SERVICE_LEVEL_005C', 'ROUTE_NUMBER_005D', 'DIRECTION_005E', 'HIGHWAY_DISTRICT_002', 'COUNTY_CODE_003', 'PLACE_CODE_004', 'FEATURES_DESC_006A', 'CRITICAL_FACILITY_006B', 'FACILITY_CARRIED_007', 'LOCATION_009', 'MIN_VERT_CLR_010', 'KILOPOINT_011', 'BASE_HWY_NETWORK_012', 'LRS_INV_ROUTE_013A', 'SUBROUTE_NO_013B', 'LAT_016', 'LONG_017', 'DETOUR_KILOS_019', 'TOLL_020', 'MAINTENANCE_021', 'OWNER_022', 'FUNCTIONAL_CLASS_026', 'YEAR_BUILT_027', 'TRAFFIC_LANES_ON_028A', 'TRAFFIC_LANES_UND_028B', 'ADT_029', 'YEAR_ADT_030', 'DESIGN_LOAD_031', 'APPR_WIDTH_MT_032', 'MEDIAN_CODE_033', 'DEGREES_SKEW_034', 'STRUCTURE_FLARED_035', 'RAILINGS_036A', 'TRANSITIONS_036B', 'APPR_RAIL_036C', 'APPR_RAIL_END_036D', 'HISTORY_037', 'NAVIGATION_038', 'NAV_VERT_CLR_MT_039', 'NAV_HORR_CLR_MT_040', 'OPEN_CLOSED_POSTED_041', 'SERVICE_ON_042A', 'SERVICE_UND_042B', 'STRUCTURE_KIND_043A', 'STRUCTURE_TYPE_043B', 'APPR_KIND_044A', 'APPR_TYPE_044B', 'MAIN_UNIT_SPANS_045', 'APPR_SPANS_046', 'HORR_CLR_MT_047', 'MAX_SPAN_LEN_MT_048', 'STRUCTURE_LEN_MT_049', 'LEFT_CURB_MT_050A', 'RIGHT_CURB_MT_050B', 'ROADWAY_WIDTH_MT_051', 'DECK_WIDTH_MT_052', 'VERT_CLR_OVER_MT_053', 'VERT_CLR_UND_REF_054A', 'VERT_CLR_UND_054B', 'LAT_UND_REF_055A', 'LAT_UND_MT_055B', 'LEFT_LAT_UND_MT_056', 'DECK_COND_058', 'SUPERSTRUCTURE_COND_059', 'SUBSTRUCTURE_COND_060', 'CHANNEL_COND_061', 'CULVERT_COND_062', 'OPR_RATING_METH_063', 'OPERATING_RATING_064', 'INV_RATING_METH_065', 'INVENTORY_RATING_066', 'STRUCTURAL_EVAL_067', 'DECK_GEOMETRY_EVAL_068', 'UNDCLRENCE_EVAL_069', 'POSTING_EVAL_070', 'WATERWAY_EVAL_071', 'APPR_ROAD_EVAL_072', 'WORK_PROPOSED_075A', 'WORK_DONE_BY_075B', 'IMP_LEN_MT_076', 'DATE_OF_INSPECT_090', 'INSPECT_FREQ_MONTHS_091', 'FRACTURE_092A', 'UNDWATER_LOOK_SEE_092B', 'SPEC_INSPECT_092C', 'FRACTURE_LAST_DATE_093A', 'UNDWATER_LAST_DATE_093B', 'SPEC_LAST_DATE_093C', 'BRIDGE_IMP_COST_094', 'ROADWAY_IMP_COST_095', 'TOTAL_IMP_COST_096', 'YEAR_OF_IMP_097', 'OTHER_STATE_CODE_098A', 'OTHER_STATE_PCNT_098B', 'OTHR_STATE_STRUC_NO_099', 'STRAHNET_HIGHWAY_100', 'PARALLEL_STRUCTURE_101', 'TRAFFIC_DIRECTION_102', 'TEMP_STRUCTURE_103', 'HIGHWAY_SYSTEM_104', 'FEDERAL_LANDS_105', 'YEAR_RECONSTRUCTED_106', 'DECK_STRUCTURE_TYPE_107', 'SURFACE_TYPE_108A', 'MEMBRANE_TYPE_108B', 'DECK_PROTECTION_108C', 'PERCENT_ADT_TRUCK_109', 'NATIONAL_NETWORK_110', 'PIER_PROTECTION_111', 'BRIDGE_LEN_IND_112', 'SCOUR_CRITICAL_113', 'FUTURE_ADT_114', 'YEAR_OF_FUTURE_ADT_115', 'MIN_NAV_CLR_MT_116', 'FED_AGENCY', 'DATE_LAST_UPDATE', 'TYPE_LAST_UPDATE', 'DEDUCT_CODE', 'REMARKS', 'PROGRAM_CODE', 'PROJ_NO', 'PROJ_SUFFIX', 'NBI_TYPE_OF_IMP', 'DTL_TYPE_OF_IMP', 'SPECIAL_CODE', 'STEP_CODE', 'STATUS_WITH_10YR_RULE', 'SUFFICIENCY_ASTERC', 'SUFFICIENCY_RATING', 'STATUS_NO_10YR_RULE', 'CAT10', 'CAT23', 'CAT29'),
                             header= FALSE,  
                             fill = TRUE, #this fills in values that are missing
                            # n = 200, 
                            colClasses = c("character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character")))
  temp$NBI_Year = i #add a column that indicates inventory year
  print(i)
  print(Sys.time())
  NBIAll <- bind_rows(NBIAll, temp)
}

saveRDS(NBIAll, file = "nbiIL92_18.RDS")
  
#### Code for reseting the variables in NBIAll
rm(NBIAll)


NBI17 <- filter(NBIAll, NBIAll$NBI_Year == 2017)

##Get it down to just the columns we are interested in
IL <- select(NBI17, STATE_CODE_001, STRUCTURE_NUMBER_008, COUNTY_CODE_003,
             PLACE_CODE_004, FEATURES_DESC_006A, LAT_016, LONG_017,
             FUNCTIONAL_CLASS_026, YEAR_BUILT_027, TRAFFIC_LANES_ON_028A, ADT_029,
             YEAR_ADT_030,  APPR_WIDTH_MT_032, STRUCTURE_LEN_MT_049, DECK_WIDTH_MT_052, DECK_COND_058,
             SUPERSTRUCTURE_COND_059, SUBSTRUCTURE_COND_060, CHANNEL_COND_061, CULVERT_COND_062,
             DATE_OF_INSPECT_090, STRAHNET_HIGHWAY_100, HIGHWAY_SYSTEM_104)

## Make the fields with 'N's in them into numeric with NAs
IL <- mutate(IL, 
             Deck_58 =  as.numeric(ifelse(DECK_COND_058           == "N", "NA", DECK_COND_058 )),
             Super_59 = as.numeric(ifelse(SUPERSTRUCTURE_COND_059 == "N", "NA", SUPERSTRUCTURE_COND_059 )),
             Sub_60 =   as.numeric(ifelse(SUBSTRUCTURE_COND_060   == "N", "NA", SUBSTRUCTURE_COND_060 )),
             Culv_62 =  as.numeric(ifelse(CULVERT_COND_062        == "N", "NA", CULVERT_COND_062))
             )

NBIAll$approach_wdt <- as.numeric(NBIAll$APPR_WIDTH_MT_032)

## Calculate area and minimum condition value
IL <- mutate(IL, 
             area_m = ifelse(DECK_WIDTH_MT_052 > 0, STRUCTURE_LEN_MT_049 *DECK_WIDTH_MT_052, STRUCTURE_LEN_MT_049 *NBIAll$approach_wdt), 
             min_con = pmin(Deck_58,Super_59, Sub_60, Culv_62, na.rm = TRUE) 
)

##Flag MPO
IL$MPO <- ifelse(IL$COUNTY_CODE_003 %in% c('031', '31', '043', '43', '089', '89', '093', '93', '097', '97', '111', '197'), "CMAP", "Down State")

##Convert the Lat Long from Degree, Min, Sec to decimal degrees
IL$LAT <- as.numeric(conv_unit(paste(substr(IL$LAT_016, 0,2 ), " ", substr(IL$LAT_016, 3,4 ) , " ", substr(IL$LAT_016, 5, 6) , "." , substr(IL$LAT_016, 7, 8), " ", sep="" ), "deg_min_sec", "dec_deg"))
IL$Long <-as.numeric(conv_unit(paste("-",str_sub(IL$LONG_017, -11, -7), " ", substr(IL$LONG_017, 4,5 ) , " ", substr(IL$LONG_017, 6, 7) , "." , substr(IL$LONG_017, 8, 9), " ", sep="" ), "deg_min_sec", "dec_deg"))

##Assing to condition group
IL <- mutate(IL, Rating = ifelse(min_con<=4, "poor", ifelse(min_con>=7, "good", "fair"))
    )


##Summarise
county <- group_by(IL,  Rating, MPO, HIGHWAY_SYSTEM_104 ) %>%
  summarise( sqr_m = sum(area_m), cnt = n()) %>%
  spread( key = Rating, value = sqr_m)

NHScounty <- filter(IL, HIGHWAY_SYSTEM_104 == 1) %>%
  group_by(COUNTY_CODE_003, Rating) %>%
  summarise( sqr_m = sum(area_m), cnt = n()) %>%
  spread( key = Rating, value = sqr_m)


##map
CMAP_NHS <- filter(IL,  MPO == 'CMAP', HIGHWAY_SYSTEM_104 == 1)

ggplot(data = CMAP_NHS) +
  geom_point(mapping = aes(y= LAT, x = Long, color = Rating, size = ADT_029)) +
  coord_quickmap() +
  scale_colour_manual(values = c("orange", "green", "red"))

## Chart
ggplot(CMAP_NHS) +
  geom_bar(mapping = aes(x= COUNTY_CODE_003, fill = Rating) )

ggplot(CMAP_NHS) +
  geom_bar(mapping = aes(x= 2017,  fill = Rating), position = "fill") 


ggplot(CMAP_NHS) +
  geom_point(mapping = aes(x= YEAR_BUILT_027, y = ADT_029, color = CMAP_NHS$Rating)) +
  facet_wrap(~COUNTY_CODE_003, scales = "free")


ggplot(CMAP_NHS) +
  geom_bar(mapping = aes(x= YEAR_BUILT_027, fill = Rating) ) +
  facet_wrap(~COUNTY_CODE_003, scales = "free")


