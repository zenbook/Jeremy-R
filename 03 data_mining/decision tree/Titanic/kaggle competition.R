
# description ===============================================================
# this code is made by Jeremy001
# based on the course of Trevor Stephens
# http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r/

# library packages and import data sets======================================

library(tidyverse)

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

















