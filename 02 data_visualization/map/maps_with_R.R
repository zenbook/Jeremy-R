# 0.load packages ==========================================================
library(maps)
library(mapdata)
library(maptools)
library(ggplot2)
library(plyr)

# 1.maps =====================================================================

## 绘制一张世界地图
map('world', fill = TRUE, col = colors())
## 问题：如何选择某个国家，绘制该国的地图？
map('usa', fill = TRUE, col = colors())
## 可以画美国的，但是其他国家的不知道怎么画

# 2.maps + ggplot2 ===========================================================


## 绘制世界地图
world_map = map_data('world')
ggplot(world_map, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = 'white', colour = 'black')
## geom_path, no fill colors
ggplot(world_map, aes(x = long, y = lat, group = group)) + 
  geom_path()

## 绘制区域地图，如东亚，中东
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

### 沙特
saudi = map_data('world', region = 'Saudi Arabia')

ggplot(saudi, aes(long, lat, group = group)) + 
  geom_polygon(colour = 'black', fill = 'white') + 
  scale_fill_brewer(palette = 'Set1')

# 3.shapefile + ggplot2 + maptools ==========================================

china_map <- readShapePoly('./China_shp/bou2_4p.shp')
plot(china_map)

## 预处理
x <- china_map@data
xs <- data.frame(x, id = seq(0:924)- 1)
### 把china_map转换成data_frame
china_map1 <- fortify(china_map)
head(china_map1)
dim(china_map1)
### 把地图坐标和省份信息join
china_mapdata <- join(china_map1, xs, type = 'full')
head(china_mapdata)

## 绘制中国地图
ggplot(china_mapdata, aes(x = long, y = lat, group = group, fill = NAME)) + 
  geom_polygon() + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE)

## 绘制省份的地图
### 浙江省
zhejiang <- subset(china_mapdata, NAME == '浙江省')
ggplot(zhejiang, aes(long, lat, group = group, fill = NAME)) + 
  geom_polygon(fill = 'beige') + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE) + 
  ggtitle('中华人民共和国浙江省') + 
  geom_point(x = 120.12, y = 30.16) + 
  annotate('text', x = 120.3, y = 30, label = '杭州市')
### 香港
hongkong <- subset(china_mapdata, NAME == '香港特别行政区')
ggplot(hongkong, aes(long, lat, group = group, fill = NAME)) + 
  geom_polygon(fill = 'beige') + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE) + 
  ggtitle('香港特别行政区')




# 全球地图 ==============================================================
library(rworldmap)
data("countryExData")
spdf <- joinCountryData2Map(countryExData, 
                            joinCode = 'ISO3', 
                            nameJoinColumn = 'ISO3V10')

mapDevice()
mapCountryData(spdf, nameColumnToPlot = 'PM10')

## 自定义设置，让地图更好看

### load data
library(XML)
url<-"http://en.worldstat.info/World/List_of_countries_by_Population_under_15_years_old"
table <- readHTMLTable(url)
raw <- as.data.frame(table[4])
names(raw) <- c('country', 'pop')
raw <- raw[-1, ]
raw$country <- as.character(raw$country)
raw$pop <- as.numeric(gsub(",",'',raw$pop))

### plot
map <- joinCountryData2Map(raw, joinCode = 'NAME', 
                           nameJoinColumn = 'country')
### 调色板
op <- palette(c('green', 'yellow', 'orange', 'red'))
### 按四分位数划分
cutvector <- quantile(map$pop, na.rm = TRUE)
map$category <- cut(map$pop, cutvector, include.lowest = TRUE)
levels(map$category) <- c('low', 'med', 'high', 'vhigh')
### plot
mapCountryData(map, nameColumnToPlot = 'category', 
               catMethod = 'categorical', 
               mapTitle = '15岁以下的世界人口分布', 
               colourPalette = 'palette', 
               oceanCol = 'lightblue', 
               missingCountryCol = 'white')
### 问题：左下角的图例太大


# 参考资料
## https://site.douban.com/182577/room/2177990/