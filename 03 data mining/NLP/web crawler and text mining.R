
# ========================= library pacakges and datasets =========================
library(rvest)
library(tm)
library(wordcloud)


# ================================== web crawler ==================================

## 前3个页面的url
url <- "https://www.psychologytoday.com/search/site/leadership%20competencies"
n <- 2
urls <- paste(url, "?page=", 1:n, sep = "")
urls <- c(url, urls)

## 前3个页面中所有文章(30篇)的url
hrefs <- NULL
for (i in 1:length(urls)) {
  page <- read_html(urls[i])
  
  href <- html_nodes(page, ".search-result h3 a") %>% 
    html_attrs()
  
  hrefs <- c(hrefs, href)
}

## 30篇文章的所有内容
texts <- NULL
for (i in 1:length(hrefs)){
  tmp_url <- read_html(hrefs[[i]])
  
  text <- html_nodes(tmp_url, ".field-type-text-with-summary .field__item") %>% 
    html_text()
  
  texts <- c(texts, text)
}

# ================================== text mining ==================================

## texts的类型是characters，而用于做文本挖掘的数据类型必须是Corpus
docs <- VCorpus(VectorSource(texts))
inspect(docs[1:2])
meta(docs[[2]])
writeLines(as.character(docs[[2]]))

# preprocessing
## 删除标点符号
docs <- tm_map(docs, removePunctuation)
## 删除换行符
for (i in seq(docs)) {
  docs[[i]] <- gsub("\n", " ", docs[[i]])
}
## 删除所有数字
docs <- tm_map(docs, removeNumbers)
## 转换成小写
docs <- tm_map(docs, tolower)
## 删除所有停止词
docs <- tm_map(docs, removeWords, stopwords("en"))
## 还可以自定义停止词
# docs <- tm_map(docs, removeWords, c("leadership", "leader", "leaders", "can", "ofen"))

# 英文单词有很多变体，比如时态，单数复数
# .......
# 最好的话，应该把不同变体都转换成相同的形式，作为一个单词

## 有些词可以组合成词组，以免被认作两个词
# for (i in seq(docs)) {
#   docs[[i]] <- gsub("leadership competencies", "lead_comp", docs[[i]])
# }
## 删除所有多于的空白
docs <- tm_map(docs, stripWhitespace)
## 最后整理一下
docs <- tm_map(docs, PlainTextDocument)

# 转换格式，查看文章中单词的频次
dtm <- DocumentTermMatrix(docs)
tdm <- TermDocumentMatrix(docs)
inspect(dtm[1:10, 1:5])
## 发现一个问题：由于前面没对单词的不同变体做处理，所以出现了同一单词的不同变体，比如ability

# 查看出现频次最高的20个单词
freq <- colSums(as.matrix(dtm))
length(freq)
ord <- order(freq, decreasing = T)
freq[head(ord, 20)]

# 查找相关性
findAssocs(dtm, c("leadership", "competencies"), corlimit = 0.7)

# 词云
wordcloud(names(freq), freq, min.freq = 25, colors = brewer.pal(10, "Dark2"))

