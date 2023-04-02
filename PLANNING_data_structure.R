# PLANNING_data_output

library(dplry)
library(ggplot2)
library(lubridate)
library(glue)
library(crayon)
library(readr)

rm(list=ls());cat('\f');gc()

# Resources----
#"https://ncceh.sharepoint.com/sites/boscoccoordination/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard%2FReport%20Guide%5FNCCEH%204%2E1%2E2%20%2D%20final%2Epdf&viewid=a0057c5d%2D63a9%2D4dd2%2D839c%2D60e509a88d59&parent=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard"

# MASTER DATA STRUCTURE----

(tab_sys.summary <- list(TAB_name                = "System Summary",
                         FILTERall.BoS_region       = NA, 
                         FILTERall.County           = NA, 
                         FILTERall.start_date       = NA, 
                         FILTERall.end_date         = NA, 
                         FILTERall.chronicity       = c("chronic", "not_chronic", "missing"), 
                         FILTERall.vet_status       = c("veteran", "non-veteran", "missing"), 
                         FILTERall.count_level      = c("Individuals", "Heads_of_Household"), 
                         FILTERall.demographic_view = c("Overall", "Race", "Ethnicity", "Gender"), 
                         TABLE.columns              = c("Active Homeless", "Inflow", "Outflow", 
                                                        "PH Exits", "Move-Ins"), 
                         TABLE.rows                 = c("unique values from FILTER.demographic_view"), 
                         FILTERchart.flow_measure   = c("Active Homeless", "System Inflow/Outflow"),
                         FILTERchart.select_breakout = c("Household Type", "Age Group", "Chronicity", "Veteran Status"),
                         CHART.x_axis               = c("date"), 
                         CHART.y_axis               = c("see FILTERchart.flow_measure"), 
                         CHART.type                 = c("Area")) )

tab_so          <- data.frame(tab_name = "Street Outreach") %>% 
  as_tibble()

tab_es.th       <- data.frame(tab_name = "Emergency Shelter & Transitional Housing") %>% 
  as_tibble()

tab_php         <- data.frame(tab_name = "Permanent Housing Projects") %>% 
  as_tibble()

tab_hp          <- data.frame(tab_name = "Homelessness Prevention") %>% 
  as_tibble()


