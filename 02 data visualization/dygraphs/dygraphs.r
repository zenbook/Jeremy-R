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
dygraph(deaths) %>% 
  dyRangeSelector()
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

# shiny dygraph
# dygraphOutput();renderdygraph

# dygraph的一些设置 series options -----------------------------------
deaths <- cbind(ldeaths, mdeaths, fdeaths)

## 线条颜色
dygraph(deaths, 
        main = 'This is title') %>% 
  dyOptions(colors = RColorBrewer::brewer.pal(3, 'Set1'))
## 具体参见brewer.pal函数的参数设置，
## 比如name参数的值有:Accent,Dark2,Paired,Pastel1,Pastel2,Set1,Set2,Set3

## step colors
dygraph(deaths[, 2:3],
        main = 'This is title') %>% 
  dyOptions(stepPlot = TRUE)

## 填充颜色(类似面积图)
dygraph(ldeaths,
        main = "This is title") %>% 
  dyOptions(fillGraph = TRUE, 
            fillAlpha = 0.4)

## points display,显示数据点
dygraph(ldeaths,
        main = 'This is title') %>% 
  dyOptions(drawPoints = TRUE, pointSize = 2)

## 为不同数据序列添加不同设置 dySeries
dygraph(deaths[, 2:3], 
        main = 'This is title') %>% 
  dySeries('mdeaths', color = 'blue', drawPoints = TRUE) %>% 
  dySeries('fdeaths', color = 'red', stepPlot = TRUE, fillGraph = TRUE)

## 线条样式
dygraph(ldeaths, 
        main = 'This is title') %>% 
  dySeries("V1", strokePattern = 'dashed', strokeWidth = 2) 
## 可设置的线条样式有："dotted", "dashed", "dotdash"

## 线条高亮 dyHighlight -----------------------------------------------
dygraph(deaths,
        main = 'This is title') %>% 
  dyHighlight(highlightCircleSize = 5, # 数据点大小
              highlightSeriesBackgroundAlpha = 0.2, # 非高亮线条的虚化
              hideOnMouseOut = FALSE) # 鼠标移开后是否保持高亮样式，false:保持

## 单独为高亮的线条设置样式
dygraph(deaths,
        main = "This is title") %>% 
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) # 单独设置高亮样式

## 坐标轴设置 ---------------------------------------------------------
dygraph(nhtemp, 
        main = 'This is title') %>% 
  dyAxis('y', 
         label = 'Temp(F)',  # 设置y轴标题
         valueRange = c(40, 60)) %>%  # 设置y轴刻度范围，不建议这么做，容易造成数据误读
  dyOptions(drawGrid = FALSE,  # 是否显示网格线(x/y轴)
            axisLineWidth = 1.5,  # 坐标轴线宽度
            fillGraph = TRUE)  # 是否显示面积
dygraph(AirPassengers,
        main = 'This is title') %>% 
  dyAxis('x', drawGrid = FALSE) %>% 
  dyAxis('y', label = 'passengers(1000)') %>% 
  dyOptions(includeZero = TRUE, 
            axisLineColor = 'navy',
            gridLineColor = 'lightblue')
## dyOptions()还有很多参数，输入"?dyOptions()"

## 次y坐标轴
temperature <- ts(frequency = 12, 
                  start = c(1980, 1),
                  data = c(7.0, 6.9, 9.5, 14.7, 18.9, 25.3, 
                           25.8, 26.8, 23.4, 18.5, 13.2, 10.1))
rainfall <- ts(frequency = 12,
               start = c(1980, 1),
               data = c(49.5, 71.5, 106.4, 129.2, 144.0, 176.0, 
                        135.6, 148.5, 216.4, 194.1, 95.6, 54.4))
weather <- cbind(temperature, rainfall)
dygraph(weather, 
        main = 'This is title') %>% 
  dySeries('rainfall', axis = 'y2')
## 上图中次坐标轴的数字带两位小数，我们加一个参数，把这个次坐标轴设置成和主坐标轴一样
dygraph(weather,
        main = 'This is title') %>% 
  dyAxis('y', label = 'Temp') %>% 
  dyAxis('y2', label = 'Rainfall', independentTicks = TRUE) %>% 
  dySeries('rainfall', axis = 'y2')
  
## labels and legends 标签和图例 ------------------------------------
## 标签labels，标题/x轴标题/y轴标题
dygraph(deaths,
        main = 'This is title', 
        xlab = 'xlab title', 
        ylab = 'ylab title')
dygraph(deaths, 
        main = 'This is title') %>% 
  dyAxis('x', label = 'xlab title') %>% 
  dyAxis('y', label = 'ylab title')

## 图例legend
## 当有两个及以上数据序列时，图例时默认展示的；
## 默认：只有当鼠标移到某个数据点时，图例上才会先是数据点的数据
dygraph(ldeaths, 
        main = 'This is title') %>% 
  dySeries('V1', label = 'ldeaths') %>% 
  dyLegend(show = 'always',  # 只有一个数据系列，也显示图例
           hideOnMouseOut = FALSE)  # 即使鼠标移出数据点，图例上也显示数据点
## show = c("auto", "always", "onmouseover", "follow", "never")
## 图例的位置设置成跟随鼠标移动
dygraph(ldeaths, 
        main = 'This is title') %>% 
  dySeries('V1', label = 'ldeaths') %>% 
  dyLegend(show = 'follow')
## 图例的默认宽度是250px，为了避免图例换行，修改图例的宽度
dygraph(deaths, 
        main = 'This is title') %>%
  dyLegend(width = 300)

## time zones --------------------------------------------------------
## dygraphs默认使用客户端的时区，可以设置时区
datetimes <- seq.POSIXt(from = as.POSIXct('2017-01-01', tz = 'GMT'),
                        to = as.POSIXct('2017-01-02', tz = 'GMT'),
                        by = '3 hours')
values <- rnorm(length(datetimes))
series <- xts(values, order.by = datetimes, tz = 'GMT')
dygraph(series)  # 客户端所在时区
dygraph(series) %>% 
  dyOptions(labelsUTC = TRUE) # 使用协调世界时
dygraph(series) %>% 
  dyOptions(useDataTimezone = TRUE) # 使用数据集自带的时区

## dyRangeSelector() -------------------------------------------------
## dyRangeSelector(dygraph, dateWindow = NULL, height = 40,
## fillColor = " #A7B1C4", strokeColor = "#808FAB", keepMouseZoom = TRUE,
## retainDateWindow = FALSE)
## 时间筛选区域
dygraph(ldeaths) %>% 
  dyRangeSelector()
## 设置dyRangeSelector的初始范围
dygraph(nhtemp) %>% 
  dyRangeSelector(dateWindow = c('1920-01-01', '1960-01-01'))

## Candlestick蜡烛图 -------------------------------------------------
data("sample_matrix")
m <- tail(sample_matrix, 32)
dygraph(m) %>% 
  dyCandlestick()
## 蜡烛图主要用于股票交易分析中，取数据集的前四列，分别是开盘价/最高价/最低价/收盘价
## 如果数据集多于4列，那么剩余的列会绘制成折线
m <- cbind(m, apply(m[, 1:3], 1, mean))
colnames(m)[5] <- 'Mean'
dygraph(m) %>% 
  dyCandlestick() %>% 
  dyLegend(width = 300) # 由于图例较多，增加一下图例宽度，使图例不换行
## 比较以下两个代码的差别
dygraph(sample_matrix) %>% 
  dyCandlestick()
dygraph(sample_matrix) %>% 
  dyCandlestick(compress = TRUE)

## 多图同步，同时缩放 ------------------------------------------------
dygraph(ldeaths, main = 'All', group = 'deaths')
dygraph(fdeaths, main = 'Female', group = 'deaths')
dygraph(mdeaths, main = 'Male', group = 'deaths')


