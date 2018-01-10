
# ============================================================================
# title:Draw map with R
# date:2017-11-27
# author:Neo王政鸣
# ============================================================================

# content ====================================================================
## - 1.点
## - 2.线【略】
## - 3.面
## - 4.画中国地图


# 1.点 =======================================================================

## 加载包
library(leaflet)
## http://rstudio.github.io/leaflet/
## http://leafletjs.com/
## https://github.com/rstudio/leaflet

## 一个点：The birthplace of R 
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

## 多个点 
data("quakes")
## https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/quakes.html
head(quakes)
str(quakes)

leaflet(data = quakes[1:20, ]) %>% 
  addTiles() %>% 
  addMarkers()

## 各种设置
## 地震按震级大小的分类情况
## 弱震:(0, 3)
## 有感地震:[3, 4.5)
## 中强震:[4.5, 6)
## 强震:[6, 8)
## 巨震:[8,)

### 1.Marker Color

df.50 = quakes[1:50, ]

getColor <- function(quakes) {
  sapply(quakes$mag, function(mag) {
    if(mag < 4.5) {
      "green"
    } else if(mag < 6) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(df.50)
)

leaflet(df.50) %>% 
  addTiles() %>% 
  addAwesomeMarkers(~long, ~lat, icon = icons, label = ~as.character(mag))


### 2.Marker Clusters 

leaflet(quakes) %>% 
  addTiles() %>% 
  addMarkers(clusterOptions = markerClusterOptions())


## 3.Popups And Labels

#### Popups

leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = 174.768, lat = -36.852, 
             popup = "The birthplace of R")

leaflet() %>% 
  addTiles() %>% 
  addPopups(lng = 174.768, lat = -36.852, 
            popup = "The birthplace of R", 
            options = popupOptions(closeButton = FALSE))

#### Labels
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = 174.768, lat = -36.852, 
             label = "The birthplace of R")

leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = 174.768, lat = -36.852, 
             label = "The birthplace of R", 
             labelOptions = labelOptions(noHide = TRUE, 
                                         textOnly = FALSE, 
                                         textsize = '15px', 
                                         direction = 'bottom'))

## 气泡
province <- read.csv('./saudi_arabia_province_data.csv')

head(province)
leaflet(province) %>% 
  addTiles() %>% 
  addCircles(lng = ~long, lat = ~lat, 
             weight = 1, 
             color = 'red', 
             radius = ~sqrt(ship_orders) * 300, 
             label = ~paste(province, ': ', ship_orders))



# 2.线【略】 ================================================================


# 3.面 ======================================================================

## 3.1 maps

library(maps)

map('world')
map('usa', fill = TRUE, col = colors())
map('world', region = 'China')

## 3.2 ggplot2

library(ggplot2)

worldmap <- map_data('world')

ggplot(data = worldmap, 
       aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = 'white', colour = 'black')

### 东亚
east_asia = map_data('world', 
                     region = c('Japan', 'China', 'North Korea', 'South Korea'))

ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) + 
  geom_polygon(colour = 'black') + 
  scale_fill_brewer(palette = 'Set1')

### 中东
gcc_countries = map_data('world', 
                         region = c('Bahrain', 
                                    'Kuwait', 
                                    'Oman', 
                                    'Qatar', 
                                    'Saudi Arabia', 
                                    'United Arab Emirates'))
ggplot(gcc_countries, aes(x = long, y = lat, group = group, fill = region)) + 
  geom_polygon(colour = 'black') + 
  scale_fill_brewer((palette = 'Set1'))

### 沙特阿拉伯
saudi = map_data('world', region = 'Saudi Arabia')

ggplot(saudi, aes(long, lat, group = group)) + 
  geom_polygon(colour = 'black', fill = 'white')



## 3.3 leaflet

mapworld = map('world', fill = TRUE, plot = FALSE)

leaflet(data = mapworld) %>% 
  addTiles() %>% 
  addPolygons(fillColor = topo.colors(20, alpha = NULL), 
              stroke = FALSE, 
              color = '#444444', 
              weight = 1, 
              smoothFactor = 0.5, 
              opacity = 1.0, 
              fillOpacity = 0.5, 
              highlightOptions = highlightOptions(color = 'white', 
                                                  weight = 2, 
                                                  bringToFront = TRUE))



# 4.画中国地图 ===================================================================

## 4.1 画一只最简单的鸡

map('world', 'China')

chinamap <- map_data('world', region = 'China')
ggplot(chinamap, aes(x = long, y = lat, group = group)) + 
  geom_polygon(color = 'black', fill = 'white')


## 4.2 画一只丑丑的鸡
china_map <- readOGR('./China_shp/bou2_4p.shp')
plot(china_map)

## 4.3 画一只稍微好看一些的鸡
library(dplyr)

x <- china_map@data
xs <- data.frame(x, id = seq(0:924)- 1)

### 把china_map转换成data_frame
china_map1 <- fortify(china_map)
china_map1$id <- as.numeric(china_map1$id)
head(china_map1)
dim(china_map1)

### 把地图坐标和省份信息join
china_mapdata <- left_join(china_map1, xs, type = 'full')
head(china_mapdata)
str(china_mapdata)

## 绘制中国地图
ggplot(china_mapdata, 
       aes(x = long, y = lat, group = group, fill = NAME)) + 
  geom_polygon() + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE)

## 绘制省份的地图
### 浙江省
zhejiang <- subset(china_mapdata, NAME == '浙江省')
ggplot(zhejiang, aes(long, lat, group = group, fill = NAME)) + 
  geom_polygon(fill = 'white') + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE) + 
  ggtitle('中华人民共和国浙江省') + 
  geom_point(x = 120.12, y = 30.16) + 
  annotate('text', x = 120.3, y = 30, label = '杭州市')

## 4.4 画一只漂亮的鸡
library(rgdal)

chinamap = readOGR('./China_shp/bou2_4p.shp')
class(chinamap)

leaflet(chinamap) %>% 
  addPolygons(color = '#444444', 
              weight = 1, 
              smoothFactor = 0.5, 
              opacity = 1.0, 
              fillOpacity = 0.5, 
              #fillColor = ~colorQuantile('YlOrRd', ALAND)(ALAND), 
              fillColor = topo.colors(10, alpha = NULL), 
              highlightOptions = highlightOptions(color = 'white', 
                                                  weight = 2, 
                                                  bringToFront = TRUE))

## 4.5 画一只特别漂亮的鸡
## https://recharts.cosx.org/
## http://echarts.baidu.com/examples.html
library(recharts)

### 中国 + 省份
mapdata <- data.frame(province = c('上海', '江苏', '浙江', '江西', '安徽'), 
                      val1 = c(100, 200, 300, 400, 420), 
                      val2 = c(200, 300, 400, 500, 520), 
                      val3 = c(1, 2, 3, 5, 4), 
                      stringsAsFactors = FALSE)

eMap(mapdata, namevar = ~province, datavar = ~val1 + val2)

## 省份 + 城市
zhejiang <- data.frame(city = c('杭州市', '绍兴市', '宁波市', '舟山市'), 
                       val1 = c(100, 200, 300, 400), 
                       val2 = c(600, 200, 100, 400), 
                       val3 = c(1, 2, 3, 4), 
                       stringAsFactors = FALSE)

eMap(zhejiang, namevar = ~city, datavar = ~val1 + val2, region = '浙江')












