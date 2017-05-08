# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(tidyverse)
library(nycflights13)
data(flights)

# Filter rows with filter()  ---------------------------
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


# arrange rows with arranges()  ------------------------
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

# select variables with select()  -----------------------
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

# add new variables with mutate()  --------------------------
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
## dep_delay = dep_time - sched_dep_time
1:3 + 1:10





















