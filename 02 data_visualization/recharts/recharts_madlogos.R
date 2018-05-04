
# 说明 ==================================================================
## 用recharts包绘制交互图形
## 包资源来自madlogos
## madlogos：https://github.com/madlogos/recharts2

## 以下练习代码来自文档：https://madlogos.github.io/recharts/#-en

# 安装madlogos的recharts
library(devtools)
devtools::install_github("madlogos/recharts")

# 加载包
library("recharts")
library("tidyverse")

# 查看说明文档
browseVignettes('recharts')


# quilk start
echartr(iris, Sepal.Length, Sepal.Width, series = Species)
## 使用数据集mtcars
str(mtcars)
head(mtcars)

## 散点图，探索wt和mpg的关系
## 1.最简洁代码，重量越重，油耗越高，每加仑可行驶的距离越短
echartr(mtcars, wt, mpg)
## 2.series:group的含义，分组
echartr(mtcars, wt, mpg, series = cyl)
## factor: am = 0:Automatic; am = 1:Auto
factor(mtcars$am[1:10], labels = c('Automatic', 'Manual'))
echartr(mtcars, wt, mpg, series = factor(am, labels = c('Automatic', 'Manual')))
## 气泡图
echartr(mtcars, wt, mpg, weight = hp, type = 'bubble')

## 参数可按照以下三种形式传入：
## 1. wt, mpg
## 2. 'wt', 'mpg'
## 3. ~wt, ~mpg

## 对数据的要求
## 1.最好是data.frame
## 2.先按照自己的需要进行排序
## 3.处理日期数据时要小心

## 混合图
d <- data.table::dcast(mtcars, carb + gear ~., mean, value.var = 'mpg')
names(d)[3] <- 'mean.mpg'
d$carb <- as.character(d$carb)
str(d)
## 默认：条形图
echartr(d, carb, "mean.mpg", gear)
## 修改成柱形图
echartr(d, carb, "mean.mpg", gear, type = 'vbar')
## series = gear有三个取值，默认三个都是柱形图，如需调整，参照如下：
## 即：gear=3和4：柱形图；gear=5：折线图，type = c()
echartr(d, carb, "mean.mpg", gear, type = c('vbar', 'vbar', 'line'))
## 修改标记为空心圆
echartr(d, carb, "mean.mpg", gear, type = c('vbar', 'vbar', 'line')) %>% 
  setSymbols('emptycircle')
## 都设置成折线图，但同时设置线型和点型
echartr(d, carb, "mean.mpg", gear, type = 'line', 
        subtype = c('stack + smooth', 'stack + dotted', 'smooth + dashed')) %>% 
  setSymbols('emptycircle')
## facet and series
d1 <- data.frame(x = rep(LETTERS[1:6], 4), 
                 y = abs(rnorm(24)), 
                 f = c(rep('i', 12), rep('ii', 12)), 
                 s = rep(c(rep('I', 6), rep('II', 6)), 2))
d1
echartr(d1, x, y, s, facet = f, type = 'radar', 
        subtype = list(c('fill', ''), c('', 'fill')))

## 图形各项设置
g <- echartr(mtcars, wt, mpg, factor(am, labels = c('Automatic', 'Manual')))
## 1. series
## 不同类型的图，可以设置不同的参数，可通过?setSeries查阅
## 设置第二个序列。。。
g %>% setSeries(series = 2, symbolSize = 8, symbolRotate = 30)
## 2.markLine
## 添加平均值线
g %>% addMarkline(data = data.frame(type = 'average', name1 = 'Avg'))
economics %>% 
  filter(date >= '2008-01-01') %>% 
  echartr(date, uempmed, type = 'line') %>% 
  addMarkLine(data = data.frame(type = 'average', name1 = 'Avg'))
## 添加自定义值对应的线???
g %>% addMarkLine(data = data.frame())

## 3.markPoints
g %>% addMarkPoint(series = 1, data = data.frame(type = 'max', name = 'Max'))
## 添加自定义值对应的点???
g %>% addMarkPoint(series = 1, data = data.frame())
## 4.添加标题，默认位置是6点钟，即下方
g %>% setTitle('wt V.S mpg')
g %>% setTitle('wt V.S mpg', pos = 12)
## 通过textStyle参数，来设置标题的样式
g %>% setTitle(title = 'wt V.S mpg', 
               pos = 12, 
               textStyle = textStyle(fontsize = 16, color = 'red'))
## 设置服标题和链接
g %>% setTitle(title = 'wt V.S mpg', 
               subtitle = '[百度一下，你就后悔](https://www.baidu.com)',
               pos = 12, 
               textStyle = textStyle(fontsize = 16, color = 'red'))
## 5.设置图例
g %>% setLegend(selected = 'Automatic')
## 修改图例位置...
g %>% setLegend(selected = 'Automatic', 
                pos = 6, 
                show = TRUE, 
                selectedMode = 'multiple',
                textStyle = list(fontsize = 12, 
                                 color = 'auto', 
                                 fontFamily = 'Courier New'))
## 6.设置工具箱
g %>% setToolbox(pos = 3, 
                 show = TRUE, 
                 language = 'cn', 
                 itemSize = 14, 
                 itemGap = 10, 
                 controls = c('mark', 'dataZoom', 'dataView', 'restore', 'saveAsImage'))
## 7.设置datazoom
g %>% setDataZoom()














head(economics)
str(economics)






