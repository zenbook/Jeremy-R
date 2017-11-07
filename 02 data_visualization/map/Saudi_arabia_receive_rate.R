# load pacckages =============================================================
library(leaflet)
library(htmltools)
library(tidyverse)

# load data ==================================================================
## 沙特各城市的经纬度
saudi_arabia_cities <- read.csv('./Saudi_arabia_city_longitude_latitude.csv', sep = ',')
## 沙特各城市签收率
saudi_arabia_data <- read.csv('./map_for_sa.csv', sep = ',')
## join两表
receive_rate_df <- left_join(saudi_arabia_data[, c('City', 'ship_num', 'COD_rec_rate', 'cnw_time_span')], 
                             saudi_arabia_cities[, c('City', 'long', 'lat')], 
                             by = 'City')
receive_rate_df$rate_pct <- paste(receive_rate_df$COD_rec_rate * 100, "%", sep = '')

# plot maps ==================================================================
leaflet(receive_rate_df) %>% 
  addTiles() %>% 
  addCircleMarkers(~long, 
                   ~lat, 
                   radius = 6, 
                   color = ~ifelse(COD_rec_rate >= 0.9, '#63BE7B', 
                                   ifelse(COD_rec_rate >= 0.85, '#B1D580',
                                          ifelse(COD_rec_rate >= 0.80, '#FFEB84',
                                                 ifelse(COD_rec_rate >= 0.75, '#FBAA77','#F8696B')))), 
                   stroke = FALSE,
                   fillOpacity = 1, 
                   label = ~paste(as.character(City), ' ',
                                  as.character(ship_num), ';',
                                  as.character(rate_pct), ';', 
                                  as.character(cnw_time_span), ';')) 
