convert2016 <- function(filePath=NULL) {

  # Import the file ----
# filePath <-  "~/R/NBI/Data/nbiIL.RDS"
  rawDF <- readRDS(filePath)

#Build NBI file ----
  nbi <- rawDF %>%
    select(STATE_CODE_001, COUNTY_CODE_003, LAT_016, LONG_017, WATERWAY_EVAL_071, ## Location
           STRUCTURE_LEN_MT_049, DECK_WIDTH_MT_052,  ##Size
           DECK_COND_058, SUPERSTRUCTURE_COND_059, SUBSTRUCTURE_COND_060, ## Condition
           OWNER_022, FUNCTIONAL_CLASS_026, YEAR_BUILT_027, ADT_029, SUFFICIENCY_RATING) %>%
    mutate(state_code = as.integer(STATE_CODE_001) ) %>% ##Format for Join
    left_join(maps::state.fips, by = c("state_code" = "fips")) %>% ## Join in the State
    mutate(county_code = as.integer(paste(state_code, COUNTY_CODE_003, sep = ""))) %>%  ##Format for Join
    left_join(maps::county.fips, by = c("county_code" = "fips")) %>% ## Join in the County 
    mutate(water = ifelse(WATERWAY_EVAL_071 == "N", 0, 1)) %>%
    mutate(yearBuilt = as.numeric(YEAR_BUILT_027))
  
#Latitude----  
  deg <- as.numeric(stringr::str_sub(nbi$LAT_016, 1, 2))
  min <- as.numeric(stringr::str_sub(nbi$LAT_016, 3, 4))
  sec <- as.numeric(stringr::str_sub(nbi$LAT_016, 5, 8))/100
  nbi$latitude <- deg + min/60 + sec/3600
  
#Longitude----
  deg <- as.numeric(stringr::str_sub(nbi$LONG_017, 1, 3))
  min <- as.numeric(stringr::str_sub(nbi$LONG_017, 4, 5))
  sec <- as.numeric(stringr::str_sub(nbi$LONG_017, 6, 9))/100
  
  nbi$longitude <- -1 * (deg + min/60 + sec/3600)

  return(nbi)
  
  }