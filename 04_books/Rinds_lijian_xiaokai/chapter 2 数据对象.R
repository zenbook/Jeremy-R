# chapter 2 数据对象

setwd("C:\\Users\\Administrator\\Documents\\R")

# 2.1 基本对象

# 2.1.1 向量入门
## 可以用R做计算
27 * 1.8 + 32  #把27摄氏度转换成华氏温度
## R更擅长批量计算：
temp <- c(27,29,23,14)
temp * 1.8 + 32
## R中还有自带的很多函数：
log(temp)
length(temp)
## 从向量中取子集：
temp[4]
temp[c(1,2,3)]
temp[-4]

# 2.1.2 向量的生成
## （1）用冒号连接连续的数值
vector1 <- 1:10
vector1
## （2）用seq函数，设置参数
vector2 <- seq(from = 1, to = 10, by =1)
vector2
## （3）用seq函数，不写参数名称
vector3 <- seq(2, 20, 2) 
vector3
## （4）用seq函数，设置其他参数值
vector4 <- seq(1, 100, length.out = 10)
vector4 <- seq(1, 100, length = 10)   # 参数名写length也可以，因为R可以识别出来是length.out
vector4
vector5 <- seq(1, 100,along.with = vector4)
vector5 <- seq(1, 100,along = vector4)
vector5
## 冒号的优先级很高，要注意：
vector6 <- 1:10 + 2
vector6
vector7 <- 1:(10 + 2)
vector7
## 综合应用，用R计算sin函数从0到π的曲线下的面积
## sin函数的图形
x <- seq(-2*pi, 2*pi, by=0.01)
y <- sin(x)
s1<-data.frame(x,y=sin(x),type=rep('sin',length(x)))  # 正弦
require("ggplot2")
ggplot(s1, aes(x = x, y = y)) + geom_line()
## 开始计算
n <- 100
w <- pi/n
x <- seq(0, pi, length.out = n)
rect <-sin(x)*w
sum(rect)
## （5）也可以用req来生成向量
group1 <- req(1:3, times = c(8,10,9))
group1
class(group1)
group2 <- factor(group1)
group2
class(group2)
## 向量中也可以存逻辑、字符串
vec_logic <- c(TRUE, FALSE, FALSE, TRUE)
vec_logic
class(vec_logic)
vec_string <- c("A", "B", "C","D")
vec_string
class(vec_string)
## 逻辑向量多数来自判断：
temp_logic <- temp > 20
temp_logic
vec_string == "A"   #这里的==是等于的判断符号，不是赋值符号
## （6）生成随机数
vec_random1 <- runif(10)   #生成0-1之间的，服从平均分布的10个随机数
vec_random1
vec_random2 <- sample(c("a", "b", "c","d"), size = 10, replace = T)  #从向量中有放回的随机抽取10个字符串
vec_random2
## （6）先建一个空向量
vec <- numeric(10)
vec

# 2.1.3 向量的计算
## 取出高于20度的温度
temp[c(1,2,3)]
temp[1:3]
temp[c(TRUE,TRUE,TRUE,FALSE)]
temp[temp > 20]
## 根据温度筛选地区：
vec_string[temp > 20]
vec_string[temp > mean(temp)]
## 计算截尾均值
vec_10 <- runif(10)
vec_max <- max(vec_10)
vec_min <- min(vec_10)
vec_trimmed <- vec_10[vec_10 < vec_max & vec_10 > vec_min]  #符号&是“并”
mean_trimmed <- sum(vec_trimmed)/length(vec_trimmed)
## 与或非对应的符号分别是&|！
## 注意向量的长度，如果向量的长度不相等：
##（1）不是倍数关系、则会报错；
##（2）是倍数关系，则长度短的会自动重复计算：
vec1 <- 1:10
vec2 <- 1:5
vec3 <- vec1 + vec2
vec3
## 判断向量是否某种类型：
is.character(vec_string)
## 找出100内的整数中能被3和2整除的数，把他们加起来：
x <- 1:100
y <- x[x %% 3 ==0 & x %% 2 == 0]
sum(y)
y <- x[x %% 6 == 0]
sum(y)

# 2.2 复合对象

# 2.2.1 矩阵
## 向量是可以看成一维的容器，矩阵可以看成是二位的容器
vector <- c(1:12)
class(vector)
my_matrix <- matrix(vector, nrow = 3, ncol = 4, byrow = FALSE)  #生成3行4列的矩阵
class(my_matrix)
my_matrix
dim(vector) <- c(4, 3)  #把向量vector的维度改成4行3列，实际上是改成了一个矩阵
vector
class(vector)
## 可以用cbind()和rbind()函数，把多个向量合并成矩阵
vector1 <- vector2 <- vector3 <- runif(3)
my_matrix <- cbind(vector1, vector2, vector3)
my_matrix
my_matrix <- rbind(vector1, vector2, vector3)
my_matrix
## 矩阵的运算
round(my_matrix*10, digits = 2)
## 幻方（各个方向求和结果都一样）
my_mat <- matrix(c(8, 3, 4, 1, 5, 9, 6, 7, 2), ncol = 3)
print(my_mat)
## 矩阵筛选子集和计算
my_mat[1,]
sum(my_mat[1,])  #求和第一行
rowSums(my_mat)  #求和每一行
colSums(my_mat)  #求和每一列
sum(diag(my_mat))#求和对角线
## 矩阵取出某行或某列后，将退化为一个向量
class(my_mat[1,])
class(my_mat[1,, drop = FALSE])
## 矩阵取子集
my_mat
my_mat[my_mat <= 5] <- 0
my_mat[my_mat > 5] <- 1
ifelse(my_mat > 5, 1, 0)
## 矩阵四则运算
A <- matrix(c(3, 1, 5, 2), 2, 2)
t(A) %*% A  #(矩阵乘法),t(A)表示A的逆矩阵
b <- matrix(c(4, 1), ncol = 1)
solve(A, b) #求解线性方程组
# 矩阵之外，还有数组，不过数组很少使用；

# 2.2.2 数据框
## 数据框不同列的类型可以不同，但各列的长度要相同；
## 同一列中的类型要相同；
city <- c("A", "B", "C", "D")
temp <- c(27, 29, 23, 14)
data <- data.frame(city, temp)
data
class(data)
## 提取数据框的子集
data[, 1]
data[, "city"]
data$city
## 组合成数据框时，缺省设置是把字符型转变成因子型。可以修改
data <- data.frame(city, temp, stringsAsFactors = FALSE) 
## 筛选
data[data$temp > 20,]
data[data$temp > mean(data$temp),]
with(data,data[temp > mean(temp),])  #用with函数更方便，不需要重复输入data$
with(data,data[temp > mean(temp),"city"])
## 通过以下函数了解数据框
str(data)
summary(data)
dim(data)
head(data)
## 数据库排序
order(data$temp)
data[order(data$temp),]
data[order(data$temp, decreasing = T),]

# 2.2.3 列表
## 用list函数生成列表
data_list <- list(city = city, temp = temp)
data_list
class(data_list)
data_list$mat <- my_mat
data_list$data <- data
## 提取子集
names(data_list)
data_list[3]
class(data_list[3])  #用一对方括号提取子集，提取后的类型还是list
data_list[[3]]
class(data_list[[3]])  #用两对方括号提取子集，提取后的类型是该子集的原来的类型
length(data_list)

# 2.3 特殊对象

# 2.3.1 缺失值与空值
## 缺失值是应该有数据但实际上没有 NA
temp <- c(27, 29, 23, 14, NA)
mean(temp)
mean(temp, na.rm = TRUE)
is.na(temp)
## 空值是完全没有 NULL
temp <- c(27, 29, 23, 14, NULL)
mean(temp)   #自动剔除NULL值
## 经常通过把某个元素的值设置为NULL来删除这个元素
data_list$data <- NULL
names(data_list)

# 2.3.2 连接
## 连接是指一类可以反复调用的输入输出对象（文本连接、文件连接、网络连接、压缩文件、管道）
## 如果我们需要频繁地操作外部数据，就可以先建立一个连接
## 建立一个内存的连接
textcon <- textConnection("output", "w")
sink(textcon)
x <- runif(10)
summary(x)
print("这句话并没有显示在终端上，而是被写入了output对象")
sink()
print(output)
## 要记得关闭连接
showConnections()
class(textcon)
close(textcon)
## 建立一个在硬盘上的文件连接：
filecon <- file("output.txt", "w")
sink(filecon)
x <- runif(10)
summary(x)
print("这句话并没有显示在终端上，而是被写入了output对象")
sink()
close(filecon)
browseURL("output.txt")

## 2.3.3 公式
n <- 1:50
xvar <- paste0("x", n)   #连接字符串
right <- paste(xvar, collapse = " + ")  
left <- "y~"
my_formula <- paste(left, right)
my_formula <- as.formula(my_formula)
class(my_formula)

## 2.3.4 表达式
## 有些时候我们希望稍后执行表达式
ex <- expression(x <- seq(1, 10, 2))
print(x)
class(ex)
eval(ex)
print(x)
## 如果表达式是字符串形式的，要用parse函数将其解析，转义为表达式
tex <- c("z <- seq(1, 10, 2)", "print(z)")
eval(parse(text = tex))

## 2.3.5 环境
## 环境可以看做是分隔出来的不同的房间，数据待在各自的房间中活动，互不干扰
ls(envir = .GlobalEnv)  #查看环境下有哪些对象
env1 <- new.env()   #创建一个新的环境变量
assign("x1", 1:5, envir = env1)  #创建一个变量，放到新的环境中
ls(envir = env1)   #查看新的环境下有哪些变量
get("x1", envir = env1)  #查看新环境下变量的具体内容
exists("x1",envir = env1)  #检查某个环境下是否有某个变量
rm("x1", envir = env1)  #删除新环境下的变量x1
exists("x1",envir = env1)

## 2.3.6 函数
exp(1)
exp(c(1, 2, 3, 4))
## 可以创建自定义函数,自定义函数，求圆的面积
my_func <- function(r){
  area <- pi*r^2
  print(area)
}
my_func(1)
## 输入函数名，观察函数的代码
my_func





