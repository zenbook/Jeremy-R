# load the labirary and the data set ---------------------------------
library('ggplot2')
data("diamonds")
str(diamonds)
set.seed(1)
dsmall <- diamonds[sample(nrow(diamonds), 100, replace = F),]

# chapter2 qplot() ---------------------------------------------------

# 2.3 基本用法 qplot(x, y, data)
qplot(carat, price, data = diamonds)  # 从图中看出明显的指数趋势，所以做一下对数变换
qplot(log(carat), log(price), data = diamonds) # 对数变换后，很明显的线性相关，但有太多的点重叠了，所以不能太轻率地下结论
qplot(carat, x*y*z, data = diamonds) # x,y,z(体积)与carat(重量)具有非常强的线性相关

# 2.4 颜色、大小、形状和其他图形属性 color, shape, size, alpha
qplot(carat, price, data = dsmall, color = color) # 颜色 color = 
qplot(carat, price, data = dsmall, color = cut, shape = cut) # 形状 shape = 
qplot(carat, price, data = dsmall, color = cut, size = cut) # 大小 size = 
# 以上是由程序自动设置标度scale,也可手动设定，如 color = I('red', 'blue')
qplot(carat, price, data = diamonds, alpha = I(1/10)) # 半透明色 alpha = I()，可以看出点重叠的位置
qplot(carat, price, data = diamonds, alpha = I(1/50))

# 2.5 几何对象 
# geom = c('point', 散点图
#          'line',  折线图
#          'smooth', 平滑曲线图
#          'boxplot', 箱线图
#          'path', 路径图（任意方向）
#          'histogram', 直方图
#          'freqpoly', 频率多边形
#          'density', 密度曲线
#          'bar' 条形图)
# 如果只给qplot()传递x参数, 则默认用直方图，如果同时传递x和y，则默认用散点图
# 2.5.1 散点图 + 曲线
qplot(carat, price, data = dsmall, geom = c('point', 'smooth')) # 不想绘制标准误，则加参数"se = FALSE"即可
qplot(carat, price, data = dsmall, geom = c('point', 'smooth'), se = F) # 非线性相关，曲线无太大意义，对数变换一下
# 2.5.2 箱线图和扰动图
qplot(color, price/carat, data = diamonds, geom = 'jitter', alpha = I(1/30))
qplot(color, price/carat, data = diamonds, geom = 'boxplot')
qplot(color, price/carat, data = diamonds, geom = 'boxplot', color = I('orange'), fill = I('lightblue'))
# 2.5.3 直方图和密度曲线图
qplot(carat, data = diamonds, geom = 'histogram')
qplot(carat, data = diamonds, geom = 'density')
summary(diamonds$carat)
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 1, xlim = c(0, 3)) # 直方图，binwidth太大时，只能看出大致分布
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 0.1, xlim = c(0, 3))
qplot(carat, data = diamonds, geom = 'histogram', binwidth = 0.01, xlim = c(0, 3)) # 直方图，binwidth设置较小一些，可以看出一些细节问题
qplot(carat, data = diamonds, geom = 'histogram', fill = color, color = I('gray'))
qplot(carat, data = diamonds, geom = 'density', color = color, size = I(1.3))
# 2.5.4 条形图
qplot(color, data = diamonds, geom = 'bar', fill = color) # 普通条形图，根据颜色对钻石进行计数
qplot(color, data = diamonds, geom = 'bar', weight = carat) + scale_y_continuous('carat') # 加权，根据颜色分组，对钻石的重量进行求和
# 2.5.5 时间序列 折线图和路径图
data("economics")
str(economics)
qplot(date, unemploy/pop, data = economics, geom = 'line')
qplot(date, uempmed, data = economics, geom = 'line')
year <- function(x){as.POSIXlt(x)$year + 1900}
qplot(unemploy/pop, uempmed, data = economics, geom = c('point', 'path'))
qplot(unemploy/pop, uempmed, data = economics, geom = 'path', color = year(date))

# 2.6 分面 facet
qplot(carat, data = diamonds, facets = color~., geom = 'histogram', fill = I('orange'), color = I('white'), binwidth = 0.1, xlim = c(0, 3))
qplot(carat, ..density.., data = diamonds, facets = color~., geom = 'histogram', fill = I('orange'), color = I('gray'), binwidth = 0.1, xlim = c(0, 3))

# 2.7 其他选项
# xlim = c(), ylim = c() 设置横纵坐标的区间
# xlab = 'text or expression', ylab = 'text or expression' 设置横纵坐标的标签文字，可以是字符串或表达式
# main = 'text or expression' 设置图形的标题，可以是字符串或表达式
# log = 'x', log = 'y', log = 'xy' 对变量取对数
qplot(log(carat), log(price), data = diamonds, geom = 'point', color = color, main = 'carat and price', xlab = 'log(carat)', ylab = 'log(price)')

# chapter3 语法突破

# chapter4 用图层构建图像
# 4.2 创建绘图对象
p <- ggplot(data = diamonds, aes(x = carat, y = price, color = cut))

# 4.3 图层
p + layer(geom = 'point') # 貌似这个功能已经取消了
p <- ggplot(diamonds, aes(x = carat))
p + geom_histogram(binwidth = 0.1, fill = 'steelblue', color = 'white')
data("msleep")
str(msleep)
qplot(sleep_rem/sleep_total, awake, data = msleep, geom = 'point')
ggplot(msleep, aes(sleep_rem/sleep_total, awake)) + geom_point()
p <- ggplot(msleep, aes(sleep_rem/sleep_total, awake))
summary(p)
p <- p + geom_point()
summary(p)
bestfit <- geom_smooth(method = 'lm', se = F, color = alpha('steelblue', 0.5), size = 2)
qplot(sleep_rem, sleep_total, data = msleep) + bestfit
qplot(awake, brainwt, data = msleep, log = 'y') + bestfit
qplot(bodywt, brainwt, data = msleep, log = 'xy') + bestfit

# 4.4 数据
data("mtcars")
str(mtcars)
p <- ggplot(mtcars, aes(mpg, wt, color = cyl)) + geom_point()
p
mtcars <- transform(mtcars, mpg = mpg^2)
p %+% mtcars

# 4.5 图形属性映射mapping aes()
# 4.5.1 图和图层
p <- ggplot(mtcars)
p <- p + aes(x = mpg, y = wt)
p <- p + geom_point()
p
p1 <- p + geom_point(aes(color = factor(cyl)))
p2 <- p + geom_point(aes(y = disp)) # 这个貌似改不了y坐标了
summary(p)
summary(p1)
summary(p2)
ggplot(mtcars, aes(mpg, disp)) + geom_point()
# 4.5.2 设定和映射
p <- ggplot(mtcars, aes(mpg, wt))
p + geom_point(color = 'darkblue') # 直接设定颜色为darkblue
p + geom_point(aes(color = 'darkblue')) # 这里却并不是如此，而是新建了一个darkblue变量，然后将颜色映射到这个变量上
# 4.5.3 分组
library('nlme')
data("Oxboys")
str(Oxboys)
p1 <- ggplot(Oxboys, aes(age, height)) + geom_line() # 没有分组
p1
p2 <- ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line() # 有分组
p2
p21 <- p2 + geom_smooth(aes(group = Subject), method = 'lm', se = F)
p21
p22 <- p2 + geom_smooth(aes(group = 1), method = 'lm', size = 2, se = F)
p22
boysbox <- ggplot(Oxboys, aes(Occasion, height)) + geom_boxplot()
boysbox
boysbox + geom_line(aes(group = Subject), color = '#3366FF')

# 4.6 几何对象 geom

# 4.7 统计变换 stat
ggplot(diamonds, aes(carat)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.1, color = 'white')
# y = ..density.. 统计变换的变量要用..包围起来

# 4.8 位置调整 
# dodge 避免重叠，并排放置
# fill 堆叠图形元素，并将高度标准化为1
# identity 不做任何调整
# jitter 给点添加扰动，避免重合
# stack 将图形元素堆叠起来
p <- ggplot(diamonds, aes(clarity, fill = cut, color = I('white')))
p + geom_bar(position = 'stack') # stack 堆叠
p + geom_bar(position = 'fill') # fill 填充
p + geom_bar(position = 'dodge') # dodge 并列
p + geom_bar(position = 'identity') # identity 不做任何调整，不适合条形图，因为会遮盖

# 4.9 整合
# 4.9.1 结合几何对象和统计变换
d <- ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), binwidth = 0.1, geom = 'area') # stat_bin(aes()) 统计变换内有aes()
d + stat_bin(aes(size = ..density..), binwidth = 0.1, geom = 'point', position = 'identity')
ggplot(diamonds, aes(carat, 1)) + xlim(0, 3) + 
  stat_bin(aes(fill = ..count..), binwidth = 0.1, geom = 'tile', position = 'identity')
# 4.9.2 显示已计算过的统计量 stat_identity()
# 4.9.3 改变图形属性和数据集
library(nlme)
model <- lme(height~age, data = Oxboys, random = ~ 1 + age | Subject)
oplot <- ggplot(Oxboys, aes(age, height, group = Subject)) + geom_line()
age_grid <- seq(-1, 1, length = 10)
subjects <- unique(Oxboys$Subject)
preds <- expand.grid(age = age_grid, Subject = subjects)
preds$height <- predict(model, preds)
oplot + geom_line(data = preds, color = '#3366FF', size = 0.4)
Oxboys$fitted <- predict(model)
Oxboys$resid <- with(Oxboys, fitted - height)
oplot %+% Oxboys + aes(y = resid) + geom_smooth(aes(group = 1))
model2 <- update(model, height ~ age + I(age^2))
Oxboys$fitted2 <- predict(model2)
Oxboys$resid2 <- with(Oxboys, fitted2 - height)
oplot %+% Oxboys + aes(y = resid2) + geom_smooth(aes(group = 1))

# chapter5 工具箱
# 5.3 基本图形类型
# geom_area() 面积图
# geom_bar(stat = 'identity') 条形图
# geom_line() 线条图， 类似的有geom_path()
# geom_point() 散点图
# geom_polygon() 多边形图
# geom_text() 在指定点处添加文本标签 参数有label hjust vjust angle等
# geom_tile()
df <- data.frame(
  x = c(3, 1, 5),
  y = c(2, 4, 6),
  label = c('a', 'b', 'c')
)
p <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
p + geom_point() + labs(title = 'geom_point')
p + geom_bar(stat = 'identity') + labs(title = 'geom_bar(stat = "identity")') 
p + geom_line() + labs(title = 'geom_line')
p + geom_area() + labs(title = 'geom_area')
p + geom_polygon() + labs(title = 'geom_polygon')
p + geom_path() + labs(title = 'geom_path')
p + geom_tile() + labs(tile = 'geom_tile')
p + geom_text(aes(label = label)) + labs(title = 'geom_text')
p + geom_point() + geom_text(aes(label = label), vjust = -1)

# 5.4 展示数据的分布
summary(diamonds$depth)
ggplot(diamonds, aes(depth)) + geom_histogram(aes(y = ..density..), binwidth = 1)
ggplot(diamonds, aes(depth)) + xlim(55, 70) + geom_histogram(aes(y = ..density..), binwidth = 0.1)
depth_dist <- ggplot(diamonds, aes(depth)) + xlim(58, 68)
depth_dist + geom_histogram(aes(y = ..density..), binwidth = 0.1) + facet_grid(cut ~ .)
depth_dist + geom_histogram(aes(fill = cut), binwidth = 0.1, position = 'fill', color = 'white')
depth_dist + geom_histogram(aes(fill = cut), binwidth = 0.1, position = 'stack', color = 'white')
depth_dist + geom_freqpoly(aes(y = ..density.., color = cut), binwidth = 0.1)
library('plyr')
ggplot(diamonds, aes(cut, depth)) + geom_boxplot()
ggplot(diamonds, aes(carat, depth, group = round_any(carat, 0.25, floor))) + geom_boxplot() + xlim(0, 3)
ggplot(mpg, aes(class, cty)) + geom_jitter()
ggplot(mpg, aes(class, drv)) + geom_jitter()
ggplot(diamonds, aes(depth)) + geom_density() + xlim(54, 70)
ggplot(diamonds, aes(depth, fill = cut)) + geom_density(alpha = I(0.2)) + xlim(54, 70)

# 5.5 处理遮盖绘制问题
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y))
norm + geom_point() # 默认形状，实心原点
norm + geom_point(shape = 1) # shape = 1, 空心原点
norm + geom_point(shape = '.') # shape = '.'，1像素的点
norm + geom_point(color = 'black', alpha = 1/5) # alpha = 1/5, 设置透明度
norm + geom_point(color = 'black', alpha = 1/10)
td <- ggplot(diamonds, aes(table, depth)) + xlim(50, 70) + ylim(50, 70)
td + geom_point()
td + geom_jitter()
jit <- position_jitter(0.5)
td + geom_jitter(position = jit)
td + geom_jitter(position = jit, color = 'black', alpha = 1/5)
td + geom_jitter(position = jit, color = 'black', alpha = 1/10)
d <- ggplot(diamonds, aes(carat, price)) + xlim(1, 3) + theme(legend.position = 'none')
d + stat_bin2d()
d + stat_bin2d(bins = 10)
d + stat_bin2d(binwidth = c(0.02, 200))
d + stat_binhex()
d + stat_binhex(bins = 10)
d + stat_binhex(binwidth = c(0.02, 200))
d + geom_point() + geom_density2d()
d + stat_density2d(geom = 'point', aes(size = ..density..), contour = F) + scale_size_area()
d + stat_density2d(geom = 'tile', aes(fill = ..density..), contour = F)
last_plot() + scale_fill_gradient(limits = c(1e-5, 8e-4))

# 5.6 曲面图

# 5.7 绘制地图

# 5.8 揭示不确定性

# 5.9 统计摘要 stat_summary()

# 5.10 添加图形注解
# 两种添加方式：批量添加 / 逐个添加
data("economics")
unemp <- ggplot(economics, aes(date, unemploy, xlab = '', ylab = 'No. unemployed(1000s)')) + geom_line()
data('presidential')
pre <- presidential[-(1:3),] # 去掉年份较早的三条数据
yrng <- range(economics$unemploy)
xrng <- range(economics$date)
unemp + geom_vline(aes(xintercept = as.numeric(start), color = I('red')), data = pre) # 绘制垂直X轴的直线
library("scales")
unemp + geom_rect(aes(NULL, NULL, xmin = start, xmax = end, fill = party), ymin = yrng[1], 
                  ymax = yrng[2], data = pre, alpha = 0.2) + scale_fill_manual(values = c('blue', 'red'))
last_plot() + geom_text(aes(x = start, y = yrng[1], label = name), data = pre, size = 3, hjust = 0, vjust = -2)
caption <- 'Unemployment rates have varied a lot over the years'
unemp + geom_text(aes(x, y, label = caption), data = data.frame(x = xrng[2], y = yrng[2]), hjust = 1, vjust = 0, size = 4)
highest <- subset(economics, unemploy == max(unemploy))
unemp + geom_point(data = highest, size = 3, color = 'red')

# 5.11 含权数据（对于点图来说，相当于气泡图）
ggplot(data = midwest, aes(percwhite, percbelowpoverty)) + geom_point() # 白人越多的地方越富裕吗？
ggplot(data = midwest, aes(percwhite, percbelowpoverty, size = poptotal / 1e6)) + 
  geom_point() + scale_size_area('population(million)', breaks = c(0.5, 1, 2, 4)) # 点大小代表人口总数
ggplot(data = midwest, aes(percwhite, percbelowpoverty, size = poptotal / 1e6)) + 
  geom_point(shape = 1, color = 'red') + scale_size_area('population(million)', breaks = c(0.5, 1, 2, 4)) # 点大小代表人口总数
ggplot(midwest, aes(percbelowpoverty)) + geom_histogram(binwidth = 1, color = 'white')
ggplot(midwest, aes(percbelowpoverty, weight = poptotal)) + geom_histogram(binwidth = 1, color = 'white')

# chapter6 标度、坐标轴和图例
# 6.3 用法
str(mpg)
plot <- qplot(cty, hwy, data = mpg)
plot
plot + aes(x = drv) # 自动转换了，不需要手动设置
p <- ggplot(msleep, aes(sleep_total, sleep_cycle, color = vore)) + geom_point()
p
p + scale_color_hue() # 无变化，还是默认的
p + scale_color_hue('what does it eat?',
                    breaks = c('herbi', 'carni', 'omni', NA),
                    labels = c('plants', 'meat', 'both', "don't know")) # 图例文字改变，图形颜色未变
p + scale_color_brewer(palette = 'Set2') # 改变了颜色

# 6.4 标度详解
# 6.4.1 通用参数
# name 设置坐标轴或图例上的标签
p <- ggplot(mpg, aes(cty, hwy, color = displ)) + geom_point()
p + scale_x_continuous('city mpg')
p + xlab('City mpg')
p + ylab('Highway mpg')
p + labs(x = 'City mpg', y = 'Highway mpg', color = 'Displacement')
p + xlab(expression(frac(miles, gallon)))
# limits 固定标度的定义域
# breaks 控制着显示在坐标轴或图例上的值，即坐标轴上应该显示哪些刻度线的值，或一个连续型标度在一个图例中如何分段
# labels 指定了应在断点处显示的标签
p <- ggplot(mtcars, aes(cyl, wt)) + geom_point()
p + scale_x_continuous(breaks = c(5.5, 6.5)) # 设置x轴显示5.5，6.5两个点
p + scale_x_continuous(limits = c(5.5, 6.5)) # 设置只显示cyl处于(5.5, 6.5)范围内的数据点
p <- ggplot(mtcars, aes(wt, cyl, color = cyl)) + geom_point()
p + scale_colour_gradient(breaks = c(5.5, 6.5))
p + scale_colour_gradient(limits = c(5.5, 6.5))
# 6.4.2 位置标度 scale_x_  scale_y_
ggplot(diamonds, aes(carat, price)) + geom_point() + scale_x_log10() + scale_y_log10()
ggplot(diamonds, aes(log(carat), log(price))) + geom_point()
library('scales')
p <- ggplot(economics, aes(date, psavert)) + geom_line() + ylab('personal saving rate') + geom_hline(yintercept = 0, color = 'grey50')
p + scale_x_date(breaks = date_breaks('5 years'), labels = date_format('%Y'))
p + scale_x_date(limits = as.Date(c('2004-01-01', '2005-01-01')),
                 labels = date_format('%Y-%m'))
# 6.4.3 颜色标度 scale_color_gradient() scale_fill_gradient()
f2d <- with(faithful, MASS::kde2d(eruptions, waiting, h = c(1, 10), n = 50))
df <- with(f2d, cbind(expand.grid(x, y), as.vector(z)))
names(df) <- c('eruptions', 'waiting', 'density')
erupt <- ggplot(df, aes(waiting, eruptions, fill = density)) + 
  geom_tile() + 
  scale_x_continuous(expand = c(0, 0)) + 
  scale_y_continuous(expand = c(0, 0))
erupt + scale_fill_gradient(limits = c(0, 0.04))
erupt + scale_fill_gradient(limits = c(0, 0.04), low = 'white', high = 'black')
erupt + scale_fill_gradient2(limits = c(-0.04, 0.04), midpoint = mean(df$density))
point <- ggplot(msleep, aes(log(brainwt), log(bodywt), color = vore)) + geom_point() 
hist <- ggplot(msleep, aes(log10(brainwt), fill = vore, color = I('white'))) + geom_histogram(binwidth = 1)
point + scale_color_brewer(palette = 'Set1')
point + scale_color_brewer(palette = 'Set2')
point + scale_color_brewer(palette = 'Pastel1')
hist + scale_fill_brewer(palette = 'Set1')
hist + scale_fill_brewer(palette = 'Set2')
hist + scale_fill_brewer(palette = 'Pastel1')
# 6.4.4 手动离散型标度
plot <- ggplot(msleep, aes(log(brainwt), log(bodywt))) + geom_point()
plot + aes(color = vore) + scale_color_manual(values = c('red', 'orange', 'yellow', 'green', 'blue'))
colors <- c(carni = 'red', 'NA' = 'orange', insecti = 'yellow', herbi = 'green', omni = 'blue')
plot + aes(color = vore) + scale_color_manual(values = colors)
plot + aes(shape = vore) + scale_shape_manual(values = c(1, 2, 6, 0, 23))
huron <- data.frame(year = 1875:1972, level = LakeHuron)
ggplot(huron, aes(year)) + 
  geom_line(aes(y = level - 5), color = 'blue') + 
  geom_line(aes(y = level + 5), color = 'red')
ggplot(huron, aes(year)) + 
  geom_line(aes(y = level - 5, color = 'below')) + 
  geom_line(aes(y = level + 5, color = 'above')) + 
  scale_color_manual('Direction', values = c('below' = 'blue', 'above' = 'red'))

# chapter7 定位 分面和坐标系
# 7.2 分面
# 两套分面系统 facet_grid() and facet_wrap()
# 7.2.1 网格型facet_grid() 
mpg2 <- subset(mpg, cyl != 5 & drv %in% c('4', 'f'))
# 不进行分面：不添加facet_grid()或设置facet_null()
ggplot(mpg2, aes(cty, hwy)) + geom_point() + facet_null()
ggplot(mpg2, aes(cty, hwy)) + geom_point()
# 一行多列(. ~ a)
ggplot(mpg2, aes(cty, hwy)) + geom_point() + facet_grid(. ~ cyl)
# 一列多行(a ~ .) 尤其用于比较分布
ggplot(mpg2, aes(cty)) + geom_histogram(color = 'white', fill = 'orange') + facet_grid(cyl ~ .)
# 多行多列
ggplot(mpg2, aes(cty, hwy)) + geom_point() + facet_grid(drv ~ cyl)
# 边际图
ggplot(mpg2, aes(displ, hwy)) + geom_point() + facet_grid(cyl ~ drv) # 未生成边际图
ggplot(mpg2, aes(displ, hwy)) + geom_point() + facet_grid(cyl ~ drv, margins = T) # 生成行列的边际图
ggplot(mpg2, aes(displ, hwy)) + geom_point() + facet_grid(cyl ~ drv, margins = c('cyl')) # 根据字段生成边际图
ggplot(mpg2, aes(displ, hwy)) + geom_point() + 
  facet_grid(cyl ~ drv, margins = T) + 
  geom_smooth(aes(color = drv), method = 'lm', se = F) 
# 7.2.1 封装型facet_wrap() 
library('plyr')
library('ggplot2movies')
data(movies)
movies$decade <- round_any(movies$year, 10, floor)
ggplot(subset(movies, decade > 1890), aes(rating, ..density..)) + geom_histogram(binwidth = 0.5) + facet_wrap(~ decade, ncol = 6)
# 7.2.3 标度控制 scales = 'fixed', 'free', 'free_x', "free_y"
p <- ggplot(mpg, aes(cty, hwy)) + geom_point()
p + facet_wrap(~ cyl)
p + facet_wrap(~ cyl, scales = 'free')
library('reshape2')
em <- melt(economics, id = 'date')
ggplot(em, aes(date, value, group = variable, color = variable)) + geom_line() + facet_grid(variable ~ ., scales = 'free_y')
mpg3 <- within(mpg2, {model <- reorder(model, cty)
                      manufacturer <- reorder(manufacturer, -cty)
})
# 7.2.5 分组与分面
p <- ggplot(mpg3, aes(cty, model)) + geom_point()
p + facet_grid(manufacturer ~ ., scales = 'free', space = 'free') + 
  theme(strip.text.y = element_text())
p <- ggplot(subset(diamonds, color %in% c('D', 'E', 'G', 'J')), aes(log(carat), log(price), color = color, group = color))
p + geom_point()
p + geom_point() + facet_grid(. ~ color)
p + geom_smooth(method = 'lm', se = F)
p + geom_smooth(method = 'lm', se = F) + facet_grid(. ~ color)
# 7.2.6 并列与分面
ggplot(subset(diamonds, color %in% c('D', 'E', 'G', 'J')), aes(color, fill = cut)) + geom_bar(position = 'dodge', color = 'white')
ggplot(subset(diamonds, color %in% c('D', 'E', 'G', 'J')), aes(color, fill = cut)) + geom_bar(position = 'fill', color = 'white')
ggplot(subset(diamonds, color %in% c('D', 'E', 'G', 'J')), aes(cut, fill = cut)) + 
  geom_bar(position = 'dodge', color = 'white') + 
  facet_grid(. ~ color) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8, color = 'grey50'))
mpg4 <- subset(mpg, manufacturer %in% c('audi', 'volkswagen', 'jeep'))
mpg4$manufacturer <- as.character(mpg4$manufacturer)
mpg4$model <- as.character(mpg4$model)
p <- ggplot(mpg4, aes(fill = model)) + geom_bar(position = 'dodge')
p + aes(x = model)
p + aes(x = model) + facet_grid(. ~ manufacturer)
p + aes(x = model) + facet_grid(. ~ manufacturer, scales = 'free_x')
p + aes(x = model) + facet_grid(. ~ manufacturer, scales = 'free_x', space = 'free')
# 7.2.7 连续型变量 需先将连续型变量设置成离散型变量
# cut_interval(x, n = 10)
# cut_internal(x, length = 1)
# cut_number(x, n = 10)
summary(mpg$displ)
mpg2$displ_1 <- cut_interval(mpg2$displ, n = 6) # 划分成等距的6份
mpg2$displ_2 <- cut_interval(mpg2$displ, length = 1) # 划分成等距为1
mpg2$displ_3 <- cut_number(mpg2$displ, n = 6) # 划分成记录条数相等的6份
p <- ggplot(mpg2, aes(x = cty, y = hwy)) + geom_point()
p + facet_grid(. ~ displ_1)
p + facet_grid(. ~ displ_2)
p + facet_grid(. ~ displ_3)

# 7.3 坐标系
# 7.3.3 笛卡尔坐标系
p <- ggplot(mtcars, aes(disp, wt)) + geom_point() + geom_smooth()
p
p + xlim(325, 500) # 筛选数据后展示
p + scale_x_continuous(limits = c(325, 500)) # 筛选数据后展示
p + coord_cartesian(xlim = c(325, 500)) # 并没有筛选数据，而是展示相应范围的数据，相当于放大
ggplot(mpg, aes(cty, displ)) + geom_point() + geom_smooth()
ggplot(mpg, aes(displ, cty)) + geom_point() + geom_smooth()
ggplot(mpg, aes(cty, displ)) + geom_point() + geom_smooth() + coord_flip()
# 7.3.4 非笛卡尔坐标系
pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) + geom_bar(width = 1)
pie
pie + coord_polar(theta = 'y') # 饼图
pie + coord_polar() # 牛眼图

# chapter8 精雕细琢
# 8.1 主题
# 8.1.1 内置主题
# 全局性设置 theme_set(theme_grey()) theme_set(theme_bw())
# 局部性设置 ggplot() + ... + theme_grey()
library('ggplot2movies')
data(movies)
p <- ggplot(movies, aes(rating)) + geom_histogram(binwidth = 1)
p + theme_classic()
theme_1 <- theme_set(theme_grey())
ggplot(movies, aes(votes, rating)) + geom_point()
# 8.1.2 主题元素和元素函数
p <- p + labs(title = 'this is a histogram')
p + theme(plot.title = element_text(size = 20))
p + theme(plot.title = element_text(size = 20, color = 'red'))
p + theme(plot.title = element_text(size = 20, face = 'bold'))
p + theme(panel.grid.major = element_line(color = 'red'))
p + theme(panel.grid.major = element_line(size = 2))
p + theme(panel.grid.major = element_line(linetype = 'dotted'))
p + theme(axis.line = element_line())
p + theme(axis.line = element_line(color = 'red'))
p + theme(axis.line = element_line(size = 0.5, linetype = 'dashed'))
p + theme(plot.background = element_rect(fill = 'grey80', color = NA))
p + theme(plot.background = element_rect(color = 'red'))
p + theme(plot.background = element_rect(size = 3, color = 'red'))
p + theme(panel.background = element_rect(color = 'red'))
p + theme(panel.background = element_rect(color = 'red', linetype = 'dashed'))
p + theme(panel.grid.major = element_blank())
last_plot() + theme(panel.grid.minor = element_blank())
last_plot() + theme(panel.background = element_blank())
last_plot() + theme(axis.title.x = element_blank())

# 8.3 存储输出
ggplot(mtcars, aes(mpg, wt)) + geom_point()
ggsave('output.pdf')
pdf(file = 'output.pdf', width = 6, height = 6)
dev.off()

# 8.4 一页多图
a <- ggplot(economics, aes(date, unemploy)) + geom_line()
b <- ggplot(economics, aes(uempmed, unemploy)) + geom_point() + geom_smooth(se = F)
c <- ggplot(economics, aes(uempmed, unemploy)) + geom_path()
pdf('output.pdf')
(a <- ggplot(economics, aes(date, unemploy)) + geom_line())
(b <- ggplot(economics, aes(uempmed, unemploy)) + geom_point() + geom_smooth(se = F))
(c <- ggplot(economics, aes(uempmed, unemploy)) + geom_path())
dev.off()
# 8.4.1 子图
library(grid)
vp1 <- viewport(width = 1, height = 1, x = 0.5, y = 0.5)
vp1 <- viewport()
vp2 <- viewport(width = 0.5, height = 0.5, x = 0.5, y = 0.5)
vp2 <- viewport(width = 0.5, height = 0.5)
vp3 <- viewport(width = unit(2, "cm"), height = unit(3, "cm"))
vp4 <- viewport(x = 1, y = 1, just = c('top', 'right')) #提示有错误
vp5 <- viewport(x = 0, y = 0, just = c('bottom', 'left'))
pdf('output.pdf', width = 4, height = 4)
subvp <- viewport(width = 0.4, height = 0.4, x = 0.75, y = 0.35)
b
print(c, vp = subvp)
dev.off()
csmall <- c + theme_gray(9) + 
  labs(x = NULL, y = NULL) + 
  theme(plot.margin = unit(rep(0, 4), 'lines'))
pdf('output.pdf', width = 4, height = 4)
b
print(csmall, vp = subvp)
dev.off()
pdf('output.pdf', width = 8, height = 6)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
vplayout <- function(x, y){
  viewport(layout.pos.row = x, layout.pos.col = y)
}
print(a, vp = vplayout(1, 1:2))
print(b, vp = vplayout(2, 1))
print(c, vp = vplayout(2, 2))
dev.off()

# chapter9 数据操作

# 9.1 plyr包
# ddply(.data, .variables, .fun, ...)




