
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
# A甲板（A Deck）：又被称为“散步甲板”（Promenade Deck），该层专供一等舱乘客使用，
#                  前部是一等客舱
# B甲板（B Deck）：又被称为“船桥甲板”（Bridge Deck），前甲板、后甲板与该层平齐但并不相连。
#                  B甲板前部为一等舱
# C甲板（C Deck），又被称为“遮盖甲板”（Shelter Deck）
# D甲板（D Deck），又被称为“沙龙甲板”（Saloon Deck）
# E甲板（E Deck），又被称为“上层甲板”（Upper Deck）
# F甲板（F Deck），又被称为“中层甲板”（Middle Deck）
# G甲板（G Deck），又被称为“下层甲板”（Lower Deck）
# 底层甲板（Orlop Deck）
full$Deck <- factor(sapply(full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))


# missing values =======================================================

# Embarked
# passenger_id为62和830的乘客的登船码头缺失
full[c(62, 830), 'Embarked']
full[c(62, 830), ]
# 这两位乘客的票价是80
# 根据票价我们来推测一下这两位乘客的登船码头
embark_fare <- full %>% filter(PassengerId != 62 & PassengerId != 830)
ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) + 
  geom_boxplot() +
  geom_hline(aes(yintercept = 80), 
             colour = 'red', 
             linetype = 'dashed', 
             lwd = 2) + 
  scale_y_continuous(labels = dollar_format()) + 
  theme_bw()
# 发现Pclass = 1 & Fare平均值在80的只有C港口，其余港口的基本都低于80美元
full$Embarked[c(62, 830)] <- 'C'


# Fare
sum(is.na(full$Fare))
full[is.na(full$Fare), ]
# 发现1044号乘客的Fare缺失
# 这位乘客Pclass = 3, Embarked = S, 求得中位数，用中位数来代替
ggplot(full[full$Pclass == 3 & full$Embarked == 'S', ], 
       aes(x = Fare)) + 
  geom_density(fill = '#99d6ff', alpha = 0.4) + 
  geom_vline(aes(xintercept = median(Fare, na.rm = TRUE)), 
             color = 'red', 
             linetype = 'dashed', 
             lwd = 1) + 
  scale_x_continuous(labels = dollar_format()) + 
  theme_bw()
median(full$Fare[full$Pclass == 3 & full$Embarked == 'S'], na.rm = TRUE)
full$Fare[1044] <- median(full$Fare[full$Pclass == 3 & full$Embarked == 'S'], 
                          na.rm = TRUE)

# Age
sum(is.na(full$Age))
factor_vars <- c('PassengerId', 'Pclass', 'Sex', 'Embarked', 'Title', 
                 'Surname', 'Family', 'FsizeD')





