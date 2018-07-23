
# library packages ==================================================================
library(DMwR)
library(tidyverse)

# load dataset ======================================================================

# algae 训练集
data("algae")


# explore dataset ===================================================================
dim(algae)
head(algae)
summary(algae)
# season ~ speed：河流自身属性
# mxPH ~ Chla:河流化学属性
# a1 ~ a7：河流中7种藻类的数量
hist(algae$mxPH)
hist(algae$mxPH, probability = TRUE, ylim = 0:1)
lines(density(algae$mxPH, na.rm = TRUE))


# dealing with NAs ==================================================================
# 1.直接删除缺失值
# 2.根据变量相关性填补缺失值
# 3.根据样本之间的关系填补缺失值

# 共184个样本是完全没有缺失值的
sum(complete.cases(algae))
# 有缺失值的样本16条
algae[!complete.cases(algae), ]
# 其中有些样本的缺失值变量更多
manyNAs(algae)
manyNAs(algae, nORp = 0.2)
#第62和第199个样本的缺失值变量多

# 1.直接删除缺失值
X = na.omit(algae)
dim(X)
sum(complete.cases(X))

# 由于第62和第199个样本的缺失值变量数很多，我们直接删除这两个样本
algae_new <- algae[-manyNAs(algae), ]

# 2.根据变量相关性填补缺失值
cor(algae_new[, 4:18], use = 'complete.obs')
symnum(cor(algae_new[, 4:18], use = 'complete.obs'))
# 0 ‘ ’ 0.3 ‘.’ 0.6 ‘,’ 0.8 ‘+’ 0.9 ‘*’ 0.95 ‘B’ 1
# 相关性 in 0.0 - 0.3 显示为空
# 相关性 in 0.3 - 0.6 显示为.
# 相关性 in 0.6 - 0.8 显示为,
# 相关性 in 0.8 - 0.9 显示为+
# 相关性 in 0.9 - 0.95 显示为*
# 相关性 >= 0.95 显示为1

# PO4 VS oPO4 *
sum(is.na(algae_new$PO4))
sum(is.na(algae_new$oPO4))
lm(PO4 ~ oPO4, data = algae_new)
algae_new[is.na(algae_new$PO4),]
algae_new[is.na(algae_new$PO4), 'PO4'] <- 
  algae_new[is.na(algae_new$PO4), 'oPO4'] * 1.293 + 42.897
# NH4 VS NO3  ,
lm(NH4 ~ NO3, data = algae_new)
sum(is.na(algae_new$NH4))
sum(is.na(algae_new$NO3))

# 3.根据样本之间的关系填补缺失值
# 解释：根据样本之间的距离来对变量缺失值进行填补
algae_new[!complete.cases(algae_new),]
# Fill in NA values with the values of the nearest neighbours
algae_clean <- knnImputation(algae_new, k = 10)
sum(is.na(algae_clean))

# modeling ==========================================================================
# 多元线性回归模型预测藻类数量
lm_a1 <- lm(a1 ~ ., data = algae_clean[, 1:12])
summary(lm_a1)
# 根据R方可以了解到，回归模型的性能不是很好

# 精简模型：向后消元发anova()
anova(lm_a1)
# 看Sum Sq列，值越小代表该变量对减小残差的贡献越小
# 因此season列可以考虑剔除掉
# 更新模型
lm2_a1 <- update(lm_a1, . ~ . -season)
summary(lm2_a1)
# 比较两个模型
anova(lm_a1, lm2_a1)
# Sum of Sq为负，代表第二个模型相对第一个模型，残差有所减少，因此第二个模型更好
anova(lm2_a1)
lm3_a1 <- update(lm2_a1, . ~ . -Chla)
summary(lm3_a1)
anova(lm2_a1, lm3_a1)
anova(lm3_a1)
lm4_a1 <- update(lm3_a1, .~ . -NH4)
summary(lm4_a1)
anova(lm3_a1, lm4_a1)

# 逐步消元，得到最终模型
final_lm_a1 <- step(lm_a1)
summary(final_lm_a1)
# R方为0.3322，还是太小了，因此多元回归模型可能不适合，需要用其他模型代替











