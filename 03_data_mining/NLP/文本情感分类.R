
# library
library(jiebaR)

# 1.分析一段话 =======================================================

## 1.1 text
sentence <- '滚出去！我没有时间听一个牢里混出来的人渣，在这里跟我讲该怎么样不该怎么样！你以为西装往身上一套，我就看不到你骨子里的寒酸，剪剪头、吹吹风，就能掩藏住心里的猥琐？你差得还远，你这种人我见得多了，但还没有见到过敢对我指手画脚的。消失，快从我面前消失！'

## 1.2 设置动力和引擎
engine <- worker()
### 查看engine的详细信息
engine

## 1.3 分词
cuts <- segment(sentence, engine)
cuts
### 从结果来看，有些词没分对，比如剪剪头、吹吹风、见到过

## 1.4 设置自定义词库，使分词更合理
### 1.4.1 方法1：创建词库文件
### 注意：词库文件中，每一行写一个词，不要加逗号等标点符号
engine2 <- worker(user = 'C:/Users/dakongyi/Documents/R/win-library/3.4/jiebaRD/dict/my_dict.txt')
segment(sentence, engine2)
### 1.4.2 方法2：使用new_user_word函数指定自定义的词汇
new_user_word(engine, c('剪剪头', '吹吹风', '见到过'))
cuts2 <- segment(sentence, engine)
cuts2
### 可以看到两个方法的结果是一样的

## 1.5 设置停止词，使分词更合理
### 1.5.1 方法1：创建停止词文件
engine3 <- worker(user = 'C:/Users/dakongyi/Documents/R/win-library/3.4/jiebaRD/dict/my_dict.txt', 
                  stop_word = 'C:/Users/dakongyi/Documents/R/win-library/3.4/jiebaRD/dict/my_stop_words.txt')
segment(sentence, engine3)
### 1.5.2 方法2：使用filter_segment函数对cuts2进行筛选，传入filter_words参数
filter_segment(cuts2, filter_words = c('我','的','听','在','你','就','能','还','对','人','从','但','讲','跟','这种','一个','身上'))


# 2.文本情感分类，正负情感 ============================================

## 2.0 load libraries
library(jiebaR)
library(plyr)
library(stringr)
library(tm)

## 2.1 data processing

### 加载评论数据
evaluation <- read.csv("./sentiment_analysis_sim/Hotel Evaluation.csv", 
                       header = TRUE, 
                       stringsAsFactors = FALSE)

### 查看数据
str(evaluation)

### 把Emotion字段的类型修改成factor
evaluation$Emotion <- as.factor(evaluation$Emotion)

### 分词
engine <- worker(user = "./sentiment_analysis_sim/all_words.txt", 
                 stop_word = "./sentiment_analysis_sim/mystopwords.txt")
cuts <- llply(evaluation$Content, segment, engine)
#### 分词结果是一个list
class(cuts)
#### 第一条评论的分词结果,注意结果中有6和8
cuts[1]

### 剔除文本中的数字和字母
content <- lapply(cuts, str_replace_all, '[0-9a-zA-Z]', '')
class(content)
content[1]
#### 发现6和8都已经替换成了""

### 检查内容为空的评论，剔除掉
idx <- which(content == "")
idx
#### 发现第98和391条评论是空内容
#### 我们看最原始的评论内容，发现其实是有内容的，其中98条偏负面，391条偏正面；
evaluation[c(98, 391), ]
#### 而分词结果中只有数字了，问题出在自定义和停止词词库上，需要修改一下；
cuts[98]
cuts[391]
content2 <- content[-idx]

### 删除每条评论分词后的空字符元素
content3 <- llply(content2, function(x) x[!x == ""])

### 把切词后的评论转换为语料
content_corpus <- Corpus(VectorSource(content3))
class(content_corpus)

### 创建文档-词条








