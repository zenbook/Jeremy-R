
# library packages ===================================================
library(magrittr)

# 18.4 Other tools from magrittr =====================================

## %T>%，当希望保存或执行多个连续的操作时
rnorm(100) %>% 
  matrix(ncol = 2) %>% 
  plot() %>% 
  str()

rnorm(100) %>% 
  matrix(ncol = 2) %T>%
  plot() %>% 
  str()

## %$%，当希望操作data frame的列时
mtcars %$% 
  cor(disp, mpg)

## %<>% 左边是希望保存的数据集，右边是对数据集的某些操作
mtcars <- mtcars %>% 
  transform(cyl = cyl * 2)
## 以上代码可以用%<>%更简便地实现：
mtcars %<>% transform(cyl = cyl * 2)


## 问题：以上这些有快捷键吗？如果有的话，分别是？

## 补充一下：发现张丹对magrittr的讲解更清楚，学习一下：












