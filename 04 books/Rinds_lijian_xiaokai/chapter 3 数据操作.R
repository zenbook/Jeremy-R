# chapter 3 数据操作

# 3.1 向量化操作

## 定义一个函数func，判断一个数字是否偶数
func <- function(x){
  if (x %% 2 == 0){
    rec <- "even"
  }
  else {
    rec <- "odd"
  }
  return(rec)
}
func(34)
## 上面定义的函数只能处理单个数字，并不能处理向量

## 如果要处理向量，可以用sapply函数
vec <- round(runif(4) * 100)
func(vec)
sapply(vec, func)  # 第一个参数是要处理的数据集，第二个参数是函数

## 还可以将函数改成可接受向量的函数
funcv <- Vectorize(func)
funcv(vec)

## 如果只是判断偶数，可以直接用ifelse函数
ifelse(vec %% 2 == 0, "even", "odd")

## sapply函数还可以计算数据框
op <- options()  #把当前的设置保存在op对象中
options(digits = 2)  #设置小数位数 = 2
sapply(iris[, 1:4], function(x) sd(x)/mean(x))
options(op)  #恢复设置

## sapply还可以计算列表
my_list <- as.list(iris[, 1:4])
sapply(my_list, mean)

## lapply函数也可以计算向量、数据框和列表，与sapply的差别是它返回的结果是列表
lapply(vec, funcv)
lapply(my_list, mean)

## 把lapply函数的结果转成更方便查看的形式(3种方法)
myfunc <- function(x){
  ret <- c(mean(x), sd(x))  #同时计算均值和标准差
  return(ret)
}
result <- lapply(my_list, myfunc)
result
t(as.data.frame(result))   #方法1：转换成数据框，然后转置
t(sapply(result, "["))    #方法2：用sapply函数，其中使用取子集的二元操作符"["，然后转置
do.call("rbind", result) #方法3：利用do.call把result传入rbind函数中

## 计算矩阵apply,apply也可以计算数据框
set.seed(1)
data <- round(runif(12) * 100)  #随机生成12个数字的向量
data <- matrix(data, 3, 4)     #把向量转成3*4矩阵，3行4列
apply(data, MARGIN = 1, sum)  #MARGIN = 1，以行为计算单位，即列1+列2+……，得到的结果应该与行数相同
apply(data, MARGIN = 2, function(x) max(x) - min(x)) #MARGIN = 2，以列为计算单位，即行1+行2+……，得到的结果应该与列数相同

## 根据鸢尾花种类，计算Sepal.Length的均值
tapply(X = iris$Sepal.Length, INDEX = list(iris$Species), FUN = mean)  #tapply函数
with(iris, tapply(Sepal.Length, list(Species), mean))

## 用aggregate比tapply更好,结果用数据框形式显示
with(iris, aggregate(Sepal.Length, by = list(Species), mean))

## 如果有两个变量要同时变化，则用mapply
vec1 <- vec2 <- (1:9)
para <- expand.grid(vec1, vec2)  #把vec1和vec2分别配对，得到81对
res <- mapply(FUN = prod, para[,1], para[, 2])
## mapply可以看做是sapply的增强版，可以处理2个及以上的变量

## 如果只有2个变量，可以用outer函数
my_func <- function(x,y){
  left <- paste0(x, " * ", y, " = ")
  right <- x * y
  ret <- paste0(left, right)
  return(ret)
}
outer(vec1, vec2, FUN = my_func)

## replicate函数，可以让某个函数调用多遍
res <- replicate(100, mean(rnorm(10000)))   #随机抽取10000个服从正态分布的样本，计算其均值，然后重复以上过程100次
hist(res)

## 总结：
## 对某个对象使用某个函数计算：sapply/lapply(输出一个列表)/apply(设置margin参数)
## 根据某个变量分组：tapply/aggregate
## 对两个对象使用某个函数计算：outer
## 对三个及以上对象使用某个函数计算：mapply
## 重复调用某个函数：replicate

# 3.2 数据转换整理

# 3.2.1 取子集和编码转换

## subset提取子集
data_sub <- subset(iris, iris$Species == "setosa", 3:5)  #subset(数据集, 所需的行, 所需的列)
head(data_sub)
data_sub <- with(iris, iris[Species == "setosa", 3:5]) 

## transform进行编码转换，如转换成对数
iris_str <- transform(iris, v1 = log(Sepal.Length)) 

## 连续变量离散化
q25 <- quantile(iris_str$v1, 0.25)   #提取v1变量的25%分位数
q50 <- quantile(iris_str$v1, 0.50)   #提取v1变量的50%分位数
q75 <- quantile(iris_str$v1, 0.75)   #提取v1变量的75%分位数
groupvec <- c(min(iris_str$v1), q25, q50, q75, max(iris_str$v1))  
labels <- c("A", "B", "C", "D")
iris_str$v2 <- cut(iris_str$v1, breaks = groupvec, labels = labels, include.lowest = T)
## cut(数据集变量， 分组的个数或者点， 标签， 是否包含下限)
## 如果设置了标签，则转换成了因子

## 转换成因子
vec <- rep(c(1, 2), c(4, 6))  #rep(值，每个值出现多少次)
vec_fac <- factor(vec, labels = c("male", "female"))  #factor函数，设置labels，控制因子的取值
levels(vec_fac)
str(vec_fac)

## levels设置和修改因子
vec <- rep(c(0, 1, 2),c(4, 6, 2))
vec_fac <- factor(vec)
levels(vec_fac) <- c("male", "female", "male")
vec_fac

## 用factor转换因子时，levels的缺省顺序按照字符顺序或数字的大小顺序，如需修改，可用relevel()修改
vec <- rep(c("b", "a"),c(4, 6))
vec_fac <- factor(vec)   #levels()结果为levels：a b
vec_fac
relevel(vec_fac, ref = "b") #levels()结果为levels：b a

# 3.2.2 长宽格式互转

## 长型数据：variable value variable字段下有多个字段；
## 宽型数据：variable1 variable2 variable3 ……宽型数据就如数据库中的数据表
data_kuan <- iris[, 1:4]
data_long <- stack(data_kuan)   #stack(),转成长型数据
View(data_long)
data_kuan <- unstack(data_long)  #unstack(),转成宽型数据
View(data_kuan)

## 转换成款型数据并计算平均值
data_long <- iris[, 4:5] 
data_kuan <- unstack(data_long)
View(data_kuan)
colMeans(data_kuan)  #计算各列的平均柱
apply(data_kuan, MARGIN = 2, FUN = mean)
colSums(data_kuan)   #计算各列的和

## 前面的函数都太弱了，可以直接一步到位的，加载reshape2包
require(reshape2)
dcast(data_long, Species~., value.var = "Petal.Width", fun = mean)

## melt函数，将款型数据融合成长型数据
iris_long <- melt(iris, id = "Species")
View(iris_long)
dcast(iris_long, Species~variable, value.var = "value", fun = mean)
dcast(iris_long, Species + variable~., value.var = "value", fun = mean)
## melt就像是铁匠的炼炉，把数据融化，dcast就像是锤子，把数据重铸成各种结构，以便分析

## 用reshap2包中的tips数据集进行分析
str(tips)
View(tips)
## 观察男女给小费有没有差别，发现男客平均小费金额比女客高
dcast(tips, sex~., value.var = "tip", fun = mean)  
## 性别结合就餐客人人数多少来对比，发现客人多，小费普遍更多，不过男性就餐人数为5人时，小费反而比4/6人都少，有点奇怪
dcast(tips, sex~size, value.var = "tip", fun = mean)   
## 女性：抽烟的比不抽烟的大方，男性：不抽烟的比抽烟的大方
dcast(tips, sex~smoker, value.var = "tip", fun = mean) 
## 想同时看小费和总消费在不同性别之间的区别，可以先用melt把宽型数据融合成长型数据
tips_k <- melt(data = tips, id.vars = c("sex", "smoker", "day", "time", "size"))
View(tips_k)
dcast(tips_k, sex~variable, value.var = "value", fun = mean)
## 再加上小费占费用的比例
tips_rate <- dcast(tips_k, sex~variable, value.var = "value", fun = mean)
tips_rate$rate <- with(tips_rate,tip/total_bill)
tips_rate
## 可以看出，女性小费占费用的比例更高，可以说女性其实更大方
## 再把性别和是否吸烟结合起来看
tips_smoker <- dcast(tips_k, sex + smoker~variable, value.var = "value", fun = mean)
tips_smoker$rate <- with(tips_smoker, tip/total_bill)
tips_smoker
## 可以看出，从比例来讲，女性：吸烟者比不吸烟者更大方；男性：不吸烟者比吸烟者大方
## 再来看看性别和就餐人数
tips_size <- dcast(tips_k, sex + size~variable, value.var = "value", fun = mean)
tips_size$rate <- with(tips_size, tip/total_bill)
tips_size

# 3.2.3 数据的拆分和合并

## 根据某个分类变量拆分
require("reshape2")
require("plyr")
iris_split <- split(iris, f = iris$Species)
class(iris_split)
str(iris_split)

## 将拆分后的数据集合并
iris_all <- unsplit(iris_split, f = iris$Species)
class(iris_all)
str(iris_all)

## 拆分之后计算结果
fun_rate <- function(x) {
  sum(x$tip) / sum(x$total_bill)
}
tips_split <- split(tips, f = tips$sex)
result <- lapply(tips_split, fun_rate)
do.call("rbind", result)

## 以上计算可以一个函数完成，即plyr包的ddply函数
ddply(tips, ~sex, fun_rate)
ddply(tips, ~sex + smoker, fun_rate)
ddply(tips, sex~smoker, fun_rate)
ddply(tips, c("sex", "smoker"), fun_rate)

## 举例说明ddply如何计算多个结果，如平均值，标准差
dfx <- data.frame(
  group = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  sex = sample(c("M", "F"), size = 29, replace = TRUE),
  age = runif(n = 29, min = 18, max = 54)
)
View(dfx)
ddply(dfx, .(group, sex), summarise,
      mean = round(mean(age), 2),
      sd = round(sd(age), 2))

## 数据的合并
## 如果数据都是一一对应的，可以用cbind合并
## 如果不是一一对应的，可以用merge函数
datax <- data.frame(id = c(1, 2, 3), gender = c(23, 44, 52))
datay <- data.frame(id = c(3, 1, 2), name = c("Tom", "Jimmy", "halo"))
merge(datax, datay, by = "id")

## 如果左表有，右表没有，会怎么样呢？
datax <- data.frame(id = c(1, 2, 3, 4), gender = c(23, 44, 52, 25))
merge(datax, datay, by = "id", all = T)
## 结果是只保留了两表都有的记录
## 设置参数all = TRUE，显示所有记录
datax <- data.frame(id1 = c(1, 2, 3, 4), gender = c(23, 44, 52, 25))
datay <- data.frame(id2 = c(3, 1, 2, 5), name = c("Tom", "Jimmy", "halo", "john"))
merge(datax, datay, by.x = "id1", by.y = "id2", all = T)

## 详细了解一下merge函数：
## 生成数据
authors <- data.frame(
  surname = c("Tukey", "Venables", "Tierney", "Ripley", "McNeil"),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4)))
books <- data.frame(
  name = (c("Tukey", "Venables", "Tierney",
            "Ripley", "Ripley", "McNeil", "R Core")),
  title = c("Exploratory Data Analysis",
            "Modern Applied Statistics ...",
            "LISP-STAT",
            "Spatial Statistics", "Stochastic Simulation",
            "Interactive Data Analysis",
            "An Introduction to R"),
  other.author = c(NA, "Ripley", NA, NA, NA, NA,
                   "Venables & Smith"))
## 两个数据框中id列的名称不同，则分别设置by.x = "", by.y = ""
## 同时设置了by.x和by.y，保留两个表都有的记录，以by.x中设置的列所在的表为左表
m1 <- merge(authors, books, by.x = "surname", by.y = "name")  
m2 <- merge(books, authors, by.x = "name", by.y = "surname")
## 设置all = TRUE，则保留所有数据
m3 <- merge(authors, books, by.x = "surname", by.y = "name", all = TRUE)

## 生成数据
x <- data.frame(k1 = c(NA,NA,3,4,5), k2 = c(1,NA,NA,4,5), data = 1:5)
y <- data.frame(k1 = c(NA,2,NA,4,5), k2 = c(NA,NA,3,4,5), data = 1:5)
## 同时以k1,k2两个字段来合并数据集
merge(x, y, by = c("k1","k2")) # NA's match
merge(x, y, by = "k1") # NA's match, so 6 rows
merge(x, y, by = "k2", incomparables = NA) # 2 rows

## 用sql语句来试试看
require(sqldf)
iris10 <- sqldf("select  * from iris limit 10")
iris_10 <- sqldf("select * from iris order by Species desc limit 10")
## 还有些问题，按照数据库的标准语句格式写的join不能执行
sqldf("select * from books")
sqldf("select * from authors")

# 3.3 输入与输出

# 3.3.2 控制台的输入和输出

## format控制输出
set.seed(1)
out <- data.frame(x1 = runif(3) * 10, x2 = c("a", "b", "c"))
print(out)
out <- format(out, digits = 3)   #把数字位数设置为3
out

## cat控制显示
cat(c("a", "b", "c"), sep = "\n")
cat(paste(out$x2, out$x1, sep = " = "), sep = "\n")

## 在控制台交互输入
x <- readline()   #输入后，在console界面输入字符串
x <- scan()
x

# 3.3.2 文本文件

## 最常见的外部文件格式，比如csv/txt/excel
## 把一些数据输出到文本文件中
output <- file("output.txt")   #建立文件连接
cat(1:100, sep = "\t", file = output)  #把1：100共100个数字输出到output文件中，分隔符是tab键
close(output)  #关闭文件连接
output <- file("output.txt")
cat(1:50, sep = "\n", file = output)
cat(51:100, sep = "\n", file = output, append = TRUE)  #append = TRUE，表示在文件尾部增加数据，而不是覆盖。不过用的时候发现都是覆盖，不知为何？
close(output)

## 从文本文件中读入数据
output <- file("output.txt")
input <- scan(file = output)
input

## 只处理字符串的输入输出
output <- file("output.txt")
writeLines(as.character(1:12),con = output)
input <- readLines(output)
input

## 复杂例子
path <- .libPaths()[1]  #返回安装包存放的目录
doc.names <- dir(path)   #得到目录下的子目录名称
doc.path <- sapply(doc.names, function(name){
  paste(path, name, "DESCRIPTION", sep = "/")
})
doc <- sapply(doc.path, function(doc) readLines(doc))
class(doc)
doc[[1]]
## 以上代码是从R的扩展包的目录下，读取每个包中的DESCRIPTION文件的内容

# 3.3.3 表格型文件

## 用write.table和read.table
write.table(iris, file = "iris.csv", sep = ",")
iris2 <- read.table(file = "iris.csv", sep = ",", stringsAsFactors = FALSE)
head(iris2)

## 用剪切板
data <- read.table("clipboard",header = TRUE)
data

## 我个人喜欢用write.csv 和 read.csv来做：
write.csv(iris, file = "iris1.csv")
iris1 <- read.csv(file = "iris1.csv",header = TRUE, stringsAsFactors = FALSE)
iris1$X <- NULL
head(iris1)
## 可以连接数据库，如使用RODBC的方式，或者使用DBI方式

# 3.3.4 其他外部文件
## 有专门读取excel文件的包，不过个人认为不是很好（依赖Java），不建议用
require("openxlsx")

## SPSS/SAS等其他统计分析软件的包
require("foreign")
## write.foreign的语法：
#write.foreign(df, datafile, codefile,package = c("SPSS", "Stata", "SAS"), ...)
datafile<-tempfile()
codefile<-tempfile()
write.foreign(esoph,datafile,codefile,package="SPSS")
file.show(datafile)
file.show(codefile)
unlink(datafile)
unlink(codefile)


# 3.4 时间相关数据的处理

## R中的时间类型可以分为两大类：1.时间类对象；2.时间序列类对象

# 3.4.1 时间类数据处理

## 时间类数据包含两类：
##（1）简单的Date类型：只包含年月日，用as.Date()转换
##（2）复杂的POSIXct类型：同时包含年月日时分秒，用as.POSIXct转换
require(lubridate)
date1 <- "1999-1-1"
class(date1)
date1 <- as.Date(date1)
class(date1)
date2 <- "01/01/1999"
date2 <- as.Date(date2,format = "%m/%d/%Y")
date2
date3 <- "01-01-1999"
date3 <- as.Date(date2,format = "%m-%d-%Y")
date3
## 标准的格式是"yyyy-mm-dd",如果不同，则需要设置format参数
date4 <- date1 + 365
date4 - date1
date4/date1   #报错，两个时间不能除

## R中初始日期是1970年1月1日
Sys.Date() - structure(0, class = "Date")

## 时间向量
date1 <- "1990-05-01"
date1 <- as.Date(date1)
dates <- seq(date1, length.out = 4, by = "day")
dates
format(dates, "%w")
weekdays(dates)

## 复杂的时间类型POSIXct
time1 <- "1990-01-01"
time1 <- as.POSIXct(time1)
time1 <- "2014-01-01 13:00:00"
class(time1)
time1 <- as.POSIXct(time1, format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
time1
time2 <- seq(from  = time1, to = Sys.time(), by = "month")

## 我们一般是先写成字符串型，再转成想要的时间格式，但我们也可以直接从数值转为时间：
time1 <- ISOdatetime(2011, 1, 1, 13, 0, 0)
time1
rep(4:5, 5)
sample(30,10)
time2 <- ISOdatetime(2016, rep(4:5, 5), sample(30, 10), 12, 0, 0)
time2

# 3.4.2 时间序列数据

## 时间序列数据，可以简单的理解为一个普通的向量绑定了一个时间类向量
## 用xts创建一个时间序列数据
require("xts")
x <- sample(100, 4)
y <- seq(as.Date("2016-05-01"), length.out = 4, by = "day")
date1 <- xts(x, y)
date1
class(date1)
str(date1)
dim(date1)

## 提取时间序列数据中的数据内容和时间属性
value <- coredata(date1)
coredata(date1) <- sample(30, 4)
time <- index(date1)

## 时间序列数据的整理方法
x <- sample(10, 4)
y <- seq(as.Date("2015-05-01"), length.out = 4, by = "day")
date2 <- xts(x, y)
date2
date3 <- cbind(date1, date2)   #cbind其实并不合理，只是演示
date3
str(date3)
names(date3) <- c("V1", "V2")
date4 <- rbind(date1, date2)
date4

## 时间序列数据取子集，可以用索引，也可以用window函数
date4[4]
window(date4, start = as.Date("2016-05-01"))
## 筛选子集之后可以直接赋值
window(date4, start = as.Date("2016-05-01")) <- c(20, 35, 61, 14)
date4

## 同样，时间序列数据还支持滞后项和离差项的计算
lag(date2)  #滞后项
date2
diff(date2)  #离差项

# 3.4.3 时间数据处理实例

## 以股票数据为例
require("quantmod")
require("xts")
getSymbols("^SSEC", src = "yahoo", from = "2001-01-01")   #从yahoo网站直接下载上证综合指数数据
class(SSEC)
View(SSEC)
head(SSEC)
chartSeries(SSEC, TA=NULL)  #绘图

## 分析调整了股利等因素后的收盘价
data <- SSEC[, "SSEC.Adjusted"]
head(data) 
names(data) <- "close"
data$ratio <- with(data, diff(close)/close)  #计算每日收益率：(今日收盘价-昨日收盘价)/今日收盘价

## 转换成数据框，排序，选出股价变动率最大的前十个
data.df <- as.data.frame(data)   
data.df[order(abs(data.df$ratio), decreasing = TRUE), ][1:10, ]

## 计算每个月的平均收益率
monthratio <- apply.monthly(data$ratio, mean, na.rm = TRUE)
head(monthratio)
class(monthratio)  #仍是一个时间序列数据

## 计算按月的价格波动，即该月内的开盘价(第一个交易日的收盘价)、最高价、最低价、收盘价(最后一个交易日的收盘价)
data.month <- to.monthly(data$close)

## 计算移动平均值，股票中常用的是90天移动平均
rollmean <- rollapply(data$close, width = 90, FUN = mean)
rollmean <- rollmean[!is.na(rollmean)]   #排除前面的90个记录，没有移动平均值
head(rollmean)
sum(data$close > rollmean)
sum(data$close < rollmean)

## 计算12个月的收益率
require("lubridate")
data$mday <- month(data)  #标注所属月份
res <- aggregate(data$ratio, data$mday, mean, na.rm = TRUE)  #计算12个月的平均收益率
cat(format(res*100, digits = 2, sientific = FALSE))





