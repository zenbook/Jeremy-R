
# 1.maps =====================================================================
library(maps)
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



ggmap(ggmap = 'china')




library(ggmap)