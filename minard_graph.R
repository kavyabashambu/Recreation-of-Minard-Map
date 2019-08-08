install.packages("readxl")
library("readxl")
minard_data <- read_excel("C://Users//kavya//OneDrive//Desktop//minard-data.xlsx")
print(minard_data)
minard_data = as.data.frame(minard_data)
typeof(minard_data)
class(minard_data)

library(dplyr)
library(ggplot2)
library(tidycensus)
library(tidyverse)
library(lubridate)
library(ggmap)
library(ggrepel)
library(gridExtra)
library(pander)
library(tibble)

travel <- select(minard_data, longitude = LONP, latitude = LATP, survivors = SURV, direction = DIR, division = DIV)
city <- na.omit(select(minard_data, longitude = LONC, latitude = LATC, city = CITY))
temperat <- na.omit(select(minard_data, longi = LONT, temperature = TEMP, days = DAYS, month = MON, day = DAY))
travel
city
temperat
      
  
ggplot() +
 geom_path(data = travel, aes(x = longitude, y = latitude, group = division, color = direction, size = survivors),
  lineend = "round") +
   geom_point(data = city, aes(x = longitude, y = latitude)) +
    geom_text(data = city, aes(x = longitude, y = latitude, label = city), vjust = 1.5) +
      scale_size(range = c(0.5, 15)) + 
        scale_colour_manual(values = c("royalblue1", "gray26")) +labs(x = NULL, y = NULL)+ 
          guides(color = FALSE, size = FALSE)


library(ggmap)
map_coordinates <- c(left = -13.10, bottom = 35.75, right = 41.04, top = 61.86)
map_of_the_war <- get_stamenmap(bbox = map_coordinates, zoom = 5,maptype = "terrain", where = "cache")
ggmap(map_of_the_war)
water_color_map <- get_stamenmap(bbox = map_coordinates, zoom = 5, maptype = "watercolor", where = "cache")
ggmap(water_color_map)

ggmap(water_color_map) +
  geom_path(data = travel, aes(x = longitude, y = latitude, group = division, color = direction, size = survivors),
   lineend = "round") +
    scale_size(range = c(0.5, 5)) + 
     scale_colour_manual(values = c("royalblue1", "gray26")) +
      guides(color = FALSE, size = FALSE) +
       theme_nothing() 


northern_europe_coordinates <- c(left = 23.5, bottom = 53.4, right = 38.1, top = 56.3)

northern_europe_map <- get_stamenmap(bbox = northern_europe_coordinates, zoom = 8,
maptype = "watercolor", where = "cache")

northern_europe_map_with_cities <- ggmap(northern_europe_map) +
 geom_path(data = travel, aes(x = longitude, y = latitude, group = division,
  color = direction, size = survivors),lineend = "round") +
   geom_point(data = city, aes(x = longitude, y = latitude),
    color = "red") +
     geom_text(data = city, aes(x = longitude, y = latitude, label = city),
      color = "red", family = "Helvetica", vjust = 1.5) +
       scale_size(range = c(0.5, 10)) + 
         scale_colour_manual(values = c("royalblue1", "gray26")) +
          guides(color = FALSE, size = FALSE) +
            theme_nothing()
northern_europe_map_with_cities


library(gridExtra)
library(gtable)
       

ggplot(data = temperat, aes(x = longi, y = temperature)) +geom_line() +
  geom_text(aes(label = temperature), vjust = 2)
      
ggplot_build(northern_europe_map_with_cities)$layout$panel_ranges[[1]]$x.range


new_temprate <- temperat %>%
  mutate(new.label = paste0(temperature, "°, ", month, ". ", day))

temperat_and_cities_plot <- ggplot(data = new_temprate, aes(x = longi, y = temperature)) +
  geom_line() +
   geom_label(aes(label = new.label),family = "Helvetica", size = 3) + 
    labs(x = NULL, y = "Celsius") +
      scale_x_continuous(limits = ggplot_build(northern_europe_map_with_cities)$layout$panel_ranges[[1]]$x.range) +
       scale_y_continuous(position = "right") +
        coord_cartesian(ylim = c(-40, 10)) +  
         theme_bw(base_family = "Helvetica") +
          theme(panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank(),
             panel.grid.minor.y = element_blank(),
              axis.text.x = element_blank(), axis.ticks = element_blank(),
               panel.border = element_blank())
temperat_and_cities_plot


typeof(temperat_and_cities_plot)
class(temperat_and_cities_plot)
typeof(northern_europe_map_with_cities)
class(northern_europe_map_with_cities)

northern_europe_map_with_cities_grob <- ggplotGrob(northern_europe_map_with_cities)
temperat_and_cities_plot_grob <- ggplotGrob(temperat_and_cities_plot)
combined_grob <- gtable_rbind(northern_europe_map_with_cities_grob, temperat_and_cities_plot_grob)
grid::grid.newpage()
grid::grid.draw(combined_grob)

panels <- combined_grob$layout$t[grep("panel", combined_grob$layout$name)]
map_height <- combined_grob$heights[panels][1]
map_height

combined_grob$heights[panels] <- unit(c(map_height, 0.1), "null")
grid::grid.newpage()
grid::grid.draw(combined_grob)
