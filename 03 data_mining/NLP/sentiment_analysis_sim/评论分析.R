# 导入所需的开发包
library(readxl)
library(jiebaR)
library(plyr)
library(stringr)
library(tm)
library(pROC)
library(ggplot2)
library(klaR)
library(randomForest)


# 读取评论数据
evaluation <- read_excel(path = file.choose(),sheet = 2)
# 查看数据类型
str(evaluation)

# 转换数据类型
evaluation$Emotion <- factor(evaluation$Emotion)

# 分词(自定义词和停止词的处理)
engine <- worker(user = 'C:\\Users\\Administrator\\Desktop\\HelloBI\\all_words.txt',
                 stop_word = 'C:\\Users\\Administrator\\Desktop\\HelloBI\\mystopwords.txt')
cuts <- llply(evaluation$Content, segment, engine)

#剔除文本中的数字和字母
Content <- lapply(cuts,str_replace_all,'[0-9a-zA-Z]','')
# 检查是否有空字符创，如有则删除
idx <- which(Content == '')
Content2 <- Content[-idx]
Content2[[1]]

# 删除含空字符的元素结果
Content3 <- llply(Content2, function(x) x[!x == ''])

# 将切词的评论转换为语料
content_corpus <- Corpus(VectorSource(Content3))

# 创建文档-词条矩阵
dtm <- DocumentTermMatrix(x = content_corpus, 
                          control = list(weighting = weightTfIdf,
                                         wordLengths = c(2, Inf)))
dtm

# 控制稀疏度
dtm_remove <- removeSparseTerms(x = dtm, sparse = 0.95)
dtm_remove
dtm_remove$dimnames$Terms
# 转换为数据框
df_dtm <- as.data.frame(as.matrix(dtm_remove))
head(df_dtm)

# 拆分为训练集和测试集
set.seed(1)
index <- sample(1:nrow(df_dtm), size = 0.75*nrow(df_dtm))
train <- df_dtm[index,]
test <- df_dtm[-index,]

# 贝叶斯分类器
bayes <- NaiveBayes(x = train, grouping = evaluation$Emotion[-idx][index], fL = 1)
# 预测
pred_bayes <- predict(bayes, newdata = test)
Freq_bayes <- table(pred_bayes$class, evaluation$Emotion[-idx][-index])
# 混淆矩阵
Freq_bayes
# 准确率
sum(diag(Freq_bayes))/sum(Freq_bayes)

#ROC曲线
roc_bayes <- roc(evaluation$Emotion[-idx][-index],factor(pred_bayes$class,ordered = T))

Specificity <- roc_bayes$specificities
Sensitivity <- roc_bayes$sensitivities

# 绘制ROC曲线
p <- ggplot(data = NULL, mapping = aes(x= 1-Specificity, y = Sensitivity))
p + geom_line(colour = 'red', size = 1) +
  coord_cartesian(xlim = c(0,1), ylim = c(0,1)) +
  geom_abline(intercept = 0, slope = 1)+ 
  annotate('text', x = 0.5, y = 0.25, label=paste('AUC=',round(roc_curve$auc,2)))+ 
  labs(x = '1-Specificity',y = 'Sensitivity', title = 'ROC Curve') +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', colour = 'brown'))




# 随机森林
rf <- randomForest(x = train, y = evaluation$Emotion[-idx][index])
pred_rf <- predict(rf, newdata = test)
# 混淆矩阵
Freq_rf <- table(pred_rf,evaluation$Emotion[-idx][-index])
Freq_rf
# 准确率
sum(diag(Freq_rf))/sum(Freq_rf)

#ROC曲线
roc_rf <- roc(evaluation$Emotion[-idx][-index],factor(pred_rf,ordered = T))

Specificity <- roc_rf$specificities
Sensitivity <- roc_rf$sensitivities

# 绘制ROC曲线
p <- ggplot(data = NULL, mapping = aes(x= 1-Specificity, y = Sensitivity))
p + geom_line(colour = 'red', size = 1) +
  coord_cartesian(xlim = c(0,1), ylim = c(0,1)) +
  geom_abline(intercept = 0, slope = 1)+ 
  annotate('text', x = 0.5, y = 0.25, label=paste('AUC=',round(roc_rf$auc,2)))+ 
  labs(x = '1-Specificity',y = 'Sensitivity', title = 'ROC Curve') +
  theme(plot.title = element_text(hjust = 0.5, face = 'bold', colour = 'brown'))

