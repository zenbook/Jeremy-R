
# library packages ========================================================
library(tidyverse)
library(nycflights13)
library(Lahman)

# 13 Relational data ======================================================

# Mutating joins:
## add new variables to one data frame from matching observations in another.
## 从另一个数据集中把匹配的记录的某些属性(列)加到某数据集中
# Filtering joins:
## filter observations from one data frame based on whether or not they match 
## an observation in the other table.
## 根据记录是否与另一个数据集中的记录是否匹配来筛选这个/些观测值；
# Set operations:
## treat observations as if they were set elements.
## ？

# 13.2 nycflights13 =======================================================
airlines
airports
planes
weather
flights

# 13.3 Keys ===============================================================
## primary key
## foreign key

planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1) %>% 
  arrange(-n)
## 同一个航班，一天中最多可以飞4次，why is that?

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1) %>% 
  arrange(-n)
## 很多记录确实飞机型号呀！！

# 13.4 Mutating joins =====================================================
flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier) %>% 
  left_join(airlines, by = 'carrier') %>% 
  View()

## 13.4.1 Understanding joins

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

## 13.4.2 Inner join
x %>% 
  inner_join(y, by = 'key')





































