# MvP

library(dplyr)
library(readr)
library(shiny)

rm(list=ls());cat('\f');gc()

# vars----
wd_PROJ  <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash"
wd_supp  <- "C:/Users/TimBender/North Carolina Coalition to End Homelessness/PM Data Center - Documents/Reporting/Reporting  Custom/BoS Tableau Dashboard/Supplemental"
wd_lb    <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/lb_data"
wd_csv   <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/csv_data"

# setup----
setwd(wd_PROJ)

# VARS----
vars <- setdiff(names(iris), "Species") # same as c(names(iris)) except it removes "Species" (the last column)

# LOAD DATA----

# Pull Data from MODULE_data
if(!"test.data" %in% ls()){ # save time by not re-running this process if it's already loaded in memory
  pre.ls <- ls()
  devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/modules/MODULE_data.R?raw=TRUE")
  # vars management
  pulled.ls <- ls()
  diff.ls   <- pulled.ls[!pulled.ls %in% pre.ls]
  keep.ls   <- c("test.data")
  drop.ls   <- diff.ls[!diff.ls %in% keep.ls]
  # remove drop.ls
  rm(list = drop.ls)
  # gc
  gc()
}


# Pull Data from MODULE_mapping
devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/modules/MODULE_mapping.R?raw=TRUE")


# SHINY APP---
# Goals----
sa.goals <- list(step_1 = c("hello world example"), 
                 step_2 = c("ggplot basemap", 
                            "show a table", 
                            "not interactive", 
                            "not filterable"), 
                 step_3 = c("table filters"), 
                 step_4 = c("map-county selection"), 
                 step_5 = c("sliders and other inputs things"),
                 step_N = c("formatting map theme", 
                            "formatting "))
sa.goals

# myMVP---
# ui----
ui <- pageWithSidebar(headerPanel  = headerPanel(title = "NC Balance of State CoC HMIS Dashboard"), 
                      sidebarPanel = sidebarPanel(), 
                      mainPanel    = mainPanel())

# server----
server <- function(input,  output, session) {
  
}

# app----
shinyApp(ui = ui, server = server)



# OLDER----
stop("older code; do not run")
# Components----
# ui-----
ui2 <- pageWithSidebar(
  # header
  headerPanel  = headerPanel(title = "<dashboard title>"),
  # sidebar panel
  sidebarPanel = sidebarPanel(
    # selectors
    selectInput(inputId  = 'xcol',
                label    = 'X Variable',
                choices  = vars),
    selectInput(inputId  = 'ycol',
                label    = 'Y Variable',
                choices  = vars,
                selected = vars[[2]]),
    numericInput(inputId = 'clusters',
                 label   = 'Cluster count',
                 value   = 3,
                 min     = 1,
                 max     = 9)
  ),
  # main panel
  mainPanel    = mainPanel(plotOutput(outputId = 'plot1')))# plotOutput is part of the shiny interactive plot


# server----
server2 <- function(input,  # input data (i.e. iris)
                   output, # output features (i.e. plot)
                   session) {

  # Building the Dataset----

  # filter down base data (IRIS) based on inputs (xcol, ycol)
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })

  # perform kmeans() function on selectedData to return clusters
  clusters <- reactive({
    kmeans(x       = selectedData(),
           centers = input$clusters)
  })

  # build plot----
  output$plot1 <- shiny::renderPlot(expr = {  # note how 'plot1' is same as outputId in UI
    # set color palette for clusters, up to maximum number of clusters (9)
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

    # par sets or queries graphical parameters
    par(mar = c(5.1, 4.1, 0, 1)) # mar sets margins for plot
    # plot... plots
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    # points addes points
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })

}

# app----
#shiny::shinyApp(ui = ui, server = server)
