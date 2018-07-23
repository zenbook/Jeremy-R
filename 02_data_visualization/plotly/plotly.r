
# 安装plotly ==============================================================
install.packages('plotly')

# load packages ===========================================================
library(plotly)
library(tidyverse)
library(htmltools)
library(shiny)
library(crosstalk)
library(leaflet)

# try =====================================================================
plot_ly(z = ~volcano, 
        type = 'surface')

# first case ggplotly() ===================================================

## data set
txhousing
txh <- txhousing %>% 
  mutate(year_month = paste(year, month, sep = '-'))

## 先创建一个ggplot对象
p <- ggplot(txh, aes(x = date, y = median, group = city)) + 
  geom_line(alpha = 0.2)

## ggplotly
ggplotly(p)

# second case plot_ly() ===================================================

txh %>% 
  group_by(city) %>% 
  plot_ly(x = ~date, y = ~median) %>% 
  add_lines(alpha = 0.2, name = 'Texan cities', hoverinfo = 'none') %>% 
  add_lines(data = filter(txh, city == 'Houston'), name = 'Houston') %>% 
  add_lines(data = filter(txh, city == 'San Antonio'), name = 'San Antonio')

# scatter plot ============================================================

## 默认样式
p1 <- plot_ly(mpg, x = ~cty, y = ~hwy, name = 'default')
p1

## add_markers:设置alpha
p2 <- plot_ly(mpg, x = ~cty, y = ~hwy) %>% 
  add_markers(alpha = 0.2, name = 'alpha')
p2

## add_markders:设置点的样式
p3 <- plot_ly(mpg, x = ~cty, y = ~hwy) %>% 
  add_markers(symbol = I(4), name = 'hollow')
p3

## 把以上3图汇总到一个图中
subplot(p1, p2, p3)

## symbol参数控制点的样式
### 当传入数字时，用I(n)
plot_ly(x = 1:25, y = 1:25, symbol = 8, name = 'pch')
plot_ly(x = 1:25, y = 1:25, symbol = I(8), name = 'pch')

p1 <- plot_ly(x = 1:25, y = 1:25, symbol = I(1:25), name = 'pch')
p2 <- plot_ly(mpg, x = ~cty, y = ~hwy, symbol = ~cyl, symbols = 1:3, name = 'cyl')
p2
subplot(p1, p2)

## 用一个字段来控制symbol参数
### 发现要将字段的值作为图例展示出来，要用factor()
### 颜色参数color也一样
p <- plot_ly(mpg, x = ~cty, y = ~hwy, alpha = 0.4)
p1 <- add_markers(p, symbol = ~cyl, name = 'cyl')
p1
p2 <- add_markers(p, symbol = ~factor(cyl), color = I('black'))
p2
subplot(p1, p2)

## color参数控制的color是离散的，colorbar函数控制连续的颜色
p1 <- add_markers(p, color = ~factor(cyl))
p1
p2 <- add_markers(p, color = ~cyl, showlegend = FALSE) %>% 
  colorbar(title = 'Viridis')
p2
subplot(p1, p2)

## 设置colorbar的色系colors
### 不设置colors参数，默认的色系
p2 <- add_markers(p, color = ~cyl) %>% 
  colorbar()
p2
### 设置colors参数，调整色系






# multiple Views ===========================================================
## 作用：在一个页面中摆放多张图

## htmlwidgets
## 用tagList()
p <- plot_ly(x = rnorm(100))
tagList(p, p)
## tagList报错了
p <- plot_ly(mpg, x = ~cty, y = ~hwy, alpha = 0.4)
p1 <- add_markers(p, symbol = ~cyl, name = 'cyl')
p2 <- add_markers(p, symbol = ~factor(cyl), color = I('black'))
tagList(p1, p2)

## 用tags
tags$div(
  tags$div(p1, style = "width:50%"), 
  tags$div(p2, style = "width:50%"), 
  tags$div(p, style = "width:100%")
)

## 用shiny
fluidPage(
  fluidRow(p), 
  fluidRow(
    column(width = 6, p1), 
    column(width = 6, p2)
  )
)

## plotly objects
head(economics)
p1 <- plot_ly(economics, x = ~date, y = ~unemploy) %>% 
  add_lines(name = 'unemploy')
p1
p2 <- plot_ly(economics, x = ~date, y = ~uempmed) %>% 
  add_lines(name = 'uempmed')
p2
## 单行多列
subplot(p1, p2)
## 多行单列
subplot(p1, p2, nrows = 2, shareX = TRUE)

# 多图联动 ================================================================

## 先创建共享数据集
sd <- SharedData$new(txhousing, ~year)
## 绘制联动图
p <- ggplot(sd, aes(x = month, y = median)) + 
  geom_line(aes(group = year)) + 
  facet_wrap(~city)
ggplotly(p, tooltip = 'year') %>% 
  highlight(defaultValues = 2015, color = 'red')

## 创建共享数据集
iris_sd <- SharedData$new(iris)
## 多图联动
p <- GGally::ggpairs(iris_sd, aes(color = Species), columns = 1:4)
highlight(ggplotly(p), on = "plotly_selected")

## 瞬时选择和永久选择(记录选择)
txh_sd <- SharedData$new(txhousing, ~city)
p <- ggplot(txh_sd, aes(x = date, y = median)) + 
  geom_line(alpha = 0.5)
p
gg <- ggplotly(p, tooltip = 'city')
gg
p1 <- highlight(gg, on = 'plotly_hover', dynamic = TRUE)
p2 <- highlight(gg, on = 'plotly_hover', dynamic = TRUE, persistent = TRUE)
subplot(p1, p2)

gg2 <- plot_ly(txhousing, x = ~date, y = ~median) %>% 
  add_lines(color = ~city, colors = 'black', alpha = 0.5)
highlight(gg2, on = 'plotly_hover', dynamic = TRUE)


## 
quakes_sd <- SharedData$new(quakes)
options(persistent = TRUE)
p1 <- plot_ly(quakes_sd, x = ~depth, y = ~mag) %>% 
  add_markers(alpha = 0.5) %>% 
  highlight(on = 'plotly_selected', dynamic = TRUE)
p2 <- leaflet(quakes_sd) %>% 
  addTiles() %>% 
  addCircles()
bscols(widths = c(6, 6), p1, p2)
## 有个问题：右侧点的颜色没有和左侧的同步


## select
txh_sd <- SharedData$new(txhousing, ~city, group = 'Choose a city')
plot_ly(txh_sd, x = ~date, y = ~median) %>% 
  group_by(city) %>% 
  add_lines(text = ~city, hoverinfo = 'text') %>% 
  highlight(on = 'plotly_selected', persistent = TRUE, selectize = TRUE, color = 'red')
## 这个样例非常好，应用度很高

## 总图和分图联动
## 也是应用度非常高的图
txh_sd <- SharedData$new(txhousing, ~city, 'Select a city')
base <- plot_ly(txh_sd, color = I('black'), height = 400) %>% 
  group_by(city)
base
## 总图-bar
p1 <- base %>% 
  summarise(miss_n = sum(is.na(median))) %>% 
  filter(miss_n >= 1) %>% 
  arrange(miss_n) %>% 
  add_bars(x = ~miss_n, y = ~factor(city, levels = city), hoverinfo = 'x+y') %>% 
  layout(
    barmode = 'overlay', 
    xaxis = list(title = 'Number of months missing'), 
    yaxis = list(title = '')
  )
p1
## 分图-时间序列
p2 <- base %>% 
  add_lines(x = ~date, y = ~median, alpha = 0.3) %>% 
  layout(xaxis = list(title = ''))
p2
## 结合总图和分图，联动
subplot(p1, p2, titleX = TRUE, widths = c(0.3, 0.7)) %>% 
  layout(margin = list(l = 120)) %>% 
  hide_legend() %>% 
  highlight(dynamic = TRUE, selectize = TRUE)

## 动态汇总
### case_01
mtcars_sd <- SharedData$new(mtcars)
p1 <- plot_ly(mtcars_sd, x = ~mpg, y = ~disp) %>% 
  add_markers(color = I('black'))
p1
p2 <- plot_ly(mtcars_sd, y = ~disp, color = I('black')) %>% 
  add_boxplot(name = 'overall')
p2
subplot(p2, p1, shareY = TRUE) %>% 
  hide_legend() %>% 
  highlight('plotly_selected')

### case_02
p2 <- plot_ly(mtcars_sd, x = ~factor(cyl)) %>% 
  add_histogram(color = I('black')) %>% 
  layout(xaxis = list(title = ''))
subplot(p2, p1) %>% 
  layout(barmode = 'overlay') %>% 
  hide_legend() %>% 
  highlight('plotly_selected')


# 动画图表 ============================================================






