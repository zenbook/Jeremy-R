
# library packages ========================================================
library(tidyverse)
library(nycflights13)

# 10.2 create tibbles =====================================================

## coerce a data frame to tibble with as_tibble()
as_tibble(iris)

## create a new tibble with tibble()
tibble(x = c(1:5), 
       y = 1, 
       z = x^2 + y)

# it never changes the type of the inputs (e.g. it never converts strings to factors!), 
# it never changes the names of variables, 
# and it never creates row names.

tibble(`:)` = rep('time', 5), 
       ` ` = rep('hahaha', 5), 
       `2000` = 1:5)

## create a new tibble with tribble()
tribble(
  ~x, ~y, ~z, 
  #=========#
  'a', 1, 3.6,
  'b', 3, 6
)

# 10.3 Tibbles vs. data.frame =============================================

## There are two main differences in the usage of a tibble vs. a classic data.frame: 
## printing and subsetting.

## 10.3.1 printing ==================================
tibble(a = lubridate::now() + runif(1e3) * 86400, 
       b = lubridate::today() + runif(1e3) * 30, 
       c = 1:1e3, 
       d = runif(1:1e3), 
       e = sample(LETTERS, 1e3, replace = TRUE))
## 默认打印设置：
## 1.打印前10行；
## 2.根据console窗口大小显示列数
## 3.列名下方显示数据类型
## 4.最下方显示未打印出的记录条数和列名及列的数据类型

## 用print(n = , width)打印
flights %>% 
print(n = 20, width = Inf)
## width = Inf:打印全部的列

## 修改默认的打印设置：
## 1.rows:
## 1.1 if more than m rows, print only n rows. 
## options(tibble.print_max = n, tibble.print_min = m) 
## 如果数据集记录条数多于n,则打印前m条记录，如果<=n,则打印所有记录条数
options(tibble.print_min = 10, tibble.print_max = 30)
## 1.2 print all rows
options(tibble.print_min = Inf)
## 1.3 default setting
options(tibble.print_min = 10, tibble.print_max = 20)

## 2.colomns:
## show all columns:
options(tibble.width = Inf)  # show all columns
options(tibble.width = NULL) # show columns within screen width range

## view all data points in a dataset
View(flights)


## 10.3.2 subsetting ===============================

df1 <- tibble(x = runif(5), 
             y = rnorm(5))
df2 <- as.data.frame(df1)
df1
df2
df1$x
df2$x
df1['x']
df1[['x']]
df2['x']
df2[['x']]
df1[1]
df1[[1]]

## subsetting with pipe
df1 %>% .$x
df2 %>% .$x
df1 %>% .[['x']]
df2 %>% .[['x']]

df1['X']
df2['X']

## how to deal with older code?
## coerce tibble to data frame
as.data.frame(df1)

## 10.5 exercise ==========================================================

## 1
class(flights)
class(iris)

## 2
df <- data.frame(abc = 1, xyz = 'a')
df$x
df$a
df$b
df[, 'xyz']
df[, c('abc', 'xyz')]

df <- as_tibble(df)
df$x
df$a
df$b
df[, 'xyz']
df[, c('abc', 'xyz')]

## 3
var <- 'dep_delay'
## ???

## 4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying$`1`
ggplot(annoying, aes(`1`, `2`)) + 
  geom_point()
annoying <-  annoying %>% 
  mutate(`3` = `2` /`1`)
annoying %>% 
  rename(one = `1`, two = `2`, three = `3`)

## 5 
tibble::enframe()
## coerce vectors or list to two-column data frame

## 6 
options(tibble.max_extra_cols = 10)

