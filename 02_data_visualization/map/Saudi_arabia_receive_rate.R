# load pacckages =============================================================
library(leaflet)
library(htmltools)
library(tidyverse)
library(maptools)

# 各城市签收率 ===============================================================

## 沙特各城市的经纬度
saudi_arabia_cities <- read.csv('./Saudi_arabia_city_longitude_latitude.csv', sep = ',')
## 沙特各城市签收率
sa_city_data <- read.csv('./map_for_sa.csv', sep = ',')
## join两表
sa_city_data <- left_join(sa_city_data[, c('City', 'ship_num', 
                                           'COD_rec_rate', 
                                           'cnw_time_span')], 
                          saudi_arabia_cities[, c('City', 'long', 'lat')], 
                          by = 'City')
sa_city_data$rate_pct <- paste(saudi_arabia_data$COD_rec_rate * 100, 
                               "%", 
                               sep = '')

## plot
leaflet(sa_city_data) %>% 
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
saudi_arabia_map <- fortify(saudi_arabia_map)
## head(saudi_arabia_map1)
## dim(saudi_arabia_map1)
## join xs1和saudi_arabia_map1
saudi_arabia_map <- left_join(saudi_arabia_map, xs1, type = 'full')
## head(saudi_arabia_mapdata)

## 测试数据
## id = seq(0:12)-1
## rate <- c(100, 120, 32, 56, 213, 780, 324, 234, 21, 578, 32, 222, 666)
## province_data <- data.frame(id, rate)
## province_data$id <- as.character(province_data$id)

## 读入业务数据
sa_province_data <- read.csv('./saudi_arabia_province_data.csv')
sa_province_data$id = as.character(sa_province_data$id)
sa_province_data$cod_rec_rate2 = paste(sa_province_data$cod_rec_rate * 100, '%')

## join地图数据和业务数据
sa_province_mapdata <- left_join(saudi_arabia_map, 
                                 sa_province_data[, c('id', 
                                                      'ship_orders', 
                                                      'cod_rec_rate')])

## 绘制地图
ggplot() + 
  geom_polygon(data = sa_province_mapdata, 
               aes(x = long, y = lat, group = group, fill = ship_orders), 
               colour = 'white') + 
  scale_fill_gradient(high = 'green', 
                      low = 'red', 
                      guide = 'colorbar', 
                      labels = comma) + 
  geom_label(data = sa_province_data, 
             aes(x = long, 
                 y = lat, 
                 label = paste(province, cod_rec_rate2)), 
             hjust = -0.2, 
             colour = 'blue') + 
  geom_point(data = sa_province_data, 
             aes(x = long, y = lat, size = cod_rec_rate), 
             color = 'orange')

  

ggplot(province_data, aes(map_id = province)) + 
  geom_map(aes(fill = ), colour= "grey", map = saudi_province_map) + 
  expand_limits(x = saudi_province_map$long, y = saudi_province_map$lat)


ggplot(province_data, aes(map_id = province)) + 
  geom_map(aes(fill = ), colour= "grey", map = saudi_province_map) +
  expand_limits(x = worldMap.fort$long, y = worldMap.fort$lat) +
  scale_fill_gradient(high = "red", low = "white", guide = "colorbar", labels = comma) +
  geom_text(aes(label = id, x = Longitude, y = Latitude)) + #add labels at centroids
  coord_equal(xlim = c(-90,-30), ylim = c(-60, 20)) + #let's view South America
  labs(x = "Longitude", y = "Latitude", title = "World Population") +
  theme_bw() 

