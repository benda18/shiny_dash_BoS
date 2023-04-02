# PLANNING_data_output

library(dplry)
library(ggplot2)
library(lubridate)
library(glue)
library(crayon)

rm(list=ls());cat('\f');gc()

# Resources----
"https://ncceh.sharepoint.com/sites/boscoccoordination/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard%2FReport%20Guide%5FNCCEH%204%2E1%2E2%20%2D%20final%2Epdf&viewid=a0057c5d%2D63a9%2D4dd2%2D839c%2D60e509a88d59&parent=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard"

# BUSINESS LOGIC----

# This section outlines and describes the transformation operations applied by
# Tableau Prep to the NCCEH Custom HUD CSV Export data to generate the extract
# files referenced by the final report. Each sub-section deals with a separate
# “branch” of the overall Tableau Prep Flow, with each branch broken into a
# series of “Flow Stages.” These stages are not individual steps but are
# functional abstractions the actual steps executed by the Flow.

# Ultimately, the Tableau Prep Flow outputs a table of enrollments where each
# enrollment record includes references to prior and future enrollments, a table
# of inventory records, and various dimension tables used for disaggregation and
# filtering in the report

# Report Main Branch Logic----

# The report main branch begins with the enrollment records from the Report
# export of the Custom HUD CSV and results in the Fact_Enrollment that is
# central to the report’s data model. Following this, the main branch intersects
# with other branches add categorical data to enrollment records that are
# necessary for calculated dimensions and filters as well as dashboard filters.
# Offset self-joins and an intersection with a pre-refined table from the
# Lookback CSV export adds relevant prior and future enrollment information to
# each enrollment row.

bl_main_branch <- data.frame(step_num   = 0:18, 
                             flow_stage = c(NA), 
                             flow_desc  = c(NA)) %>% 
  as_tibble()

# Lookback Branch Logic----

# The Lookback branch uses the Lookback export of the Custom HUD CSV for it’s
# input steps. It is filtered at multiple points through inner joins with other
# branches to limit the dataset to only those records that pertain to clients
# with enrollments in the Main branch and to avoid duplication of records that
# appear in both the Report and Lookback exports of the Custom HUD CSV. The
# Lookback Branch’s role in the report is to provide prior enrollment
# information for each client’s first enrollment in the Report export of the
# Custom HUD CSV, should a prior enrollment exist

bl_lookback_branch <- data.frame(step_num   = 0:11, 
                                 flow_stage = c(NA), 
                                 flow_desc  = c(NA)) %>% 
  as_tibble()
