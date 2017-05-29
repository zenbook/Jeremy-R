
# ============================== library packages ==============================
library(VIM)
library(mice)
library(tibble)
library(tidyverse)
data("sleep", package = "VIM")
tsleep <- as_tibble(sleep)
tsleep

# ============================ 15.1 处理缺失值的步骤 ============================

## 识别缺失数据
## 检查导致数据缺失的原因
## 删除包含缺失值的实例或用合理的数值代替（插补）缺失值

# 数据缺失产生的原因

## 完全随机缺失 missing completely at random MCAR
## 某个变量是否有缺失值与已观测和未观测的变量都没有关系

## 随机缺失 missing at random MAR
## 某个变量是否有缺失值与已观测的变量有关，但与自身的未观测值无关

## 非随机缺失 not missing at random NMAR
## 与自身的未观测值有关

# ============================== 15.2 识别缺失值 ==============================

## NA(not available): missing value
## NaN(not a number): impossible value
## inf(infinity): infinite value

## 判断是否缺失值
x <- c(1, NA, NaN, Inf)
is.na(x)
is.nan(x)
is.infinite(x)

## 判断是否完整实例（每个变量都没有缺失值的实例）
complete.cases(tsleep)
tsleep[complete.cases(tsleep), ]
## 返回至少有一个缺失值的实例
tsleep[!complete.cases(tsleep), ]

## TRUE = 1, FALSE = 0, sum得实例数，mean得比例
sum(is.na(tsleep$Dream))
mean(is.na(tsleep$Dream))
mean(!complete.cases(tsleep))

# ============================ 15.3 探索缺失值的模式 ============================

## 15.3.1 列表展示缺失值模式
## misc包的md.pattern()
md.pattern(tsleep)

## 15.3.2 图形展示缺失值模式
## VIM包
aggr(tsleep, prop = FALSE, numbers = TRUE)
aggr(tsleep, prop = FALSE, numbers = TRUE, plot = FALSE)
summary(aggr(tsleep, plot = FALSE))
aggr(tsleep, prop = TRUE, numbers = TRUE)

matrixplot(tsleep)

marginplot(tsleep[, c("Gest", "Dream")], 
           pch = c(20), 
           col = c("darkgray", "red", "blue"))
## VIM包中还有其他图形用于展示缺失值模式，可继续探索

## 15.3.3 用相关性探索缺失值
qsleep <- as_tibble(abs(is.na(tsleep)))
ysleep <- qsleep[sapply(qsleep, sd) > 0]
cor(ysleep)
cor(tsleep, ysleep, use = "pairwise.complete.obs")

# ============================ 15.5/6/7 处理缺失值 ============================

# 推理法填补缺失值
## 三个变量有计算关系，如A = B + C
## 身份证号码推断性别/年龄
## 邮政编码推断省市区

# 行删除法
oksleep <- tsleep[complete.cases(tsleep), ]
oksleep <- na.omit(tsleep)
options(digits = 1)
cor(oksleep)
cor(tsleep, use = "complete.obs")

fit <- lm(Dream ~ Gest + Span, data = na.omit(tsleep))
summary(fit)

fit2 <- lm(Dream ~ Gest + Span, data = tsleep)
summary(fit2)

# 多重插补法
imp <- mice(tsleep, seed = 1234)
fit <- with(imp, lm(Dream ~ Span + Gest))
pooled <- pool(fit)
summary(pooled)
## 查看某个变量中缺失值插补后的值
tmp$imp$Dream
## 查看插补后的完整数据集
complete(imp, 3) # 这个有问题



