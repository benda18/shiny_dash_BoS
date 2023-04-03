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
  titlePanel(title="NC Balance of State CoC HMIS Dashboard", 
             windowTitle="NCCEH NC BoS HIMS Dashboard"),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      sliderInput(inputId = "foo", 
                  label = "Number of Foos:", 
                  min = 0, max = 10, value = 4),
      checkboxGroupInput("checkGroup", 
                         label = h3("Checkbox group"), 
                         choices = list("Choice 1" = 1, 
                                        "Choice 2" = 2, 
                                        "Choice 3" = 3),
                         selected = NULL),
      hr(),
      fluidRow(column(3, verbatimTextOutput("value")))
      ), # /sidebarPanel
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  ) # /sidebar layout
)

# deploy_server----
db.server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
  # checkbox output: 
  # You can access the values of the widget (as a vector)
  # with input$checkGroup, e.g.
  output$value <- renderPrint({ input$checkGroup })
  
}

# deploy_shiny.app----
shinyApp(ui = db.ui, server = db.server)
