
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
map('world', 'China')

## 3.2 ggplot

library(ggplot2)

worldmap = map_data('world')

ggplot(world_map, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = 'white', colour = 'black')

### 东亚
east_asia = map_data('world', region = c('Japan', 'China', 'North Korea', 'South Korea'))

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












library(rgdal)

chinamap = readOGR('./China_shp/bou2_4p.shp')

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

















