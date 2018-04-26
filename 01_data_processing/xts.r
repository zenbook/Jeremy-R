
# 教程来自张丹的博客：http://blog.fens.me/r-xts/
library('xts')
data("sample_matrix")
head(sample_matrix)
tail(sample_matrix)

# 矩阵转换为xts格式
sample.xts <- as.xts(sample_matrix, descr = 'my new xts boject')
class(sample.xts)

# 数据查询
## 根据日期筛选
head(sample.xts['2007']) # 2007年的
head(sample.xts['2007-03']) # 2007-03的
tail(sample.xts['2007-03']) # 2007-03的
head(sample.xts['2007-03/']) # 从2007-03开始的
tail(sample.xts['2007-03/']) # 从2007-03开始的
head(sample.xts['2007-03-06/2007']) # 2007年从2007-03-06开始的
tail(sample.xts['2007-03-06/2007']) # 2007年从2007-03-06开始的
sample.xts['2007-03-01'] # 2007-03-01的
## 根据其他字段筛选(和一般筛选没有差别)
sample.xts[sample.xts$Open > 51, ]

# 画图(扩展：用ggplot/highchart等绘制时间序列图形)
plot(sample_matrix)
plot(sample.xts)
plot(sample_matrix[,1])
# K线图
plot(sample.xts, type = 'candles')

# 首尾时间
firstof(2000)
firstof(2000, 02)
lastof(2000)
lastof(2000, 02)
lastof(2017, 02)
lastof(2017, 2)
.parseISO8601('2000')
.parseISO8601('2000-03/2004-02')
.parseISO8601('2000-01/03')

# 按时间分割数据并计算(日/周/月/季/年：平均/求和……)
## 日
apply.daily()
## 周(从周二到周一，WHY? 怎么自定义?)
apply.weekly(sample.xts[-c(1:6), ], mean)
## 月
apply.monthly(sample.xts, mean)
apply.monthly(sample.xts[,1], function(x){var(x)})
## 季
apply.quarterly(sample.xts, mean)
## 年
apply.yearly(sample.xts, mean)

# 按期间分割 to.period()
to.period(sample_matrix)
to.period(sample.xts)









