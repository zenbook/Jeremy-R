
# 教程来自张丹的博客：http://blog.fens.me/r-zoo/
library('zoo')

x.date <- as.Date('2017-01-01') + c(0:9)
class(x.date)
x <- zoo(rnorm(5), x.date)
x
class(x)
head(x)
str(x)
plot(x)

# 多组时间序列
y <- zoo(matrix(1:12, 4, 3), 0:27)
str(y)
summary(y)
plot(y)
