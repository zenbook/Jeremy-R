
# library packages ========================================================
library(tidyverse)

# 12.2 Tidy data ==========================================================
# what's tidy data?
# Each variable must have its own column.
# Each observation must have its own row.
# Each value must have its own cell.
table1
table2
table3
table4a
table4b

table1 %>% 
  mutate(rate = cases / population * 10000)

table1 %>% 
  count(year, wt = cases)

ggplot(table1) + 
  geom_bar(aes(year, cases, fill = country), 
           stat = 'identity', 
           position = 'dodge')

# 12.3 spreading and gathering ============================================

## 12.3.1 gathering
table4a %>% 
  gather(`1999`, `2000`, key = 'year', value = 'cases')

table4b %>% 
  gather(`1999`, `2000`, key = 'year', value = 'population')

tidy4a <- table4a %>% 
  gather(-country, key = 'year', value = 'cases')

tidy4b <- table4b %>% 
  gather(-country, key = 'year', value = 'population')

left_join(tidy4a, tidy4b)

## 12.3.2 spreading
## spread正是gather的逆操作
spread(table2, key = type, value = count)

## exercise 

## 1
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  spread(key = year, value = return) %>% 
  gather(-half, key = 'year', value = 'return', convert = TRUE)

## 2
## wrong code
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
## right code
table4a %>% 
  gather(`1999`, `2000`, key = 'year', value = 'cases')
## OR
table4a %>% 
  gather(-country, key = 'year', value = 'cases')

## 3
people <- tribble(
  ~name,             ~key,    ~value,
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people$test <- c(1, 1, 2, 1, 1)

people %>% 
  spread(key, value)

## 4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>% 
  gather(-pregnant, key = 'sex', value = 'people')

# 12.4 separating and uniting =============================================

## 12.4.1 separate  ======================
table3

## rate column contains cases and population,how to separate it?
table3 %>% 
  separate(rate, into = c('cases', 'population'))

## 可以发现separate自动把rate列分成了cases和population，它能自动识别分割符号/
## 如果我们想手动设置分割符号，也木有问题：
table3 %>% 
  separate(rate, into = c('cases', 'population'), sep = '/')

## 不过，我们发现cases和population两列的数据格式竟然是chr,我们希望是int或double，怎么破？
table3 %>% 
  separate(rate, into = c('cases', 'population'), 
           sep = '/', 
           convert = TRUE)
## OK,是int类型了

## 除了根据分隔符，也可以根据位置来separate
table3 %>% 
  separate(year, into = c('century', 'year'), sep = 2)
## sep除了可以是一个值，也可以是数值向量，不过其长度不能长于into中的长度

## 12.4.2 unite  =========================

## unite正好是separate的逆操作
table3 %>% 
  separate(year, into = c('century', 'year'), sep = 2) %>% 
  unite(year, century, year)
## 第一个year是新合成列的列名，后两个是待合并的列名

## 发现新列year的格式不是我们想要的，世纪和年份中有'_'分隔开来了，怎么去掉？
table3 %>% 
  separate(year, into = c('century', 'year'), sep = 2) %>% 
  unite(year, century, year, sep = '')
## 通过设置sep = ''

## 还发现year的类型是chr，转换一下即可

## exercise  =============================

## 1.extra, fill
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, 
           c("one", "two", "three"), 
           extra = 'merge')  # warn, drop, merge

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, 
           c('one', 'two', 'three'), 
           fill = 'left')  # warn, right, left

## 2.remove
## remove the input column, we've got the new column, so we don't need the old column
## default value is TRUE, set it to be FALSE to keep the input column
table3 %>% 
  separate(rate, c('cases', 'population'), remove = FALSE)

## 3.separate and extract
df <- tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e"))
df %>% extract(x, "A")
df %>% extract(x, c('A', 'B'))  # 报错
df %>% extract(x, c("A", "B"), "([[:alnum:]]+)-([[:alnum:]]+)")

# 12.5 missing values ======================================================

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

## 缺失值有两种：
## 1.明显的缺失值：在数据集中用NA表示，如上表2015年第四季度；
## 2.隐晦的缺失值：没在数据集中出现，但按理应该有数据的，如2016年第一季度；

## 如何让隐晦的缺失值显示出来？可以先spread，然后gather
stocks %>% 
  spread(year, return) %>% 
  gather(-qtr, key = 'year', value = 'return')

## 如何让隐晦的缺失值显示出来？ 还可以用complete
stocks %>% 
  complete(year, qtr)
## 原理是：寻找year + qtr的dinstinct组合

## 如何删除显示出来的缺失值？
stocks %>% 
  spread(year, return) %>% 
  gather(-qtr, key = 'year', value = 'return', na.rm = TRUE)

stocks[!is.na(stocks$return), ]

## 还有这种情况：缺失值NA实际上是数据来源的某种记录习惯，比如NA表示其值就是上一行的值
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment
## 如上表中的数据，person为NA的两行，实际值应该是第一行的Derrick Whitmore
## 怎么用上面的Derrick Whitmore来填充NA呢？用fill
treatment %>% 
  fill(person)

## 如果不是用Derrick Whitmore来填充，而是应该用Katherine Burke来填充，怎么办？
treatment %>% 
  fill(person, .direction = 'up') # .direction的默认值是down

## exercise

## 1.the difference of fill between spread and complete
table2 %>% 
  spread(type, count, fill = 'NA')
stocks %>% 
  complete(year, qtr, fill = list(return = 'NA'))

df <- tibble(
  group = c(1:2, 1),
  item_id = c(1:2, 2),
  item_name = c("a", "b", "b"),
  value1 = 1:3,
  value2 = 4:6
)
df %>% complete(group, nesting(item_id, item_name))
df %>% complete(group, nesting(item_id, item_name), fill = list(value1 = 0))
  
# 12.6 Case study =========================================================
who
who %>% 
  gather(new_sp_m014:newrel_f65, 
         key = 'key', 
         value = 'cases', 
         na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(key, 'newrel', 'new_rel')) %>% 
  separate(key, c('new', 'type','sexage'), sep = '_') %>% 
  select(-iso2, -iso3, -new) %>% 
  separate(sexage, c('sex', 'age'), sep = 1)

## exercise
who %>% 
  gather(new_sp_m014:newrel_f65, 
         key = 'key', 
         value = 'cases', 
         na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(key, 'newrel', 'new_rel')) %>% 
  separate(key, c('new', 'type','sexage'), sep = '_') %>% 
  select(-iso2, -iso3, -new) %>% 
  separate(sexage, c('sex', 'age'), sep = 1) %>% 
  group_by(country, year, sex) %>% 
  summarise(cases = sum(cases)) %>% 
  ggplot() + 
  geom_bar(aes(x = year, y = cases, fill = sex), stat = 'identity')

