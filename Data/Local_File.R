library(tidyverse)

filePath1 <- "~/R/NBI/Data/2016hwybronlyonefile.zip"
col_types <- paste0(rep('c',135),collapse='')
rawDF <- readr::read_csv(filePath1, col_types=col_types)

nbiIL <- rawDF %>% 
  filter(rawDF$STATE_CODE_001 == "17") %>%
  as.data.frame()

nbiIL <- subset(rawDF, STATE_CODE_001 == "17" )

class(rawDF)
class(nbiIL)

write.csv(nbiIL, "nbiIL.txt", row.names = FALSE, quote =FALSE, na = "" )


filePath1 <- "~/R/NBI/Data/nbiIL.zip"
col_types <- paste0(rep('c',135),collapse='')
rawDF2 <- readr::read_csv(filePath1, col_types=col_types)

?write.csv()

saveRDS(nbiIL, file = "nbiIL.rds")
saveRDS(nbiIL, file = "nbiIL.Rdata")

load(nbiIL.rds)

x<- anti_join(rawDF2, rawDF)


