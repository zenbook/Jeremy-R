
# load packages ========================================================
library(ggplot2)
library(ggthemes)
library(scales)
library(dplyr)
library(mice)
library(randomForest)


# load dataset =========================================================
train = read.csv('train.csv', stringsAsFactors = FALSE)
test = read.csv('test.csv', stringsAsFactors = FALSE)
full = bind_rows(train, test)
str(full)

# feature engineering ==================================================

# 1.乘客的Name中包含了一些称谓，如Mr Mrs, Miss, 称谓反映了乘客的社会地位和身份；
full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
# 学习gsub！！！
table(full$Title, full$Sex)
# 把很少用到的称谓汇总一起
rare_Title <- c('Dona', 'Lady', 'the Countess', 'Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
# 把相同含义的称谓汇总为一个
full$Title[full$Title == 'Mlle'] <- 'Miss'
full$Title[full$Title == 'Ms'] <- 'Miss'
full$Title[full$Title == 'Mme'] <- 'Mrs'
full$Title[full$Title %in% rare_Title] <- 'Rare Title'
table(full$Title, full$Sex)

# 2.抽取出乘客的姓氏，姓氏代表家族
full$Surname <- sapply(full$Name, 
                       function(x) strsplit(x, split = '[,.]')[[1]][1])
# 通过家族还可以了解到乘客的种族

# 3.家庭成员数量，毛主席说人多力量大，是不是人多就更有可能存活呢？
full$Fsize <- full$SibSp + full$Parch + 1

# 4.组合Surname 和 Fsize
full$Family <- paste(full$Surname, full$Fsize, sep = '_')

# 来看看不同Fsize的存活分布
ggplot(data = full[1:891, ], aes(x = Fsize, fill = factor(Survived))) + 
  geom_bar(stat = 'count', position = 'dodge') + 
  scale_x_continuous(breaks = c(1:11)) + 
  labs(x = 'Family Size') + 
  theme_bw()
# 发现不是人越多越容易存活，
# Fsize = 2/3/4的人存活人数多于死亡人数
# Fsize = 1 OR Fsize >=5 存活人数少于死亡人数
# 独自一个人，没有帮忙，容易死亡；家人太多，要让家人活，自己也容易死亡；
# 因此我们分成三类
full$FsizeD[full$Fsize == 1] <- 'single'
full$FsizeD[full$Fsize > 1 & full$Fsize < 5] <- 'small'
full$FsizeD[full$Fsize >= 5] <- 'large'

# 来个马赛克图瞧瞧不同家庭大小的存活情况
mosaicplot(table(full$FsizeD, full$Survived), 
           main = 'Family Size by Survived', 
           shade = TRUE)

# 4.舱位和甲板
full$Cabin[1:20]
# 第一个字母代表甲板
strsplit(full$Cabin[2], NULL)[[1]]
# 救生艇甲板（The Boat Deck）：该甲板位于最顶层，因两侧安放了救生艇而得名
# A甲板（A Deck）：又被称为“散步甲板”（Promenade Deck），该层专供一等舱乘客使用，前部是一等客舱
# B甲板（B Deck）：又被称为“船桥甲板”（Bridge Deck），前甲板、后甲板与该层平齐但并不相连。B甲板前部为一等舱

# C甲板（C Deck），又被称为“遮盖甲板”（Shelter Deck）
# D甲板（D Deck），又被称为“沙龙甲板”（Saloon Deck）
# E甲板（E Deck），又被称为“上层甲板”（Upper Deck）
# F甲板（F Deck），又被称为“中层甲板”（Middle Deck）
# G甲板（G Deck），又被称为“下层甲板”（Lower Deck）
# 底层甲板（Orlop Deck）
full$Deck <- factor(sapply(full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))




















