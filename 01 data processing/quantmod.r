library('quantmod')

# get data 默认从雅虎财经中获取数据
# get one company's data
getSymbols('GOOG')
class(GOOG)
head(GOOG)
## get multiple companies data
getSymbols('GOOG;AAPL;AMZN;MSFT')
## 获取指定时间段的数据
getSymbols('GOOG', from = '2017-01-01')
getSymbols('GOOG', from = '2016-01-01', to = '2016-04-30')

# 绘制股票图
chartSeries(GOOG)

# 为股票图添加元素
addMACD()
addBBands()

# 绘制股票图，设置颜色和主题
chartSeries(GOOG, multi.col = TRUE, theme = 'white')

# 绘制股票图，添加其他元素
chartSeries(GOOG, multi.col = TRUE, theme = 'white', TA = 'addMACD(); addBBands()')
