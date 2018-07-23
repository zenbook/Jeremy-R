# load pacckages --------------------------------------------------------------------
library('leaflet')
library('magrittr')
library('sp')
library('maps')
library('htmltools')

# http://rstudio.github.io/leaflet/
# http://leafletjs.com/
# https://github.com/rstudio/leaflet

# first case ------------------------------------------------------------------------
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m

# abount leaflet map ----------------------------------------------------------------
# 经纬度参数，longitude，lng, long；latitude, lat；
df <- data.frame(lat = 1:10, long = rnorm(10))
#以下四个代码等价：可以不指明经纬度参数的字段名称
leaflet(df) %>% addCircles()
leaflet(df) %>% addCircles(lng = ~Long, lat = ~Lat)
leaflet() %>% addCircles(data = df)
leaflet() %>% addCircles(data = df, lat = ~ Lat, lng = ~ Long)

# sp --------------------------------------------------------------------------------
sr1 <- Polygon(cbind(c(2, 4, 4, 1, 2), c(2, 3, 5, 4, 2)))
sr2 <- Polygon(cbind(c(5, 4, 2, 5), c(2, 3, 2, 2)))
sr3 <- Polygon(cbind(c(4, 4, 5, 10, 4), c(5, 3, 2, 5, 5)))
sr4 <- Polygon(cbind(c(5, 6, 6, 5, 5), c(4, 4, 3, 3, 4)), hole = TRUE)
sr11 <- Polygons(list(sr1), 's1')
sr21 <- Polygons(list(sr2), 's2')
sr31 <- Polygons(list(sr4, sr3), 's3/4')
spp <- SpatialPolygons(list(sr11, sr21, sr31), 1:3)
leaflet() %>% addPolygons(data = spp)

# maps -----------------------------------------------------------------------------
mapstate <- map('state', fill = TRUE, plot = FALSE)
leaflet(data = mapstate) %>% 
  addTiles() %>% 
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# formula interface ----------------------------------------------------------------
m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles() %>% addMarkers()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

# base maps ------------------------------------------------------------------------
# 默认使用openstreetmap
m <- leaflet() %>% 
  setView(lng = 116.403972, lat = 39.915122, zoom = 16)
m %>% addTiles()
# 加载第三方地图
names(providers) # 查看都有哪些第三方地图提供
m %>% addProviderTiles(providers$OpenMapSurfer)
m %>% addProviderTiles(providers$Stamen.Toner)
m %>% addProviderTiles(providers$HikeBike)

# markers --------------------------------------------------------------------------
leaflet(quakes[1:20, ]) %>% 
  addTiles() %>% 
  addMarkers()

# 设置参数
leaflet(quakes[1:20, ]) %>% 
  addTiles() %>% 
  addMarkers(popup = ~as.character(mag), # 点击后显示的文字内容
             label = ~as.character(mag)) # 鼠标移入时显示的文字内容

# Show first 20 rows from the `quakes` dataset
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag))
# 使用自定义的图标 makeIcon(), icons(), iconList()
## makeIcon()
greenleaficon <- makeIcon(
  iconUrl = 'http://leafletjs.com/examples/custom-icons/leaf-green.png',
  iconWidth = 38, 
  iconHeight = 95,
  iconAnchorX = 22, 
  iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, 
  shadowHeight = 64,
  shadowAnchorX = 4, 
  shadowAnchorY = 62
)
leaflet(data = quakes[1:4, ]) %>% 
  addTiles() %>% 
  addMarkers(icon = greenleaficon)
## 自定义图标，值不同，图标不同 icons()
quakes1 <- quakes[1:5, ]
leaficons <- icons(
  iconUrl = ifelse(quakes1$mag < 4.6, 
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png", 
                   "http://leafletjs.com/examples/custom-icons/leaf-red.png"),
  iconWidth = 38, 
  iconHeight = 95,
  iconAnchorX = 22, 
  iconAnchorY = 94
)
leaflet(data = quakes1) %>% 
  addTiles() %>% 
  addMarkers(icon = leaficons)
## iconList()
oceanicons <- iconList(
  ship = makeIcon('ferry-18.png', 'ferry-18@2x.png', 18, 18), # 怎么设置具体的icon？
  pirate = makeIcon('danger-24.png', 'danger-24@2x.png', 24, 24)
)
df <- sp::SpatialPointsDataFrame(
  cbind((runif(20) - .5) * 10 - 90.620130,
        (runif(20) - .5) * 3.8 + 25.638077),
  data.frame(type = factor(
    ifelse(runif(20) > 0.75, 'pirate', 'ship'),
    c('ship', 'pirate')
  ))
)
leaflet(df) %>% 
  addProviderTiles(providers$HikeBike) %>%  
  addMarkers(icon = ~oceanicons[type])
# 使用其他iconfont,如Font Awesome, Bootstrap Glyphicons and Ion icons
# 用addAwesomeMarkers代替addMarkers, makeAwesomIcon(), awesomeIcons(), awesomeIconList()
## addAwesomeMarkers, awesomeIcons()
leaflet(quakes1) %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addAwesomeMarkers(icon = awesomeIcons(icon = 'map-marker', 
                                        iconColor = 'black',
                                        library = 'fa'))  # ion, fa, glyphicon
df20 <- quakes[1:20, ]
getcolors <- function(quakes){
  sapply(quakes$mag, function(mag){
    if(mag <= 4){
      "green"
      }
    else if(mag <= 5){
      "orange"
      }
    else{
      "red"
      }
  })
}
icons <- awesomeIcons(
  icon = 'map-marker',
  iconColor = 'black',
  library = 'fa',
  markerColor = getcolors(df20)
)
leaflet(df20) %>% 
  addTiles() %>% 
  addAwesomeMarkers(icon = icons, label = ~as.character(mag))
  
# marker cluster
leaflet(quakes) %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addMarkers(clusterOptions = markerClusterOptions())

# circle markers
leaflet(df) %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addCircleMarkers()
# 设置参数
pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))
leaflet(df) %>% 
  addProviderTiles(providers$HikeBike) %>%
  addCircleMarkers(
    radius = ~ifelse(type == "ship", 6, 10),
    color = ~pal(type),
    stroke = FALSE, fillOpacity = 0.5
  )

# popups and labels ----------------------------------------------------------------
## popups
content <- paste(sep = "<br/>",
                 "<b><a href = 'http://www.baidu.com'>天安门广场</a></b>",
                 "前门大街1号",
                 "北京市")
leaflet() %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addPopups(lng = 116.403972, 
            lat = 39.915122,
            content,
            options = popupOptions(closeButton = FALSE))
df <- read.csv(textConnection(
  "Name, Lat, Long
  Samurai Noodle,47.597131,-122.327298
  Kukai Ramen,47.6154,-122.327157
  Tsukushinbo,47.59987,-122.326726"
))
leaflet(df) %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addMarkers(popup = ~htmlEscape(Name))
## labels
leaflet(df) %>% 
  addProviderTiles(providers$HikeBike) %>% 
  addMarkers(label = ~htmlEscape(Name))
### 自定义labels
leaflet() %>% 
  addProviderTiles(providers$HikeBike) %>% 
  setView(lng = 116.403972, 
          lat = 39.915122,
          zoom = 12) %>% 
  addMarkers(lng = 116.403972, 
             lat = 39.915122,
             label = "Default Label",
             labelOptions = labelOptions(noHide = TRUE)) %>% 
  addMarkers(lng = 116.403972, 
             lat = 39.905122,
             label = "second label",
             labelOptions = labelOptions(noHide = T,
                                         textOnly = T)) %>% 
  addMarkers(lng = 116.403972, 
             lat = 39.925122,
             label = "third label",
             labelOptions = labelOptions(noHide = T,
                                         textsize = "20px")) %>% 
  addMarkers(lng = 116.403972, 
             lat = 39.895122,
             label = "fourth label",
             labelOptions = labelOptions(noHide = T,
                                         direction = "bottom",
                                         style = list('color' = 'red',
                                                      'font-family' = 'serif',
                                                      'font-style' = 'italic',
                                                      'font-size' = '14px',
                                                      'border-color' = 'rgba(0, 0, 0, 0.5)')))








