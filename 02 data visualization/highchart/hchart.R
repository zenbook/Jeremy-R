
# load packages ------------------------------------------------------
library(dplyr)
library(tidyr)
library(highcharter)
library(broom)
library(forecast)
library(ggplot2)
library(quantmod)
library(treemap)
library(viridis)

# load datasets ------------------------------------------------------

# use hchart() function-----------------------------------------------
hchart(mpg, 'scatter', hcaes(x = cty, y = displ, group = drv))

# use highchart ------------------------------------------------------
highchart() %>% 
  hc_chart(type = 'column') %>% 
  hc_title(text = 'A highcharter chart') %>% 
  hc_xAxis(categories = 2012:2016) %>% 
  hc_add_series(data = c(3900, 4300,5700, 8500, 11900), name = 'users') %>% 
  hc_add_theme(hc_theme_flat())

# highchart绘图步骤---------------------------------------------------
## demo
highcharts_demo()
## citytemp
highchart() %>% 
  hc_title(text = 'city temperatrue') %>% # 添加标题
  hc_subtitle(text = 'this is the subtitle') %>% # 添加副标题
  hc_xAxis(categories = citytemp$month) %>% # 设置x轴坐标系列名称
  hc_yAxis(title = list(text = 'Temperature'), labels = list(format = '{value}℃'))  %>% 
  hc_add_series(name = 'tokyo', data = citytemp$tokyo) %>% # 添加数据系列
  hc_add_series(name = 'new york', data = citytemp$new_york) %>% # 添加数据序列
  hc_add_series(name = 'london', data = citytemp$london) %>% # 添加数据序列
  hc_add_theme(hc_theme_darkunica()) %>% # 添加主题
  hc_tooltip(table = TRUE, sort = TRUE) # 设置工具提示

# 建多个Y轴坐标 hc_yAxis_multiples + create_yaxis ---------------------
highchart() %>% 
  hc_yAxis_multiples(
    create_yaxis(naxis = 2,  # 创建2个Y轴坐标
                 heights = c(2, 3), # 两个坐标的高度比例为2:1
                 title = list(text = NULL), # 设置Y轴坐标标题为空(无标题)
                 lineWidth = 1, # 设置Y轴线宽度为1
                 sep = 0.10, # 设置坐标轴之间的间隙宽度,百分比形式
                 turnopposite = FALSE # 默认是TRUE,控制y轴的位置是否调转一下
                 )) %>% 
  # 新增一个数据序列，放在第一个Y轴坐标上
  hc_add_series(data = c(1, 3, 2, 5, 1, 7), 
                yAxis = 0 # 创建的Y轴坐标序号从0开始，0代表第一个
                ) %>% 
  # 新增一个数据序列，放在第二个Y轴坐标上
  hc_add_series(type = 'column',  # 图表类型改成柱形图
                data = c(20, 40, 10, 59, 23, 13),
                yAxis = 1) %>% 
  # 调整一下主题颜色
  hc_add_theme(hc_theme_flat()) %>% 
  # 添加图表标题
  hc_title(text = 'THIS IS TITLE')

highchart() %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_yAxis_multiples(
    create_yaxis(naxis = 3, sep = 0.05, lineWidth = 1, title = list(text = NULL))
  ) %>% 
  hc_add_series(data = c(1, 3, 2)) %>% 
  hc_add_series(data = c(20, 40, 10), yAxis = 1) %>% 
  hc_add_series(data = c(200, 400, 500), type = 'column', yAxis = 2) %>% 
  hc_add_series(data = c(500, 300, 400), type = 'column', yAxis = 2)
  
# 不同类型的字段产生不同类型的图形------------------------------------
## character data
hchart(diamonds$cut, colorByPoint = TRUE, name = 'cut') %>% 
  hc_title(text = 'character data')
## numeric data
hchart(diamonds$price, color = '#B71C1C', name = 'price') %>% 
  hc_title(text = 'numeric data')

# 柱形图 type = 'column' ----------------------------------------------
hchart(favorite_bars, 'column', hcaes(x = bar, y = percent)) %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_xAxis(title = list(text = NULL)) %>% 
  hc_title(text = 'My favorite bars') %>% 
  hc_yAxis(title = list(text = NULL))

highchart() %>% 
  hc_add_series(favorite_bars$percent, type = 'column', name = 'percent') %>% 
  hc_xAxis(categories = favorite_bars$bar) %>% 
  hc_add_theme(hc_theme_darkunica())

# 条形图 ---------------------------------------------------------------
## hcbar() 快捷函数
hcbar(favorite_bars$bar, favorite_bars$percent)

# 箱线图 ---------------------------------------------------------------
hcboxplot(iris$Sepal.Length, var = iris$Species, color = 'red') %>% 
  hc_add_theme(hc_theme_flat())

highchart() %>% 
  hc_add_series_boxplot(iris$Sepal.Length, iris$Species) %>% 
  hc_add_theme(hc_theme_flat())


# 密度图 ---------------------------------------------------------------
hcdensity(iris$Sepal.Length)

# icon图 ---------------------------------------------------------------
hciconarray(c('nice', 'good'), c(10, 20))
hciconarray(c('nice', 'good'), c(10, 20), size = 10)
hciconarray(c('nice', 'good'), c(10, 20), icons = 'child')
hciconarray(c('car', 'truck', 'plane'), c(10, 20, 45), icons = c('car', 'truck', 'plane'))
hciconarray(c('plane', 'truck', 'car'), c(35, 20, 10), icons = c('plane', 'truck', 'car')) %>% 
  hc_add_theme(hc_theme_merge(hc_theme_flatdark(), 
                              hc_theme_null(chart = list(backgroundColor = '#34495e'))))

# 地图 hcmap -----------------------------------------------------------
# https://code.highcharts.com/mapdata/
data("USArrests", package = 'datasets')
usarrests <- mutate(USArrests, 'woe-name' = rownames(USArrests))
hcmap(map = 'countries/us/us-all', 
      data = usarrests, 
      joinBy = 'woe-name', 
      value = 'UrbanPop', 
      name = 'Urban Population')
hcmap(map = 'countries/us/us-all',
      data = usarrests,
      joinBy = 'woe-name',
      value = 'UrbanPop',
      name = 'Urban Population',
      download_map_data = TRUE)

# 饼图 -----------------------------------------------------------------
## hcpie() 快捷绘图 ----------------------------------
hcpie()

highchart() %>% 
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_title(text = 'This is title') %>% 
  hc_add_series_labels_values(favorite_bars$bar, 
                              favorite_bars$percent, 
                              type = 'pie',
                              colorByPoints = TRUE,
                              dataLabels = list(enabled = FALSE)
  ) %>% 
  hc_xAxis(categories = favorite_bars$bar) %>% 
  hc_legend(align = 'left') %>% 
  hc_tooltip(pointFormat = "数量占比：{point.y}%")

# Sparklines -----------------------------------------------------------
x <- cumsum(rnorm(10))
hcspark(x) # 折线图，默认
hcspark(x, 'column') # 柱形图
hcspark(c(1, 4, 5, 2, 9), 'pie') # 饼图
hcspark(x, type = 'area') # 面积图

# 树图treemap ----------------------------------------------------------
## hctreemap() 
data("GNI2014")
tm <- treemap(GNI2014, 
              index = c('continent', 'iso3'),
              vSize = 'population',
              vColor = 'GNI',
              type = 'comp',
              palette = rev(viridis(6)),
              draw = FALSE)
hctreemap(tm,
          allowDrillToNode = TRUE,
          layoutAlgorithm = 'squarified') %>% 
  hc_title(text = 'Gross National Income World Data') %>% 
  hc_tooltip(pointFormat = "<b>{point.name}</b>:<br>
                            Pop:{point.value:,.0f}<br>
                            GNI:{point.valuecolor:,.0f}")
## hchart()  
mpgman <- mpg %>%  ## 数据处理，得到的结果是：每个厂家的车辆数n/车型数model
  group_by(manufacturer) %>% 
  summarise(n = n(),
            unique = length(unique(model))) %>% 
  arrange(-n, -unique)
hchart(mpgman, 'treemap', hcaes(x = manufacturer, value = n, color = unique))

# hcts() 时间序列或折线图 -----------------------------------------------
hcts(c(1, 5, 2, 10, 5, 20))


# 折线图 ----------------------------------------------------------------
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

highchart() %>%
  hc_xAxis(categories = citytemp$month) %>%
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>%
  hc_add_series(name = "London", data = citytemp$london) %>%
  hc_legend(align = "left", verticalAlign = "top",
            layout = "vertical", x = 0, y = 100)

# 散点图 + 气泡图 --------------------------------------------------------
## hchart()
### 散点图
hchart(mtcars, 'scatter', hcaes(x = wt, y = mpg))
### 气泡图
hchart(mtcars, "scatter", hcaes(x = wt, y = mpg, z = drat, color = hp))
## highchart()
### 散点图
highchart() %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg)
### 气泡图
highchart() %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$hp)

# 面积图 ------------------------------------------------------------------
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

# hc_add_series() ------------------------------------------------------------
highchart() %>% 
  hc_add_series(data = abs(rnorm(5)), 
                type = 'column',
                color = 'orange') %>% 
  hc_add_series(data = purrr::map(0:4, function(x)list(x, x)), 
                type = 'scatter', 
                color = 'blue')



# highstock() -----------------------------------------------------------------
x <- getSymbols('GOOG', auto.assign = FALSE)
y <- getSymbols('AMZN', auto.assign = FALSE)
highchart(type = 'stock') %>% 
  hc_add_series(x) %>% 
  hc_add_series(y, type = 'ohlc')
# hc_add_series_flags
usdjpy <- getSymbols("USD/JPY", src="oanda", auto.assign = FALSE)
dates <- as.Date(c("2016-05-08", "2016-09-12"), format = "%Y-%m-%d")
highchart(type = "stock") %>%
  hc_add_series_xts(usdjpy, id = "usdjpy") %>%
  hc_add_series_flags(dates,
                      title = c("E1", "E2"),
                      text = c("This is event 1", "This is the event 2"),
                      id = "usdjpy")



# highchart with forecast---------------------------------------------

dataset <- forecast(auto.arima(AirPassengers), level = 95)
hchart(dataset)


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
      pointPlacement = "on"),
    list(
      name = "Actual Spending",
      data = c(50000, 39000, 42000, 31000, 26000, 14000),
      pointPlacement = "on")
  ) %>% 
  hc_add_theme(hc_theme_darkunica())





# 热力图heatmap ---------------------------------------------
dfdiam <- diamonds %>% 
  group_by(cut, clarity) %>% 
  summarize(price = mean(price))
hchart(dfdiam, type = 'heatmap', hcaes(x = cut, y = clarity, value = price))

# 曲线图-时间序列图 -----------------------------------------
data("economics_long")
eco <- filter(economics_long, variable %in% c('uempmed', 'unemploy'))
hchart(eco, type = 'line', hcaes(x = date, y = value01, group = variable))



# 条形图 ----------------------------------------------------
mpgman2 <- count(mpg, manufacturer, year)
hchart(mpgman2, 
       'bar', 
       hcaes(x = manufacturer, y = n, group = year),
       color = c('#0070c0', '#ed7d31'),
       name = c('year 1999', 'year 2008')) %>% 
  hc_add_theme(hc_theme_flat())



x <- getSymbols("GOOG", auto.assign = FALSE)
hchart(x[, c(1:2)])


# 把hchart保存为html文件 ------------------------------------
x <- highcharts_demo() %>% 
  hc_add_theme(hc_theme_monokai())
saveWidget(x, 'hchart.html')








library(PerformanceAnalytics)

data(edhec)
R <- edhec[, 1:3]

hc <- highchart(type = "stock")
hc <- hc_yAxis_multiples(hc, create_yaxis(naxis = 3, heights = c(2,1,1)))

for(i in 1:ncol(R)) {
  hc <- hc_add_series(hc, R[, i], yAxis = i - 1, name = names(R)[i])
}

hc <- hc_scrollbar(hc, enabled = TRUE) %>%
  hc_add_theme(hc_theme_flat())

hc


axis <- create_yaxis(naxis = 3, heights = c(2,1,1))
names <- c("A", "B", "C") 
newaxis <- purrr::map2(axis, names, function(x, y){x$title <- list(text = y);x}) 
newaxis <- purrr::map2(axis, names, function(x, y){x$title <- y;x}) 


hc_yAxis_multiples(newaxis)
hc <- highchart(type = "stock")
hc <- hc_yAxis_multiples(newaxis)

for(i in 1:ncol(R)) {
  hc <- hc_add_series(hc, R[, i], yAxis = i - 1, name = names(R)[i])
}

hc <- hc_scrollbar(hc, enabled = TRUE) %>%
  hc_add_theme(hc_theme_flat())

hc

highchart(type = 'stock') %>%   
  hc_title(text = 'title')%>%  #图标标题  
  hc_add_theme(hc_theme_darkunica()) %>% 
  hc_yAxis_multiples(  
    list(top = "0%", height = "30%", lineWidth = 1,  
         title = list(text = "y轴标题（上面）"),  
         labels = list(format = "{value}%", rotation = 30 )  
    ),     
    #设置上半部分y轴坐标属性，高度30%，线宽1，标签为%格式，标签倾斜30度  
    list(top = "30%", height = "70%",showFirstLabel = T,   
         showLastLabel = F, offset = 0,  
         title = list(text = "y轴标题（下面）"),  
         labels = list(format = "{value}"))         
    #设置下半部分y轴坐标属性，顶端从30%的高度开始，整体高度70%，不显示第一个标签和最后一个标签  
  ) %>% 
  hc_add_series(day_amount_fy[,1], name = 'amount') %>% 
  hc_add_series(day_amount_fy[,2], name = 'cust_num', yAxis = 1)


axis1 <- create_yaxis(naxis = 3, heights = c(2,1,1), title = list(text =NULL))


highchart() %>%
  hc_add_series(data = abs(rnorm(5)), type = "column") %>%
  hc_add_series(data = purrr::map(0:4, function(x) list(x, x)), type = "scatter", color = "blue")


append(list(a=1,b=2), list(c=3,d=4)) 

merge(list(a=1, b="test"), list('hh'))

births %>% 
  filter(between(year, 2013, 2014)) %>% 
  filter(date_of_month %in% c(6, 13, 20)) %>% 
  mutate(day = ifelse(date_of_month == 13, 'thirteen', 'not_thirteen')) %>% 
  group_by(day_of_week, day) %>% 
  summarise(mean_births = mean(births)) %>% 
  arrange(day_of_week)


caption = htmltools::tags$caption(
  style = 'caption-side:top; text-align:center; font-size:25px','奖金收入榜'
),

, 
initComplete = JS(
  "function(settings, json) {",
  "$(this.api().table().header()).css({'background-color': '#3C8DBC', 'color': '#fff', 
  'font-size':'13px'});",
  "}"
  )



highchart() %>% 
  hc_chart(type = 'column') %>% 
  hc_add_theme(hc_theme_flat()) %>% 
  hc_xAxis(categories = unique(bonus$NAME)) %>% 
  hc_add_series(data = bonus[bonus$QUOTA_NAME == '帮客户订货', 'BONUS'], 
                name = '帮客户订货') %>% 
  hc_add_series(data = bonus[bonus$QUOTA_NAME == '完成累计订货额', 'BONUS'], 
                name = '完成累计订货额') %>% 
  hc_add_series(data = bonus[bonus$QUOTA_NAME == '完善客户信息', 'BONUS'], 
                name = '完善客户信息') %>% 
  hc_plotOptions(column = list(stacking = 'normal'))


hchart(bonus[bonus$QUOTA_ID != 'ORDER1',], 'column',
       hcaes(x = NAME, y = BONUS, group = QUOTA_NAME)) %>% 
  hc_add_theme(hc_theme_flat()) %>% 
  hc_yAxis(title = list(text = ''), labels = list(format = '{value}元')) %>% 
  hc_xAxis(title = list(text = '')) %>% 
  hc_tooltip(table = TRUE, sort = TRUE) %>% 
  hc_plotOptions(column = list(stacking = 'normal'))


# 组合图 -----------------------------------------------------------
# hc_add_series_labels_values()
highchart() %>% 
  hc_title(text = 'THIS IS TITLE') %>% 
  hc_subtitle(text = 'THIS IS SUBTITLE') %>% 
  hc_add_series_labels_values(favorite_pies$pie, 
                              favorite_pies$percent, 
                              name = 'pie', 
                              colorByPoint = TRUE, 
                              type = 'column') %>% 
  hc_add_series_labels_values(favorite_bars$bar, 
                              favorite_bars$percent,
                              type = 'pie',
                              name = 'bar',
                              colors = substr(terrain.colors(5), 0, 7),
                              colorByPoint = TRUE,
                              center = c('35%', '10%'),
                              size = 100, 
                              dataLabels = list(enabled = FALSE)) %>% 
  hc_xAxis(categories = favorite_pies$pie) %>% 
  hc_yAxis(text = list('percent'),
           labels = list(format = '{value}%'),
           max = 100) %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_tooltip(pointFormat = '{point.y}%') %>% 
  hc_add_theme(hc_theme_flat())


# hc_add_series_df() 已过时，基本不用 -------------------------------------
# 使用dataframe绘制图形
n <- 50
df <- data_frame(
  x = rnorm(n),
  y = x * 2 + rnorm(n),
  w = x^2
)
hc_add_series_df(highchart(), 
                 data = df, 
                 type = 'point',
                 x = x, 
                 y = y)


