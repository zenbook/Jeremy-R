# library packages ===========================================================
library(mice)
library(VIM)

# explore dataset ============================================================
head(nhanes)
str(nhanes)

## show missing values pattern
md.pattern(nhanes)
## pattern describle
### 1.列为变量名，行为缺失值的表现，1表示完整，0表示缺失；
### 2.第一行，13表示：25个样本中，13个样本是完整的，没有缺失值；最右侧0表示含缺失值的变量数；
### 3.2/3/4/5行含义类同；
### 4.底部数字表示：每个变量含缺失值的样本数量，最右侧27表示样本总的缺失值数；

## another way to show missing value pattern
p <- md.pairs(nhanes)
p
## pattern describle
### 1.变量两两组成一组AB，AB均不缺失：rr; A完整B缺失：rm; A缺失B完整：mr; AB均缺失：mm

## plot missing pattern
marginplot(nhanes[, c('chl', 'bmi')], 
           col = mdc(1:2), 
           cex = 1.2, 
           cex.lab = 1.2, 
           cex.numbers = 1.3, 
           pch = 19)













