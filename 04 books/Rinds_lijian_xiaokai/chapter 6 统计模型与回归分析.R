# chapter 6 统计模型与回归分析

# 6.1 线性回归

# 6.1.1 回归模型与经典假设
set.seed(1)
x <- seq(1, 5, length.out = 100)
noise <- rnorm(n = 100, mean = 0, sd = 1)  #生成噪音数据
beta0 <- 1
beta1 <- 2
y <- beta0 + beta1 * x + noise  #y是x的线性函数
xy <- data.frame(x, y)
require("ggplot2")
ggplot(data = xy, aes(x = x, y = y)) + 
  geom_point(color = "red")

# 6.1.2 参数估计
x2y <- function(x, b0, b1){  #y是x的线性函数
  y <- b0 + b1 * x
  return(y)
}
sq_error <- function(x, y, b0, b1){   #计算残差平方和
  predictions <- x2y(x, b0, b1)
  errors <- sum((y - predictions)^2)
  return(errors)
}
result <- optim(c(0, 0), function(b) sq_error(x, y, b[1], b[2]))  #用最优化函数optim求参数b0和b1；
result$par
## 可以发现，最优化函数计算得到的参数与我们之前设置的差不多：b0≈1，b1≈2；

# 矩阵计算
xmat <- cbind(1, x)
solve(t(xmat) %*% xmat) %*% t(xmat) %*% y  # 矩阵乘法

# 最小二乘法 lm()函数
model <- lm(y ~ x)
summary(model)

ggplot(xy, aes(x, y)) + geom_point(color = "red")
plot(y ~ x)
abline(model)
names(model)
model$coefficients
model$fitted.values
xy2 <- data.frame(x, model$fitted.values)
names(xy2) <- c("x", "y2")
ggplot(xy2, aes(x, y2)) + geom_line()

# 6.1.3 模型预测 预测函数predict()
yconf <- predict(model, interval = "confidence")
ypred <- predict(model, interval = "prediction")
plot(y ~ x, col = "grey", pch = 16)
lines(yconf[, "lwr"] ~ x, col = "black", lty = 3)
lines(yconf[, "upr"] ~ x, col = "black", lty = 3)
lines(ypred[, "lwr"] ~ x, col = "black", lty = 2)
lines(ypred[, "upr"] ~ x, col = "black", lty = 2)
lines(ypred[, "fit"] ~ x, col = "black", lty = 1)

# 6.1.4 离散自变量的情况
set.seed(1)
x <- factor(rep(c(0, 1, 2), each = 20))
y <- c(rnorm(20, 0, 1), rnorm(20, 1, 1), rnorm(20, 2, 1))
model <- lm(y ~ x)
summary(model)$coefficients

anova(model)

# 6.2 模型的诊断

# 6.2.1 非正态性
require("stats")
data(LMdata, package = "rinds")
ggplot(LMdata$NonL, aes(x, y)) + geom_point()

model <- lm(y ~ x, data = LMdata$NonL)
res1 <- residuals(model)
shapiro.test(res1)

# 6.2.1 非线性
summary(model)$r.squared  #R方f非常接近1，说明比较接近直线，但是如果看图，发现更具有非线性关系
ggplot(LMdata$NonL, aes(x, y)) + geom_point()
plot(y ~ x, data = LMdata$NonL)
abline(model)
# 我们可以进一步来看残差的散点图
plot(model$residuals ~ LMdata$NonL$x)
# 从残差的散点图可以看到，残差以一种二次曲线的方式呈现，并不是随机的，说明残差中蕴含某种规律

# 我们加入二次项来建立新的回归模型
model2 <- lm(y ~ x + I(x^2), data = LMdata$NonL)
summary(model2)$r.squared   #可以发现R方更接近1了，这说明模型更有效了
summary(model2)$coefficients  #发现一次项的P值不显著，说明一次项可能不需要，我们在模型中剔除掉
model3 <- update(model2, y~ .-x)
summary(model3)$coefficients

AIC(model, model2, model3)  #model3的AIC最小，说明model3最有效
plot(model3$residuals ~ LMdata$NonL$x)   #再来看残差的散点图，发现都是随机分布的，看不出任何规律

# 6.2.3 异方差
model <- lm(y ~ x, data = LMdata$Hetero)
plot(model$residuals ~ LMdata$Hetero$x)  #从残差的散点图我们可以看到，随着自变量增大，残差的范围也增大
# 我们假定残差与x存在线性关系，那么残差的方差和x的平方就存在线性关系，所以我们用x的平方作为权重，进行加权最小二乘
model2 <- lm(y ~ x, weights = 1/x^2, data = LMdata$Hetero)
summary(model)$r.squared
summary(model2)$r.squared  # 发现R放提高了，模型更有效了
# model2的效果也不一定是最好的，我们可以迭代
require("nlme")
glsmodel <- gls(y ~ x, weights = varFixed(~x), data = LMdata$Hetero)
summary(glsmodel)
names(glsmodel)
plot(glsmodel$residuals ~ LMdata$Hetero$x)   #这个还不是很好，要再看一下

# 6.2.4 自相关
model <- lm(y ~ x, data = LMdata$AC)
# 后一项噪声与前一项噪声存在依赖关系
# 对残差进行DW检验来确定其自相关性
require("lmtest")
dwtest(model)
# 发现模型中存在自相关的情况，不能使用最小二乘法，改用gls，用广义最小二乘，并在corr参数中设置噪声的自相关参数
glsmodel <- gls(y~x, corr = corAR1(), data = LMdata$AC)

# 6.2.5 异常值
# 异常值可能对回归模型造成不好的影响，异常值包括三种：
#（1）远离回归线的离群点
#（2）远离自变量均值的杠杆点
#（3）对回归线有重要影响的高影响点
model <- lm(y ~ x, LMdata$Outlier)
plot(y ~ x, data = LMdata$Outlier)
abline(model)
summary(model)
# 诊断离群点和杠杆点的方法是计算学生化残差和杠杆值
# 更重要的是使用cook距离
# car包中的influencePlot函数能将三个指标用气泡图的形式绘制出来
require("car")
inf1 <- influencePlot(model)
# 可以发现样本点32对回归模型的影响很大，我们将其剔除，建立新模型
model2 <- update(model, y ~ x, subset = -32, data = LMdata$Outlier)
plot(y ~ x, data = LMdata$Outlier)
abline(model, lty = 1)
abline(model2, lty = 2)
summary(model2)

# 多重共线性
# 如果自变量之间存在线性关系，我们称为多重共线性，这对回归模型有很大的影响
model <- lm(y ~ x1 + x2 + x3, data = LMdata$Mult)
summary(model)
# 我们发现R方很高，但是各个自变量都没有通过检验，这可能就是遇到了多重共线性的问题；
# 我们使用car包中的vif函数来计算方差膨胀因子VIF
require("car")
vif(model)
# 发现自变量的VIF都很大，则三个变量都存在多重共线性关系；我们要剔除变量
# 方法是使用逐步回归的方式
model2 <- step(model)


# 6.3 线性回归的扩展

# 6.3.1 非线性回归
str(USPop)
ggplot(USPop, aes(x = year, y = population)) + geom_point()
scatterplot(population ~ year, data = USPop, boxplot = FALSE)
# 这是人口增长数据，人口模型可以采用Logistic增长函数形式
popmodel <- nls(population ~ theta1/(1 + exp(-(theta2 + theta3 * year))), 
                start = list(theta1 = 400, theta2 = -49, theta3 = 0.025),
                data = USPop, trace = FALSE)
summary(popmodel)$coefficients
# 可以采用内置的自启动模型，只需要指定函数形式即可，不需要指定参数的初始值
# Logistic函数对应的selfstarting函数名为SSlogis
popmodel2 <- nls(population ~ SSlogis(year, phi1, phi2, phi3), data = USPop)
summary(popmodel2)$coefficients
# 判断拟合效果，画图
with(USPop, plot(year, population, pch = 16))
with(USPop, lines(year, fitted(popmodel)))
with(USPop, lines(year, fitted(popmodel2)))
# 非线性模型，我们假设模型的残差是正态、独立和同方差
# 正态检验  stats包中的shapiro.test函数，实现Shapiro-Wilk正态性检验
res <- residuals(popmodel)
shapiro.test(res)
# 发现模型的残差不具备正态性 也可以画QQplot图
# 异方差检验
barlett.test(res)   # 这个检验貌似有问题了，再看
# 独立性检验
acf(res)

# 6.3.2 非参数回归
# 不假设函数的形式，而是通过数据归纳

# 6.3.2.1 局部多项式回归拟合

# 构造数据
x <- seq(0, 8*pi, length.out = 100)
y <- sin(x) + rnorm(100, sd = 0.3)
plot(x,y)
# 利用loess函数，进行回归拟合
model <- loess(y ~ x, span = 0.4)
lines(x, model$fitted, col = "red", lty = 2, lwd = 2)
model2 <- loess(y ~ x, span = 0.8)
lines(x, model2$fitted, col = "blue", lty = 2, lwd = 2)
# 将模型用于预测
predict(model2, data.frame(x))
# loess更多的是作为一种数据关系探索的方法

# 6.3.2.2 样条回归
# 将自变量分为多个组，每个组进行多项式回归
require("splines")
model1 <- lm(y ~ bs(x, df = 10, degree = 1)) #df表示把数据分成多少个区域，degree表示多项式的次数，一次项二次项……
prey <- predict(model1, newdata = list(x))
plot(x, y)
lines(x, prey, lwd = 1, col = "red")
# 增加degree，用2次项
model2 <- lm(y ~ bs(x, df = 10, degree = 2))
prey2 <- predict(model2, newdata = list(x))
lines(x, prey2, lwd = 1, col = "blue")

# 6.3.2.3 加性模型
require("mgcv")
str(trees)
head(trees)
model <- gam(Volume ~ s(Girth) + s(Height), data = trees)
par(mfrow = c(1, 2))
plot(model, se = T, resid = T, pch = 16)
summary(model)


# 6.3 Logistic回归

# 构造数据
set.seed(1)
b0 <- 1
b1 <- 2
b2 <- 3
x1 <- rnorm(1000)
x2 <- rnorm(1000)
z <- b0 + b1 * x1 + b2 * x2
pr <- 1/(1 + exp(-z))
y <- rbinom(1000, 1, pr)
plotdata <- data.frame(x1, x2, y = factor(y))
ggplot(plotdata, aes(x = x1, y = x2, color = y)) + 
  geom_point()
data <- data.frame(x1, x2, y)
model <- glm(y ~ ., data = data, family = "binomial")
summary(model)
w <- model$coefficients
inter <- -w[1]/w[3]
slope <- -w[2]/w[3]
ggplot(plotdata, aes(x = x1, y = x2, color = y)) + 
  geom_point() + 
  geom_abline(intercept = inter, slope = slope)
predict(model, newdata = list(x1 = 1, x2 = 3), type = "response")

