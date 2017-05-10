# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(tidyverse)
library(nycflights13)
data(flights)

# Filter rows with filter()  ==================================
filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
## 这种写法可以既显示数据，又保存到变量中:
(jan1 <- filter(flights, month == 1, day == 1))  

## >, <, >= , <=, ==, !=, %in%, between
## 注意：在判断是否等于时，用"=="而不是"="
## 当判断浮点数是否相等时，不能直接用"=="
sqrt(2)^2 == 2
1/49*49 == 1
## 可以改用near函数来判断是否相等
near(sqrt(2)^2, 2)
near(1/49*49, 1)
## %in%, x %in% y, 相当于sql中的in函数
filter(flights, month %in% c(11, 12))
## between(variable, left, right)
filter(flights, between(dep_time, 1200, 1300))

## &：and；|：or；!：not
filter(flights, month == 11 | month == 12)
filter(flights, month == 11 | 12)
## 摩根律
## !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y
## 查询延迟2个小时以上的航班，延迟起飞或延迟降落
filter(flights, arr_delay >= 120, dep_delay >= 120)

## missing values: NA
## NA 与任何数据都无法计算和比较，计算与所得结果都是NA
## filter时，只取结果为TRUE的记录，过滤FALSE和NA的记录
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
## 如果需要提取NA值的记录，则用is.na()
filter(df, is.na(x) | x >1) 

## exercises
filter(flights, arr_delay >= 120)
filter(flights, dest %in% c('IAH', 'HOU'))
filter(flights, month %in% c(7, 8, 9))
filter(flights, arr_delay >= 120, dep_delay <= 0)
filter(flights, (arr_delay >= 60 | dep_delay >= 60), air_time >= 30)
filter(flights, dep_time >= 0, dep_time <= 600)
filter(flights, between(dep_time, 0, 600))
sum(is.na(flights$dep_time))
NA ^ 0
NA * 0


# Arrange rows with arranges()  ==================================
## one variable
arrange(flights, dep_delay)
## multiple variables
arrange(flights, year, month, day)
## descending order
arrange(flights, desc(dep_delay))
arrange(flights, -dep_delay)
## missing values are always at the end
arrange(df, x)
arrange(df, -x)

## exercise
## how to arrange missing values at the top?
## missig value at top and ascending order
arrange(df, -is.na(x))
## missig value at top and descending order
arrange(df, -is.na(x), -x)

arrange(flights, -arr_delay)
arrange(flights, dep_delay)
arrange(flights, distance / air_time)
arrange(flights, distance)
arrange(flights, -distance)

# Select variables with select()  ==================================
## select multiple variables
select(flights, year, month, day)
select(flights, year:day)
## drop multiple variables
select(flights, -(year:day))
## tricks
starts_with('abc')
ends_with('abc')
contains('abc')
matchs('(.)\\1')  # regular expression
num_range('x', 1:3)  # x1, x2, x3
vars <- c('A', 'B', 'C')
one_of(vars)
## rename variables using rename(), keeping other variables
rename(flights, tail_num = tailnum)
## reorder variables using select() and everything()
select(flights, tailnum, everything())

## exercise
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with('dep'), starts_with('arr'))
select(flights, year, year)  # select year once, not twice
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
select(flights, contains('TIME'))  # not case sensitive

# Add new variables with mutate()  ==================================
## get a smaller dataframe
flight_sml <- select(flights, year:day, 
                     ends_with('delay'), 
                     distance, air_time)
## add new variables at the end of the dataframe
mutate(flight_sml, 
       gain = arr_delay - dep_delay, 
       speed = distance / air_time * 60)  # 每小时飞行多少英里
## 在同一个mutate()函数中，可以引用刚刚创建的新变量
mutate(flight_sml, 
       miles_per_minute = distance / air_time, 
       miles_per_hour = miles_per_minute * 60)
## only want to keep the new variables using transmute()
transmute(flight_sml, 
          gain = arr_delay - dep_delay, 
          speed_minute = distance / air_time, 
          spped_hour = speed_minute * 60)
## arithmetic operators: +, -, *, /, ^
## modular arithmetic: 
## %/%:整除，取整数，如:5%/%2 = 2
5 %/% 2
## %%:取余，如:5 %% 2 = 1
5 %% 2
transmute(flights, dep_time, 
          dep_hour = dep_time %/% 100, 
          dep_minur = dep_time %% 100)
## Logs: log(), log2(), log10()
## offsets:lead(): next value; lag(): previous value
x <- 1:10
lead(x)
lag(x)
## Cumulative and rolling aggregates: 
## cumsum(), cumprod(), cummin(), cummax(), cummean()
cumsum(x)
cumprod(x)
cummin(x)
cummax(x)
cummean(x)
## Logical comparisons, <, <=, >, >=, !=, ==
## ranking
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)  # 升序，最小值排第一, NA值不参与排名, 相同值排相同名次
min_rank(desc(y))  # 降序
row_number(y)  # 升序，最小值排第一, NA值不参与排名, 相同值排不同名次
row_number(desc(y))
dense_rank(y)  # 升序，最小值排第一, NA值不参与排名, 相同值排相同名次
dense_rank(desc(y))
percent_rank(y)
percent_rank(desc(y))
cume_dist(y)
ntile(y, 2)

## exercise
transmute(flights, 
          dep_time, 
          dep_time_new = (dep_time %/% 100 * 60) + dep_time %% 100, 
          sched_dep_time, 
          sched_dep_time_new = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100)
transmute(flights, 
          dep_time, 
          dep_time_new = (dep_time %/% 100 * 60) + dep_time %% 100, 
          arr_time, 
          arr_time_new = (arr_time %/% 100 * 60) + arr_time %% 100, 
          air_time, 
          air_time2 = arr_time_new - dep_time_new)

select(flights, dep_time, sched_dep_time, dep_delay)
flights %>% 
  select(tailnum, arr_delay) %>% 
  arrange(-arr_delay) %>% 
  mutate(arr_top = min_rank(desc(arr_delay))) %>% 
  filter(arr_top <=10)
## dep_delay = dep_time - sched_dep_time
1:3 + 1:10

# Grouped summaries data with summarise() and group_by()  =================
## one variable
summarise(flights, 
          delay = mean(dep_delay, na.rm = TRUE))
## multiple variables          
summarise(flights, 
          dep_delay = mean(dep_delay, na.rm = TRUE), 
          arr_delay = mean(arr_delay, na.rm = TRUE))
## use summarise with group_by()
by_month <- group_by(flights, year, month)
summarise(by_month, delay = mean(dep_delay, na.rm = TRUE))

## pipe
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest, 
                   count = n(), 
                   distance = mean(distance, na.rm = TRUE), 
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != 'HNL')
delay <- arrange(delay, distance, delay)
View(delay)
ggplot(data = delay, mapping = aes(x = distance, y = delay)) + 
  geom_point(aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)
## 从原始数据中看不出任何的规律
# ggplot(data = flights, mapping = aes(x = distance, y = arr_delay)) + 
#   geom_point(alpha = 1/5, position = 'jitter')
flights %>% 
  group_by(dest) %>% 
  summarise(count = n(),
            dist = mean(distance, na.rm = TRUE), 
            delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20,
         dest != 'HNL') %>% 
  ggplot(mapping = aes(x = dist, y = delay)) + 
  geom_point(aes(size = count), 
             alpha = 1/3) + 
  geom_smooth(se = FALSE)
  
## missing values
flights %>% 
  group_by(year, month) %>% 
  summarise(delay = mean(dep_delay))  # 如果不设置na.rm = TRUE,则分组中有NA的，结果也是NA
## 筛选非缺失值的数据
## dep_delay和arr_delay为NA的，即为取消的航班
not_cancelled_flights <- flights %>% 
  filter(!is.na(dep_delay), 
         !is.na(arr_delay))
not_cancelled_flights %>% 
  group_by(year, month) %>% 
  summarise(count = n(), 
            dist = mean(distance), 
            delay = mean(arr_delay))

## counts
## 做汇总时，最好带上计数n()或sum(!is.na())
not_cancelled_flights %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay)) %>% 
  ggplot(mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
## 从频率直方图上看，有的航班的延误时间达到了5个小时(300分钟)以上
## 但延迟这么长时间的航班数可能非常少，我们加入count来看一下
not_cancelled_flights %>% 
  group_by(tailnum) %>% 
  summarise(n = n(), 
            delay = mean(arr_delay)) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/5)
## 果然非常少(接近0)
## 我们排除飞行次数非常少的航班，再来看看数据分布情况
not_cancelled_flights %>% 
  group_by(tailnum) %>% 
  summarise(n = n(), 
            delay = mean(arr_delay)) %>% 
  filter(n > 30) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/5)
## 可以发现多数航班的延迟时间还是在-20-30之间
## 重复执行同一个代码块的技巧：Ctrl + Shift + P
## 1.ctrl + enter， 执行第一次， 如上面的代码
## 2.修改代码块中的部分代码，如:n > 25 改成 n > 30
## 3.想要执行修改后的代码块，则按快捷键：Ctrl + Shift + P

batting <- as_tibble(Lahman::Batting)
batting %>% 
  group_by(playerID) %>% 
  summarise(ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
            ab = sum(AB, na.rm = TRUE)) %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

## useful summary functions：
## 1.measure of location:mean(), median()
not_cancelled_flights %>% 
  group_by(year, month) %>% 
  summarise(delay_mean = mean(arr_delay), 
            delay_median = median(arr_delay))
## 在汇总的时候加入筛选，常常有意想不到的功效：
not_cancelled_flights %>% 
  group_by(year, month) %>% 
  summarise(delay_avg1 = mean(arr_delay), 
            delay_avg2 = mean(arr_delay[arr_delay > 0])) # 筛选确实延迟的航班

## 2.measures of spread:
## var(): 
## sd():标准差
## IQR():四分位距
## mad():这个有点歧义，有mean absolute deviation和median absolute deviation
not_cancelled_flights %>% 
  group_by(year, month) %>% 
  summarise(delay_sd = sd(arr_delay), 
            delay_IQR = IQR(arr_delay), 
            delay_mad = mad(arr_delay))

x <- c(1, 2, 3, 4, 5)
median(x)
mad(x)

## 3.measure of rank:
## min()
## quantile(x, 0.25) # quantile(x, 0.25)表示上四分位数，还可设置0.5， 0.75，甚至0-1的任何数
## max()
not_cancelled_flights %>% 
  group_by(year, month, day) %>% 
  summarise(first_flight = min(dep_time), 
            last_flight = max(dep_time))

## 4.measute of position:
## first():数据集当前排序中的第一条数据
## nth(x, 2):数据集当前排序中的第2条数据
## last():数据集当前排序中的最后一条数据
flights %>% 
  filter(!is.na(dep_time)) %>% 
  arrange(year, month, day, dep_time) %>% 
  group_by(year, month, day) %>% 
  summarise(first_dep = first(dep_time), 
            last_dep = last(dep_time))
test <- flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))
View(test)

## 5.counts:
## n():所有的记录(不论是否缺失值)
## sum(!is.na(x)):非缺失值
## n_distinct(x):不重复值
## count()

flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

## count is very useful:
## count one variable
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  count(dest) %>% 
  arrange(-n)
## count multiple variables
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  count(year, month, day)
## use count to sum with wt parameter
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  count(tailnum, wt = distance) %>% 
  arrange(-n)

## 6.counts and proportions of logical values:
## sum(x > 10) mean(y == 0)
## true = 1, false = 0
## sum() get counts of true,mean() get proportion of true
## 每天多少趟航班？其中多少趟出发时间早于5点，比例是多少？
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(year, month, day) %>% 
  summarise(dep_all = n(), 
            dep_5_n = sum(dep_time < 500), 
            dep_5_p = mean(dep_time < 500)) %>% 
  arrange(-dep_5_p)

## grouping by multiple variables
### 每天多少次航班起飞
(per_day <- 
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(year, month, day) %>% 
  summarise(flights = n()))
### 每月多少次航班起飞
### 根据前面的数据可以直接汇总
(per_month <- summarise(per_day, flights = sum(flights)))
### 2013年多少次航班起飞
(per_year <- summarise(per_month, flights = sum(flights)))
## 往上汇总rolling up

## ungroup
daily <- group_by(flights, year, month, day)
daily %>% 
  ungroup() %>% 
  summarise(n = n())

## exercise
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(flight) %>% 
  summarise(n = n(), 
            late10_n = sum(dep_delay == 10),
            late10_p = mean(dep_delay == 10)) %>% 
  arrange(-late10_p) %>% 
  filter(n >= 2, late10_p >= 0.33)

flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(flight) %>% 
  summarise(n = n(), 
            ontime_n = sum(dep_delay == 0),
            ontime_p = mean(dep_delay == 0)) %>% 
  filter(ontime_p >= 0.99) %>% 
  arrange(-ontime_p)
  
flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(dest) %>% 
  summarise(n = n())

flights %>% 
  filter(!is.na(dep_time), 
         !is.na(arr_time)) %>% 
  group_by(tailnum) %>% 
  summarise(dist = sum(distance))

flights %>% 
  group_by(year, month, day) %>% 
  summarise(n = n(), 
            cancel_n = sum(is.na(arr_time)), 
            cancel_p = mean(is.na(arr_time)), 
            arr_delay_mean = mean(arr_delay, na.rm = TRUE)) %>% 
  mutate(date = paste(year, month, day, sep = '-')) %>% 
  # filter(month == 1) %>% 
  ggplot(mapping = aes(x = arr_delay_mean, y = cancel_n)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

## grouped mutate and filter
## use group_by with mutate() and filter()
### 每月晚点TOP3
flights %>% 
  group_by(month) %>% 
  filter(rank(desc(arr_delay)) < 4)

### 筛选目的地城市到达航班超过365次的所有航班记录
flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)

flights %>% 
  group_by(dest) %>% 
  filter(n() > 365) %>% 
  filter(arr_delay > 0) %>% 
  count(dest, wt = arr_delay) %>% 
  mutate(delay_t = n, delay_prop = n / sum(n)) %>% 
  arrange(-delay_prop)


