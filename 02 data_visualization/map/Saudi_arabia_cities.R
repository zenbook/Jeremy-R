# load pacckages =============================================================
library(leaflet)
library(magrittr)
library(sp)
library(maps)
library(htmltools)
library(tidyverse)

# load data ==================================================================
## 沙特各城市的经纬度
saudi_arabia_cities <- read.csv('./Saudi_arabia_city_longitude_latitude.csv', 
                                sep = ',')
## 沙特各城市签收率
saudi_arabia_data <- read.csv('./map_for_sa.csv', 
                              sep = ',')
## join两表
receive_rate_df <- left_join(saudi_arabia_data[, c('City', 'Ship_num', 'Receive_rate')], 
                          saudi_arabia_cities[, c('City', 'long', 'lat')], 
                          by = 'City')
receive_rate_df$rate_pct <- paste(receive_rate_df$Receive_rate * 100, "%", sep = '')

# plot maps ==================================================================
getColor <- function(receive_rate_df) {
  sapply(receive_rate_df$Receive_rate, function(Receive_rate) {
    if(Receive_rate >= 0.88) {
      "green"
    } else if(Receive_rate >= 0.85) {
      "orange"
    } else if(Receive_rate >= 0.82) {
      "yellow"
    } else if(Receive_rate >= 0.80) {
      "Wheat"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  markerColor = getColor(receive_rate_df)
)

icons <- awesomeIcons(
  icon = 'shopping-cart',
  library = 'fa',
  markerColor = getColor(receive_rate_df)
)


leaflet(receive_rate_df) %>% 
  addTiles() %>% 
  addAwesomeMarkers(~long, 
                    ~lat, 
                    icon = icons, 
                    label = ~as.character(rate_pct))
 
leaflet(receive_rate_df) %>% 
  addTiles() %>% 
  addCircleMarkers(~long, 
                   ~lat, 
                   radius = ~Ship_num / 1000, 
                   color = 'green', 
                   fillColor = 'red', 
                   fill = 'orange', 
                   label = ~as.character(rate_pct)) 


addCircleMarkers(map, lng = NULL, lat = NULL, radius = 10,
                 layerId = NULL, group = NULL, stroke = TRUE, color = "#03F",
                 weight = 5, opacity = 0.5, fill = TRUE, fillColor = color,
                 fillOpacity = 0.2, dashArray = NULL, popup = NULL,
                 popupOptions = NULL, label = NULL, labelOptions = NULL,
                 options = pathOptions(), clusterOptions = NULL, clusterId = NULL,
                 data = getMapData(map))










