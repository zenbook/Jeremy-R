# 将当前文件所在的路径设置为工作目录
library('rstudioapi')
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 加载包
library(jiebaR)

# 简单分词  ----------------------------------------------------------------------------
wk = worker()
wk['大家好，我是来自杭州的Jeremy，一个数据分析爱好者']
wk['上海自来水来自海上']
wk['南京市长江大桥同志视察南京市长江大桥']
wk['南京市市长江大桥同志视察南京市长江大桥']
# 分词的语法有三个，结果相同：
# 1.wk['']
# 2.wk<=''
# 3.segment('', wk)
wk<='大家好，我是来自杭州的Jeremy，一个数据分析爱好者'
segment('上海自来水来自海上', wk)

# 对文本文件分词  ----------------------------------------------------------------------
wk['./B2B.txt']
# 在当前工作目录下生成一个分词后的文本文件，词与词之前以空格间隔

# 分词引擎
# mix, mp, hmm, full, query, tag, simhash, and keywords.

# 分词函数结构 -------------------------------------------------------------------------
worker(type = 'mix',  # 分词引擎的类型,默认使用mix混合模型
       dict = DICTPATH,  # 系统词典的路径，默认DICTPATH
       hmm = HMMPATH,  # HMM模型的路径
       user = USERPATH,  # 用户词典的路径
       idf = IDFPATH,  # IDF词典
       stop_word = STOPPATH,  # 停止词词典路径,文件必须是utf-8
       write = TRUE,
       qmax = 20,  # 最大成词字符数, 默认20
       topn = 5,  # 关键词数, 默认5个, 适用于simhash和keywords分词引擎
       encoding = 'utf-8',  # 输入文件的编码, 默认utf-8
       detect = TRUE,  # 是否检查输入文件的编码, 默认为TRUE
       symbol = FALSE,  # 是否保留符号
       lines = 1000,  # 当输入文件时，每次读取的最大行数，如果文件过大，可分次读取
       output = './text_split.txt',  # 分词后文件的路径和名称
       bylines = FALSE,  # 分词后的结果是否按行输出
       user_weight = 'min'  # 用户词典的权重
       )

# 查看分词引擎的配置
wk
# 修改分词引擎的配置，可以按照上述的函数结构，在调用时进行设置
# 也可以直接单独设置，如wk$lines = 200
library(pryr)
otype(wk)
class(wk)

# 配置词典  -----------------------------------------------------------------------------
# 词典对分词结果的好坏影响重大，虽然jiebaR有默认的标准词典，但是不同行业使用不同词典，效果更好
# 查看现有的默认词典
show_dictpath()  # 词典路径
dir(show_dictpath())  # 词典
# jieba.dict.utf8, 系统典文件，最大概率法，utf8编码的
# hmm_model.utf8, 系统词典文件，隐式马尔科夫模型，utf8编码的
# user.dict.utf8, 用户词典文件，utf8编码的
# stop_words.utf8，停止词文件，utf8编码的
# idf.utf8，IDF语料库，utf8编码的
# jieba.dict.zip，jieba.dict.utf8的压缩包
# hmm_model.zip，hmm_model.utf8的压缩包
# idf.zip，idf.utf8的压缩包
# backup.rda，无注释
# model.rda，无注释
# README.md，说明文件

# 查看系统词典jieba.dict.utf8，打印前50行
scan(file = 'C:/Users/dakongyi/Documents/R/win-library/3.3/jiebaRD/dict/jieba.dict.utf8',
     what = character(), 
     nlines = 50, 
     sep = '\n', 
     encoding = 'utf-8', 
     fileEncoding = 'utf-8')
# 可以发现，系统词典每个词有三列，以空格分割
# 第一列：此项；第二列：词频； 第三列：词性

# 查看用户词典user.dict.utf8，打印前50行
scan(file = 'C:/Users/dakongyi/Documents/R/win-library/3.3/jiebaRD/dict/user.dict.utf8',
     what = character(), 
     nlines = 50, 
     sep = '\n', 
     encoding = 'utf-8', 
     fileEncoding = 'utf-8')
# 可以发现用户词典只有5个词，而且没有词频，用户词典中的词频默认为系统词典中的最大词频

# 可以自定义一个用户词典，如user.uft8, 放入dict目录下
# 定义以下词：
# 市长
# 江大桥
wk = worker(user = 'C:/Users/dakongyi/Documents/R/win-library/3.3/jiebaRD/dict/user.utf8')  
wk['南京市长江大桥同志视察南京市长江大桥']
# 以上也有问题，就是后面的"南京市长江大桥"也被分成了南京 市长 江大桥

# 使用搜狗词典  ----------------------------------------------------------------------------
# D:\application\SogouInput\7.7.0.6625\scd\14108.scel
# 需安装cidian项目


# 停止词过滤  ------------------------------------------------------------------------------
# 停止词的概念：分词结果中不需要的词，比如的/得/地/你/我/他……
# jiebaR中过滤停止词有两个方法：
# 1.配置停止词文件，如默认的停止词文件stop_words.utf8
wk = worker(
  stop_word = 'C:/Users/dakongyi/Documents/R/win-library/3.3/jiebaRD/dict/stop_word1.utf8')
segment <- wk['之乎者也，我是Jeremy, 他是jimmy，你是谁？']
segment
# 2.使用filter_segment()函数
wk = worker()
segment <- wk['之乎者也，我是Jeremy, 他是jimmy，你是谁？']
filter <- c('之', '乎', '者', '也', '你', '我', '他')
filter_segment(segment, filter)
# 系统默认的停止词文件中的停止词还是很多的，比如几乎所有的标点符号都在其中

# 关键词提取  ------------------------------------------------------------------------------
#    关键词提取是文本处理非常重要的一个环节，一个经典算法是TF-IDF算法。
# 其中，TF（Term Frequency）代表词频，IDF（Inverse Document Frequency）表示逆文档频率。
# 如果某个词在文章中多次出现，而且不是停止词，那么它很可能就反应了这段文章的特性，这就是我们
# 要找的关键词
# TF-IDF = TF(词频) * 逆文档频率(IDF)
# 对文档中每个词计算TF-IDF的值，把结果从大到小排序，就得到了这篇文档的关键性排序列表。
# 在安装目录中的idf.utf8文件，为IDF的语料库
# 查看idf.utf8文件的前50行
scan(file = 'C:/Users/dakongyi/Documents/R/win-library/3.3/jiebaRD/dict/idf.utf8',
     what = character(), 
     nlines = 50, 
     sep = '\n', 
     encoding = 'utf-8', 
     fileEncoding = 'utf-8')
# idf.utf8文件每一行有2列，第一列是词项，第二列为权重
wk = worker()
text = 'R的极客理想系列文章，涵盖了R的思想，使用，工具，创新等的一系列要点，以我个人的学习和体验去诠释R的强大。'
segment<-wk[text]
segment
freq(segment)
# 取tf-idf前5的关键词
keys = worker('keywords', topn = 5)
vector_keywords(segment, keys)
# ？问题：
# 如果idf语料库中没有词，那么怎么计算tf_idf值呢？

