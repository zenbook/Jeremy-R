
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
## 很多记录缺失飞机型号呀！！

# 13.4 Mutating joins =====================================================
flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier) %>% 
  left_join(airlines, by = 'carrier') %>% 
  View()

## 13.4.1 Understanding joins =================

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

left_join(x, y, by = 'key')
inner_join(x, y, by = 'key')
right_join(x, y, by = 'key')
full_join(x, y, by = 'key')

## 13.4.2 Inner join ==========================
x %>% 
  inner_join(y, by = 'key')

## 13.4.3 outer join ==========================
## left_join
## outer_join
## full_join

x %>% 
  left_join(y, 'key')

x %>% 
  right_join(y, 'key')

x %>% 
  full_join(y, 'key')

## 13.4.4 duplicate keys ======================

## one table has duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

x %>% 
  inner_join(y, 'key')

x %>% 
  left_join(y, 'key')

x %>% 
  right_join(y, 'key')

x %>% 
  full_join(y, 'key')

## both tables have duplicate keys

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

x %>% 
  left_join(y, 'key')

## 不论一个表还是两个表有重复的主键，join的关键都是：把所有能匹配的都匹配上

## 13.4.5 define the key columns ==============
## 1.by defualt, by = NUll,把两表中所有名称相同的字段都拿来作为join的主键外键
flights %>% 
  left_join(weather)
## 两个字段都有year,month,day,hour,origin这些字段
## 2.两个表都出现的相同名称的字段
x %>% left_join(y, by = 'key')
## 3.两表中代表相同含义的字段的名称不同
flights %>% 
  left_join(airports, by = c('dest' = 'faa'))
flights %>% 
  left_join(airports, by = c('origin' = 'faa'))

## 13.4.5 exercise ============================

flight2 <- flights %>% 
  group_by(dest) %>% 
  summarise(delay_mean = mean(arr_delay, na.rm = TRUE)) 

airports %>%
  left_join(flight2, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(mapping = aes(color = delay_mean)) +
  coord_quickmap()

airports %>% 
  select(faa, lat, lon) %>% 
  right_join(flights, by = c('faa' = 'origin')) %>% 
  left_join(airports[, c('faa', 'lat', 'lon')], by = c('dest' = 'faa')) %>% 
  mutate(origin = faa, 
         lat.origin = lat.x,
         lon.origin = lon.x,
         lat.dest = lat.y, 
         lon.dest = lon.y) %>% 
  select(year:tailnum, origin:lon.origin, dest, lat.dest, lon.dest, air_time:time_hour)
  
flight2 <- flights %>% 
  group_by(tailnum) %>% 
  summarise(delay_mean = mean(arr_delay, na.rm = TRUE)) 

planes %>% 
  select(tailnum, year) %>% 
  mutate(age = 2017 - year) %>% 
  left_join(flight2, by = 'tailnum') %>%
  filter(!is.na(year)) %>% 
  group_by(age) %>% 
  summarise(delay_mean_all = mean(delay_mean, na.rm = TRUE)) %>% 
  arrange(-delay_mean_all) %>% 
  ggplot(aes(x = age, y = delay_mean_all)) + 
  geom_col()

# 13.5 filtering join =====================================================
# semi_join(x, y) keeps all observations in x that have a match in y.
# anti_join(x, y) drops all observations in x that have a match in y.
top_dest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)
top_dest

# 用filter
flights %>% 
  filter(dest %in% top_dest$dest)

# 用semi_join
flights %>% 
  semi_join(top_dest, by = 'dest')

# 没有飞机资料的航班信息，anti_join
flights %>% 
  anti_join(planes, by = 'tailnum') %>% 
  count(tailnum, sort = TRUE)
## 为什么某些航班竟然没有飞机信息呢？

flights %>% 
  filter(is.na(tailnum)) %>% 
  count(dep_time)

flight100 <- flights %>% 
  count(tailnum, sort = TRUE) %>% 
  filter(n >= 100)

flights %>% 
  semi_join(flight100, by = 'tailnum')

anti_join(flights, airports, by = c("dest" = "faa"))

anti_join(airports, flights, by = c("faa" = "dest"))


# 13.7 Set operations =====================================================
# intersect(x, y): return only observations in both x and y.
# union(x, y): return unique observations in x and y.
# setdiff(x, y): return observations in x, but not in y.
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)

union(df1, df2)

setdiff(df1, df2)

setdiff(df2, df1)
