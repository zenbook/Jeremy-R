
# 1.maps =====================================================================
library(maps)
library(mapdata)
## 绘制一张世界地图
map('world', fill = TRUE, col = colors())
## 问题：如何选择某个国家，绘制该国的地图？
map('usa', fill = TRUE, col = colors())
## 可以画美国的，但是其他国家的不知道怎么画

# 2.maps + ggplot2 ===========================================================
library(ggplot2)

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
ggplot(gcc_countries, aes(long, lat, group = group, fill = region)) + 
  geom_polygon(colour = 'black') + 
  scale_fill_brewer(palette = 'Set1')

# 3.shapefile + ggplot2 + maptools ==========================================
library(maptools)

china_map <- readShapePoly('./china_shp/bou2_4p.shp')
saudi_arabia_map <- readShapePoly('./saudi_arabia_shp/SAU_adm1.shp')

plot(china_map)
plot(saudi_arabia_map)


x <- saudi_arabia_map@data
dim(x)
x

x <- china_map@data
xs <- data.frame(x, id = seq(0:924)- 1)


china_map1 <- fortify(china_map)
head(china_map1)

library(plyr)
china_mapdata <- join(china_map1, xs, type = 'full')
head(china_mapdata)

ggplot(china_mapdata, aes(x = long, y = lat, group = group, fill = NAME)) + 
  geom_polygon() + 
  geom_path(colour = 'grey40') + 
  scale_fill_manual(values = colours(), guide = FALSE)














