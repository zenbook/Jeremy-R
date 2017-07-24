
# library packages =====================================================
library(rattle)
library(cluster)

# prepare data =========================================================
# import data
data("wine", package = 'rattle')
table(wine$Type)
# 'data.frame':	178 obs. of  14 variables:
# standardization
wine.stand <- scale(wine[-1])

# modeling =============================================================
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


















