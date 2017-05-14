
# library packages ========================================================
library(tidyverse)
library(modelr)
options(na.action = na.warn)

# All models are wrong, but some are useful.

# 23.2  A simple model ====================================================
ggplot(sim1, aes(x, y)) + 
  geom_point()
## 我们发现非常强的模式:线性相关，y = a_0 + a_1 * x，但我们不知道a_0, a_1应该是多少
## 我们可以画出很多线，看那些线最有代表性
models <- tibble(
  a1 = runif(250, -20, 40), 
  a2 = runif(250, -5, 5)
)
ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) + 
  geom_point()
## 图中有非常多的模型，但哪个才是好的呢？
## 我们可以用原始值与模型对应的值的距离来计算，距离最小的那个模型，自然就是最好的
## 新建一个函数model1,以data和a（含有两个值的向量）作为输入，得到模型的模拟结果
model1 <- function(a, data){
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)



















