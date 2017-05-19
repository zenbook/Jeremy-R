
# library packages ================================================================
library(tidyverse)
library(Hmisc)

# 7.1 描述性统计分析 ==============================================================
mtcars <- as_tibble(mtcars)
summary(mtcars)
sapply(mtcars, mean)
fivenum(mtcars$mpg)

## 自己写一个计算各统计量的函数
mystat <- function(x, na.omit = FALSE){
  if (na.omit)
    x <- x[!is.na(x)]
  n = length(x)
  m = mean(x)
  s = sd(x)
  skew = 
}



describe(mtcars)


















