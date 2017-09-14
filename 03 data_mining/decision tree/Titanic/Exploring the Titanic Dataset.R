
# load packages ========================================================
library(ggplot2)
library(ggthemes)
library(scales)
library(dplyr)
library(mice)
library(randomForest)


# load dataset =========================================================
train = read.csv('train.csv', stringsAsFactors = FALSE)
test = read.csv('test.csv', stringsAsFactors = FALSE)
full = bind_rows(train, test)
str(full)

# feature engineering ==================================================

# 1.乘客的Name中包含了一些称谓，如Mr Mrs, Miss, 称谓反映了乘客的社会地位和身份；
full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
table(full$Title, full$Sex)























