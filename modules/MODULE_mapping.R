# MODULE_mapping

library(ggplot2)
library(tigris)
library(tidycensus)
library(dplyr)
library(glue)
library(readr)

# Vars----
var_year <- 2021

# Get Data----
nc_bound <- tigris::states(cb = T, year = var_year) %>%
  .[.$NAME == "North Carolina",]
adjacent_states <- tigris::states(cb = T, year = var_year) %>%
  .[.$STUSPS %in% c("VA", "WV", "TN", "SC", 
                    "GA", "KY", "AL", "DE", 
                    "MD"),]

nc_counties     <- tigris::counties(state = "NC", cb = T, year = var_year)
bos_cos_regions <- read_csv("https://raw.githubusercontent.com/timbender-ncceh/PIT_HIC/main/crosswalks/county_district_region_crosswalk.csv") %>%
  .[,c("Coc/Region", "County")] 
colnames(bos_cos_regions)[!colnames(bos_cos_regions) %in% "County"] <- "Region"
bos_cos_regions$Region <- bos_cos_regions$Region %>%
  gsub("^BoS ", "", .)


# Tidy----
nc_counties <- left_join(nc_counties, 
                         bos_cos_regions, 
                         by = c("NAME" = "County"))

bos_regions <- nc_counties[!is.na(nc_counties$Region),] %>%
  .[!.$Region %in% c("Durham CoC", "Orange CoC"),] %>%
  group_by(Region) %>%
  summarise()

bos_regions$Region_f <- factor(bos_regions$Region, 
                               levels = paste("Region", 1:13, sep = " "))

bos_counties <- nc_counties[!is.na(nc_counties$Region),] %>%
  .[!.$Region %in% c("Durham CoC", "Orange CoC"),]

# set limits of basemap to bbox extent of NC
# manual adjustments to bbox
x.adj <- 0.3
y.adj <- 0.9

# get bbox 
bbox.nc <- nc_counties %>%
  sf::st_geometry()
bbox.nc <- attributes(bbox.nc)$bbox

# adjust bbox lims
bbox.nc["xmin"] <- bbox.nc["xmin"] - x.adj * 0.1
bbox.nc["xmax"] <- bbox.nc["xmax"] + x.adj
bbox.nc["ymin"] <- bbox.nc["ymin"] - y.adj * 0.1
bbox.nc["ymax"] <- bbox.nc["ymax"] + y.adj 

# Build Basemap----
basemap <- ggplot() + 
  theme_void()+
  theme(panel.border = element_rect(color = "black", fill = NA), 
        panel.background = element_rect(fill = "#e0fffe"),
        panel.ontop = F)+
  # theme(axis.text = element_blank(), 
  #       axis.ticks = element_blank())+
  geom_sf(data = adjacent_states, 
          fill = "white", 
          color = "grey")+
  geom_sf(data = nc_bound,
          color = "grey",
          fill = "white") +
  geom_sf(data = bos_regions, 
          color = "white",
          aes(fill = Region_f))+
  geom_sf(data = nc_bound, 
          color = "grey", 
          fill = NA) +
  geom_sf(data = bos_counties, 
          fill = NA, color = "black") +
  coord_sf(xlim = range(bbox.nc[c("xmin", "xmax")]), 
           ylim = range(bbox.nc[c("ymin", "ymax")]))+
  scale_fill_discrete(name = "BoS Region")

# basemap

# # OLDER----
# # Set Variables----
# var_state        <- "North Carolina"  
# demographic.info <- "population"      # you can also change this to 'housing'
# var_year         <- 2020              # year of census data to pull.  i think 2019 is most recent available due to pandemic
# 
# # Download All US State Boundary Geographies----
# boundary_all.states <- tigris::states(cb   = T,  # TRUE = low_res, FALSE = high_res 
#                                       year = var_year)
# 
# # this line of code filters down to the state you set in 'var_state' from the
# # top of the page
# boundary_var.state <- boundary_all.states[boundary_all.states$NAME %in% var_state,]
# 
# # plot a map of var_state
# ggplot() + 
#   geom_sf(data = boundary_var.state)+
#   labs(title = "This is the minimum you need for a basic map in R",
#        subtitle = "Below we'll talk about changing the map theme adding more features",
#        caption = "There's so much more we can do though")
# 
# # set map to var plot_basemap
# plot_basemap <- ggplot() + 
#   geom_sf(data = boundary_var.state)
# 
# # print to plot map
# plot_basemap
# 
# # theme updates----
# plot_basemap <- plot_basemap +
#   theme(axis.text         = element_blank(),                  # removes the longitude/latitude labels
#         axis.ticks        = element_blank(),                  # removes the '-' (tick) marks from the axis
#         panel.background  = element_rect(fill = "light blue", # color name, code, etc 
#                                          color = "blue"),     # color name, code, etc 
#         plot.background   = element_rect(fill = "pink",       # color name, code, etc 
#                                          color = "red"),      # color name, code, etc 
#         plot.title        = element_text(face = "bold",       # ("plain", "italic", "bold", "bold.italic")
#                                          size = 18,           # text size in pts
#                                          color = NULL),       # color name, code, etc 
#         plot.subtitle     = element_text(face = NULL,         # ("plain", "italic", "bold", "bold.italic")
#                                          size = 16,           # text size in pts
#                                          color = NULL),       # color name, code, etc 
#         plot.caption      = element_text(face = "italic",     # ("plain", "italic", "bold", "bold.italic")
#                                          size = NULL,         # text size in pts
#                                          color = NULL),       # color name, code, etc 
#         legend.background = element_rect(fill = "light green",# color name, code, etc 
#                                          color = "green")) +  # color name, code, etc 
#   labs(title    = "[Title - Update for each final map]",      # Set the Map title here 
#        subtitle = glue("{var_state}, USA, {var_year}"),       # generated from vars
#        caption  = "Source: US Census Bureau, Accessed 2023")  # Set the Map caption here 
# 
# # print to view map
# plot_basemap
# 
# # HOW TO ADD ADDITIONAL GEOGRAPHIC FEATURES TO YOUR MAP----
# 
# # The US Census Bureau has an open database of cartographic boundary shapefiles
# # that known as TIGER.  The R package 'tigris' allows easy access to this
# # library in R.  The basemap produced so far has used state boundaries pulled
# # from tigris().  But let's explore some of the other things we can add to our
# # basemap to help the map's audience better orient themselves to their location
# # in the state by downloading major road and water features.
# 
# # add counties----
# county_names <- tigris::counties(state = var_state, cb = T, year = var_year)$NAME
# gc()
# 
# ggplot() + 
#   geom_sf(data = tigris::counties(var_state,cb=T,year=var_year), 
#           fill = "white", color = "grey")
# 
# # HOW TO ADD CENSUS DATA TO YOUR MAP----
# nc_county_population <- tidycensus::get_estimates(geography = "county", 
#                                                   product = "population", 
#                                                   state = var_state, 
#                                                   geometry = T)
# 
# 
# # add to our county map
# plot_basemap + 
#   geom_sf(data = nc_county_population)
# 
# # filter out variable to "POP" (removes 'density', which we don't want)
# nc_county_population <- nc_county_population[nc_county_population$variable == "POP",]
# 
# 
# # fill (color) counties based on population size variable
# pop.nc <- plot_basemap + 
#   geom_sf(data = nc_county_population, 
#           aes(fill = value))
# 
# pop.nc
# 
# # Changing the Legend, Colors, Grid, Axis, and other Thematic Items----
# 
# pop.nc + 
#   theme(axis.text = element_blank(),            # removes the lon/lat labels from the axes
#         axis.ticks = element_blank())+          # remoes the tick marks from the axes 
#   scale_fill_viridis_c(option = "C",            # changes the color pattern to a preset that I like
#                        labels = scales::comma,  # adds commas to the legend values
#                        name = "County Population")+ # allows you to custom-name the legend
#   labs(title = "[map title goes here]", 
#        subtitle = "[map subtitle goes here]", 
#        caption = "[i use this argument for data source references]")
# 
# 
# # Improved with library(glue)
# pop.nc + 
#   theme(axis.text = element_blank(),            # removes the lon/lat labels from the axes
#         axis.ticks = element_blank())+          # remoes the tick marks from the axes 
#   scale_fill_viridis_c(option = "C",            # changes the color pattern to a preset that I like
#                        labels = scales::comma,  # adds commas to the legend values
#                        name = glue("{demographic.info}"))+ # allows you to custom-name the legend
#   labs(title = glue("{var_state} {demographic.info} Information by County"), 
#        subtitle = glue("Census Year: {var_year}"), 
#        caption = glue("Source: US Census Bureau"))
