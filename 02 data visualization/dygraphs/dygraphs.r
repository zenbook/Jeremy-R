# dygraphs包主要用来绘制时间序列图形，使用的数据格式一般是xts

# loading packages ----------------------------------------------------------------
library('dygraphs')
library('xts')
library('magrittr')

# demo case -----------------------------------------------------------------------
deaths <- cbind(mdeaths, fdeaths)
dygraph(deaths)
# 选择区域：缩放
# 双击：退出缩放

# 用管道函数为dygraph图形添加其他元素，或进行一些自定义
# 添加区域选择控件
dygraph(deaths) %>% dyRangeSelector()
# 其他一些设置
dygraph(deaths) %>% 
  dySeries('mdeaths', label = 'Male') %>% 
  dySeries('fdeaths', label = 'Female') %>% 
  dyOptions(stackedGraph = TRUE) %>%   # 累积折线图
  dyRangeSelector(height = 20)  # 区域选择控件高度

hw <- HoltWinters(ldeaths)
predicted <- predict(hw, n.ahead = 72, prediction.interval = TRUE)
dygraph(predicted, main = 'This is title') %>% 
  dyAxis("x", drawGrid = FALSE) %>% 
  dySeries(c('lwr', 'fit', 'upr'), label = 'Deaths') %>% 
  # dyOptions(colors = RColorBrewer::brewer.pal(3, 'Set1'))
  dyOptions(colors = 'red')




















