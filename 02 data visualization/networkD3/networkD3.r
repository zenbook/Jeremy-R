# load package ---------------------------------------------------
library("networkD3")
library('jsonlite')
library('dplyr')

# simpleNetwork --------------------------------------------------
src <- c("A", "A", "A", "A", "B", "B", "B", "C", "C", "D")
target <- c("B", "C", "D", "J", "E", "F", "J", "G", "H", "I")
networkdata <- data.frame(src, target)
simpleNetwork(networkdata,
              fontSize = 16)

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
             zoom = TRUE, 
             fontSize = 16,
             opacity = 0.8)

forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Nodesize = "size",
             radiusCalculation = "Math.sqrt(d.nodesize)+6",
             Group = "group", opacity = 0.4, legend = TRUE)

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
