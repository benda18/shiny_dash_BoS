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
the.wd   <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash"
supp.wd  <- "C:/Users/TimBender/North Carolina Coalition to End Homelessness/PM Data Center - Documents/Reporting/Reporting  Custom/BoS Tableau Dashboard/Supplemental"
lb.wd    <- NA
csv.wd   <- NA

# setup----
setwd(the.wd)

# data download requirements (LookBack)----
# see ica.manual (var, above)

# data download requirements (main)----
# a. Name: User preference; not referenced by report.
# b. Description: User preference; not required or referenced by report. 
# c. Type: NCCEH_Custom_HUD_CSV_Payload
# d. Provider Type: Reporting Group
# e. Reporting Group: BoS CoC Dashboard Reporting Group (2283)
# f. Start Date: 10/01/2020
# g. End Date: Last day of most recently completed month (or user preference)

# load data----
data_scaffold    <- read.xlsx(NA)
geocode_co_cw    <- read.xlsx(NA)
co_reg_cw        <- read.xlsx(NA)
client           <- read_csv(NA)
enrollmentcoc    <- read_csv(NA)
enrollment       <- read_csv(NA)
projectcoc       <- read_csv(NA)
project          <- read_csv(NA)
inventory        <- read_csv(NA)
export           <- read_csv(NA)
LB_enrollmentcoc <- read_csv(NA)
LB_enrollment    <- read_csv(NA)
LB_projectcoc    <- read_csv(NA)
LB_project       <- read_csv(NA)

# tidy----

# analysis / modeling----

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
