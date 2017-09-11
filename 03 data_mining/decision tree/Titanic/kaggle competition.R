
# description ===============================================================
# this code is made by Jeremy001
# based on the course of Trevor Stephens
# http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r/

# library packages and import data sets======================================

library(tidyverse)
library(rattle)
library(rpart)
library(rpart.plot)
library(RColorBrewer)

train <- read_csv('train.csv')
test <- read_csv('test.csv')

# first try =================================================================
table(train$Survived)
prop.table(table(train$Survived))
# 38%左右的乘客存活了下来，不到一半，那么我们先猜测test中所有人都died吧
test$Survived <- rep(0, 418)
submit <- select(test, PassengerId, Survived)
write_csv(submit, 'theyalldied.csv')
# 提交到kaggle后发现准确率只有62%，跟train数据集的存活比例差不多；

# second try ================================================================
# 'women and chidren first!!'
# maybe women are more likely survived?

table(train$Sex)
prop.table(table(train$Sex, train$Survived))

train %>% 
  count(Sex) %>% 
  mutate(prop = n / sum(n))

train %>% 
  count(Sex, Survived) %>% 
  mutate(prop = n / sum(n))

# 发现男性的存活率特别低，不到20%；而女性的存活率高达四分之三！
# 那我们不妨猜测test中男性都died,而女性全部存活；

test$Survived <- 0
test[test$Sex == 'female', 'Survived'] <- 1

# Kaggle反馈：预测的准确性提升到了76.56%

# third try ==================================================================
# 'women and chidren first!!'
# maybe children are more likely survived?
summary(train$Age)
# there're 177 missing values
# create a new column child, if age < 18 then child = 1
train$Child <- 0
train$Child[train$Age < 18] <- 1
# 不同性别不同年龄的存活率如何？
aggregate(Survived ~ Child + Sex, data = train, FUN = sum)
aggregate(Survived ~ Child + Sex, data = train, FUN = length)
aggregate(Survived ~ Child + Sex, 
          data = train, 
          FUN = function(x) {sum(x)/length(x)})
# 发现跟年龄没有多大关系
# 只是男孩的存活率比成年人大一些，但是相比与女生，存活率还是较低

# fourth try =================================================================
# 看看船票价格和舱位等级对存活率是否有影响
train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '0-10'
table(train$Fare2)

aggregate(Survived ~ Fare2 + Pclass + Sex, data = train, FUN = sum)
aggregate(Survived ~ Fare2 + Pclass + Sex, data = train, FUN = length)
aggregate(Survived ~ Fare2 + Pclass + Sex, 
          data = train, 
          FUN = function(x) {sum(x)/length(x)})
# 发现femal票价20-30及30+ & Pclass = 3的存活率明显低于其他组
# 因此我们修正一下之前的“预测”
test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & Pclass == 3 & Fare >= 20] <- 0


# mocel ======================================================================

fit <- rpart(Survived ~ Sex, 
             data = train, 
             method = 'class')
fancyRpartPlot(fit)







