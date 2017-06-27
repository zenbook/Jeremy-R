
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

## 补充一下：发现张丹对magrittr的讲解更清楚：
## http://blog.fens.me/r-magrittr/

# 向右操作符%>%, 向左操作符%T>%, 解释操作符%$% 和 复合赋值操作符%<>%

# 1.向右操作符%>%
# 取10000个随机数符合，符合正态分布。
# 求这个10000个数的绝对值，同时乘以50。
# 把结果组成一个100*100列的方阵。
# 计算方阵中每行的均值，并四舍五入保留到整数。
# 把结果除以7求余数，并画出余数的直方图。

# 常规方法
set.seed(1)
d1 <- rnorm(1000)
d2 <- abs(d1)*50
d3 <- matrix(d2, ncol = 100)
d4 <- round(rowMeans(d3))
hist(d4%%7)

# %>%
set.seed(1)
rnorm(1000) %>% 
  abs %>% 
  `*`(50) %>% 
  matrix(ncol = 100) %>% 
  rowMeans %>% 
  round %>% 
  `%%`(7) %>% 
  hist

# 2.向左操作符%T>%(Tee operator)
# 取10000个随机数符合，符合正态分布。
# 求这个10000个数的绝对值，同时乘以50。
# 把结果组成一个100*100列的方阵。
# 计算方阵中每行的均值，并四舍五入保留到整数。
# 把结果除以7求余数，并话出余数的直方图。
# 对余数求和

set.seed(1)
rnorm(1000) %>% 
  abs %>% 
  `*`(50) %>% 
  matrix(ncol = 100) %>% 
  rowMeans %>% 
  round %>%
  `%%`(7) %T>% 
  hist %>%
  sum

# 3.解释操作符%$%
# 把data frame的字段属性传给右侧的函数或表达式
# 根据左侧data frame的某个字段进行筛选
data.frame(x = 1:10, 
           y = rnorm(10),
           z = letters[1:10]) %$% 
  .[which(x > 5), ]

iris %$% .[which(Species == 'setosa'), ]


# 4.复合赋值操作符%<>%
# 同时给左右两侧赋值，即进行右侧相关的处理，最后把结果保存到左侧
x <- rnorm(100)
x %<>% abs() %>% sort %>% head(10)
x

# 5.其他功能

# 5.1 符号操作符
# extract	                  `[`
# extract2	          `[[`
# inset	                  `[<-`
# inset2	                  `[[<-`
# use_series	          `$`
# add	                  `+`
# subtract	          `-`
# multiply_by	          `*`
# raise_to_power	          `^`
# multiply_by_matrix	  `%*%`
# divide_by	          `/`
# divide_by_int	          `%/%`
# mod	                  `%%`
# is_in	                  `%in%`
# and	                  `&`
# or	                  `|`
# equals	                  `==`
# is_greater_than	          `>`
# is_weakly_greater_than	  `>=`
# is_less_than	          `<`
# is_weakly_less_than	  `<=`
# not (`n'est pas`)	  `!`
# set_colnames	          `colnames<-`
# set_rownames	          `rownames<-`
# set_names	          `names<-`

# 5.2 %>% 传递到代码块
# 代码块，用{}括在一起
rnorm(100) %>% 
  multiply_by(5) %>% 
  add(5) %>% 
  {
    cat('Mean:', mean(.), 
        'Var:', var(.), '\n')
    sort(.) %>% head
  }

