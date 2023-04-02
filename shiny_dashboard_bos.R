library(dplyr)
library(shiny)
library(openxlsx)
library(readr)
library(glue)

rm(list=ls());cat('\f');gc()

# background----
current.dash <- "https://public.tableau.com/app/profile/nccehdatacenter/viz/NCBalanceofStateCoCHMISDashboard/BoS"
ica.manual   <- "https://ncceh.sharepoint.com/sites/boscoccoordination/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard%2FReport%20Guide%5FNCCEH%204%2E1%2E2%20%2D%20final%2Epdf&viewid=a0057c5d%2D63a9%2D4dd2%2D839c%2D60e509a88d59&parent=%2Fsites%2Fboscoccoordination%2FShared%20Documents%2F4%2D%20BoS%20Developing%20CoC%20System%2FFunding%20and%20Performance%20Subcommittee%2FBoS%20Dashboard"

# funs----

# vars----
wd_PROJ  <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash"
wd_supp  <- "C:/Users/TimBender/North Carolina Coalition to End Homelessness/PM Data Center - Documents/Reporting/Reporting  Custom/BoS Tableau Dashboard/Supplemental"
wd_lb    <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/lb_data"
wd_csv   <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/csv_data"

# setup----
setwd(wd_PROJ)

# Pull Data from MODULE_data----
devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/modules/MODULE_data.R?raw=TRUE")

# build shiny dash----
# TOP-LEVEL TABS
# .... System summary, 
# .... street outreach, 
# .... emergency shelter & transitional housing, 
# .... permanent housing projects
# .... homelessness prevention
# MAP LAYOUT FILTERS
# .... County
# GLOBAL DASHBOARD FILTERS
# .... start_date <--> end_date, 
# .... chronicity, 
# .... veteran_status, 
# .... count_level (individual vs. HoH)
# DEMOGRAPHIC FILTER
# .... overall, 
# .... race, 
# .... ethnicity, 
# .... gender
# TIMELINE CHART FILTERS
# ....(varies by previous filter settings)


# deploy----
