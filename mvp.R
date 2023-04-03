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
pre.ls()


# UI-----
ui <- pageWithSidebar(
  # header----
  headerPanel  = headerPanel(title = 'Iris k-means clustering'),
  # sidebar panel----
  sidebarPanel = sidebarPanel(selectInput(inputId  = 'xcol', 
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
                                           max     = 9)),
  # main panel----
  mainPanel    = mainPanel(plotOutput('plot1')))


# SERVER----
server <- function(input, # input data (i.e. iris)
                   output, # output features (i.e. plot)
                   session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    # par sets or queries graphical parameters
    par(mar = c(5.1, 4.1, 0, 1))
    # plot... plots
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    # points addes points
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
}

# APP----

shiny::shinyApp(ui = ui, server = server)
