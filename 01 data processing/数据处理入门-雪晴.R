
# ============================== library packages ==============================
library(reshape2)
library(tibble)
library(plyr)
data(iris)

# 取子集
iris[iris$Species == 'setosa', ]
subset(iris, Species == 'setosa')

# 新变量
iris$V1 <- iris$Sepal.Length + iris$Petal.Length
transform(iris, V2 = Sepal.Length + Petal.Length)
iris <- transform(iris, V2 = Sepal.Length + Petal.Length)

# 连续变量离散化
people <- tibble(age = c(13, 42, 17, 29, 22, 45, 67, 12, 31, 10), 
                 sex = c('M', 'F', 'M', 'F', 'F', 'M', 'M', 'F', 'F', 'M'))
groupvec <- c(0, 18, 45, 60, 100)
labels <- c('少年', '青年', '中年', '老年')
people$label <- with(people, 
                     cut(age, 
                         breaks = groupvec, 
                         labels = labels))

# 转换成因子型
vec <- rep(c(0, 1), c(4, 6))
vec_fac <- factor(vec, labels = c('Male', 'Female'))
vec_fac2 <- factor(vec, levels = c(0, 1))
levels(vec_fac)
levels(vec_fac2)
levels(vec_fac2) <- c('Male', 'Female')

# 因子合并
vec <- rep(c(0, 1, 3), c(4, 6, 2))
vec_fac <- factor(vec)
levels(vec_fac) <- c('Male', 'Female', 'Male')
vec_fac

# 因子重设
vec <- rep(c('b', 'a'), c(4, 6))
vec
vec_fac <- factor(vec)
vec_fac
relevel(vec_fac, ref = 'b')

# 长表/宽表
iris$V1 <- NULL
data_w <- iris[1:4]
data_l <- stack(data_w)
head(data_l)
data_w <- unstack(data_l)
head(data_w)

# 数据重塑
data_sub <- iris[, 4:5]
dcast(data = data_sub, 
      formula = Species ~., 
      value.var = 'Petal.Width', 
      fun = mean)
# 宽表转长表
iris_long <- melt(data = iris, 
                  id = 'Species')
dcast(data = iris_long, 
      formula = Species ~ variable, 
      value.var = 'value', 
      fun = mean)

# 练习
head(tips)
dcast(tips, sex ~ ., value.var = 'tip', mean)
dcast(tips, sex ~ size, value.var = 'tip', mean)
dcast(tips, size ~ sex, value.var = 'tip', mean)

tips_melt <- melt(tips, id = c(3:7))
dcast(tips_melt, sex ~ variable, value.var = 'value', fun = mean)

# 数据合并
datax <- tibble(id = c(1, 2, 3), 
                name = c('john', 'jeremy', 'lily'))
datax
datay <- tibble(id = c(1, 3, 2), 
                age = c(23, 54, 32))
merge(datax, datay, by = 'id')

# 数据拆分
iris_splited <- split(iris,  f = iris$Species)
class(iris_splited)

# 数据汇总：plyr包
ratio_fun <- function(x) {
  sum(x$tip) / sum(x$total_bill)
}
ddply(.data = tips, 
      .variables = 'sex', 
      .fun = ratio_fun)

ddply(tips, .(sex), ratio_fun)
ddply(tips, sex ~ smoker, ratio_fun)

each(max, min, median)(tips$tip)

# 对每一个满足条件的列做某个运算
colwise(mean, is.numeric)(tips)
