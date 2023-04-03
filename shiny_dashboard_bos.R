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


# DEPLOY----

# general desired layout: 

gen.layout_2byN <- c("MAP", "FILTERS", 
                     "MAP", "TABLE", 
                     "title", "title", 
                     "FILTER", "FILTER", 
                     "CHART", "CHART") %>%
  matrix(., ncol = 2, byrow = T) %>%
  as.data.frame() %>%
  mutate(row_num = 1:length(V1)) %>%
  as.data.table() %>%
  melt(., 
       id.vars = c("row_num"), 
       variable.name = "col_num") %>% 
  as.data.frame() %>%
  mutate(., 
         col_num = as.numeric(gsub(pattern = "^V", "", col_num)))

gen.layout_2byN
gen.layout_ids <- data.frame(NA)

# deploy_ui----
db.ui <- fluidPage(
  titlePanel(title = "NC Balance of State CoC HMIS Dashboard"),
  # LAYOUT----
  # verticalLayout()
  # flowLayout()
  # splitLayout()
  navbarPage(title       = "SELECT PROGRAM:", 
             id          = "navbar01", 
             position    = "static-top", 
             collapsible = T, 
             fluid       = T, 
             windowTitle = NA,
             tabPanel("System Summary", 
                      icon = icon("globe"),
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#ss1 { float: left; background-color: #ddddff; }",
                                          "#ss2 { float: right; background-color: #ccffcc; }"),
                               div(id = "ss1", class = "half-fill", "Map: County by Region"),
                               div(id = "ss2", class = "half-fill", "Global Dashboard Filters"),
                               padding = 0)
                      ), 
             tabPanel("Street Outreach", 
                      icon = icon("handshake-angle"),
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#so1 { float: left; background-color: #ddddff; }",
                                          "#so2 { float: right; background-color: #ccffcc; }"),
                               div(id = "so1", class = "half-fill", "Map: County by Region"),
                               div(id = "so2", class = "half-fill", "Global Dashboard Filters"),
                               padding = 0)
                      ), 
             tabPanel("Emergency Shelter & Transitional Housing", 
                      icon = icon("people-roof"),
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#esth1 { float: left; background-color: #ddddff; }",
                                          "#esth2 { float: right; background-color: #ccffcc; }"),
                               div(id = "esth1", class = "half-fill", "Map: County by Region"),
                               div(id = "esth2", class = "half-fill", "Global Dashboard Filters"),
                               padding = 0)
                      ), 
             tabPanel("Permanent Housing Projects", 
                      icon = icon("house-user"), 
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#php1 { float: left; background-color: #ddddff; }",
                                          "#php2 { float: right; background-color: #ff0000; }"),
                               div(id = "php1", class = "half-fill", "Map: County by Region"),
                               div(id = "php2", class = "half-fill", "Global Dashboard Filters"),
                               padding = 0),
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#php3 { float: left; background-color: #ddddff; }",
                                          "#php4 { float: right; background-color: #ff0000; }"),
                               div(id = "php3", class = "half-fill", "Table"),
                               div(id = "php4", class = "half-fill", "Chart"),
                               padding = 0)
                      ),
             tabPanel("Homelessness Prevention", 
                      icon = icon("p"), 
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#hp1 { float: left; background-color: #ddddff; }",
                                          "#hp2 { float: right; background-color: #ff0000; }"),
                               div(id = "hp1", class = "half-fill", "Map: County by Region"),
                               div(id = "hp2", class = "half-fill", "Global Dashboard Filters"),
                               padding = 0),
                      fillPage(tags$style(type = "text/css",
                                          ".half-fill { width: 50%; height: 100%; }",
                                          "#hp3 { float: left; background-color: #ddddff; }",
                                          "#hp4 { float: right; background-color: #ff0000; }"),
                               div(id = "hp3", class = "half-fill", "Table"),
                               div(id = "hp4", class = "half-fill", "Chart"),
                               padding = 0)
             )))

# deploy_server----
db.server <- function(input, output) {
  
}

# deploy_shiny.app----
shinyApp(ui = db.ui, server = db.server)

