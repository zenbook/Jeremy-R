
# library packages ===================================================
library(tidyverse)
library(forcats)

# creating factors ===================================================
## 字符串向量
str1 <- c('Dec', 'Jan', 'Nov', 'Feb')
## 用以上的向量表示月份的问题有：
## 1.月份只有12个，而且是特定的名称，书写的时候很可能写错；
str2 <- c('Dec', 'Jan', 'Noc', 'Feb') ## Nov,not Noc
## 2.排序时，默认按照字母顺序，而不是月份的顺序
sort(str1)

## 先创建levels
month_level <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
## 然后把string转换成factor
fac1 <- factor(str1, levels = month_level)
fac1
sort(fac1)
## 任何不在levels之内的值都转换成null
fac2 <- factor(str2, levels = month_level)
fac2

## 如果有null值希望给出报错信息，则用parse_factor
fac2 <- parse_factor(str2, levels = month_level)

## 如果不设置levels参数的值，则默认按照字母顺序设置levels
fac1 <- factor(str1)
fac1

## 如果想按照字符串出现的顺序设置levels,2个方法:
fac1 <- factor(str1, levels = unique(str1))
fac1
fac1 <- str1 %>% factor() %>% fct_inorder()
fac1

# 15.3 General Social Survey
gss_cat
gss_cat %>% 
  count(race)

ggplot(gss_cat, aes(x = race)) + 
  geom_bar()

# ggplot把值为0的factor自动剔除了，要保存的话，设置如下：
ggplot(gss_cat, aes(race)) + 
  geom_bar() + 
  scale_x_discrete(drop = FALSE)
  
gss_cat %>% 
  count(rincome)

ggplot(gss_cat, aes(rincome)) + 
  geom_bar()

gss_cat %>% 
  count(relig) %>% 
  arrange(-n)

# 15.4 Modifying factor order

gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(tvhours, relig)) + geom_point()

## using fct_reorder to reorder factors by ascending
gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(tvhours, fct_reorder(relig, tvhours))) + geom_point()

## using fct_reorder to reorder factors by descending
gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(tvhours, fct_reorder(relig, -tvhours))) + geom_point()

## 最好不要在aes中用fct_reorder,我们可以先用mutate处理完之后再ggplot
## 这样，y轴坐标标题就还是relig
gss_cat %>% 
  group_by(relig) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  mutate(relig = fct_reorder(relig, tvhours)) %>% 
  ggplot(aes(tvhours, relig)) + geom_point()

gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  ggplot(aes(age, rincome)) + geom_point()


## fct_reorder会按照字母的顺序重新给factors排序
gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  mutate(rincome = fct_reorder(rincome, age)) %>% 
  ggplot(aes(age, rincome)) + geom_point()

## 如果不想按照字母的顺序，则不要用fct_reorde
## 用fct_relevel可以设置优先展示的level
gss_cat %>% 
  group_by(rincome) %>% 
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  ) %>% 
  mutate(rincome = fct_relevel(rincome, 'Not applicable')) %>% 
  ggplot(aes(age, rincome)) + geom_point()

gss_cat %>% 
  filter(!is.na(age)) %>% 
  group_by(age, marital) %>% 
  count() %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(age, prop, color = marital)) + 
    geom_line(na.rm = TRUE)

## 用fct_reorder2,给line按照最大年龄时的prop设置颜色
gss_cat %>% 
  filter(!is.na(age)) %>% 
  group_by(age, marital) %>% 
  count() %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(age, prop, color = fct_reorder2(marital, age, prop))) + 
  geom_line() + 
  labs(color = 'marital')

## reorder factors in bar chart
ggplot(gss_cat, aes(marital)) + 
  geom_bar()

## 根据count降序排列
gss_cat %>% 
  mutate(marital = marital %>% fct_infreq()) %>% 
  ggplot(aes(marital)) + 
  geom_bar()

## 根据count升序排列
gss_cat %>% 
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% 
  ggplot(aes(marital)) + 
  geom_bar()

gss_cat %>% 
  ggplot(aes(tvhours)) + 
  geom_histogram()

summary(gss_cat$tvhours)

# 15.5 Modifying factor levels
# 重新编码

gss_cat %>% count(partyid)
## 下面把partyid重新编码
## fct_recode,新编码在前，老编码在后
gss_cat %>% 
  mutate(partyid = fct_recode(
    partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>% 
  count(partyid)
## 可以将多个老编码合并为一个新编码
gss_cat %>% 
  mutate(partyid2 = fct_recode(
    partyid, 
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>% 
  count(partyid2)
## 将多个老编码合并为一个新编码时一定要注意，不能随便合并，以免产生误导

## 比fct_recode更好用的是fct_collapse()
gss_cat %>% 
  mutate(partyid3 = fct_collapse(
    partyid, 
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
  )) %>% 
  count(partyid3)

## 还有一个更诡异（厉害）的折叠函数，fct_lump
## 它把较小占比的项都合并起来
gss_cat %>% 
  mutate(relig2 = fct_lump(relig)) %>% 
  count(relig2)
## 以上代码中fct_lump从最小占比的一直往上折叠，直到折叠后的结果仍然是最小占比时停止
## 以上的结果有时候并没有用，我们可以设置折叠后剩余的项数
gss_cat %>% 
  mutate(relig2 = fct_lump(relig, n = 10)) %>% 
  count(relig2, sort = TRUE) %>% 
  print(n = Inf)

gss_cat %>% 
  mutate(partyid2 = fct_recode(
    partyid, 
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  group_by(year, partyid2) %>% 
  count() %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(aes(year, prop, color = fct_reorder2(partyid2, year, prop))) + 
  geom_line() + 
  labs(color = 'partyid')

