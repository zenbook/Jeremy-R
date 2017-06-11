
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










