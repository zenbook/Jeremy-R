# chapter 4 控制语句和函数

# 4.1 控制语句

# 4.1.1 条件判断
# 用if来判断某个数字是否为奇数
num <- 5
if (num %% 2 != 0){
  cat(num, "is odd")
}
# 如果写在一行，可以省略大括号
if(num %% 2 != 0) cat(num, "is odd")
# 如果有多个分支判断，可以用else嵌套
num <- 4
if(num %% 2 != 0){
  cat(num, "is odd")
} else {
  cat(num, "is even")
}
# 多个分支，else嵌套
num <- 10
if(num %% 3 ==1){
  cat("mode is ",1)
} else if (num %% 3 == 2){
  cat("mode is ", 2)
} else {
  cat("mode is ", 0)
}
# 用ifelse函数
num <- 1 : 6
ifelse(num %% 2 == 0, yes = "even", no = "odd")
# ifelse函数还可以嵌套
set.seed(1)
num <- sample(20:70, 20, replace = TRUE)
num
res <- ifelse(num > 50, "老年", ifelse(num > 30, "中年", "青年"))
# switch函数,
# 如果第一个参数值是数字，返回后面字符集中相应位置的字符串
switch(2, "banana", "apple", "other")
num <- 10
mode <- num %% 3
cat("mode is ", switch(mode + 1, 0, 1, 2))
# 如果第一个参数值是字符串，返回后面字符集中完全匹配的字符串
fruits <-  c("orange", "banana", "apple", "grape", "other")
price <- function(fruit){
  switch(fruit,
         apple = 10,
         orange = 12,
         grape = 16,
         banana = 8,
         0)
}
price("apple")
price <- Vectorize(price)
price(c("apple", "orange", "banana"))

# 4.1.2 循环
# 循环语句：可以重复运行某段代码；根据终止运行的条件，可以分为for循环和while循环
# for循环的终止条件是循环的次数
# 计算了1：100之间的所有奇数之和
x <- 0
for (i in 1:100){
  if(i %% 2 != 0){
    x = x + i
  }
}
print(x)
sum(seq(1, 100, by = 2))

# while循环的终止条件是达到某个标准
x <- 0
i <- 1
while(i < 100){
  if(i %% 2 != 0){
    x = x + i
  }
  i = i + 1
}
print(x)

# repeat也可以执行循环
x <- 0
i <- 1
repeat{
  if(i %% 2 != 0){
    x = x + i
  }
  i <- i + 1
  if(i > 100) break
}
print(x)
# 还有next命令
x <- 0
i <- 0
repeat{
  i <- i + 1
  if(i > 100) break
  if(i %% 2 == 0) next
  x = x +i
}

# 在循环中修改变量，比较消耗内存和计算时间

# 创建一个函数，判断一个数字是否为质数
findprime <- function(x){
  if(x %in% c(2, 3, 5, 7)) return(TRUE)
  if(x %% 2 == 0 | x == 1) return(FALSE)
  xsqrt <- round(sqrt(x))
  xseq <- seq(from = 3, to = xsqrt, by = 2)
  if (all(x %% xseq != 0)) return(TRUE)
  else return(FALSE)
}
# 方法1
system.time({
  x <- logical()
  for (i in 1: 1e5){
    y = findprime(i)
    x <- c(x, y)
  }
})
# 方法2
system.time({
  x <- logical(1e5)
  for (i in 1:1e5){
    y <- findprime(i)
    x[i] <- y
  }
})
# 方法3
system.time({
  x <- sapply(1:1e5, findprime)
})
# R 很擅长做向量化运算，所以在R中尽量少用循环


# 4.2 函数

# 计算n以内的斐波那契数列
fibonaci <- function(n){
  i <- 2
  x <- 1:2
  while (x[i] < n){
    x[i + 1] <- x[i] + x[i - 1]
    i <- i + 1
  }
  x <- x[-i]
  return(x)
}

fibonaci(100)



