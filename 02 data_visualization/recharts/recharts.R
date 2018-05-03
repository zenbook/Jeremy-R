
# 说明 ==================================================================
## 用recharts包绘制交互图形


# 资源：
## madlogos：https://github.com/madlogos/recharts2, https://madlogos.github.io/recharts/#-en
## 谢益辉：https://recharts.yihui.name/ , https://recharts.yihui.name/
## 谢益辉+魏太云：https://github.com/cosname/recharts, https://recharts.cosx.org/
## 谢益辉个人的不建议继续使用了，应该不再维护了
## 谢益辉+魏太云一起做的，有一些bug，还不成熟，建议暂不使用
## 因此，暂时使用madlogos的

# 安装统计之都的recharts
library(devtools)
devtools::install_github("cosname/recharts")

# 安装madlogos的recharts
library(devtools)
devtools::install_github("madlogos/recharts")


# 加载包
library("recharts")
library("tidyverse")

# 基本图形 ============================================================

## 1.散点图
## 输入data.famre，可指定xvar,yvar,series,theme
## 一共有7个主题：1~7
ePoints(dat = iris[, 3:5], 
        xvar = ~Petal.Length, 
        yvar = ~Petal.Width, 
        series = ~Species, 
        theme = 2)

## 2.折线图
head(WorldPhones)
str(WorldPhones)

head(iris)

eBar(cut(rnorm(1000), -4:4))


## echartR作图的数据源一般是long长型数据，而不是宽型数据

# 1.scatter 散点图
# 1.1 最简单的样式
echartr(iris, x = ~Sepal.Width, y = ~Petal.Width)
# 1.2 增加系列
echartR(iris, x = ~Sepal.Width, y = ~Petal.Width, series = ~Species)
# 1.3 添加标线和标记
a <- mean(iris[iris$Species == "setosa",]$Petal.Width)
b <- mean(iris[iris$Species == "versicolor",]$Petal.Width)
c <- mean(iris[iris$Species == "virginica",]$Petal.Width)

echartR(data = iris, x = ~Sepal.Width, y = ~Petal.Width, 
        series = ~Species, type = 'scatter', scale=F,
        markLine = rbind(c(1, 'Mean', a, 0, a, 5, a, F), 
                         c(2, 'Mean', b, 0, b, 5, b, F), 
                         c(3, 'Mean', c, 0, c, 5, c, F)),
        markPoint = rbind(c(1, 'max', "max", F), 
                          c(2, 'max', "max", F), 
                          c(3, 'max', "max", F)))

# 2.bubble 气泡图
# 2.1 设置weight参数的值，气泡大小代表权重
echartR(data = iris, x = ~Sepal.Width, y = ~Petal.Width, weight = ~Petal.Length, type = 'bubble')
# 2.2 增加系列series
echartR(data = iris, x = ~Sepal.Width, y = ~Petal.Width, weight = ~Petal.Length, series = ~Species, 
        type = 'bubble', symbolList='circle')

# 3.bar 柱形图
# 3.0 准备数据
dfiris <- melt(iris, id = "Species")
dtspe <- dcast(dfiris, Species~., value.var = "value", mean)
names(dtspe) <- c("Species", "Mean")
dtiris <- dcast(dfiris, Species + variable~., value.var = "value", mean)
names(dtiris) <- c("Species","Param","Mean")
# 3.1 最简单的样式,单个系列
echartR(data = dtspe, x = ~Species, y = ~Mean, type = "bar")
# 3.2 多个系列
echartR(data = dtiris, x = ~Param, y = ~Mean, series = ~Species, type = 'bar')
# 3.3 堆积柱形图 stack = T
echartR(data = dtiris, x = ~Param, y = ~Mean, series = ~Species, 
        stack = T, type = 'bar')

echartr(dtiris, Param, Mean, Species, type = 'hbar', subtype = 'stack')


# 4.bar 条形图
# 条图和柱图的区别只在于xyflip开关选项
# 4.1 最简单的样式,单个系列
echartR(data = dtspe, x = ~Species, y = ~Mean, type = "bar", xyflip = T)
# 4.2 多个系列
echartR(data = dtiris, x = ~Param, y = ~Mean, series = ~Species, type = 'bar', xyflip = T)
# 4.3 堆积条形图 stack = T
echartR(data = dtiris, x = ~Param, y = ~Mean, series = ~Species, 
        stack = T, type = 'bar', xyflip = T)

# 5.histogram 直方图  
## 报错，貌似在修改，暂时无法绘制直方图
# 5.1 标准直方图
echartR(data = iris, y = ~Sepal.Width, type = "histogram", xyflip = T)
# 5.2 直方图的条形图格式
echartR(data = iris, y = ~Sepal.Width, type = "histogram")

# 6.pie 饼图
# 6.1 标准饼图
#计算每个类别的记录数，count
require("MASS")
data(ships)
dtships <- ships
dtships$id <- row.names(dtships)
echartR(dtships, x = ~type, y = ~id, type = "pie")   
# 6.2 如果y对应的是数值型，则按照数值计算占比，sum
dtships <- dcast(dtships, type~., value.var = "incidents", sum)
names(dtships) <- c("type", "incidents")
dtships <- arrange(dtships, desc(incidents))
echartR(dtships, x = ~type, y = ~incidents, type = "pie")  

# 7.ring 环图
# 环形图是饼图的变形，只需将type改为"ring",同时把饼图的半径参数扩展为包含内、外径的长度为2的向量即可。
echartR(dtships, x = ~type, y = ~incidents, type='ring')

# 8.Rose Nightingale南丁格尔玫瑰图
echartR(dtships, x = ~type, y = ~incidents, type='rose')

## 环形图和玫瑰图其实都是饼图的变形，所以数据的格式都一样，只需改一下type就可以了
## 疑问：
#（1）.如何在饼图上添加标签，如每一个扇形的占比？
#（2）.如何按照扇形大小排序？
# 第2个问题的解决方法可能是先把数据源排序然后再绘制饼图
# 第2个问题并不能这么解决，饼图还是按照x轴的顺序来绘制的，与y的数值无关

# 9.line 线图
# 9.0 注意：echartR的x轴不识别日期格式的数据
# 把日期进行处理
airquality$strDate <- with(airquality, paste(2015, Month, Day, sep="-"))
# 9.1 最简单的线型图
air <- airquality[airquality$Month == 5,]
echartR(data = air, x = ~Day, y = ~Wind, type = "line")
# 9.2 平滑曲线，linesmooth
echartR(data = air, x = ~Day, y = ~Wind, type = "linesmooth")
# 9.3 多条线型图
air <- airquality[airquality$Month %in% c(5,7),]
echartR(air, x = ~Day, y= ~Temp, series= ~Month, type='line')
echartR(air, x = ~Day, y= ~Temp, series= ~Month, type='linesmooth')
# 9.4 堆积线型图
echartR(air, x = ~Day, y= ~Temp, series= ~Month, type='line', stack = T)
echartR(air, x = ~Day, y= ~Temp, series= ~Month, type='linesmooth',stack = T)
# 9.5 设置z坐标轴
echartR(airquality, x = ~Day, y= ~Wind, z=~Month, type='line', pos = list(title = 12))
# 9.6 设置datazoom
airq <- melt(airquality[,c("Ozone","Solar.R","Wind","Temp","strDate")],
             id=c("strDate"))
echartR(airq, x = ~strDate, y= ~value, series= ~variable, type='linesmooth', dataZoom=c(20,50))

# 10.Area 面积图
dfiris <- iris
dfiris$id <- row.names(iris)
dfiris <- melt(dfiris,id=c("Species","id"))
names(dfiris) <- c("Species","id","Param","Value")
dtiris <- dcast(dfiris[,c(1,3,4)],Species+Param~.,value.var="Value",mean)
names(dtiris) <- c("Species","Param","Mean")
# 10.1 面积图
echartR(dfiris, x = ~id, y= ~Value, series= ~Param, type='area', yAxis=list(color='none'))
# 10.2 平滑面积图
echartR(dfiris, x = ~id, y= ~Value, series= ~Param, type='areasmooth', yAxis=list(color='none'))
# 10.3 堆积面积图
echartR(dfiris, x = ~id, y = ~Value, series = ~Param, type = "area", 
        yAxis = list(color = "none"), stack = T)
# 10.4 堆积平滑面积图
echartR(dfiris, x = ~id, y = ~Value, series = ~Param, type = "areasmooth", 
        yAxis = list(color = "none"), stack = T)

# 11.Funnel 漏斗图
# 11.1 标准漏斗图
echartR(dtships, x = ~type,  y = ~incidents, type='funnel')
# 11.2 金字塔图（逆序漏斗图）
echartR(dtships, x = ~type,  y = ~incidents, type='pyramid')

# 12.雷达图
# 雷达图就是极坐标系下的线图/面积图，通过Echarts的polar参数模块控制
# 12.1 空心雷达图
browser <- as.data.frame(
  matrix(c(2013,270,160,75,117,84.5,
           2014,260,156,80,126,98,
           2015,250,152,85,135,112.5),
         byrow=T,ncol=6)
)
names(browser) <- c("Year","IE8-","IE9+","Safari","Firefox","Chrome")
browser <- melt(browser,id="Year")
echartR(browser, x= ~variable, y= ~value, series= ~Year, type='radar', symbolList='none')
# 12.2 实心雷达图
player <- data.frame(name=c(rep("Philipp Lahm",5),rep("Dani Alves",5)),
                     para=rep(c("Passing%","Key passing","Comp crosses",
                                "Crossing%","Successful dribbles"),2),
                     value=c(89.67, 1.51, 0.97, 24.32, 0.83,
                             86.62, 2.11, 0.99, 20.78, 1.58))
echartR(player, x= ~para, y= ~value, series= ~name, type='radarfill')

# 13.Map 地图

# 13.1 地图类型；区域地图 + 标点
# 准备区域的数据
gdp <- readLines("ChinaGDP.txt", encoding = "UTF-8")
dtgdp <- unlist(strsplit(gdp,split=","))
dtgdp <- as.data.frame(t(matrix(dtgdp,nrow=3)),stringsAsFactors=F)
names(dtgdp) <- c('Year','Prov',"GDP")
dtgdp$GDP <- as.numeric(dtgdp$GDP) 
# for (i in 1:2) dtgdp[, i] <- as.character(dtgdp[, i])
dtgdp$Prov <- as.factor(enc2native(dtgdp$Prov))
dtgdp$Year<- as.factor(dtgdp$Year)
# 准备标点的数据
top3 <- dcast(dtgdp[dtgdp$Prov %in% c("广东", "江苏", "山东"),c("Prov","GDP")], Prov~., sum)
top3 <- cbind(top3,rep("Top3", 3), c(32.04, 23.16, 36.65), c(118.78, 113.23, 117.00), rep(T, 3))
top3 <- top3[,c(3, 1, 2, 4:6)]
names(top3) <- c("Series", "Prov", "GDP", "Xcoord", "Ycoord", "Effect")
for (i in 1:2) top3[, i] <- as.character(top3[, i])
# 绘制交互式地图
echartR(dtgdp, x = ~Prov, y = ~GDP, series= ~Year, 
        type=c('map', 'china', 'area'),
        dataRangePalette=c("red","orange",'gold','green1','aquamarine2','royalblue4'),
        dataRange=c('High',"Low"),pos=list(toolbox=3),markPoint = top3,
        theme=list(backgroundColor="#1b1b1b", borderColor="royalblue4",
                   borderWidth=0.5))

echartR(dtgdp, x = ~Prov, y = ~GDP, 
        type=c('map', 'china', 'area'),
        dataRangePalette=c("red","orange",'gold','green1','aquamarine2','royalblue4'),
        dataRange=c('High',"Low"),
        theme=list(backgroundColor="#1b1b1b", borderColor="royalblue4",
                   borderWidth=0.5))



# 13.2 地图类型：point类型 + 标点
# 准备数据
# chinapm25 <- readLines('https://raw.githubusercontent.com/madlogos/Shared_Doc/master/Shared_Documents/China%20PM2.5.txt',
#                       encoding = "UTF-8")
chinapm25 <- readLines("E:/R/Jeremy-R/02 data_visualization/recharts/chinapm25.txt", 
                       encoding = "UTF-8")
chinapm25 <- unlist(strsplit(chinapm25, split=","))
chinapm25 <- as.data.frame(t(matrix(chinapm25, nrow=4)), stringsAsFactors=F)
names(chinapm25) <- c('city', 'pm25', "ycoord", "xcoord")
chinapm25 <- chinapm25[, c(1, 2, 4, 3)]
for (i in 2:4) chinapm25[,i] <- as.numeric(chinapm25[,i])
top5 <- head(chinapm25[order(chinapm25$pm25, decreasing=T), ], 5)
top5$Name <- "Top 5"
top5$effect <- T
top5 <- top5[,c(5, 1, 2, 3, 4, 6)]
# chinapm25$name <- "all"
# chinapm25$lighteffect <- "T"
# chinapm25 <- chinapm25[,c(5, 1, 2, 4, 3, 6)]
# 绘制地图
echartR(chinapm25, x = ~city, y = ~pm25, xcoord = ~xcoord, ycoord = ~ycoord,
        type = c('map', 'china', 'point'),
        palette=c("Gray", "Orange", "Green", "Purple"),
        theme=list(backgroundColor = "#1b1b1b", borderColor = "royalblue4",
                   borderWidth=0.8),
        dataRange=c("High","Low"),
        dataRangePalette=c("red","orange",'gold','green1','aquamarine2','royalblue4'),
        title = "物恋网运营中心分布图",
        pos = list(toolbox=3, title = 12),
        markPoint = top5
)

# 13.3 地图类型； line类型 + 标线
# 准备数据
migrate <- as.data.frame(matrix(unlist(strsplit(readLines("CZflight.txt", encoding = "UTF-8")[3], ",")), 
                                byrow=T, ncol=2), stringsAsFactors=F)
names(migrate) <- c("From", "To")
migrateCoord <- as.data.frame(matrix(unlist(strsplit(readLines("CZflight.txt", encoding = "UTF-8")[4], ",")), 
                                     byrow=T, ncol=3), stringsAsFactors=F)
for (i in 2:3) migrateCoord[,i] <- as.numeric(migrateCoord[,i])
names(migrateCoord) <- c("City","Ycoord","Xcoord")
migrate <- merge(migrate,migrateCoord, by.x="From", by.y="City", all.x=T)
migrate <- merge(migrate,migrateCoord, by.x="To", by.y="City", all.x=T)
migrate$series <- "全国"
# markLine source data
migrateEm <- as.data.frame(matrix(unlist(strsplit(readLines("CZflight.txt", encoding = "UTF-8")[5], ",")), 
                                  byrow=T, ncol=3), stringsAsFactors=F)
migrateEm[, 3] <- as.numeric(migrateEm[, 3])
names(migrateEm) <- c("From", "To", "NFlights")
#migrate <- merge(migrate,migrateEm,by=c("From","To"),all.x=T)
#migrate$Val[is.na(migrate$Val)] <- "-"
migrate$NFlights <- 1
migrateEm <- merge(migrateEm, migrateCoord, by.x="From", by.y="City", all.x=T)
migrateEm <- merge(migrateEm, migrateCoord, by.x="To", by.y="City", all.x=T)
# markLine dataset (8 col)
markline <- migrateEm[, c(2, 1, 3, 5, 4, 7, 6)]
markline$To <- paste(markline$From, markline$To, sep="/")
markline$effect <- T
# markPoint dataset (6 col)
markpoint <- migrateEm[, c(2, 1, 3, 7, 6)]
markpoint$effect <- T
# plot
echartR(migrate, x=~From, x1=~To, y=~NFlights, series=~series, xcoord=~Xcoord.x,
        ycoord=~Ycoord.x, xcoord1=~Xcoord.y, ycoord1=~Ycoord.y, 
        type=c('map', 'china', 'line'), palette=c("Gray", "Orange", "Green", "Purple"), 
        pos=list(toolbox=3, title = 12), title="物恋网全国物流线路图", 
        dataRange=c("High", "Low"),
        dataRangePalette=c("red", "orange", 'gold', 'green1', 'aquamarine2', 'royalblue4'), 
        legend=list(mode='single', select=c('北京')), 
        markLine = markline, markPoint=markpoint, 
        theme=list(backgroundColor="#1b1b1b", borderColor="royalblue4",
                   borderWidth=0.8))

mapdata <- data.frame(province = c('上海', '江苏', '浙江', '江西'), 
                      val1 = c(100, 200, 300, 400), 
                      val2 = c(200, 300, 400, 500), 
                      val3 = c(1, 2, 3, 5), 
                      stringsAsFactors = FALSE)

eMap(mapdata, namevar = ~province, datavar = ~val1 + val2)



# 14.Wordcloud 词云

# 准备数据
baiduhot <- paste0(readLines("http://top.baidu.com/buzz?b=1&fr=topindex"), collapse="")
# baiduhot <- paste0(readLines("Baidu Hot Words.txt"),collapse="")
hotword <- gsub(".+?<a class=\"list-title\"[^>]+?>([^<>]+?)</a>.+?<span class=\"icon-(rise|fair|fall)\">(\\d+?)</span>.+?", "\\1\t\\3\t", baiduhot)
hotword <- enc2native(gsub("^(.+?)\t{4,}.+$","\\1",hotword))
hotword <- t(matrix(unlist(strsplit(hotword,"\t")),nrow=2))
hotword <- as.data.frame(hotword,stringsAsFactors=F)
names(hotword) <- c("Keyword","Freq")
hotword$Freq <- as.numeric(hotword$Freq)
hotword <- hotword[order(hotword$Freq,decreasing=T),]
# 绘制词云
echartR(hotword[1:30,], x=~Keyword, y=~Freq, type="wordcloud", 
        title="Baidu Word Search Top 30", palette=NULL,
        title_url="http://top.baidu.com/buzz?b=1", 
        subtitle="Tuesday, Auguest 18, 2015")

# 15.和弦图
# 15.1 简单和弦图
# 构造数据
deutsch <- data.frame(player = c('Kruse', 'Kramer', 'Neuer', 'Boateng', 'Lahm', 'Kroos', 
                               'Muller', 'Gotze', 'Badstuber', 'Hummels', 'Weidenfeller', 
                               'Reus', 'Gundogan'), 
                      hire = c(rep('Monchengladbach', 2), rep('Bayern', 7), rep('Dortmund', 4)), 
                      weight = rep(1, 13),  
                      role = c('Fw', 'Mf', 'Gk', 'Df', 'Df', 'Mf', 'Mf', 'Fw', 'Df', 'Df', 'Gk', 'Df', 'Md'), 
                      stringsAsFactors = F)
# 无缎带和弦图
echartR(deutsch, x = ~player, y = ~weight, x1 = ~hire, type ='chord', xAxis = list(rotate = 90),
        title = 'Deutsch Soccer Team - Clubs',pos = list(legend = 6,title = 12))
# 有缎带和弦图
echartR(deutsch, x=~player, y=~weight, x1=~hire, type='chordribbon', 
        title='Deutsch Soccer Team - Clubs',pos=list(legend=6,title=12))
# 对矩阵数据做和弦图
grpmtx <- matrix(c(11975, 5871, 8916, 2868, 1951, 10048, 2060, 6171, 8010, 16145,
                   8090, 8045, 1013, 990, 940, 6907), byrow=T, nrow=4)
dimnames(grpmtx) <- list(LETTERS[1:4],LETTERS[1:4])
grpmtx <- melt(grpmtx)
echartR(grpmtx, x=~Var1, y=~value, x1=~Var2, type='chordribbon', 
        title='Group A-D mutual links', pos=list(legend=10, title=5))

# 15.2 多系列和弦图
# 构造数据
mideast <- read.csv("MidEast.csv", header=T, stringsAsFactors=F, encoding = "UTF-8")
names(mideast[,2:16]) <- mideast$X
mideast <- melt(mideast,id="X")
mideast$attd <- gsub("(.+)/\\d+","\\1",mideast$value)
mideast$attd[mideast$attd==''] <- NA
mideast$attd <- factor(mideast$attd,levels=unique(mideast$attd))
mideast$wt <- gsub(".+/(\\d+)","\\1",mideast$value)
mideast$wt <- as.numeric(mideast$wt)
echartR(mideast,x=~X, y=~wt, x1=~variable, series=~attd, type='chordribbon', 
        title='Relationship in Mid-east', subtitle='(source: Caixin)', 
        palette=c('#FBB367','#80B1D2','#FB8070','#CC99FF','#B0D961','#99CCCC','#BEBBD8',
                  '#FFCC99','#8DD3C8','#FF9999','#CCEAC4','#BB81BC','#FBCCEC','#CCFF66',
                  '#99CC66','#66CC66','#FF6666','#FFED6F','#ff7f50','#87cefa'), 
        pos=list(legend=10,title=5,toolbox=2),
        subtitle_url='http://international.caixin.com/2013-09-06/100579154.html')

## 和弦图有问题，再看

# 16 Force 力导向布局图
netNode <- as.data.frame(matrix(unlist(strsplit(readLines('Network.txt', encoding = "UTF-8")[1], ",")), 
                                byrow=T, ncol=3), stringsAsFactors=F)
names(netNode) <- c("name", "category", "value")
netLink <- as.data.frame(matrix(unlist(strsplit(readLines('Network.txt', encoding = "UTF-8")[2], ",")), 
                                byrow=T,ncol=4), stringsAsFactors=F)
names(netLink) <- c("from", "to", "relation", "weight")
netLink$weight <- as.numeric(netLink$weight)
netLink <- merge(netLink,netNode, by.x="from", by.y="name", all.x=T)
netLink <- merge(netLink, netNode, by.x="to", by.y="name", all.x=T)
rm(netNode)
netLink$category.x <- factor(netLink$category.x, levels=c("Root", "Node 1", "Node 2", "Node 3", "Leaf"))  
# Order the categories
netLink <- netLink[order(netLink$category.x), ]
netLink$Link <- with(netLink, paste(from, to, relation, sep="/"))
netLink$NodeVal <- with(netLink, paste(value.x, value.y, sep="/"))
netLink$Series <- with(netLink, paste(category.x, category.y, sep="/"))
echartR(netLink, x = ~Link, y = ~weight, x1 = ~NodeVal, series = ~Series, type = 'force', 
        title='绍兴俞氏社会网络', pos=list(title=5, legend=10), 
        palette=c('brown', 'green4', 'green3', 'lawngreen', 'olivedrab1'))


# 17 Candlestick K线图
# K线图必须将日期整理在x，开盘、收盘、最低、最高标签整理在x1（且按该顺序排序），价格整理在y。
stockidx <- data.frame(
  date=c('1/24','1/25','1/28','1/29','1/30','1/31','2/1','2/4','2/5','2/6','2/7',
         '2/8','2/18','2/19','2/20','2/21','2/22','2/25','2/26','2/27','2/28','3/1',
         '3/4','3/5','3/6','3/7','3/8','3/11','3/12','3/13','3/14','3/15','3/18',
         '3/19','3/20','3/21','3/22','3/25','3/26','3/27','3/28','3/29','4/1','4/2',
         '4/3','4/8','4/9','4/10','4/11','4/12','4/15','4/16','4/17','4/18','4/19',
         '4/22','4/23','4/24','4/25','4/26','5/2','5/3','5/6','5/7','5/8','5/9',
         '5/10','5/13','5/14','5/15','5/16','5/17','5/20','5/21','5/22','5/23',
         '5/24','5/27','5/28','5/29','5/30','5/31','6/3','6/4','6/5','6/6','6/7',
         '6/13'),
  open=c(2320.26,2300,2295.35,2347.22,2360.75,2383.43,2377.41,2425.92,2411,2432.68,
         2430.69,2416.62,2441.91,2420.26,2383.49,2378.82,2322.94,2320.62,2313.74,
         2297.77,2322.32,2364.54,2332.08,2274.81,2333.61,2340.44,2326.42,2314.68,
         2309.16,2282.17,2255.77,2269.31,2267.29,2244.26,2257.74,2318.21,2321.4,
         2334.74,2318.58,2299.38,2273.55,2238.49,2229.46,2234.9,2232.69,2196.24,
         2215.47,2224.93,2236.98,2218.09,2199.91,2169.63,2195.03,2181.82,2201.12,
         2236.4,2242.62,2187.35,2213.19,2203.89,2170.78,2179.05,2212.5,2227.86,
         2242.39,2246.96,2228.82,2247.68,2238.9,2217.09,2221.34,2249.81,2286.33,
         2297.11,2303.75,2293.81,2281.45,2286.66,2293.4,2323.54,2316.25,2320.74,
         2300.21,2297.1,2270.71,2264.43,2242.26,2190.1),
  close=c(2302.6,2291.3,2346.5,2358.98,2382.48,2385.42,2419.02,2428.15,2433.13,
          2434.48,2418.53,2432.4,2421.56,2382.91,2397.18,2325.95,2314.16,2325.82,
          2293.34,2313.22,2365.59,2359.51,2273.4,2326.31,2347.18,2324.29,2318.61,
          2310.59,2286.6,2263.97,2270.28,2278.4,2240.02,2257.43,2317.37,2324.24,
          2328.28,2326.72,2297.67,2301.26,2236.3,2236.62,2234.4,2227.74,2225.29,
          2211.59,2225.77,2226.13,2219.55,2206.78,2181.94,2194.85,2193.8,2197.6,
          2244.64,2242.17,2184.54,2218.32,2199.31,2177.91,2174.12,2205.5,2231.17,
          2235.57,2246.3,2232.97,2246.83,2241.92,2217.01,2224.8,2251.81,2282.87,
          2299.99,2305.11,2302.4,2275.67,2288.53,2293.08,2321.32,2324.02,2317.75,
          2300.59,2299.25,2272.42,2270.93,2242.11,2210.9,2148.35),
  low=c(2287.3,2288.26,2295.35,2337.35,2347.89,2371.23,2369.57,2417.58,2403.3,2427.7,
        2394.22,2414.4,2415.43,2373.53,2370.61,2309.17,2308.76,2315.01,2289.89,
        2292.03,2308.92,2330.86,2259.25,2270.1,2321.6,2304.27,2314.59,2296.58,
        2264.83,2253.25,2253.31,2250,2239.21,2232.02,2257.42,2311.6,2314.97,2319.91,
        2281.12,2289,2232.91,2228.81,2227.31,2220.44,2217.25,2180.67,2215.47,2212.56,
        2217.26,2204.44,2177.39,2165.78,2178.47,2175.44,2200.58,2232.26,2182.81,
        2184.11,2191.85,2173.86,2161.14,2179.05,2212.5,2219.44,2235.42,2221.38,
        2225.81,2231.36,2205.87,2213.58,2210.77,2248.41,2281.9,2290.12,2292.43,
        2274.1,2270.25,2283.94,2281.47,2321.17,2310.49,2299.37,2294.11,2264.76,
        2260.87,2240.07,2205.07,2126.22),
  high=c(2362.94,2308.38,2346.92,2363.8,2383.76,2391.82,2421.15,2440.38,2437.42,
         2441.73,2433.89,2443.03,2444.8,2427.07,2397.94,2378.82,2330.88,2338.78,
         2340.71,2324.63,2366.16,2369.65,2333.54,2328.14,2351.44,2352.02,2333.67,
         2320.96,2333.29,2286.33,2276.22,2312.08,2276.05,2261.31,2317.86,2330.81,
         2332,2344.89,2319.99,2323.48,2273.55,2246.87,2243.95,2253.42,2241.34,
         2212.59,2234.73,2233.04,2242.48,2226.26,2204.99,2196.43,2197.51,2206.03,
         2250.11,2245.12,2242.62,2226.12,2224.63,2210.58,2179.65,2222.81,2236.07,
         2240.26,2255.21,2247.86,2247.67,2250.85,2239.93,2225.19,2252.87,2288.09,
         2309.39,2305.3,2314.18,2304.95,2292.59,2301.7,2322.1,2334.33,2325.72,
         2325.53,2313.43,2297.1,2276.86,2266.69,2250.63,2190.1))
stockidx <- melt(stockidx,id="date")
stockidx <- stockidx[order(stockidx$variable),]
echartR(stockidx, x=~date, x1=~variable, y=~value, type='k', title='2013年上半年上证指数', AxisAtZero = F, 
        dataZoom=c(0,50),scale = T, pos = list(title = 12, legend = 6))

# 18 Gauge 仪表盘

# 仪表盘的数据集比较简单，标签列在x，数值在y，单位在x1。如果要自定义表盘颜色，可以在x列标记’axisStyle’，则
# x1列为颜色（Hex值或颜色名），y为切断点。此外可单独通过splitNumber制定刻度数量
gauge <- data.frame(x=c("完成率",rep("axisStyle",3)),
                    unit=c("%","forestgreen","orange","red2"),KPI=c(74,0.5,0.8,1))
echartR(gauge,x=~x,y=~KPI,x1=~unit,type='gauge')




