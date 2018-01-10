
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











