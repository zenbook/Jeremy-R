
#  7.1 假设检验
data(Income, package = "rinds")
head(Income)
income <- Income$Income
summary(income)
## 我们发现中位数为3373，均值为16890，如果你的工资为18000，那么可以说明你的工资没有拖大家的后退吗？
## 即你的工资显著的高于平均值，或者说平均工资显著得低于18000
## 在假设检验中，我们希望可以拒绝原假设，而采用备择假设，于是我们设置h1：u < 18000,于是设置h0:u > 18000
## 总体方差未知，检验均值最常用得是t检验
t.test(income, mu = 18000, slternative = "less")
## 我们发现p-value = 0.7823，这个数字可以理解为“拒绝原假设而犯错误得概率”
require("ggplot2")
ggplot(Income, aes(Income)) + geom_histogram(binwidth = 10000)
## 通过绘图我们发现收入是长尾分布，不仅不是正态分布，连对称分布都算不上
## 而t检验要求样本服从正态分布，因此p值较大可能是因为使用了t检验
## 换Wilcoxon符号秩检验
wilcox.test(income, mu = 18000, alternative = "less")
## 这时我们发现p值非常小，基本等于0
## 说明我们选择t检验不对，选择Wilcoxon符号秩检验是更好的选择
## 然而，Wilcoxon符号秩检验虽然不要求正态分布，但是要求是对称分布
## 符号检验不要求数据分布的对称性，因此我们使用rinds包中的sign.test
require("rinds")
sign.test(income, m0 = 18000, h1 = "less")
## 我们发现p值更小，更接近0，所以结论很明显，收入18000并没有拖大家的后腿

## 从上面的过程，我们发现，选择统计方法要注意背后隐含的假设，比如正态分布，对称分布……


# 检验两个样本的均值
## 构造一个新的样本：
set.seed(1)
income2 <- rnorm(100, mean = 10000, sd = 2000)
wilcox.test(x = income, y = income2, alternative = "less")
## 我们设置的alternative = “less"，该检验会自动选择大小的两边

# 检验两个样本的方差
## 要求：样本都服从正态分布，用方差比可以构成F统计量，var.test()

# 大多数情况下，数据并不来自正态分布，因此经常用非参数统计的方法，比如Ansari-Bradly检验
var(income)
var(income2)
ansari.test(x = income2, y = income, alternative = "less")


# 两样本的相关性，相关关系，常用的是Spearman秩相关和Kendall t相关检验
## 在R中统一用cor.test()实现
cor.test(x = income, y = income2, method = "kendall", alternative = "two.sided")
## 发现p值很大，所以两者无相关性

# 对分布的检验
## 最常用的关于分布的检验是Kolmogorov-Smirno检验
## 在R中通过ks.test()函数来实现
## ks.test()函数有两个形式，常用的方式是参数y控制分布的名称，p开头，比如pnorm表示正态分布
ks.test(x = income, y = "pnorm", mean = mean(income), sd = sd(income))
## Kolmogorov-Smirno检验与其他一些关于分布的检验不一样，备择假设是”不符合某种方式“

















