# load package ---------------------------------------------------
library("networkD3")
library('jsonlite')
library('dplyr')

# simpleNetwork --------------------------------------------------
#函数结构
simpleNetwork(Data = ,  # 数据源，三列，第一列：source,第二列：target,第三列：edge value;目前不影响
              Source = ,  # 如果未指定，默认数据源第一例
              Target = ,  # 如果未指定，默认数据源第二列
              height = ,  # 图形高度，用像素表示'200px'
              width = ,  # 图形宽度，用像素表示'200px'
              linkDistance = ,  # 连接线的长度，用像素表示'30px'
              charge = ,  # 表示两个节点的强度是吸引还是排斥，用正负数字表示
              fontSize = ,  # 节点文本的字号
              fontFamily = ,  # 节点文本的字体
              linkColour = ,  # 连接线的颜色
              nodeColour = ,  # 节点的颜色
              nodeClickColour = ,  # 节点被点击后的颜色，同时改变文本的颜色
              textColour = ,  # 节点文本的颜色
              opacity = ,  # 不透明度
              zoom = ) # 是否可缩放
src <- c("A", "A", "A", "A", "B", "B", "B", "C", "C", "D")
target <- c("B", "C", "D", "J", "E", "F", "J", "G", "H", "I")
networkdata <- data.frame(src, target)
# 设置字体，字号
simpleNetwork(networkdata, 
              fontSize = 16,
              fontFamily = 'sans-serif')
simpleNetwork(networkdata,
              linkColour = 'red',
              nodeColour = 'green',
              textColour = 'orange',
              fontSize = 16, 
              fontFamily = 'fantasy',
              charge = -100)

# forceNetwork ---------------------------------------------------
# 函数结构
forceNetwork(Links = ,  # links between nodes, 3 vars:Source,Target,Value
                        # Source=0,Nodes中的第一个记录,target=0,Nodes中的第一个记录
                        # Value,表示这条连接的强度，数字越大，连接线越粗
             Nodes = ,  # Nodes
             Source = ,  # links中的source字段
             Target = ,  # links中的target字段
             Value = ,  # links中的value字段
             NodeID = ,  # Nodes中的nodeid，比如misnodes中的name
             Nodesize = ,  # Nodes中的size，代表每个节点的大小
             Group = ,  # Nodes中的group，代表各个节点的分组
             height = ,
             width = ,
             colourScale = ,  # 节点的颜色
             fontSize = ,  # 节点文本的字号
             fontFamily = ,  # 节点文本的字体
             linkDistance = ,  # 连接线的长度，用像素表示'30px'
             linkWidth = ,  # 连接线的宽度，用像素表示
             radiusCalculation = ,  # 节点半径计算方式
             charge = ,  # 表示两个节点的强度是吸引还是排斥，用正负数字表示
             linkColour = ,  # 连接线的颜色
             opacity = ,  # 不透明度
             zoom = ,  # 缩放, true, false
             legend = , # 图例 true, false
             bounded = ,  # 边界 true，false
             opacityNoHover = ,  # 鼠标不移入时，不透明度
             clickAction =  # 提示某个节点被点击了
             )
data("MisLinks")
data("MisNodes")
links01 <- filter(MisLinks, target == 0 & source != 11)
nodes01 <- head(MisNodes, 10)
forceNetwork(Links = links01, 
             Nodes = nodes01,
             Source = 'source',
             Target = 'target',
             Value = 'value',
             NodeID = 'name',
             Nodesize = 'size',
             Group = 'group',
             zoom = TRUE, 
             fontSize = 16,
             opacity = 0.8)

forceNetwork(Links = MisLinks, 
             Nodes = MisNodes, 
             Source = "source",
             Target = "target", 
             Value = "value", 
             NodeID = "name",
             Nodesize = "size",
             radiusCalculation = "Math.sqrt(d.nodesize)+6",
             Group = "group", 
             opacity = 0.6, 
             legend = TRUE)

# sankeyNetwork --------------------------------------------------
URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
              'master/JSONdata/energy.json')
Energy <- jsonlite::fromJSON(URL)
sankeyNetwork(Links = Energy$links, 
              Nodes = Energy$nodes,
              Source = 'source',
              Target = 'target',
              Value = 'value',
              NodeID = 'name',
              units = 'TWh',
              fontSize = 12,
              nodeWidth = 30)

#### JSON Data Example
# Load data JSON formated data into two R data frames
# Create URL. paste0 used purely to keep within line width.
URL <- paste0("https://cdn.rawgit.com/christophergandrud/networkD3/",
              "master/JSONdata/miserables.json")

MisJson <- jsonlite::fromJSON(URL)

# Create graph
forceNetwork(Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8)

# Create graph with zooming
forceNetwork(Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8, zoom = TRUE)


# Create a bounded graph
forceNetwork(Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8, bounded = TRUE)

# Create graph with node text faintly visible when no hovering
forceNetwork(Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8, bounded = TRUE,
             opacityNoHover = TRUE)

## Specify colours for specific edges
# Find links to Valjean (11)
which(MisNodes == "Valjean", arr = TRUE)[1] - 1
ValjeanInds = which(MisLinks == 11, arr = TRUE)[, 1]

# Create a colour vector
ValjeanCols = ifelse(1:nrow(MisLinks) %in% ValjeanInds, "#bf3eff", "#666")

forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8, linkColour = ValjeanCols)


## Create graph with alert pop-up when a node is clicked.  You're
# unlikely to want to do exactly this, but you might use
# Shiny.onInputChange() to allocate d.XXX to an element of input
# for use in a Shiny app.

MyClickScript <- 'alert("You clicked " + d.name + " which is in row " +
(d.index + 1) +  " of your original R data frame");'

forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 1, zoom = FALSE,
             bounded = TRUE, clickAction = MyClickScript)

## End(Not run)
