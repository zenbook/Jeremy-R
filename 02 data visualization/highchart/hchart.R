
# load packages and datasets------------------------------------------
data(diamonds, economics_long, mpg, package = "ggplot2")
library(dplyr)
library(tidyr)
library(highcharter)
library(broom)
library(ggplot2)

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


highchart() %>% 
  hc_chart(type = "line") %>% 
  hc_title(text = "Monthly Average Temperature") %>% 
  hc_subtitle(text = "Source: WorldClimate.com") %>% 
  hc_xAxis(categories = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) %>% 
  hc_yAxis(title = list(text = "Temperature (C)")) %>% 
  hc_plotOptions(line = list(
    dataLabels = list(enabled = TRUE),
    enableMouseTracking = FALSE)
  ) %>% 
  hc_series(
    list(
      name = "Tokyo",
      data = c(7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6)
    ),
    list(
      name = "London",
      data = c(3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8)
    )
  )


# 面积图 ---------------------------------------------------------
highchart() %>% 
  hc_chart(type = "area") %>% 
  hc_title(text = "Historic and Estimated Worldwide Population Distribution by Region") %>% 
  hc_subtitle(text = "Source: Wikipedia.org") %>% 
  hc_xAxis(categories = c("1750", "1800", "1850", "1900", "1950", "1999", "2050"),
           tickmarkPlacement = "on",
           title = list(enabled = FALSE)) %>% 
  hc_yAxis(title = list(text = "Percent")) %>% 
  hc_tooltip(pointFormat = "<span style='color:{series.color}'>{series.name}</span>:
             <b>{point.percentage:.1f}%</b> ({point.y:,.0f} millions)<br/>",
             shared = TRUE) %>% 
  hc_plotOptions(area = list(
    stacking = "percent",
    lineColor = "#ffffff",
    lineWidth = 1,
    marker = list(
      lineWidth = 1,
      lineColor = "#ffffff"
    ))
  ) %>% 
  hc_add_series(name = "Asia", data = c(502, 635, 809, 947, 1402, 3634, 5268)) %>% 
  hc_add_series(name = "Africa", data = c(106, 107, 111, 133, 221, 767, 1766)) %>%
  hc_add_series(name = "Europe", data = c(163, 203, 276, 408, 547, 729, 628)) %>% 
  hc_add_series(name = "America", data = c(18, 31, 54, 156, 339, 818, 1201)) %>% 
  hc_add_series(name = "Oceania", data = c(2, 2, 2, 6, 13, 30, 46)) %>% 
  hc_add_theme(hc_theme_monokai())

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

# 饼图 ---------------------------------------------------------------
mpg2 <- mpg
mpg2$id <- rownames(mpg2)
hchart(fy_cat1, 'pie', hcaes(x = cat1, y = num)) %>% 
  hc_add_theme(hc_theme_darkunica())

# 雷达图 -------------------------------------------------------------
highchart() %>% 
  hc_chart(polar = TRUE, type = "line") %>% 
  hc_title(text = "Budget vs Spending") %>% 
  hc_xAxis(categories = c("Sales", "Marketing", "Development",
                          "Customer Support",  "Information Technology",
                          "Administration"),
           tickmarkPlacement = "on",
           lineWidth = 0) %>% 
  hc_yAxis(gridLineInterpolation = "polygon",
           lineWidth = 0,
           min = 0) %>% 
  hc_series(
    list(
      name = "Allocated Budget",
      data = c(43000, 19000, 60000, 35000, 17000, 10000),
      pointPlacement = "on"
    ),
    list(
      name = "Actual Spending",
      data = c(50000, 39000, 42000, 31000, 26000, 14000),
      pointPlacement = "on"
    )
  ) %>% 
  hc_add_theme(hc_theme_monokai())


# 气泡图 + 拟合曲线 -----------------------------------------
set.seed(123)
data <- sample_n(diamonds, 300)
modlss <- loess(price ~ carat, data = data)
fit <- arrange(augment(modlss), carat)
head(fit)
highchart() %>% 
  hc_add_series(data, type = 'scatter',
                hcaes(x = carat, y = price, size = depth, group = cut)) %>% 
  hc_add_series(fit, type = 'spline', hcaes(x = carat, y = .fitted),
                name = "Fit", id = 'fit') %>% 
  hc_add_series(fit, type = 'arearange',
                hcaes(x = carat, low = .fitted - 2*.se.fit, high = .fitted + 2*.se.fit),
                linkedTo = 'fit')

# 热力图heatmap ---------------------------------------------
dfdiam <- diamonds %>% 
  group_by(cut, clarity) %>% 
  summarize(price = mean(price))
hchart(dfdiam, type = 'heatmap', hcaes(x = cut, y = clarity, value = price))

# 曲线图-时间序列图 -----------------------------------------
data("economics_long")
eco <- filter(economics_long, variable %in% c('pop', 'uempmed', 'unemploy'))
hchart(eco, type = 'line', hcaes(x = date, y = value01, group = variable))

# 树图treemap -----------------------------------------------
data(mpg)
## 数据处理，得到的结果是：每个厂家的车辆数n/车型数model
mpgman <- mpg %>% 
  group_by(manufacturer) %>% 
  summarise(n = n(),
            unique = length(unique(model))) %>% 
  arrange(-n, -unique)
head(mpgman)
hchart(mpgman, 'treemap', hcaes(x = manufacturer, value = n, color = unique))

# 条形图 ----------------------------------------------------
mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, 'bar', hcaes(x = manufacturer, y = n, group = year),
       color = c('#0070c0', '#ed7d31'),
       name = c('year 1999', 'year 2008'))
  

library(quantmod)

x <- getSymbols("GOOG", auto.assign = FALSE)
hchart(x[, c(1:2)])


day_amount$ORDER_DATE <- parse_date_time(day_amount$ORDER_DATE, orders = c('Ymd', 'mdy', 'dmY', 'ymd'))

highchart() %>% 
  hc_add_series(
    day_amount, 
    type = 'line', 
    hcaes(x = ORDER_DATE, y = AMOUNT, group = VENDOR_CODE)
  ) %>% 
  hc_add_theme(hc_theme_monokai())

# 把hchart保存为html文件
x <- highcharts_demo() %>% 
  hc_add_theme(hc_theme_monokai())
saveWidget(x, 'hchart.html')


# 建多个Y轴坐标 hc_yAxis_multiples + create_yaxis ------------------------------------------
highchart() %>% 
  hc_yAxis_multiples(
    create_yaxis(
      naxis = 2,  # 创建2个Y轴坐标
      heights = c(2, 1), # 两个坐标的高度比例为2:1
      title = list(text = NULL), # 设置Y轴坐标标题为空(无标题)
      lineWidth = 1, # 设置Y轴线宽度为1
      sep = 0.05 # 设置坐标轴之间的间隙宽度,百分比形式
    )
  ) %>% 
  hc_add_series( # 新增一个数据序列，放在第一个Y轴坐标上
    data = c(1, 3, 2), 
    yAxis = 0 # 创建的Y轴坐标序号从0开始，0代表第一个
  ) %>% 
  hc_add_series( # 新增一个数据序列，放在第二个Y轴坐标上
    type = 'column',
    data = c(20, 40, 10),
    yAxis = 1
  ) %>% 
  hc_add_theme(hc_theme_darkunica())

highchart() %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_yAxis_multiples(
    create_yaxis(naxis = 3, sep = 0.05, lineWidth = 1, title = list(text = NULL))
  ) %>% 
  hc_add_series(data = c(1, 3, 2)) %>% 
  hc_add_series(data = c(20, 40, 10), yAxis = 1) %>% 
  hc_add_series(data = c(200, 400, 500), type = 'column', yAxis = 2) %>% 
  hc_add_series(data = c(500, 300, 400), type = 'column', yAxis = 2)

highchart() %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_yAxis_multiples(create_yaxis(naxis = 3, sep = 0.05, lineWidth = 1, title = list(text = NULL))) %>% 
  hc_add_series(day_amount, 'spline', hcaes(x = ORDER_DATE, y = AMOUNT, group = VENDOR_CODE)) %>% 
  hc_add_series(day_amount, 'spline', hcaes(x = ORDER_DATE, y = CUST_NUM, group = VENDOR_CODE), yAxis = 1) %>% 
  hc_add_series(day_amount, 'spline', hcaes(x = ORDER_DATE, y = MAS_NUM, group = VENDOR_CODE), yAxis = 2) %>% 
  hc_plotOptions(
    spline = list(marker = FALSE, lineWidth = 4)
  ) %>% 
  hc_tooltip(table = TRUE, sort = TRUE)


library("quantmod")
usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
dates <- as.Date(c("2016-05-08", "2016-09-12"), format = "%Y-%m-%d")
highchart(type = "stock") %>%
hc_add_series_xts(usdjpy, id = "usdjpy") %>%
hc_add_series_flags(dates,
title = c("E1", "E2"),
text = c("This is event 1", "This is the event 2"),
id = "usdjpy")






highchart(type = 'stock') %>% 
  hc_add_theme(hc_theme_monokai()) %>% 
  hc_yAxis_multiples(create_yaxis(naxis = 3, sep = 0.05, lineWidth = 1, title = list(text = NULL))) %>% 
  hc_add_series_xts(day2[,1], name = 'amount') %>% 
  hc_add_series_xts(day2[,3], name = 'cust_num', yAxis = 1) %>% 
  hc_add_series_xts(day2[,4], name = 'mas_num', yAxis = 2)
  
highchart(type = 'stock') %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_yAxis_multiples(
    list(top = '0%', height = '33%', title = list(text = '成交金额'), position = 'left'),
    list(top = '33%', height = '33%', title = list(text = '客户数')),
    list(top = '66%', height = '34%', title = list(text = '成交笔数'))
  ) %>% 
  hc_add_series(day_amount_fy[, 1], name = 'fy_amount', color = '#2B908F') %>% 
  hc_add_series(day_amount_fy[, 2], name = 'fy_cust_num', color = '#2B908F', yAxis = 1) %>% 
  hc_add_series(day_amount_fy[, 3], name = 'fy_mas_num', color = '#2B908F', yAxis = 2) %>% 
  hc_add_series(day_amount_tl[, 1], name = 'tl_amount', color = '#90EE7E', yAxis = 0) %>% 
  hc_add_series(day_amount_tl[, 2], name = 'tl_cust_num', color = '#90EE7E', yAxis = 1) %>% 
  hc_add_series(day_amount_tl[, 3], name = 'tl_mas_num', color = '#90EE7E', yAxis = 2)

hcts(day_amount_fy[,1])


