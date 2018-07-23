
# 0.说明 =============================================================================

## 利用天气预测销售
## 品牌：六町目
## 店铺：天河东方宝泰店
## 数据报告期：20160601 - 20180331

library(tidyverse)
library(lubridate)


# 1.数据 =============================================================================

## 历史销售
thdfbt_sales <- read_csv(file = './thdfbt_sales.csv')
str(thdfbt_sales)
View(thdfbt_sales)

## 历史天气
weather_history <- read.csv(file = './weather_history.csv', 
                            header = TRUE, 
                            stringsAsFactors = FALSE, 
                            fileEncoding = 'gbk')
weather_history$year <- year(weather_history$date)
str(weather_history)
View(weather_history)


x <- ymd('2017-10-1')

### 天气
weather_history %>% 
  group_by(year, weather) %>% 
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







# ===================================================================================



# ===================================================================================



# ===================================================================================