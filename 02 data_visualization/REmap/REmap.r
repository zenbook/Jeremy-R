# load package --------------------------------------------------------------------
library("REmap")

# demo 
remap(demoC)
remap(demoE)

# 基本函数 -----------------------------------------------------------------------
# get_city_coord() 获取城市经纬度
# get_geo_position() 获取城市向量的经纬度
get_city_coord('shanghai')
city_vec <- c('北京', 'shanghai', '杭州')
get_geo_position(city_vec)
get_geo_position(city_vec)$city

# 迁徙地图 -----------------------------------------------------------------------
## 语法结构
remap(mapdata,
      title = '',
      subtitle = '',
      theme = get_theme("Dark"))
set.seed(123)
origin <- rep('北京', 10)
destination <- c('上海', '包头', '杭州', '福州', '深圳',
                 '广州', '长沙', '丽江', '乌鲁木齐', '哈尔滨')
datamap <- data.frame(origin, destination)
out <- remap(datamap,
             title = '全国十大城市航班图',
             theme = get_theme('Dark'))
plot(out)

# 个性化地图 ---------------------------------------------------------------------
get_theme(theme = 'Dark', # 主题：Dark,Bright,Sky；"None":自定义
          lineColor = "", # 线条颜色
          backgroundColor = '',
          titleColor = '',
          borderColor = '',
          regionColor = '')
remap(datamap, 
      theme = get_theme("Bright"))
remap(datamap,
      theme = get_theme("None", 
                        lineColor = 'orange'))
remap(datamap, 
      theme = get_theme('None',
                        backgroundColor = 'white',
                        regionColor = 'gray',
                        borderColor = 'lightblue',
                        lineColor = 'red'))

