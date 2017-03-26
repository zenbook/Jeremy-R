# load package ---------------------------------------------------
library("networkD3")
library('jsonlite')

# simpleNetwork --------------------------------------------------
src <- c("A", "A", "A", "A", "B", "B", "C", "C", "D")
target <- c("B", "C", "D", "J", "E", "F", "G", "H", "I")
networkdata <- data.frame(src, target)
simpleNetwork(networkdata)

# forceNetwork ---------------------------------------------------
data("MisLinks")
data("MisNodes")
forceNetwork(Links = MisLinks, 
             Nodes = MisNodes,
             Source = 'source',
             Target = 'target',
             Value = 'value',
             NodeID = 'name',
             Group = 'group',
             opacity = 0.8)

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


