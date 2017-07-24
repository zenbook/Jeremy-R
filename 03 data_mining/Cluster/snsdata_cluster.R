
# library packages =====================================================
library(tidyverse)

# prepare data =========================================================

## 1.import data
teens <- read.csv('snsdata.csv')

## 2.dealing with missing values
table(teens$gender)
table(teens$gender, useNA = 'ifany')
prop.table(table(teens$gender, useNA = 'ifany'))
## dummy coding(extract gender variable to two varialbes:female and no_gender)
teens$female <- ifelse(teens$gender == 'F' & !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)
table(teens$female, useNA = 'ifany')
table(teens$no_gender, useNA = 'ifany')

## 3.dealing with outliers
summary(teens$age)
## there are students with extremely large(106.927) and small age(3.086)
boxplot(teens$age)
ggplot(teens,aes(age)) + 
  geom_histogram(binwidth = 1)
## recode outliers to be missing value NA
teens$age <- ifelse(teens$age >= 13 & teens$age <= 20, teens$age, NA)
summary(teens$age)
## compute the average age for total dataset
mean(teens$age, na.rm = TRUE)
## compute the average age for every grade year
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)
## use ave to get a vector mean age per grade year
avg_age <- ave(teens$age, teens$gradyear, 
               FUN = function(x)mean(x, na.rm = TRUE))
## replacing missing value with avg_age
teens$age <- ifelse(is.na(teens$age), avg_age, teens$age)
summary(teens$age)

# modeling =============================================================

## modeling 1st time =============================
## variable gender is duplicate
teens_kmeans <- kmeans(teens[, -2], 5)
attributes(teens_kmeans)
teens_kmeans$size

## modeling 2nd time =============================
## only use interests
interests <- teens[, 5:40]
## standardization
interests_z <- as.data.frame(lapply(interests, scale))
teens_cluster <- kmeans(interests_z, 5)
## check average value of each cluster on every interests
## 通过对比不同群在各个兴趣上的平均水平，发现各个群的特征差异
teens_cluster$center
## 把聚类结果存入原数据集中，看看分群与其他变量的关系
teens$cluster <- as.factor(teens_cluster$cluster)
table(teens$cluster)
teens[1:5, c("cluster", 'gender', 'friends', 'age')]
## average age per cluster
aggregate(data = teens, age ~ cluster, mean)
## 发现分群与年龄没太大关系，各群的平均年龄差不多
## average friends number per cluster
aggregate(data = teens, friends ~ cluster, mean)
## 有差异，朋友数量对分群有用，可加入模型中
## female propertion per cluster(total:73.5%)
aggregate(data = teens, female ~ cluster, mean)
## cluster=1,88.4%girls;cluster=4,69.6%girls female对分群也有作用

## modeling 3rd time =============================
## prepare data
teens3 <- teens[, 4:40]
teens3_z <- as.data.frame(lapply(teens3, scale))
female <- teens[, 41]
teens3_z <- cbind(teens3_z, female)
## modeling
teens3_cluster <- kmeans(teens3_z, 5)
## add cluster to teens data frame
teens$cluster3 <- as.factor(teens3_cluster$cluster)
table(teens$cluster3)
prop.table(table(teens$cluster3))
table(teens$cluster)
prop.table(table(teens$cluster))
## 发现加入年龄和性别变量后，分群后的比例更加悬殊
## 加入朋友数量这一变量后，分群后的朋友数量平均值差异更大
aggregate(data = teens, friends ~ cluster3, mean)
## 1/2/4群的女生比例均超过83%，female变量对分群有较大影响
aggregate(data = teens, female ~ cluster3, mean)

ggplot(teens, aes(cluster, friends)) + 
  geom_boxplot()
ggplot(teens, aes(cluster3, friends)) + 
  geom_boxplot()








