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
