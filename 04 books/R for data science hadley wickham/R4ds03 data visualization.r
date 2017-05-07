# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(tidyverse)

# ggplot  ------------------------------------------------------------------------------

## 3.2 First try  ---------------------------------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = hwy))

## 3.3 Aesthetic mappings  ------------------------
## size, color, shape，alpha, fill, group, stroke

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

## 设置统一的
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = 'blue')

# The name of a color as a character string.
# The size of a point in mm.
# The shape of a point as a number

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = fl))

## 将同一个变量设置给不同的属性，则会综合一起 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = fl, shape = fl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, stroke = cyl))

## 注意以下代码中color = displ < 5，这种设置非常不错！ 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, 
                           y = hwy, 
                           color = hwy > mean(mpg$hwy)))

## 3.5 facets  ------------------------------
## facet_wrap
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
## facet_grid
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ class)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(class ~ .)
## facet_grid two variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

## 3.6 geometric object  -------------------------
## different plot types
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

## multiple geometrics
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv, linetype = drv))
## 更简洁的写法是：
ggplot(data = mpg, 
       mapping = aes(x = displ, y = hwy)) +
  geom_point() +　
  geom_smooth()

## mapping
## 在ggplot()中的mapping是全局的，里面的设置影响所有的图层；
## 在geom_()中的mapping是局部的，里面的设置只影响当前的图层；
ggplot(data = mpg, 
       mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth()

## geom_()中也可以单独设置data
ggplot(data = mpg, 
       mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == 'subcompact'), se = FALSE)

## group
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), 
              show.legend = FALSE)

geom_line()
geom_boxplot()
geom_histogram()
geom_area()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE, 
              mapping = aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth(se = FALSE, 
              mapping = aes(linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = drv))

## 3.7 statistic transformation  -----------------
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
## geom_bar()用的统计变换是count
## 可以用stat_count()代替geom_bar
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
  
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) + 
  geom_bar(mapping = aes(x = cut)) # 但结果并不是我们想要的
ggplot(data = demo) + 
  geom_bar(mapping = aes(x = cut, y = freq), 
           stat = 'identity')

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

ggplot(data = demo) + 
  geom_col(mapping = aes(x = cut, y = freq))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..)) # 没有group，有问题

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 100))

## 3.8 position adjustments ---------------

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

## position:stack,identity,fill,dodge,jitter

## stack，堆积，默认
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

## identity，适用于散点图
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 0.2, position = 'identity')
ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) + 
  geom_bar(fill = NA, position = 'identity')

## fill，方便对比各项占比
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity, color = I('white')), 
           position = 'fill')

## dodge，常规柱形图，对比每项的值
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity, color = I('white')),
           position = 'dodge')

## jitter，适用于散点图，添加扰动，画出每一个点
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(alpha = 0.5, position = 'jitter')

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = drv, y = hwy)) + 
  geom_boxplot()



















