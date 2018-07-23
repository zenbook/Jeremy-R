
# 加载包
library(tidyverse)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(d3heatmap)
library(modelr)
library(nycflights13)

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

# 7.4 Missing values ===========================================

## actions about unusul values:

## 1.drop the entire data point:
diamonds %>% 
  filter(between(y, 3, 20))
## that is not a good idea!

## 2.use NA to replace the unusual value:
diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

## ifelse(test, value if test == TRUE, value if test == FALSE)

## ggplot() will warn you if it remove some missing values:
ggplot(data = flights, mapping = aes(x = dep_delay)) + 
  geom_histogram(binwidth = 10)

## suppress the warning messange with na.rm = TRUE:
ggplot(data = flights, mapping = aes(x = dep_delay)) + 
  geom_histogram(binwidth = 10,
                 na.rm = TRUE)

## 遇到缺失值时，首先要了解为什么有缺失值，
## 比如flights数据集中dep_time为NA代表着这趟航班取消了，没有起飞

flights %>% 
  mutate(cancelled = is.na(dep_time), 
         sched_dep_hour = sched_dep_time %/% 100 + 
           sched_dep_time %% 100 / 60) %>% 
  ggplot(mapping = aes(x = sched_dep_hour)) + 
  geom_freqpoly(mapping = aes(color = cancelled), 
                binwidth = 1/4)

## 7.4.1 exercise ==============================================

sum(is.na(flights$dep_delay))

ggplot(data = flights, mapping = aes(x = dep_delay)) + 
  geom_histogram(binwidth = 10)

ggplot(data = flights, mapping = aes(x = dep_delay)) + 
  geom_bar()

# 7.5 Corvariation =============================================

## 7.5.1 A categorical and continuous variable =================

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

## 不同切割质量的钻石数量相差太大，不好比较
ggplot(data = diamonds, mapping = aes(x = cut)) + 
  geom_bar()

## 不用count,用density来比较一下：
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

## 还有一个更好的展现方式：boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_boxplot()
## 从图中我们至少有两个较为明显的发现：
## 1.每个cut类别下的异常值都比较多；
## 2.Fair类别的平均价竟然是最高的！不可置信呀！这是为什么呢？
## 应该是其他变量导致的吧

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
## 箱线图的箱子比较多呀？不太好对比，可以排序一下：
ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), 
                             y = hwy))
## 如果x轴上标签字段比较长，可以把箱线图转个方向：
ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, -hwy, FUN = median), 
                             y = hwy)) + 
  coord_flip()

## 7.5.1.1 exercise ===========================================

flights %>% 
  mutate(cancelled = is.na(dep_time), 
         sched_dep_hour = sched_dep_time %/% 100, 
         sched_dep_minute = sched_dep_time %% 100, 
         sched_dep = sched_dep_hour + sched_dep_minute / 60) %>% 
  ggplot(mapping = aes(x = sched_dep, y = ..density..)) + 
  geom_freqpoly(mapping = aes(color = cancelled), 
                binwidth = 0.5)

## carat with price
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_point()

## log(carat) with log(price)
diamonds %>% 
  ggplot(mapping = aes(x = log(carat), y = log(price))) + 
  geom_point()

## color with price
ggplot(data = diamonds, mapping = aes(x = color, y = price)) + 
  geom_boxplot()

## clarity with price
ggplot(data = diamonds, mapping = aes(x = clarity, y = price)) + 
  geom_boxplot()

## cut with carat
ggplot(data = diamonds, mapping = aes(x = reorder(cut, carat, FUN = median), 
                                      y = carat)) + 
  geom_boxplot()

## 总结：钻石越重，价格越高；Fair切割的钻石虽然没切割好，但是钻石更重，所以价格更高

## ggstance,注意看mapping中x和y设置的是哪个字段？正好跟原来coord_flip的相反
ggplot(data = diamonds, mapping = aes(x = price, y = cut)) + 
  geom_boxploth()

## lvplot::geom_lv
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_lv()

## geom_violin
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_violin()

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_histogram(binwidth = 1000) + 
  facet_grid(. ~ cut)

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_histogram(binwidth = 1000) + 
  facet_wrap(~ cut)

## ggbeeswarm
## geom_quasirandom()
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_quasirandom()
## geom_beeswarm() don't use it if dataset is too large
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_beeswarm()

## geom_jitter
ggplot(data = iris, mapping = aes(x = Species, y = Sepal.Length)) + 
  geom_jitter()
## geom_quasirandom
ggplot(data = iris, mapping = aes(x = Species, y = Sepal.Length)) + 
  geom_quasirandom()
## geom_beeswarm
ggplot(data = iris, mapping = aes(x = Species, y = Sepal.Length)) + 
  geom_beeswarm()

## 7.5.2 Two categorical variables ===========================

## geom_count
ggplot(data = diamonds, mapping = aes(x = cut, y = color)) + 
  geom_count()

## dplyr::count()
diamonds %>% 
  count(cut, color)

## geom_tile():类似热力图
diamonds %>% 
  count(cut, color) %>% 
  ggplot(mapping = aes(x = cut, y = color)) + 
  geom_tile(mapping = aes(fill = n))

## seriation, d3heatmap and heatmaply


## 7.5.2.1 exercise ==========================================

flights %>% 
  group_by(dest, month) %>% 
  summarise(dep_delay_mean = mean(dep_delay)) %>% 
  ggplot(mapping = aes(x = month, y = dest)) + 
  geom_tile(mapping = aes(fill = dep_delay_mean))
## 尼玛亮瞎眼呐，目的地太多了，这样展示实在不友好，怎么破？

## 答：因为color字段取值都比较短，展示更美观

## 7.5.3 Two continuous variables ============================
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_point()

## 数据集太大了，散点图上点太多，都重叠在一起了
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_point(alpha = 0.01)

## 如果数据集太大，用alpha也不一定是最好的办法，还可以用别的：
## geom_bin2d()
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_bin2d()
## geom_hex()
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) + 
  geom_hex()

## 还可以把其中一个字段"切割"成不同组
diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

## 不同箱线图中的数据集数量其实是不同的，怎么表示出来呢？

## 1.varwidth = TRUE
diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), 
               varwidth = TRUE)
## 不是很好看哈，特别是1.5以后的都太细了

## 2.cut_number()：分成多少个箱线图
diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 020)))

## 7.5.3.1 exercise ===========================================

ggplot(data = diamonds, 
       mapping = aes(x = price, 
                     y = ..density.., 
                     color = cut_width(carat, 0.5))) + 
  geom_freqpoly()

## carat with price
ggplot(data = diamonds, 
       mapping = aes(x = carat,  
                     y = ..density.., 
                     color = cut_width(price, 5000))) + 
  geom_freqpoly()

ggplot(data = diamonds, 
       mapping = aes(x = cut_width(price, 5000),  
                     y = carat)) + 
  geom_boxplot() + 
  coord_flip()

# 7.6 Patterns and models =====================================

## Could this pattern be due to coincidence (i.e. random chance)?
## How can you describe the relationship implied by the pattern?
## How strong is the relationship implied by the pattern?
## What other variables might affect the relationship?
## Does the relationship change if you look at individual subgroups of the data?

ggplot(faithful, aes(x = waiting, y = eruptions)) + 
  geom_point()

## 如果A变量与B变量相关，那么可以用B变量来预测A变量
## 如果A变量与B变量是因果关系，那么可以用自变量来控制因变量

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(diamonds2, aes(carat, resid)) + 
  geom_point()

ggplot(diamonds2, aes(cut, resid)) + 
  geom_boxplot()

x <- c(3, 2, 6, 7, 9)
y <- c(6.1, 3.9, 11.8, 14.2, 20)
test <- data.frame(x = x, y = y)
model <- lm(y ~ x, data = test)
model$residuals
mean(model$residuals)
var(model$residuals)
sd(model$residuals)
test$resid = model$residuals


# 7.7 ggplot2 calls ==========================================
## 当对ggplot函数熟悉之后，可以省略参数名，这样节省时间
ggplot(diamonds, aes(carat, price)) + 
  geom_point()

diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(cut, clarity, fill = n)) + 
  geom_tile()

