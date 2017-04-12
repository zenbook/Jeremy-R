# load packages -------------------------------------------------------------------
library('rvest')
library('stringr')
library('tidyr')

# https://rpubs.com/Radcliffe/superbowl

# simple demo ---------------------------------------------------------------------
## 数据是标准的html表格格式
## 读取网页
read_html("http://en.wikipedia.org/wiki/Table_(information)") %>% 
  ## 抓取第一个wikitable标签的内容
  html_node(".wikitable") %>%
  ## 把wikitable从html代码格式转换成dataframe格式
  html_table()

# 流程详解 ------------------------------------------------------------------------
## 1.读取网页read_html()
url <- 'http://espn.go.com/nfl/superbowl/history/winners'
webpage <- read_html(url)
## 2.抓取内容html_nodes()
sb_table <- html_nodes(webpage, 'table')
## 3.把内容转换成dataframe
sb <- html_table(sb_table[[1]])
head(sb)
## 4.把数据整理一下
### 去掉前两行(无效数据),加上原来的列名
rown <- sb[2,]
sb <- sb[-(1:2), ]
colnames(sb) = rown
head(sb)
### 用阿拉伯数字代替罗马数字,转换日期格式
sb$NO. <- c(1:dim(sb)[1])
# sb$DATE <- as.Date(sb$DATE, format = "%B. %d, %Y") # 格式转换有问题，再看
### 把RESULT列分割成四列(winner, loser, winnerScore, loserScore)
# 先把winner和loser从result中分割出来
sb <- separate(sb, RESULT, c('winner', 'loser'), sep = ', ', remove = TRUE)
# 再来分割winner/score和loser/score
pattern <- "\\d+$"
sb$winnerScore <- as.numeric(str_extract(sb$winner, pattern))
sb$loserScore <- as.numeric(str_extract(sb$loser, pattern))
sb$winner <- gsub(pattern, "", sb$winner)
sb$loser <- gsub(pattern, "", sb$loser)
head(sb)




# 不太规范的数据格式 --------------------------------------------------------------
## PDF文件链接
read_html("http://www.sec.gov/litigation/suspensions.shtml") %>% 
  html_nodes("p + table a") %>% 
  head()






























