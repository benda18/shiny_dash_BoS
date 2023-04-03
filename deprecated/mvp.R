# MvP

library(dplyr)
library(readr)
library(shiny)
library(data.table)

rm(list=ls()[!ls() %in% "test.data"]);cat('\f');gc()
# Funs----

# hud_age_category <- function(age_yrs, 
#                              breaks_upper = c(17,24,34,44,54,64,126)){
#   require(dplyr)
#   require(data.table)
#   
#   if(is.na(age_yrs) | age_yrs > max(breaks_upper)){
#     out <- NA
#   }else{
#     bac <- data.frame(lower = 0, upper = breaks_upper[1])
#     for(i in 2:length(breaks_upper)){
#       bac <- rbind(bac, 
#                    data.frame(lower = breaks_upper[i-1]+1, 
#                               upper = breaks_upper[i]))
#     }
#     bac <- mutate(bac, name = paste(lower, upper, sep = "-"))
#     bac$in_cat <- between(x = rep(age_yrs, nrow(bac)), 
#                           lower = bac$lower, upper = bac$upper)
#     out <- bac[bac$in_cat,]$name
#   }
#   return(out)
# }

# vars----
wd_PROJ  <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash"
wd_supp  <- "C:/Users/TimBender/North Carolina Coalition to End Homelessness/PM Data Center - Documents/Reporting/Reporting  Custom/BoS Tableau Dashboard/Supplemental"
wd_lb    <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/lb_data"
wd_csv   <- "C:/Users/TimBender/Documents/R/ncceh/projects/shiny_dash/csv_data"

# setup----
setwd(wd_PROJ)

# VARS----

# LOAD DATA----

# # Pull Data from MODULE_data
# if(!"test.data" %in% ls()){ # save time by not re-running this process if it's already loaded in memory
#   pre.ls <- ls()
#   devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/modules/MODULE_data.R?raw=TRUE")
#   # vars management
#   pulled.ls <- ls()
#   diff.ls   <- pulled.ls[!pulled.ls %in% pre.ls]
#   keep.ls   <- c("test.data")
#   drop.ls   <- diff.ls[!diff.ls %in% keep.ls]
#   # remove drop.ls
#   rm(list = drop.ls)
#   # gc
#   gc()
# }

# pretend dataset

# gen_fakeid <- function(gen_n = 1){
#   require(dplyr)
#   out <- replicate(n = gen_n, 
#                    paste(c(sample(LETTERS,1), 
#                            sample(1:9, size = 1),
#                            sample(0:9, size = 8, replace = T)), 
#                          sep = "", collapse = ""))
#   return(out)
# }
# 
# set.seed(as.numeric(ymd(20230403)))
# pretend.df <- data.frame(pid = gen_fakeid(gen_n = 1000), 
#                          age = sample(12:48, 
#                                       size = 1000, 
#                                       replace = T), 
#                          hud_age_cat = NA,
#                          race = sample(test.data$calc_race, 
#                                        size = 1000, replace = T),
#                          gender = sample(test.data$calc_gender, 
#                                          size = 1000, replace = T),
#                          County = sample(bos_counties$NAME, 
#                                          size = 1000, 
#                                          replace = T)) %>%
#   as_tibble() %>%
#   left_join(., 
#             bos_cos_regions)
# 
# pretend.df$hud_age_cat <- unlist(lapply(X = pretend.df$age, 
#                                         FUN = hud_age_category))
# 
# pretend.df <- pretend.df %>%
#   group_by(Region, hud_age_cat) %>%
#   summarise(n_pid = n_distinct(pid)) 
# 
# pretend.df <- pretend.df %>%
#   as.data.table() %>%
#   dcast(., 
#         Region ~ hud_age_cat, fill = 0) %>%
#   .[order(c(1, 10:13, 2:9)),] %>%
#   as.data.frame() %>%
#   as_tibble()



# SHINY APP---
# # Goals----
# sa.goals <- list(done_1 = c("hello world example"), 
#                  done_2 = c("ggplot basemap", 
#                             "show a table", 
#                             "not interactive", 
#                             "not filterable"), 
#                  done_3 = c("example checkbox - region"), 
#                  done_4 = c("link slider region to table", 
#                             "link slider region to map"),
#                  done_5 = c("slider-region functions"),
#                  step_6 = c("deploy to web server"),
#                  step_7 = c("nav bar"),
#                  step_8 = c("replace test.data with real_data"),
#                  step_9 = c("make entire dash functional"),
#                  step_N = c("formatting", "aesthetics"), 
#                  `step_N+1` = c("full deployment"))

# myMVP---
# ui----




ui <- fluidPage(titlePanel("NC Balance of State CoC HMIS Dashboard"),
                div(h4("Proof of Concept Shiny Dashboard Demonstrating the following:"),
                    ("* Ability to add [dummy] data table(s) to dashboard"),
                    br("* Ability to add map(s) to dashboard"), 
                    ("* Ability to interact with table(s) and map(s) through user inputs (checkbox)"), 
                    br("* Hosted web deployment"),
                    h4("Still needs to demonstrate the Following:"), 
                    ("* tidy and clean data to meet dashboard's full needs"), 
                    br("* implement date range slider as an interactive filter"), 
                    ("* Aesthetic improvements (colors, sizes, locations, layouts, etc)"), 
                    br("* Demonstrate working proof of complex multi-filter dashboard interactions (i.e. Race + Date + Region)"), 
                    ("* all items/issues in smartsheet can be addressed")),
                # sidebar----
                sidebarLayout(sidebarPanel(
                  # Select Regions by checkbox----
                  checkboxGroupInput(inputId = "checkGroup01", 
                                     label = h3("Select by Region"), # h3 is a markup / html tag for heading
                                     choices = list("Region 1" = "Region 1", 
                                                    "Region 2" = "Region 2", 
                                                    "Region 3" = "Region 3", 
                                                    "Region 4" = "Region 4", 
                                                    "Region 5" = "Region 5", 
                                                    "Region 6" = "Region 6", 
                                                    "Region 7" = "Region 7", 
                                                    "Region 8" = "Region 8", 
                                                    "Region 9" = "Region 9", 
                                                    "Region 10" = "Region 10", 
                                                    "Region 11" = "Region 11", 
                                                    "Region 12" = "Region 12", 
                                                    "Region 13" = "Region 13"),
                                     selected = paste("Region", 1:13, sep = " ")),
                  #hr(),  # this is an html tag <hr> for creating a thematic break in a page
                  # fluidRow(column(3, verbatimTextOutput("value01"))), # prints the results of the checkboxes
                ), 
                mainPanel(plotOutput(outputId = "basemap01"), 
                          tableOutput(outputId = "table01"))))

# server----
server <- function(input,  output, session) {
  # load data
  pretend.df <- read_csv("https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/proof_of_concept_app/summary_agegroups_by_region.csv")
  devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/shiny_dash_BoS/main/modules/MODULE_mapping.R?raw=TRUE")
  
  # other stuff
  output$basemap01 <- renderPlot({
    basemap+
      geom_sf(data = bos_regions[bos_regions$Region %in% input$checkGroup01,], # filter regions here 
              color = "white",
              aes(fill = Region_f))+
      geom_sf(data = nc_bound, 
              color = "grey", 
              fill = NA) +
      geom_sf(data = bos_counties[bos_counties$Region %in% input$checkGroup01,],  # filter regions here
              fill = NA, color = "black") +
      coord_sf(xlim = range(bbox.nc[c("xmin", "xmax")]), 
               ylim = range(bbox.nc[c("ymin", "ymax")]))+
      scale_fill_discrete(name = "BoS Region")
  })
  output$table01 <- renderTable({
    pretend.df[pretend.df$Region %in% input$checkGroup01,]
  })
  # You can access the values of the widget (as a vector)
  # with input$checkGroup01, e.g.
  output$value01 <- renderPrint({ 
    input$checkGroup01 
  })
}

# app----
shinyApp(ui = ui, server = server)

