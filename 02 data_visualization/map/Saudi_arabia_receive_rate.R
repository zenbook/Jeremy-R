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
receive_rate_df <- left_join(saudi_arabia_data[, c('City', 'Ship_num', 'Receive_rate')], 
                             saudi_arabia_cities[, c('City', 'long', 'lat')], 
                             by = 'City')
receive_rate_df$rate_pct <- paste(receive_rate_df$Receive_rate * 100, "%", sep = '')

# plot maps ==================================================================
leaflet(receive_rate_df) %>% 
  addTiles() %>% 
  addCircleMarkers(~long, 
                   ~lat, 
                   radius = 6, 
                   color = ~ifelse(Receive_rate >= 0.88, '#63BE7B', 
                                   ifelse(Receive_rate >= 0.85, '#B1D580',
                                          ifelse(Receive_rate >= 0.82, '#FFEB84',
                                                 ifelse(Receive_rate >= 0.80, '#FBAA77','#F8696B')))), 
                   stroke = TRUE,
                   fillOpacity = 1, 
                   label = ~paste(as.character(City), ' ',
                                  'Ship_num:', 
                                  as.character(Ship_num), ';',
                                  'Receive_rate:',
                                  as.character(rate_pct), ';')) 


