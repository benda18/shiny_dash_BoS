# PLANNING_data_output

library(dplyr)
library(ggplot2)
library(lubridate)
library(glue)
library(crayon)
library(readr)
library(ggplot2)
library(data.table)

rm(list=ls());cat('\f');gc()

# Resources----
#"https://ncceh.sharepoint.com/sites/boscoccoordination/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard%2FReport%20Guide%5FNCCEH%204%2E1%2E2%20%2D%20final%2Epdf&viewid=a0057c5d%2D63a9%2D4dd2%2D839c%2D60e509a88d59&parent=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard"

# MASTER DATA STRUCTURE----

# Data Structure: System Summary----
tab_sys.summary <- list(TAB_name                   = "System Summary",
                        FILTERall.BoS_region       = c("all 13 unique regions"), 
                        FILTERall.County           = c("all unique BoS counties"), 
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
                        CHART.type                 = c("Area")) 

# Data Structure: Street Outreach----
tab_so          <- list(TAB_name = "Street Outreach") 

# Data Structure: Emergency Shelter & Transitional Housing----
tab_es.th       <- list(TAB_name = "Emergency Shelter & Transitional Housing") 

# Data Structure: Permanent Housing Projects----
tab_php         <- list(TAB_name = "Permanent Housing Projects") 

tab_hp          <- list(TAB_name = "Homelessness Prevention") 


# EXAMPLE AREA CHART----
data(lakers, package = "lubridate")
lakers$date <- ymd(lakers$date)

ex.chart_area <- lakers %>%
  group_by(date, opponent,
           game_type, 
           team_LAL = team == "LAL") %>%
  summarise(t_points = sum(points)) %>%
  ungroup() %>%
  mutate(., 
         team_LAL = ifelse(team_LAL, "LAL", "opp")) 

ggplot() + 
  geom_area(data = ex.chart_area, 
            #position = "fill",
            aes(x = date, y = t_points, 
                fill = team_LAL))+
  labs(title = "LA Lakers Games Scores", 
       subtitle = "Purpose: To Show how an Area Chart is Built")
