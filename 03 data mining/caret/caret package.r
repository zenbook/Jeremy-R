# load the packages
library('caret')
library('AppliedPredictiveModeling')
library('mlbench')

# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 2.Visualization using caret package
# featurePlot()
# 2.1 Scatterplot Matrix
transparentTheme(trans = 0.4)
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = 'pairs',
            auto.key = list(columns = 3))
# 2.2 Scatterplot Matrix with Ellipses
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = 'ellipse',
            auto.key = list(columns = 3))
# 2.3 Overlayed Density Plots
transparentTheme(trans = 0.9)
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = 'density',
            scales = list(x = list(relation = 'free'),
                          y = list(relation = 'free')),
            adjust = 1.5,
            pch = '|',
            layout = c(4, 1),
            auto.key = list(columns = 3))
# 2.4 Box Plots
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = 'box',
            scales = list(y = list(relation = 'free'),
                          x = list(rot = 90)),
            layout = c(4, 1),
            auto.key = list(columns = 2))
# 2.5 Scatter Plots
data("BostonHousing")
regvar <- c('age', 'lstat', 'tax')
str(BostonHousing[, regvar])
featurePlot(x = BostonHousing[, regvar],
            y = BostonHousing$medv,
            plot = 'scatter',
            type = c('p', 'smooth'),
            span = 0.5,
            layout = c(3, 1))

# 3. pre_processing

# 3.1 creating dummy variables
library('earth')
data("etitanic")
head(model.matrix(survived ~., data = etitanic))
dummies <- dummyVars(survived ~., data = etitanic)
head(predict(dummies, newdata = etitanic))

# 3.2 zero and near-zero variance predictors
data(mdrr)
data.frame(table(mdrrDescr$nR11))
nzv <- nearZeroVar(mdrrDescr, saveMetrics = T)
nzv[nzv$nzv,][1:10,]
nzv[1:10,]
table(nzv$nzv)
dim(mdrrDescr)
nzv <- nearZeroVar(mdrrDescr)
filteredmdrr <- mdrrDescr[, -nzv]
dim(filteredmdrr)

# 3.3 identifying correlated predictors
mdrrcor <- cor(filteredmdrr)
highcor <- sum(abs(mdrrcor[upper.tri(mdrrcor)]) > 0.999)
summary(mdrrcor[upper.tri(mdrrcor)])
highcor <- findCorrelation(mdrrcor, cutoff = 0.75)
filteredmdrr <- filteredmdrr[, -highcor] # 这样是把相关的两个变量都剔除了吧？
dim(filteredmdrr)


# 3.4 linear dependencies
ltfrDesign <- matrix(0, nrow=6, ncol=6)
ltfrDesign[,1] <- c(1, 1, 1, 1, 1, 1)
ltfrDesign[,2] <- c(1, 1, 1, 0, 0, 0)
ltfrDesign[,3] <- c(0, 0, 0, 1, 1, 1)
ltfrDesign[,4] <- c(1, 0, 0, 1, 0, 0)
ltfrDesign[,5] <- c(0, 1, 0, 0, 1, 0)
ltfrDesign[,6] <- c(0, 0, 1, 0, 0, 1)
# column2 + column3 = column1
# column4 + column5 + column6 = column1
comboinfo <- findLinearCombos(ltfrDesign)
comboinfo
filteredltfrDesign <- ltfrDesign[, -comboinfo$remove]

# 3.5 the preProcess() function

# 3.6 centering and scaling
set.seed(96)
intrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2)
training <- filteredmdrr[intrain,]
testing <- filteredmdrr[- intrain,]
trainmdrr <- mdrrClass[intrain]
testmdrr <- mdrrClass[- intrain]
preprocvalues <- preProcess(training, method = c('center', 'scale'))
traintransformed <- predict(preprocvalues, training)
testtransformed <- predict(preprocvalues, testing)

# 3.7 imputation

# 3.8 transforming predictors


# 4. data splitting

# 4.1 Simple Splitting Based on the Outcome
set.seed(234)
irisindex <- createDataPartition(iris$Species, p = 0.8, list = F, times = 1) 
# list = F, avoid returns the data set into a list
length(irisindex)
iristrain <- iris[irisindex, ]
iristest <- iris[-irisindex, ]
prop.table(table(iris$Species))
prop.table(table(iristrain$Species))
prop.table(table(iristest$Species))

# 4.2 Splitting Based on the Predictors
data("BostonHousing")
head(BostonHousing)
testing <- as.data.frame(scale(BostonHousing[, c('age', 'nox')]))
set.seed(5)
startset <- sample(1:dim(testing)[1], 5)
samplepool <- testing[-startset,]
start <- testing[startset,]
newsample <- maxDissim(start, samplepool, n = 20)

# 4.3 Data Splitting for Time Series
















