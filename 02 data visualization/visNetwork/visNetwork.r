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

# 参考资源
## vignette("Introduction-to-visNetwork")
## shiny::runApp(system.file("shiny", package = "visNetwork"))
## http://datastorm-open.github.io/visNetwork/

# nodes ------------------------------------------------------------------------
## nodes必须是dataframe,至少包含id列
visNodes(nodes,
         id = ,  # node的id
         shape = ,  # node的形状,ellipse, circle, database, box, text
         size = ,  # node的大小,默认25
         title = ,
         value = ,
         x = ,
         y = ,
         label = ,
         level = ,
         group = ,
         hidden = ,
         image = ,
         mass = ,
         physics = ,
         borderWidth = ,
         borderWidthSelected = ,
         brokenImage = ,
         labelHighlightBold = ,
         color = ,
         fixed = ,
         font = ,
         icon = ,
         shadow = ,
         scaling = ,
         shapeProperties = )
nodes <- data.frame(id = 1:10,
                    label = paste('node', 1:10),
                    group = c('A', 'B'),
                    value = 1:10,
                    shape = c('square', 'triangle', 'box', 'circle', 'dot',
                              'star', 'ellipse', 'database', 'text', 'diamond'),
                    title = paste0("<p><b>", 1:10, "</b><br>Node !</p>"),
                    color = c('darked', 'grey', 'orange', 'darkblue', 'purple'),
                    shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE))
edges <- data.frame(from = c(1, 2, 4, 7, 8, 10), to = c(6, 9, 5, 3, 1, 5))
visNetwork(nodes, edges, height = '500px', width = '100%')
# global configuration
# 设置所有的node都相同的样式
visNetwork(nodes, edges, width = '100%') %>% 
  visNodes(shape = 'square',
           color = list(background = 'lightblue',
                        boder = 'darkblue',
                        highlight = 'orange'),
           shadow = list(enabled = TRUE, 
                         size = 10)) %>% 
  visLayout(randomSeed = 12)
# combine individual and global configuration
nodes <- data.frame(id = 1:4,
                    shape = c('square', 'circle'),
                    label = LETTERS[1:4])
edges <- data.frame(from = c(2,4,3,3), 
                    to = c(1,2,4,2))
visNetwork(nodes, edges, width = '100%') %>% 
  visNodes(color = list(backgroundc = 'lightblue',
                        border = 'darkblue',
                        highlight = 'orange'),
           shadow = list(enabled = TRUE, 
                         size = 10)) %>% 
  visLayout(randomSeed = 12)
# use complex configuration individually
nodes <- data.frame(id = 1:4, 
                    shape = c('square', 'circle'),
                    color.background = 'lightblue',
                    color.border = 'darkblue',
                    color.highlight = 'orange', 
                    label = LETTERS[1:4])
edges <- data.frame(from = c(2,4,3,3), 
                    to = c(1,2,4,2),
                    label = letters[1:4],
                    font.color = c('red', 'blue'),
                    font.size = c(10, 20))
visNetwork(nodes, edges, width = '100%')

# edges --------------------------------------------------------------
visEdges(edges,
         title = ,
         value = ,
         label = ,
         length = ,
         width = ,
         dashes = ,
         hidden = ,
         hoverWidth = ,
         id = ,
         physics = ,
         selectionWidth = ,
         selfReferenceSize = ,
         labelHighlightBold = ,
         color = ,
         font = ,
         arrows = ,
         arrowStrikethrough = ,
         smooth = ,
         shadow = ,
         scaling = )
nodes <- data.frame(id = 1:10, 
                     group = c('A', 'B'))
edges <- data.frame(from = sample(1:10, 8), 
                    to = sample(1:10, 8),
                    label = paste("Edge", 1:8),
                    length = c(100, 500),
                    width = c(4, 1),
                    arrows = c('to', 'from', 'middle', 'middle;to'),
                    dashes = c(TRUE, FALSE),
                    title = paste("Edge", 1:8),
                    smooth = c(FALSE, TRUE),
                    shadow = c(FALSE, TRUE, FALSE, TRUE))
visNetwork(nodes, edges, height = '500px', width = '100%')





















