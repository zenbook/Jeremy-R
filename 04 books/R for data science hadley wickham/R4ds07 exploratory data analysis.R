# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(tidyverse)
library(nycflights13)
data(flights)

# 7.3 variation =============================================

## 7.3.1 Visualization distributions ========================

## categorical variables;bar chart
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  count(cut)

## continuous variables:histogram chart
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = carat), 
                 binwidth = 0.1,
                 color = 'white')

## ggplot2::cut_width() is a good function
diamonds %>% 
  count(cut_width(carat, 0.5))

## 当绘制直方图时，可多设置几次binwidth和bins，也许能发现不同的数据分布模式
## 也可以筛选数据集中的部分数据绘制直方图
diamonds %>% 
  filter(carat < 1) %>% 
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01, 
                 color = 'white')
## 可以发现一个很有趣的现象：0.3-/0.4-/0.5-/0.7-/0.9-这些克拉段的钻石数降序排列

## 当希望在一个图中显示多个直方图时，建议使用geom_freqpoly(),而不是geom_histogram()
diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat, color = cut)) + 
  geom_freqpoly(binwidth = 0.1)
## 可以发现，最多的是cut = Ideal的钻石，而这类钻石主要分布在0-0.5克拉

## 7.3.2 Tapical values ===================================

## 钻石的价格受很多因素的影响，比如切割，重量，颜色，净度，可参考网站的详细介绍：
## https://www.diamonds.pro/zh-hans
## 要做数据分析，先对即将分析的行业有所了解
ggplot(diamonds, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)

## 美国黄石国家公园中喷泉的喷发时间的分布也有点意思：
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25, 
                 color = 'white')

## 7.3.3 Unusual values ===================================
## outlier的产生原因：
## 1.输入有误；
## 2.数据确实如此，可能代表着重大发现呢；
## 然而在现实业务中，见到异常值不要太高兴，而应该提高警惕

ggplot(data = diamonds, mapping = aes(x = y)) + 
  geom_histogram(binwidth = 0.5)
## 可以发现y字段有异常值，但是我们不知道异常值分布在哪里
## 可以用coord_cartesian()来设置ylim和xlim的范围
ggplot(data = diamonds, mapping = aes(x = y)) + 
  geom_histogram(binwidth = 0.5) + 
  coord_cartesian(ylim = c(0, 50))
## 由此我们发现，在0,30,60附近有异常值
## 我们把这些附近的数据筛选出来看一下：
diamonds %>% 
  filter(y <= 3 | y >= 30) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
## 发现为0的y,这代表着缺失值；
## 也发现3厘米和6厘米的y，这太罕见了，可能是小数点标错了；

## 对异常值的处理：
## 1.判断异常值的产生原因：是数据确实如此，还是人为原因弄错了；
## 2.人员原因弄错了的话：如果可以修正则修正，如果不能修正，则建议删除这条记录；
## 3.如果数据确实如此：可以先带着异常值进行分析，然后剔除异常值再分析一次，对比结果；

## 7.3.4 exercise ===========================================
ggplot(data = diamonds, mapping = aes(x = x)) + 
  geom_histogram(binwidth = 0.5)

diamonds %>% 
  filter(price <= 2500) %>% 
  ggplot(mapping = aes(x = price)) + 
  geom_histogram(binwidth = 10)
## 为什么1500左右的价格没有呢？

diamonds %>% 
  summarise(n_0.99 = sum(carat == 0.99, na.rm = TRUE), 
            n_1 = sum(carat == 1, na.rm = TRUE))
## 0.99克拉比1克拉便宜了20%，当然都要切割成1克拉啦！

## 对比coor_cartesian 和ylim , xlim
## coord_cartesian:keep all data point
diamonds %>% 
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01) + 
  coord_cartesian(ylim = c(0, 500))
## ylim,xlim:only keep data points within the range
diamonds %>% 
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01) + 
  ylim(0, 500)

diamonds %>% 
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01) + 
  coord_cartesian(xlim = c(0.5, 1.5))

diamonds %>% 
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01) + 
  xlim(0.5, 1.5)






























