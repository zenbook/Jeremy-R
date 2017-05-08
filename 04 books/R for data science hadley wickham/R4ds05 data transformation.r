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
(jan1 <- filter(flights, month == 1, day == 1))  # 这种写法可以既显示数据，又保存到变量中

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





















