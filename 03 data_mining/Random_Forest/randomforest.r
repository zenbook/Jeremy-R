
# library packages ===================================================
library('randomForest')
library('caret')
library('mice')
library('tidyverse')


# case stydy 01 ======================================================

data <- read.csv('Cardiotocographic.csv', header = TRUE)

# 把响应变量NSP转变成因子型
data$NSP <- as.factor(data$NSP)
table(data$NSP)

# 把数据集分成训练集和测试集
set.seed(123)
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
train <- data[ind == 1,]
test <- data[ind == 2,]
table(train$NSP)
table(test$NSP)

# 用randomforest进行分类
set.seed(222)
rf <- randomForest(NSP ~ ., data = train)
print(rf)
attributes(rf)
rf$confusion

# 用模型预测train数据集，并查看混淆矩阵
p1 <- predict(rf, data = train)
confusionMatrix(p1, train$NSP)

# 用模型预测test数据集，并查看混淆矩阵
p2 <- predict(rf, test)
confusionMatrix(p2, test$NSP)

# error rate of random forest
plot(rf)
# 可以看出，决策树数量在200以上的时候，错误率已经趋于平稳了

# 调试模型参数mtry
t <- tuneRF(train[, -22], train[, 22],
       stepFactor = 0.5,
       plot = TRUE,
       ntreeTry = 300,
       trace = TRUE,
       improve = 0.05)
# 可以看出，mtry = 8时OOB error最小

# 修改模型参数，再次生成模型
rf2 <- randomForest(NSP ~ ., data = train,
                    ntree = 300,
                    mtry = 8,
                    importance = TRUE,
                    proximity = TRUE)
print(rf2)

# 看新模型在test数据集上的预测精度如何
p22 <- predict(rf2, test)
confusionMatrix(p22, test$NSP)

# no. of nodes for the Trees
hist(treesize(rf),
     main = 'no, of nodes for the Trees',
     col = 'green')
hist(treesize(rf2),
     main = 'no, of nodes for the Trees',
     col = 'green')

# 变量重要性
importance(rf)
varImpPlot(rf)
importance(rf2)
varImpPlot(rf2)
# 左图表示：how worse the model performs without each variable
# 右图表示：how pure the nodes are at the end of the tree without each variable
# 排在最上方的变量最重要，最下方的最不重要

# 选取最重要的10个变量
varImpPlot(rf2,
           sort = TRUE,
           n.var = 10,
           main = 'TOP 10 variables importance')

# 看看随机森林模型中真正用到的变量有哪些
varUsed(rf)
varUsed(rf2)

# 因变量对自变量的依赖
partialPlot(rf2, train, ASTV, '1')
partialPlot(rf2, train, ASTV, '3')
partialPlot(rf2, train, ASTV, '2')

# 获取随机森林中的决策树
getTree(rf2, 1, labelVar = TRUE)

# Multi-dimensional Scaling plot for random forest
MDSplot(rf2, train$NSP)


# case study 02 ======================================================

## 01 business understanding ===================
# In this example, the bank wanted to cross-sell term deposit product to its customers.
# Contacting all customers is costly and does not create good customer experience. 
# So, the bank wanted to build a predictive model which will identify customers who are 
# more likely to respond to term deport cross sell campaign.

## 02 prepare data =============================
bank_add_full <- read.csv(
  './data/bank-additional/bank-additional-full.csv', 
  header = TRUE,
  sep = ';'
)
str(bank_add_full)
table(bank_add$y)
prop.table(table(bank_add_full$y))

## 03 clean and transform data =================

## missing value
sum(complete.cases(bank_add_full))
md.pattern(bank_add_full)
## 发现没有缺失值

## outlier
summary(bank_add_full)
boxplot(bank_add_full$age)
boxplot(bank_add_full$duration)
boxplot(bank_add_full$pdays)
sum(bank_add_full$pdays == 0)
## 虽然有异常值，但是目前还无法确定这些异常值是否可进一步处理，所以暂不处理

## split data into train and validation sample
set.seed(1234)
bank_index <- createDataPartition(bank_add_full$y, 
                                  p = 0.7, 
                                  list = FALSE, 
                                  times = 1)
bank_train <- bank_add_full[bank_index, ]
bank_valid <- bank_add_full[-bank_index, ]
prop.table(table(bank_train$y))
prop.table(table(bank_valid$y))
## 训练集和验证集中样本分布基本无差异，OK！

## 04 modeling =================================

## make formula
varnames <- names(bank_add_full)
varnames <- varnames[!varnames %in% c('y')]
varnames <- paste(varnames, collapse = '+')
rf_formu <- as.formula(paste('y', varnames, sep = ' ~ '))

## modeling
rf_model <- randomForest(rf_formu, 
                         bank_train, 
                         ntree = 500, 
                         importance = TRUE)
attributes(rf_model)
rf_model
## 看最后的混淆矩阵，发现精准度不高，主要是对yes的分类不精准；

## plot
plot(rf_model)

## variable importance
varImpPlot(rf_model, 
           sort = TRUE, 
           main = 'Variable Importance', 
           n.var = 6)
var_impo <- data.frame(rownames(rf_model$importance), rf_model$importance[, 4])
colnames(var_impo) <- c('var_name', 'MeanDecreaseGini')
rownames(var_impo) <- NULL
var_impo <- var_impo %>% 
  arrange(-MeanDecreaseGini)

## model performance



## 

confusionMatrix(data = rf_model$predicted, 
                reference = bank_train$y, 
                positive = 'yes')













