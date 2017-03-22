library('quantmod')

# get data 默认从雅虎财经中获取数据
# get one company's data
getSymbols('GOOG')
class(GOOG)
## get multiple companies data
getSymbols('GOOG;AAPL;AMZN;MSFT')
## 获取指定时间段的数据
getSymbols('GOOG', from = '2017-01-01')
getSymbols('GOOG', from = '2016-01-01', to = '2016-04-30')

# 绘制股票图
chartSeries(getSymbols("GOOG", from = '2017-01-01'))
