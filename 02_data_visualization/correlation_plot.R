
# 内容：绘制相关系数图
# 作者：王政鸣
# 日期：2018-01-17

# 安装corrplot
# install.packages('corrplot')

library(corrplot)

corr <- cor(mtcars[1:7])

corrplot(corr = corr)
