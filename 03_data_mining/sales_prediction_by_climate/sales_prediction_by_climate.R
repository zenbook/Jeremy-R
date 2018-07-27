
# 0.说明 =============================================================================

## 利用天气预测销售
## 品牌：六町目
## 店铺：天河东方宝泰店
## 数据报告期：20160601 - 20180331

library(tidyverse)
library(lubridate)
library(recharts)
library(caret)
library(e1071)


# 1.数据 =============================================================================

## 历史销售

### 导入数据
thdfbt_sales <- read_csv(file = './thdfbt_sales.csv')
thdfbt_sales$p_day <- as.Date(thdfbt_sales$p_day)

# sum(is.na(thdfbt_sales))

### 剔除以下的记录
### 1.1 剔除月初和月末：无法断定月末是否有"买"业绩、月初"退"业绩的现象，因此剔除；
### [已提前删除]
### 1.2 剔除节假日：暂未计算节假日的权重指数，因此剔除；
### [已提前删除]
### 1.3 销售额为0的记录；
thdfbt_sales <- thdfbt_sales[thdfbt_sales$sale_amount > 0,]

# str(thdfbt_sales)
# View(thdfbt_sales)
# tail(thdfbt_sales)

## 历史天气

### 导入数据
weather_history <- read.csv(file = './weather_history.csv', 
                            header = TRUE, 
                            stringsAsFactors = FALSE, 
                            fileEncoding = 'gbk')
weather_history$date <- as.Date(weather_history$date)
weather_history$year <- year(weather_history$date)
weather_history$month <- month(weather_history$date)

### 剔除缺失值
weather_history <- weather_history[weather_history$winddirection != '',]
weather_history <- weather_history[weather_history$windforce != '',]

# str(weather_history)
# View(weather_history)
# tail(weather_history)
# sum(is.na(weather_history))

### 天气
weather_history %>% 
  group_by(year, weather_level2, weather_new2) %>% 
  summarise(record_n = n()) %>% 
  spread(year, record_n)

### 风向
weather_history %>% 
  group_by(winddirection) %>% 
  summarise(record_n = n()) %>% 
  arrange(-record_n)
### 风力大小
weather_history %>% 
  group_by(windforce) %>% 
  summarise(record_n = n()) %>% 
  arrange(-record_n)

## join销售和天气，保留既有销售又有天气的记录
thdfbt_sales_weather <- inner_join(x = thdfbt_sales, 
                                   y = weather_history, 
                                   by = c('p_day' = 'date'))

# str(thdfbt_sales_weather)
# sum(is.na(thdfbt_sales_weather))
# View(thdfbt_sales_weather)

### 把数据写出到本地
write.csv(thdfbt_sales_weather, 
          './thdfbt_sales_weather.csv', 
          fileEncoding = 'gbk', 
          row.names = FALSE)

# 可视化分析 ========================================================================

## 高温、低温 VS 销售额
thdfbt_sales_weather %>% 
  filter(p_day >= '2018-03-01') %>% 
  select(p_day, high_degree, low_degree, sale_amount_index) %>% 
  gather(param, value, -p_day) %>% 
  echartr(x = p_day, 
          y = value, 
          param, 
          type = 'curve') %>% 
  setSymbols('emptycircle') %>% 
  setYAxis(axisLine = list(lineStyle = lineStyle(width = 0)), 
           min = 0, 
           name = 'Temp') %>% 
  setY1Axis(series = 'sale_amount_index', 
            axisLine = list(lineStyle = lineStyle(width = 0)), 
            min = 0, 
            name = 'sale_amount')

## 各类天气的天数和平均销售额

thdfbt_sales_weather %>% 
  group_by(year, weather_level, weather_new) %>% 
  summarise(record_n = n(), 
            avg_high = mean(high_degree), 
            avg_low = mean(low_degree), 
            avg_sales = mean(sale_amount_index)) %>% 
  filter(year == 2016) %>% 
  echartr(x = weather_level, 
          y = avg_sales, 
          type = 'column')

thdfbt_sales_weather %>% 
  filter(weather_new == '暴雨', 
         year == 2017) %>% 
  View()
  
## 星期平均销售(剔除指数影响)
thdfbt_sales_weather %>% 
  group_by(year, day_of_week) %>% 
  summarise(record_n = n(), 
            avg_high = mean(high_degree), 
            avg_low = mean(low_degree), 
            avg_sales = mean(sale_amount), 
            avg_sales_index = mean(sale_amount_index)) %>% 
  echartr(x = day_of_week, 
          y = avg_sales_index, 
          type = 'column') %>% 
  setYAxis(min = 0)


# 线性回归分析 =====================================================================

lm_model <- lm(sale_amount_index ~ high_degree + low_degree, 
               data = thdfbt_sales_weather)

thdfbt_sales_weather[1:10, 'sale_amount_index']
lm_model$fitted.values[1:10]

rmse <- function(error){
  sqrt(mean(error^2))
}
rmse(lm_model$residuals)








# 支持向量回归分析 ==================================================================

svr_model <- svm(sale_amount_index ~ high_degree + low_degree, 
                 data = thdfbt_sales_weather)
rmse(svr_model$residuals)

# ===================================================================================




