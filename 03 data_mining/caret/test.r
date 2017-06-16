
# setting the working directory
setwd("F:/百度云同步盘/Data Science/01 R/03 data mining/caret")
# loading the packages
library('caret')
set.seed(1)
# loading the data file
load('mutagen.RData')
load('descr.RData')
# eliminating the zero or near_zero variance variables
nzvdescr <- nearZeroVar(descr, saveMetrics = T)
table(nzvdescr$nzv)
nzvdescr <- nearZeroVar(descr)
filtereddescr <- descr[, -nzvdescr]
# spliting the data set into train set and test set
intrain <- createDataPartition(mutagen, p = 0.75, list = FALSE)
traindescr <- filtereddescr[intrain,]
testdescr <- filtereddescr[-intrain,]
trainclass <- mutagen[intrain]
testclass <- mutagen[-intrain]
# checking the structure of the train set and test set
prop.table(table(mutagen))
prop.table(table(trainclass))
prop.table(table(testclass))
# solving multicollinearity by checking the correlations bettween variables
ncol(traindescr)
descrcorr <- cor(traindescr[1:20], use = 'pairwise.complete.obs')
sum(is.na(descrcorr))
highcorr <- findCorrelation(descrcorr, 0.90)






