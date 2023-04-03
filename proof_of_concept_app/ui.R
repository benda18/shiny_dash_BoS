library(dplyr)
library(readr)
library(shiny)
library(data.table)
library(ggplot2)
library(tigris)
library(tidycensus)
library(glue)

fluidPage(titlePanel("Proof of Concept Shiny Dashboard - Tim Bender, NCCEH (April 2023)"),
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
