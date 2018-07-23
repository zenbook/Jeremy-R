
# http://rstudio-pubs-static.s3.amazonaws.com/33876_1d7794d9a86647ca90c4f182df93f0e8.html

# library packages =====================================================
library(rattle)
library(cluster)
library(reshape2)

# prepare data =========================================================
# import data
data("wine", package = 'rattle')
table(wine$Type)
# 'data.frame':	178 obs. of  14 variables:
# standardization
wine.stand <- scale(wine[-1])

# 1.kmeans =============================================================
# kmeas,k = 3
k.means.fit <- kmeans(wine.stand, 3)
# all the elements of the cluster outputs:
attributes(k.means.fit)
# cluster result
k.means.fit$cluster
# centers 各群在各变量上的均值
k.means.fit$center
# size 各群的样本数量
k.means.fit$size
# withiness 各群组内方差
k.means.fit$withinss
# conbine wine and cluster
wine$cluster1 <- k.means.fit$cluster 
table(wine$cluster1, wine$Type)

# how to choose the right k value?
# elbow criterion
wssplot <- function(data, nc = 15, seed = 1234){
  wss <- (nrow(data) - 1) * sum(apply(data, 2, var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers = i)$withiness)
  }
  plot(1:nc, wss, type = 'b', 
       xlab = 'Number of Clusters', 
       ylab = 'Within Groups Sum of Squares')
}
wssplot(wine.stand, nc = 6)

# plot
clusplot(wine.stand, k.means.fit$cluster, 
         main = '2D representation of the Cluster solution',
         color = TRUE, 
         shade = TRUE, 
         labels = 3, 
         lines = 0)
# evaluate the performance of clustering
table(wine[,1], k.means.fit$cluster)

# 2.Hierarchical clustering ============================================

## 选择合适的距离计算方式
d <- dist(wine.stand, method = 'euclidean')
H.fit <- hclust(d, method = 'ward.D')
attributes(H.fit)

## output
plot(H.fit)
## cut to 3 clusters
groups <- cutree(H.fit, k = 3)
## plot the border
rect.hclust(H.fit, k = 3, border = 'red')

## performance:confusion matrix
table(wine[, 1], groups)
prop.table(table(wine[, 1], groups))
prop.table(table(wine[, 1], groups), 1)
prop.table(table(wine[, 1], groups), 2)


# study case 1:European Protein Comsuption =============================

## prepare data
url = 'http://www.biz.uiowa.edu/faculty/jledolter/DataMining/protein.csv'
food <- read.csv(url)
## standardization
food.stand <- scale(food[-1])

## 01.use redmeat and whitemeat to clustering
set.seed(1234)
food.kmeans1 <- kmeans(food.stand[, c('RedMeat', 'WhiteMeat')], 
                       centers = 3, 
                       nstart = 10)
food.kmeans1
## list output
o <- order(food.kmeans1$cluster)
data.frame(food$Country[o], food.kmeans1$cluster[o])
## plot output
plot(x = food$RedMeat, y = food$WhiteMeat, type = 'n', 
     xlim = c(3, 19), xlab = 'RedMeat', ylab = 'WhiteMeat')
text(x = food$RedMeat, y = food$WhiteMeat, labels = food$Country, 
     col = food.kmeans1$cluster)

wssplot(food.stand, nc = 8)

## 02.use all variable to clustering
## modeling
set.seed(12345)
food.kmeans2 <- kmeans(food[, -1], centers = 7, nstart = 10)
## list output
o <- order(food.kmeans2$cluster)
data.frame(food$Country[o], food.kmeans2$cluster[o])
## plot output
clusplot(food[, -1], food.kmeans2$cluster, 
         main = '2D representation of the Cluster solution', 
         color = TRUE,
         shade = TRUE,
         labels = 2, 
         lines = 0)

## 03 层次聚类


# study case 2:Customer Segmentation ===================================

## prepare data
offer <- read.csv('offer.csv', header = TRUE)
colnames(offer) <- c('Offer', 'Campaign', 'Varietal', 'Minimum_qty', 
                     'Discount', 'Origin', 'Past_peak')
transaction <- read.csv('transaction.csv', header = TRUE)
colnames(transaction) <- c('Customer_last_name', 'Offer')
## transform data 
pivot <- dcast(transaction, Customer_last_name ~ Offer, fill = 0, 
               fun.aggregate = length)

## compute distance
D = daisy(pivot[, -1], metric = 'gower')

## clustering
H.fit <- hclust(D, method = 'ward.D2')

## output
plot(H.fit)
groups <- cutree(H.fit, k = 4)
rect.hclust(H.fit, k = 4, border = 'red')
clusplot(pivot, groups, color = TRUE, shade = TRUE, 
         labels = 2, lines = 0, main = 'Customer Segmentation')


customer_cluster <- merge(transaction, groups, 
                          by.x = 'Customer_last_name', 
                          by.y = 'row.names')
colnames(customer_cluster) <- c('name', 'offer', 'cluster')
head(customer_cluster)




