# load packages -------------------------------------------------------------------
library('rvest')
library('stringr')
library('tidyr')

# https://rpubs.com/Radcliffe/superbowl
# https://cran.r-project.org/web/packages/rvest/rvest.pdf
# http://cpsievert.github.io/slides/web-scraping/20150612/#1

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


# another good case ---------------------------------------------------------------
url <- "http://www.fia.com/events/fia-formula-one-world-championship/season-2015/race-classification-0"
fiaTableGrabber <- function(url,num){
  #Grab the page
  hh = read_html(url)
  #Parse HTML
  cc = html_nodes(hh, xpath = "//table")[[num]] %>% 
    html_table(fill=TRUE)
  #Set the column names
  colnames(cc) = cc[1, ]
  #Drop all NA column
  cc = Filter(function(x)!all(is.na(x)), cc[-1,])
  #Fill blanks with NA
  cc = apply(cc, 2, function(x) gsub("^$|^ $", NA, x))
  #would the dataframe cast handle the NA?
  as.data.frame(cc)
}
#Usage:
#NUM:
## Qualifying:
### 1 CLASSIFICATION 
### 2 BEST SECTOR TIMES
### 3 SPEED TRAP 
### 4 MAXIMUM SPEEDS
##Race:
### 1 CLASSIFICATION
### 2 FASTEST LAPS
### 3 BEST SECTOR TIMES
### 4 SPEED TRAP
### 5 MAXIMUM SPEEDS
### 6 PIT STOPS
xx <- fiaTableGrabber(url,NUM)

# another case from RStudio ------------------------------------------------------
## 读取url
legomovie <- read_html("http://www.imdb.com/title/tt1490017/")
## 抓取评分7.8
legomovie %>% 
  html_node("strong span") %>%   # 评分的标签
  html_text() %>%   # 转换成文本
  as.numeric()  # 转换成数值
## 抓取演员姓名 
legomovie %>% 
  html_nodes("#titleCast .itemprop span") %>%  # 演员表所在的标签
  html_text()  # 转换成文本(缺陷：只抓取了第一页)
## 抓取饰演角色/配音角色
legomovie %>% 
  html_nodes("#titleCast .character") %>% 
  html_text() %>% 
  head()
## 以上数据需要清洗
legomovie %>% 
  html_nodes("table") %>% 
  .[[2]] %>% 
  html_table()


# If you prefer, you can use xpath selectors instead of css: html_nodes(doc, xpath = "//table//td")).
# Extract the tag names with html_tag(), text with html_text(), a single attribute with html_attr() or all attributes with html_attrs().
# 
# Detect and repair text encoding problems with guess_encoding() and repair_encoding().
# 
# Navigate around a website as if you’re in a browser with html_session(), jump_to(), follow_link(), back(), and forward(). Extract, modify and submit forms with html_form(), set_values() and submit_form(). (This is still a work in progress, so I’d love your feedback.)
# 
# To see these functions in action, check out package demos with demo(package = "rvest").





















