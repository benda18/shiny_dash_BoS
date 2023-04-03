library(dplyr)
library(readr)
library(shiny)
library(data.table)
library(ggplot2)

function(input, output) {
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
