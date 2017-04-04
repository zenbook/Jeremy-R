# setwd, load packages and dataset ------------------------------------------------
library('randomForest')
library('caret')
setwd('E:/R/Jeremy-R/03 data mining/random forest')
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
