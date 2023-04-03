# MvP

library(dplyr)
library(readr)
library(shiny)
library(data.table)

rm(list=ls()[!ls() %in% "test.data"]);cat('\f');gc()
# Funs----
hud_age_category <- function(age_yrs, 
                             breaks_upper = c(17,24,34,44,54,64,126)){
  require(dplyr)
  require(data.table)
  
  if(is.na(age_yrs) | age_yrs > max(breaks_upper)){
    out <- NA
  }else{
    bac <- data.frame(lower = 0, upper = breaks_upper[1])
    for(i in 2:length(breaks_upper)){
      bac <- rbind(bac, 
                   data.frame(lower = breaks_upper[i-1]+1, 
                              upper = breaks_upper[i]))
    }
    bac <- mutate(bac, name = paste(lower, upper, sep = "-"))
    bac$in_cat <- between(x = rep(age_yrs, nrow(bac)), 
                          lower = bac$lower, upper = bac$upper)
    out <- bac[bac$in_cat,]$name
  }
  return(out)
}

# vars----
wd_PROJ  <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash"
wd_supp  <- "C:/Users/TimBender/North Carolina Coalition to End Homelessness/PM Data Center - Documents/Reporting/Reporting  Custom/BoS Tableau Dashboard/Supplemental"
wd_lb    <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/lb_data"
wd_csv   <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/csv_data"

# setup----
setwd(wd_PROJ)

# VARS----

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

# pretend dataset

gen_fakeid <- function(gen_n = 1){
  require(dplyr)
  out <- replicate(n = gen_n, 
                   paste(c(sample(LETTERS,1), 
                           sample(1:9, size = 1),
                           sample(0:9, size = 8, replace = T)), 
                         sep = "", collapse = ""))
  return(out)
}

set.seed(as.numeric(ymd(20230403)))
pretend.df <- data.frame(pid = gen_fakeid(gen_n = 1000), 
                         age = sample(12:48, 
                                      size = 1000, 
                                      replace = T), 
                         hud_age_cat = NA,
                         race = sample(test.data$calc_race, 
                                       size = 1000, replace = T),
                         gender = sample(test.data$calc_gender, 
                                         size = 1000, replace = T),
                         County = sample(bos_counties$NAME, 
                                         size = 1000, 
                                         replace = T)) %>%
  as_tibble() %>%
  left_join(., 
            bos_cos_regions)

pretend.df$hud_age_cat <- unlist(lapply(X = pretend.df$age, 
                                        FUN = hud_age_category))

pretend.df <- pretend.df %>%
  group_by(Region, hud_age_cat) %>%
  summarise(n_pid = n_distinct(pid)) 

pretend.df <- pretend.df %>%
  as.data.table() %>%
  dcast(., 
        Region ~ hud_age_cat, fill = 0) %>%
  .[order(c(1, 10:13, 2:9)),] %>%
  as.data.frame() %>%
  as_tibble()

# SHINY APP---
# Goals----
sa.goals <- list(done_1 = c("hello world example"), 
                 done_2 = c("ggplot basemap", 
                            "show a table", 
                            "not interactive", 
                            "not filterable"), 
                 step_3 = c("example slider - region; not working"), 
                 step_4 = c("deploy to web server"),
                 step_5 = c("link slider region to table", 
                            "link slider region to map"), 
                 step_6 = c("slider-region functions"),
                 step_7 = c("nav bar"),
                 step_8 = c("replace test.data with real_data"),
                 step_9 = c("make entire dash functional"),
                 step_N = c("formatting", "aesthetics"), 
                 step_N+1 = c("full deployment"))
sa.goals

# myMVP---
# ui----
ui <- fluidPage(titlePanel("NC Balance of State CoC HMIS Dashboard"), 
                # Select Regions by checkbox----
                checkboxGroupInput("checkGroup", label = h3("Select by Region"), 
                                   choices = list("Region 1" = 1, 
                                                  "Region 2" = 2, 
                                                  "Region 3" = 3, 
                                                  "Region 4" = 4, 
                                                  "Region 5" = 5, 
                                                  "Region 6" = 6, 
                                                  "Region 7" = 7, 
                                                  "Region 8" = 8, 
                                                  "Region 9" = 9, 
                                                  "Region 10" = 10, 
                                                  "Region 11" = 11, 
                                                  "Region 12" = 12, 
                                                  "Region 13" = 13),
                                   selected = c(1:13)),
                hr(),
                fluidRow(column(3, verbatimTextOutput("value01"))),
                # sidebar----
                sidebarLayout(sidebarPanel(
                  # Select [something] by sliderInput
                  sliderInput(inputId = "someID", 
                              label   = "some_label", 
                              min     = 0, 
                              max     = 2, 
                              value   = 1 )), 
                  mainPanel(plotOutput(outputId = "basemap01"), 
                            tableOutput(outputId = "table01"))))

# server----
server <- function(input,  output, session) {
  output$basemap01 <- renderPlot({
    basemap
  })
  output$table01 <- renderTable({
    pretend.df
  })
  # You can access the values of the widget (as a vector)
  # with input$checkGroup, e.g.
  output$value01 <- renderPrint({ input$checkGroup })
}

# app----
shinyApp(ui = ui, server = server)



# OLDER----
stop("older code; do not run")
# Components----
# Vars
vars1 <- setdiff(names(iris), "Species") # same as c(names(iris)) except it removes "Species" (the last column)

# ui-----
ui2 <- pageWithSidebar(
  # header
  headerPanel  = headerPanel(title = "<dashboard title>"),
  # sidebar panel
  sidebarPanel = sidebarPanel(
    # selectors
    selectInput(inputId  = 'xcol',
                label    = 'X Variable',
                choices  = vars1),
    selectInput(inputId  = 'ycol',
                label    = 'Y Variable',
                choices  = vars1,
                selected = vars1[[2]]),
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
