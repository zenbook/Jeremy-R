# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(tidyverse)

# ggplot  ------------------------------------------------------------------------------

## First try  ---------------------------------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = hwy))

## Aesthetic mappings  ------------------------
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
























