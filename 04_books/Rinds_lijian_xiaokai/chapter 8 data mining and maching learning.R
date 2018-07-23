
# chapter 8 ==========================================================

# 8.1 数据挖掘的一般流程 =============================================

# 8.2 Clustering 聚类 ================================================

# 8.2.1 Hierarchical clustering 层次聚类 =============================

## 层次聚类也成为系统聚类，先把每个样本都单独作为一类，然后根据距离进行合并，
## 直到所有的样本都合并为一类；
## 聚类首先要清晰的定义样本之间的距离关系，计算类间距离的常用方法有以下六种：
## 最短距离法、最长距离法、类平均法、重心法、中间距离法、离差平方和法
## 用stats包中的hclust函数，该函数重要的参数包括：样本间的距离矩阵和计算类间距离的方法

## 用iris数据集，取前四个变量，标准化之后计算欧式距离矩阵：
data <- iris[,-5]
dataScale <- scale(data)
Dist <- dist(dataScale, method = "euclidean")

## 根据矩阵绘制热图
heatmap(as.matrix(Dist), labRow = F, labCol = F)

## 使用hclust函数建立聚类模型
clustemodel <- hclust(Dist, method = "ward.D2")
result <- cutree(clustemodel, k = 3)  #用cutree函数提取每个样本所属的类别
table(iris[, 5], result)  #观察聚类结果与真实分类的差别
plot(clustemodel)  #绘制聚类树图
rect.hclust(clustemodel, k = 3, border = 'red')

## 层次聚类的优缺点：
##（1）优点：基于距离矩阵进行聚类，不需要原始数据；可用于不同形状的聚类；
##          聚类前无需确定聚类个数
##（2）缺点：对异常点比较敏感，适用于较小规模的数据，不适合处理较大数据集

## 如果样本量很大，可以使用快速层次聚类fastcluster包
library("fastcluster")
clustemodel2 <- hclust(Dist, method = "ward.D2")
result <- cutree(clustemodel2, k = 3)  #用cutree函数提取每个样本所属的类别
table(iris[, 5], result)  #观察聚类结果与真实分类的差别
plot(clustemodel2)  #绘制聚类树图
rect.hclust(clustemodel2, k = 3, border = 'red')

## 聚类的关键是距离计算方法的选择，主要有：欧式距离\曼哈顿记录\两项距离\闵可夫斯基距离\
## 相关系数\夹角余弦\马氏距离……
## 必要时，还要考虑标准化和转换，也可以自定义距离矩阵

## 一些特别的距离要加载proxy包，如余弦距离
library("proxy")
res <- dist(data, method = "cosine")
clustemodel3 <- hclust(res, method = "ward.D2")
result <- cutree(clustemodel3, k = 3)  #用cutree函数提取每个样本所属的类别
table(iris[, 5], result)  #观察聚类结果与真实分类的差别
plot(clustemodel3)  #绘制聚类树图
rect.hclust(clustemodel3, k = 3, border = 'red')
## 用夹角余弦定义距离矩阵的聚类效果明显变好！！

## 对于二分类变量，可采用杰卡德(Jaccard)方法计算他们之间的距离
x <- c(0, 0, 1, 1, 1, 1)
y <- c(1, 0, 1, 1, 0, 1)
dist(rbind(x, y), method = "Jaccard")

## 如果要处理多个取值的分类变量，可以转成多个二分类变量，方法与因子变量转成哑变量一样

## 如果是分类变量和数值变量混合在一起，可以先用离差计算单个特征的距离，再进行合并计算
x <- c(0, 0, 1.2, 1, 0.5, 1, NA)
y <- c(1, 0, 2.3, 1, 0.9, 1, 1)
d <- abs(x - y)
dist <- sum(d[!is.na(d)])/6
dist


# 8.2.2 kmeans K均值聚类 =============================================

## K均值聚类又称为动态聚类，需要先确定聚类的个数，主要参数有：
## 数据对象\聚类个数\取随机初始中心的次数(默认为1)
clusteModel <- kmeans(dataScale, centers = 3, nstart = 10)
class(clusteModel)
table(iris$Species, clusteModel$cluster)

## kmeans函数默认采用欧氏距离，如果要使用其他距离计算方法，则使用cluster包的pam函数，
## 配合proxy包来计算
library("proxy")
library("cluster")
clusteModel2 <- pam(dataScale, k = 3, metric = "Mahalanobis")
clusteModel2$medoids
table(iris$Species, clusteModel2$clustering)

## 轮廓系数图和主成分散点图观察聚类效果
par(mfcol = c(1, 2))
plot(clusteModel2, which.plots = 2, main = "")
plot(clusteModel2, which.plots = 1, main = "")

## kmeans与pam的区别：kmeans的中心点是虚的，pam的中心点是真实的样本点；
## K均值聚类最初的类中心是随机选择的，这样可能会形成较差的聚类结果，如何改进使效果更好呢？
##（1）增加取随机初始中心的次数，nstart,如取值为10,20……
##（2）多做几次聚类；
##（3）先抽样，使用层次聚类确定初始的类中心
##（4）先聚成多个类，如10个，然后手工合并
##（5）采用两分法K均值聚类

## 如何确定合理的聚类个数K？
##（1）根据业务知识来确定
##（2）先用层次聚类来决定个数
##（3）对原始数据进行变换，如降维后再实施聚类
##（4）尝试多次聚类
##（5）根据聚类效果调整，如观察轮廓系数图
##（6）fpc包kmeansruns函数来自动探测最佳的聚类数
library("fpc")
pka <- kmeansruns(iris[, 1:4], krange = 2:6, critout = TRUE, runs = 2,criterion = "asw")
## 貌似聚成两类是最合适的？

## K均值聚类的优缺点和注意事项：
##（1）优点：快速简单
##（2）缺点：不合适非球形数据

## cluster扩展包中其他聚类函数：agnes—凝聚层次聚类；diana—划分层次聚类；fanny—模糊聚类

# 8.2.3 基于密度的聚类 ===============================================
## K均值聚类不适用于非球形的聚类，对于非球形聚类，我们需要用基于密度的聚类，
## 常用的是DBSCAN方法
x1 <- seq(0, pi, length.out = 100)
y1 <- sin(x1) + 0.1 * rnorm(100)
x2 <- 1.5 + seq(0, pi, length.out = 100)
y2 <- cos(x2) + 0.1 * rnorm(100)
data <- data.frame(c(x1, x2),c(y1, y2))
names(data) <- c("x", "y")
model1 <- kmeans(data,centers = 2,nstart = 10)
library(ggplot2)
ggplot(data, aes(x, y)) + geom_point(color = model1$cluster)
## 从聚类的结果可以看出，数据其实有很明显的分布特征，但是K均值聚类不能识别这种特征

## 用基于密度的聚类来做
library(fpc)
model2 <- dbscan(data, eps = 0.3, MinPts = 4)   #关键在于设置合理的eps和MinPts这两个参数
ggplot(data, aes(x, y)) + geom_point(color = model2$cluster)

# 8.2.4 自组织映射 ===================================================
##自组织映射SOM不仅是一种聚类技术，也是一种降维可视化技术
library(kohonen)
data <- as.matrix(iris[, -5])
somModel <- som(data, grid = somgrid(15, 10, "hexagonal"))
par(mfcol = c(1, 1))
plot(somModel, ncolors = 10, type = "dist.neighbours")

## 将原本的类别信息添加到图中
irisclass <- as.numeric(iris[, 5])
plot(somModel, type = "mapping", labels = irisclass, 
     col = irisclass + 3, main = "mapping plot")

# 8.3 Classification分类 =============================================
set.seed(1)
library("mlbench")
data(PimaIndiansDiabetes2)
data <- PimaIndiansDiabetes2
library("caret")
preprocvalues <- preProcess(data[, -9])



















