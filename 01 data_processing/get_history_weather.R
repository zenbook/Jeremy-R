# 加载包 ================================================================
library(rvest)
library(tidyverse)

# 1. 方法1 不编写函数 ===================================================
## 设置参数
city <- 'guangzhou'
month <- '201803'
baseurl <- 'http://lishi.tianqi.com/'
url <- paste(baseurl, city, '/', month, '.html', sep = '')
## 解析天气
weather <- url %>% 
  read_html(encoding = 'GBK') %>% 
  html_nodes('div.tqtongji2') %>% 
  html_nodes('ul') %>% 
  html_text() %>% 
  strsplit("\\s{4,}")
## 转成dataframe
weather <- unlist(weather[-1]) %>% 
  matrix(ncol = 6, byrow = TRUE) %>% 
  data.frame(stringsAsFactors = FALSE)
## 重命名列名称
names(weather) <- c('date', 'highdegree', 'lowdegree', 'weather', 'winddirection', 'windforce')
## 增加city
weather$city <- city

# 2. 方法2 编写getweather()函数 =========================================
getweather <- function(city, date){
  baseurl <- 'http://lishi.tianqi.com/'
  url <- paste(baseurl, city, '/', date, '.html', sep = '')
  ## 解析天气
  weather <- url %>% 
    read_html(encoding = 'GBK') %>% 
    html_nodes('div.tqtongji2') %>% 
    html_nodes('ul') %>% 
    html_text() %>% 
    strsplit("\\s{4,}")
  ## 转成dataframe
  weather <- unlist(weather[-1]) %>% 
    matrix(ncol = 6, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  ## 重命名列名称
  names(weather) <- c('date', 'highdegree', 'lowdegree', 'weather', 
                      'winddirection', 'windforce')
  ## 增加city
  weather$city <- city
  ## 返回数据
  return(weather)
}
guangzhou_201803 <- getweather('guangzhou', '201803')
guangzhou_201803

# 3. 方法3 写循环，批量爬取历史天气 =====================================
## 查询广州2011-2018各月天气(历史天气最早的年份是2011年)
## 设置year、month、city、baseurl
years <- c(2011:2012)
months <- c('01', '02', '03', '04', '05', '06', 
            '07', '08', '09', '10', '11', '12')
chinese_city_list <- read.csv("./chinese_city_list.csv", 
                              header = TRUE, 
                              stringsAsFactors = FALSE)
city <- chinese_city_list$name
baseurl <- 'http://lishi.tianqi.com/'
## 创建一个空数据框
weather_history <- data.frame(t(rep(NA,7)))[-1,]
names(weather_history) <- c('date', 'highdegree', 'lowdegree', 
                            'weather', 'winddirection', 'windforce', 'city')
## 循环，爬取天气数据
### 第一层：i，城市列表个数
for (i in 1:length(city)){
  ### 第二层：j，年份列表个数，2010-2018共9年
  for (j in 1:length(years)){
    ### 第三层：k，月份，12个月
    for (k in 1:length(months)){
      url <- paste(baseurl, city[i], '/', years[j], months[k], '.html', sep = '')
      ### 解析天气
      weather <- url %>% 
        read_html(encoding = 'GBK') %>% 
        html_nodes('div.tqtongji2') %>% 
        html_nodes('ul') %>% 
        html_text() %>% 
        strsplit("\\s{4,}")
      ### 转成dataframe
      weather <- unlist(weather[-1]) %>% 
        matrix(ncol = 6, byrow = TRUE) %>% 
        data.frame(stringsAsFactors = FALSE)
      ### 重命名列名称
      names(weather) <- c('date', 'highdegree', 'lowdegree', 
                          'weather', 'winddirection', 'windforce')
      weather$city <- city[i]
      ## 返回数据
      weather_history <- rbind(weather_history, weather)
    }
  }
}

# 4. 方法4 利用getweather()函数和循环 ==================================
for (i in 1:length(city)){
  for (j in 1:length(years)){
    for (k in 1:length(months)){
      weather <- getweather(city[i], paste0(years[j], months[k]))
      weather_history <- rbind(weather_history, weather)
    }
  }
}


# 5. 数据缺失说明 =====================================================
## 2011年1月缺失11天数据，日期范围是：17-25、27、28
weather_history$month <- substr(weather_history$date, 6, 7)
weather_history$year <- substr(weather_history$date, 1, 4)
weather_history %>% 
  filter(city == 'guangzhou', 
         year == '2011') %>% 
  group_by(month) %>% 
  summarise(dates = n())



# 参考文档
## https://segmentfault.com/a/1190000011498596
## https://blog.csdn.net/u012111465/article/details/76064223
