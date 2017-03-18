
# load packages and datasets------------------------------------------
data(diamonds, economics_long, mpg, package = "ggplot2")
library(dplyr)
library(tidyr)
library(highcharter)

# use hchart() function-----------------------------------------------
hchart(mpg, 'scatter', hcaes(x = cty, y = displ, group = drv))

# use highchart API---------------------------------------------------
highchart() %>% 
  hc_chart(type = 'column') %>% 
  hc_title(text = 'A highcharter chart') %>% 
  hc_xAxis(categories = 2012:2016) %>% 
  hc_add_series(data = c(3900, 4300,5700, 8500, 11900), name = 'users') %>% 
  hc_add_theme(hc_theme_economist())

# highchart绘图步骤---------------------------------------------------
data("citytemp")
head(citytemp)
highchart() %>% 
  hc_add_series(name = 'tokyo', data = citytemp$tokyo) %>% # 添加数据系列
  hc_title(text = 'city temperatrue') %>% # 添加标题
  hc_subtitle(text = 'this is the subtitle') %>% # 添加副标题
  hc_xAxis(categories = citytemp$month) %>% # 设置x轴坐标系列名称
  hc_add_series(name = 'new york', data = citytemp$new_york, type = 'spline') %>% 
  hc_add_series(name = 'london', data = citytemp$london) %>% 
  hc_yAxis(title = list(text = 'Temperature'), labels = list(format = '{value}℃'))  %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_tooltip(table = TRUE, sort = TRUE)
  
# 不同类型的字段产生不同类型的图形------------------------------------
## character data
hchart(diamonds$cut, colorByPoint = TRUE, name = 'cut') %>% 
  hc_title(text = 'character data')
## numeric data
hchart(diamonds$price, color = '#B71C1C', name = 'price') %>% 
  hc_title(text = 'numeric data')

# highchart with forecast---------------------------------------------
library(forecast)
dataset <- forecast(auto.arima(AirPassengers), level = 95)
hchart(dataset)

# highstock-----------------------------------------------------------
library(quantmod)
x <- getSymbols('GOOG', auto.assign = FALSE)
y <- getSymbols('AMZN', auto.assign = FALSE)
highchart(type = 'stock') %>% 
  hc_add_series(x) %>% 
  hc_add_series(y, type = 'ohlc')

# highmaps------------------------------------------------------------
# 有点问题
data("unemployment")
str(unemployment)
hcmap('countries/us/us-all-all', data = unemployment, name = 'unemployment',
      value = 'value', joinBy = c('hc_key', 'code'), borderColor = 'transparent') %>% 
  hc_colorAxis(dataClasses = color_classes(c(seq(0, 10, by = 2), 50))) %>% 
  hc_legend(layout = 'vertical', align = 'right', floating = TRUE,
            valueDecimal = 0, valueSuffix = '%')

# 一个非常好的示例----------------------------------------------------
hchart(airquality, 'line', hcaes(x = as.factor(Day), y = Temp, group = Month),
       color = c("#e5b13a", "#4bd5ee", "#4AA942", "#FAFAFA", "#B71C1C")) %>% 
  hc_title(text = 'A <span style="color:#e5b13a">very good</span> case!', useHTML = TRUE) %>% 
  hc_tooltip(table = TRUE, sort = TRUE) %>% 
  hc_credits(enabled = FALSE) %>% 
  hc_add_theme(
    hc_theme_flatdark(
      chart = list(
        backgroundColor = 'transparent',
        divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
      )
    )
  )


# 散点图--------------------------------------------------------------
hchart(mpg, "scatter", hcaes(x = displ, y = hwy, group = class))

table(mpg$drv)
str(mpg)
hchart(mpg$displ)
hchart(diamonds$price)
highcharts_demo() %>% 
  hc_add_theme(hc_theme_monokai())


# 把hchart保存为html文件
x <- highcharts_demo() %>% 
  hc_add_theme(hc_theme_monokai())
saveWidget(x, 'hchart.html')
