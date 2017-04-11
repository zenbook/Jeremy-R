# how to get start -------------------------------------------------------------
# cran
install.packages('visNetwork')
# github
devtools::install_github('datastorm-open/visNetwork')
# load library
library('visNetwork')

# demo -------------------------------------------------------------------------
nodes <- data.frame(id = 1:4)
edges <- data.frame(from = c(1, 2, 3, 4), to = c(2, 3, 4, 1))
visNetwork(nodes, 
           edges, 
           width = '100%')  # 让图形伸展开
## 说明：
## visNetwork至少需要两个信息：
## 1.nodes:id
## 2.edges:from and to
