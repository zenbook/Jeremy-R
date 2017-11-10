# load pacckages =============================================================
library(leaflet)
library(htmltools)
library(tidyverse)
library(maptools)

# 各城市签收率 ===============================================================

## 沙特各城市的经纬度
saudi_arabia_cities <- read.csv('./Saudi_arabia_city_longitude_latitude.csv', sep = ',')
## 沙特各城市签收率
saudi_arabia_data <- read.csv('./map_for_sa.csv', sep = ',')
## join两表
receive_rate_df <- left_join(saudi_arabia_data[, c('City', 'ship_num', 'COD_rec_rate', 
                                                   'cnw_time_span')], 
                             saudi_arabia_cities[, c('City', 'long', 'lat')], 
                             by = 'City')
receive_rate_df$rate_pct <- paste(receive_rate_df$COD_rec_rate * 100, "%", sep = '')

## plot
leaflet(receive_rate_df) %>% 
  addTiles() %>% 
  addCircleMarkers(~long, 
                   ~lat, 
                   radius = 6, 
                   color = ~ifelse(COD_rec_rate >= 0.9, '#63BE7B', 
                                   ifelse(COD_rec_rate >= 0.85, '#B1D580',
                                          ifelse(COD_rec_rate >= 0.80, '#FFEB84',
                                                 ifelse(COD_rec_rate >= 0.75, 
                                                        '#FBAA77','#F8696B')))), 
                   stroke = FALSE,
                   fillOpacity = 1, 
                   label = ~paste(as.character(City), ' ',
                                  as.character(ship_num), ';',
                                  as.character(rate_pct), ';', 
                                  as.character(cnw_time_span), ';')) 

# 各省签收率 =================================================================

## 读入shp文件
saudi_arabia_map <- readShapePoly('./Saudi_arabia_shp/SAU_adm1.shp')
## plot(saudi_arabia_map)

## 处理shp文件
x1 <- saudi_arabia_map@data
xs1 <- data.frame(x1, id = seq(0:12)-1)
xs1$id <- as.character(xs1$id)
## write.csv(xs1, 'saudi_province.csv')
## 把map转换成data_frame
saudi_arabia_map1 <- fortify(saudi_arabia_map)
## head(saudi_arabia_map1)
## dim(saudi_arabia_map1)
## join xs1和saudi_arabia_map1
saudi_arabia_mapdata <- left_join(saudi_arabia_map1, xs1, type = 'full')
## head(saudi_arabia_mapdata)

## 测试数据
id = seq(0:12)-1
rate <- c(100, 120, 32, 56, 213, 780, 324, 234, 21, 578, 32, 222, 666)
province_data <- data.frame(id, rate)
province_data$id <- as.character(province_data$id)

## 读入业务数据
province_data <- read.csv('./saudi_arabia_province_data.csv')
province_data$id <- as.character(province_data$id)

## join地图和业务数据
saudi_province_map <- left_join(saudi_arabia_mapdata, 
                                province_data, 
                                type = 'full')

## 绘制地图
ggplot(saudi_province_map, aes(x = long, y = lat, group = group, fill = cod_rec_rate)) +  
  geom_polygon() + 
  geom_path(colour = 'orange')



