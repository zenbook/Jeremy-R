require("ggplot2")
require("ggthemes")
require("rinds")
require("plyr")


# 10.1 R语言可视化简介

# data(anscombe, package = "rinds")
# 只看数据，很难一眼发现规律
head(anscombe)

# 计算每列的均值，发现x的均值相同   y的均值相同
colMeans(anscombe)

# 计算x 与 y 的相关系数，发现四对都相等
sapply(1:4, function(x) cor(anscombe[, x], anscombe[, x + 4]))

# 把幕布分成两行两列
par(mfcol = c(2, 2), mex = 0.8)

# 绘制散点图
for (x in 1 : 4) plot(anscombe[, x], anscombe[, x + 4], pch = 19)
# 从散点图我们才发现，原来这些看起来很相似的数据，其实差别非常大

# ggplot2入门

# 画布
p <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy))
print(p)

# 在画布上增加几何对象geom
p + geom_point()

# 把变量year映射到颜色上
p <- ggplot(mpg, aes(x = cty, y = hwy, color = factor(year)))
p + geom_point()

# 在画布和几何对象上增加统计变换stat_
p <- ggplot(mpg, aes(x = cty, y = hwy, color = factor(year)))
p + stat_smooth()
# 我么看到画布上有两个统计变换的平滑曲线，那是因为我们在画布上就定义了color = factor(year)
# 画布上定义的，会影响该画布上的所有图层

# 我们可以在几何对象上定义颜色，这样就不会影响其他的图层
p <- ggplot(mpg, aes(x = cty, y = hwy))
p + geom_point(aes(color = factor(year))) + stat_smooth()
# 这样，散点图中区分了颜色，而统计变换平滑曲线则是一条，没有根据年份来区分

# 当我们设置mapping的时候，我们并没有定义他们的各类属性，比如颜色，形状和大小，这些我们可以通过标度来控制
p <- ggplot(mpg, aes(x = cty, y = hwy))
p + geom_point(aes(color = factor(year))) + scale_color_manual(values = c("blue2", "red4")) + stat_smooth()

# ggplot2也可以控制分组绘图，用facet
p <- ggplot(mpg, aes(x = cty, y = hwy))
p + geom_point(aes(color = factor(year))) + 
  scale_color_manual(values = c("blue2", "red4")) + 
  stat_smooth(aes(color = factor(year))) + 
  facet_wrap(~ year, ncol = 1)


# 10.2 分布的特征

# 直方图
p <- ggplot(iris, aes(x = Sepal.Length)) + 
  geom_histogram(binwidth = 0.1, fill = "skyblue", colour = "black") + 
  theme_bw()
print(p)

# 加上核密度曲线  geom_histogram() 中加上aes( y = ), 同时加上stat_density
p <- ggplot(iris, aes(x = Sepal.Length)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1, fill = "skyblue", colour = "black") + 
  stat_density(geom = "line", color = "black", linetype = 2, size = 1, adjust = 2) + 
  theme_bw()
print(p)

# 比较三种不同鸢尾花的核密度曲线
p <- ggplot(iris, aes(x = Sepal.Length, color = Species, linetype = Species)) + 
  stat_density(geom = "line", size = 1, position = "identity", adjust = 1) + 
  scale_color_economist() + 
  theme_economist()
print(p)


# 箱线图

p <- ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species)) + 
  geom_boxplot() + 
  theme_bw()
print(p)

# 小提琴图
p <- ggplot(iris, aes(x = Species, y = Sepal.Length, color = Species)) + 
  geom_violin(size = 1) + 
  geom_point(alpha = 0.1, position = position_jitter(0.1)) + 
  scale_color_brewer(palette = "Set1") + 
  theme_bw()
print(p)


# 10.3 比例的构成

# 条形图
# 简单条形图（单个）
ggplot(mpg, aes(x = class)) + geom_bar()
# 简单条形图（多个）
p <- ggplot(mpg, aes(x = class, fill = year)) + 
  geom_bar(color = "black", position = position_dodge()) + 
  scale_fill_brewer() + 
  theme_bw()
print(p)
# 堆积条形图
mpg$year <- factor(mpg$year)
p <- ggplot(mpg, aes(x = class, fill = year)) + 
  geom_bar(color = "black") + 
  scale_fill_brewer() + 
  theme_bw()
print(p)
# 百分比堆积条形图  position = position_fill()
p <- ggplot(mpg, aes(x = class, fill = year)) + 
  geom_bar(color = "black", position = position_fill()) + 
  scale_fill_brewer() + 
  theme_bw()
print(p)

# 滑珠图
data <- ddply(mpg, .(class, year), function(x) nrow(x))
p <- ggplot(data, aes(x = class, y = V1)) +   # 底层画布
  geom_linerange(aes(ymax = V1), color = "grey", ymin = 0, size = 1) + # 第二层：线条，显示y线条，从最小值到最大值
  geom_point(aes(color = year), size = 5) + # 第三层：添加不同年份的点
  theme_bw()
print(p)

# 马赛克图
require("vcd")
data("titanic")
mosaic(Survived ~ Class + Sex, data = titanic, shade = T, 
       highlighting_fill = c("red4", "skyblue"),
       highlighting_direction = "right")


# 层次树图
require("treemap")
data("apple")
treemap(apple, index = c("item", "subitem"), vSize = "time1206", type = "value", 
        title = "Apple's Fiancial Report",
        fontsize.labels = c(20, 14), fontcolor.labels = "black", 
        bg.labels = 0, position.legend = "none", border.col = "white")

# 10.4 时间的变化

# 柱形图
fillcolor <- ifelse(economics[440:470, "psavert"] > 4, "steelblue", "red4")
p <- ggplot(economics[440:470, ], aes(x = date, y = psavert)) + 
  geom_bar(stat = "identity", fill = fillcolor) + 
  theme_bw()
print(p)

# 折线图
p <- ggplot(data = economics[300:470, ], aes(x = date, y = psavert)) + 
  geom_area(fill = "#76c0c1", size = 0.3, position = position_identity()) + 
  geom_line(color = "#014d64", size = 1) + 
  annotate(geom = "rect", xmax = as.Date("2001-01-01"), xmin = as.Date("2000-01-01"), ymin = 0, ymax = 10, 
           alpha = 0.4, color = "gray", fill = "gray70") + 
  annotate(geom = "text", x = as.Date("2000-07-01"), y = 7, label = "2000") + 
  theme_economist()
  
# 日历图
require("openair")
data(mydata)
View(mydata)
calendarPlot(mydata, pollutant = "o3", year = 2003)


# 10.5 R与交互可视化
require("rCharts")
p1 <- nvd3Plot(Sepal.Length ~ Sepal.Width, group = "Species", data = iris, type = "scatterChart")
p1$set(width = 550)
p1$show()

# 以下可视化方式并不好，不建议使用
require("googleVis")
require("WDI")
DF <- WDI(country = c("CN", "RU", "BR", "ZA", "IN", "DE", "AU", "CA", "FR", "IT", "JP", "MX", "GB", "US", "ID", "AR", "KR", "SA", "TR"),
          indicator = c("NY.GDP.MKTP.CD", "SP.AY.LEOO.IN", "EN.ATM.CO2E.KT"),
          start = 2000, end = 2009)
M <- gvisMotionChart(DF, idvar = "country", timevar = "year", xvar = "EN.ATM.CO2E.KT", yvar = "NY.GDP.MKTP.CD")
plot(M)














