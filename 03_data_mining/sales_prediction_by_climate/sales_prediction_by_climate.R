
# 0.说明 =============================================================================

## 利用天气预测销售
## 品牌：六町目
## 店铺：天河东方宝泰店
## 数据报告期：20160601 - 20180331

library(tidyverse)
library(lubridate)
library(recharts)
library(caret)


# 1.数据 =============================================================================

## 历史销售
thdfbt_sales <- read_csv(file = './thdfbt_sales.csv')
thdfbt_sales$p_day <- as.Date(thdfbt_sales$p_day)
str(thdfbt_sales)
View(thdfbt_sales)
tail(thdfbt_sales)

## 历史天气
weather_history <- read.csv(file = './weather_history.csv', 
                            header = TRUE, 
                            stringsAsFactors = FALSE, 
                            fileEncoding = 'gbk')
weather_history$date <- as.Date(weather_history$date)
weather_history$year <- year(weather_history$date)
weather_history$month <- month(weather_history$date)
str(weather_history)
View(weather_history)
tail(weather_history)

## 天气
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

## join

thdfbt_sales_weather <- left_join(x = thdfbt_sales, 
                                  y = weather_history, 
                                  by = c('p_day' = 'date'))

View(thdfbt_sales_weather)

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


# 回归分析 ==========================================================================
lm_model <- lm(sale_amount_index ~ high_degree + low_degree, 
               data = thdfbt_sales_weather)

attributes(lm_model)

# ===================================================================================



# ===================================================================================




