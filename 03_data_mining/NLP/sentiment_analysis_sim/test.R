library(jiebaR)

sentence <- '滚出去！我没有时间听一个牢里混出来的人渣，在这里跟我讲该怎么样不该怎么样！你以为西装往身上一套，我就看不到你骨子里的寒酸，剪剪头、吹吹风，就能掩藏住心里的猥琐？你差得还远，你这种人我见得多了，但还没有见到过敢对我指手画脚的。消失，快从我面前消失！'
# 设置动力和引擎
engine <- worker()
# 查看引擎配置
engine

# 分词
cuts <- segment(sentence, engine)
cuts


# 自定义词库--方法一
engine2 <- worker(user = 'C:/Program Files/R/R-3.3.1/library/jiebaRD/dict/my_dict.txt')
segment(sentence, engine2)

# 自定义词库--方法二
new_user_word(engine, c('剪剪头','吹吹风','见到过'))
cuts2 <- segment(sentence, engine)
cuts2

# 停止词的处理--方法一
engine3 <- worker(user = 'C:/Program Files/R/R-3.3.1/library/jiebaRD/dict/my_dict.txt',
  stop_word = 'C:/Program Files/R/R-3.3.1/library/jiebaRD/dict/stop_words.txt')
segment(sentence, engine3)

# 停止词的处理--方法二
cuts3 <- filter_segment(cuts2, filter_words = c('我','的','听','在','你','就','能','还','对',
                                                '人','从','但','讲','跟','这种','一个','身上'))




# 转换为语料库
sentences <- c('看了一下，又是一男三女的披着励志外衣得狗血爱情剧，为了制造毫无意义的紧张感，让做工作介绍的去窃取商业机密，编剧你真的上过班吗？胡歌流里流气得表演油腻得堪比黄晓明',
               '胡歌每次都吹的很好，结果每次都被同剧吊打，伪装者被靳东，琅琊榜是凯凯王，现在更是尴尬，演的啥玩意啊',
               '头两集估计为了过审被大量删减了 而且删完变得很难看 第三集开始突然正常好看了 编剧出品还是有保障的 然后这剧不套路这点很不错 但情节时紧时松')

# 切词(从引擎上配置用户自定义词和停止词)
engine <- worker(user = 'C:\\Users\\Administrator\\Desktop\\HelloBI\\all_words.txt',
                 stop_word = 'C:\\Users\\Administrator\\Desktop\\HelloBI\\mystopwords.txt')

cuts <- lapply(sentences, segment, engine)

cuts_corpus <- Corpus(VectorSource(cuts))
dtm <- DocumentTermMatrix(cuts_corpus)
tf <- as.data.frame(as.matrix(dtm))
tf
