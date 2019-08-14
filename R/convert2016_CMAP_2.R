convert2016 <- function(filePath=NULL) {

  # Import the file ----
# filePath <-  "~/R/NBI/Data/nbiIL.RDS"
# filePath <-  "~/R/NBI/Data/nbiIL18.RDS"
# filePath <-  "~/R/NBI/Data/Raw/nbiIL92_18.RDS"
  rawDF <- readRDS(filePath)

  library(readr)
  Owner_code <- read_csv("~/R/NBI/Data/Owner_code.csv")

  condition_levels <- factor( levels = c("Good", "Fair", "Poor"), ordered = TRUE)
  condition_levels
  
#Build NBI file ----
  nbi <- rawDF %>%
    filter(RECORD_TYPE_005A =="1") %>%
    select(STATE_CODE_001, COUNTY_CODE_003, LAT_016, LONG_017, WATERWAY_EVAL_071, HIGHWAY_SYSTEM_104, ## Location
           APPR_WIDTH_MT_032, STRUCTURE_LEN_MT_049, DECK_WIDTH_MT_052,   ##Size
           DECK_COND_058, SUPERSTRUCTURE_COND_059, SUBSTRUCTURE_COND_060, CULVERT_COND_062,  ## Condition
           OWNER_022, FUNCTIONAL_CLASS_026, YEAR_BUILT_027, ADT_029, SUFFICIENCY_RATING, CAT10, NBI_Year) %>%
    mutate(state_code = as.integer(STATE_CODE_001) ) %>% ##Format for Join
    left_join(maps::state.fips, by = c("state_code" = "fips")) %>% ## Join in the State
    mutate(county_code = as.integer(paste(state_code, COUNTY_CODE_003, sep = ""))) %>%  ##Format for Join
    left_join(maps::county.fips, by = c("county_code" = "fips")) %>% ## Join in the County 
    mutate(water = ifelse(WATERWAY_EVAL_071 == "N", 0, 1)) %>%
    mutate(yearBuilt = as.numeric(YEAR_BUILT_027)) %>%
    mutate(age = 2019 - yearBuilt) %>%
    left_join(Owner_code, by = c("OWNER_022" = "Code")) %>%
    mutate(CAT10 = fct_recode(CAT10, "Good" = "G","Fair" = "F","Poor" = "P")) %>%
    mutate(    DECK_COND_058 =  as.numeric(ifelse(DECK_COND_058           == "N", "NA", DECK_COND_058 )),
               SUPERSTRUCTURE_COND_059 = as.numeric(ifelse(SUPERSTRUCTURE_COND_059 == "N", "NA", SUPERSTRUCTURE_COND_059 )),
               SUBSTRUCTURE_COND_060 =   as.numeric(ifelse(SUBSTRUCTURE_COND_060   == "N", "NA", SUBSTRUCTURE_COND_060 )),
               CULVERT_COND_062 =  as.numeric(ifelse(CULVERT_COND_062        == "N", "NA", CULVERT_COND_062)),
               APPR_WIDTH_MT_032 = as.numeric(APPR_WIDTH_MT_032),
               STRUCTURE_LEN_MT_049 = as.numeric(STRUCTURE_LEN_MT_049),
               DECK_WIDTH_MT_052 = as.numeric(DECK_WIDTH_MT_052), 
               ADT_029 = as.numeric(ADT_029)
               ) %>%
    mutate(    area_m = ifelse(DECK_WIDTH_MT_052 > 0, STRUCTURE_LEN_MT_049 *DECK_WIDTH_MT_052, STRUCTURE_LEN_MT_049 *APPR_WIDTH_MT_032), 
               min_con = pmin(DECK_COND_058,SUPERSTRUCTURE_COND_059, SUBSTRUCTURE_COND_060, CULVERT_COND_062, na.rm = TRUE), 
               Rating = ifelse(min_con<=4, "Poor", ifelse(min_con>=7, "Good", "Fair")))
  
  
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
  
  nbi <- nbi %>%
    filter(longitude > -92) %>%
    filter(latitude > 36) %>%
    filter(latitude < 50)
  
  nbi_trend <- nbi
  #nbi <- nbi %>% filter(NBI_Year == max(nbi$NBI_Year))
  
  #return(nbi)
  return(nbi_trend)
  
  }