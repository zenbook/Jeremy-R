
# 12.1 网络数据获取 ====================================================
## 12.1.1 XML和XPath
require("XML")
require("RCurl")
require("rjson")
# 抓取table报表 readHHTMLTable()
url_china <- "http://zh.wikipedia.org/wiki/中国一级行政区"
tables <- readHTMLTable(url_china, 
                        header = FALSE, 
                        stringsAsFactors = FALSE)  # 不能连接到维基百科网站
url_abcchina <- "http://data.eastmoney.com/zjlx/601288.html"
tables <- readHTMLTable(url_abcchina, 
                        header = TRUE, 
                        stringsAsFactors = FALSE)  
# XML在windows系统下貌似不能很好地显示中文字符
tables[1]

## 问题：现在越来越多的https协议，怎么去抓取采取https协议的网页数据呢？

# 抓取非结构化的数据 htmlParse() 和 getNodeSet()
## htmlParse() 负责抓取页面数据并形成树状结构
## getNodeSet()  对抓取的数据根据XPath语法来选取特定的节点集合
douban_url <- "https://movie.douban.com/top250"  
# 豆瓣采取的协议是https协议，不能直接抓取
dianping_url <- "http://t.dianping.com/list/hangzhou-category_253"
jingdian <- htmlParse(dianping_url)
class(jingdian)
str(jingdian)
nodes <- getNodeSet(jingdian, "//div[@class = 'tg-floor-item-wrap']")
class(nodes)
str(nodes)
jingdian <- sapply(nodes, xmlValue)
class(jingdian)
str(jingdian)
jingdian <- gsub("\t", "", jingdian)
jingdian <- gsub("\n", "", jingdian)
jingdian[1]
jingdian <- as.data.frame(jingdian)
View(jingdian)
## 遗留问题：怎么更好地转换成表格格式


#  美团
meituan_url <- "http://hz.meituan.com/category/zizhucan?mtt=1.index%2Ffloornew.0.0.itedy0jr"
zizhu <- htmlParse(meituan_url, encoding = "UTF-8")
zizhu


# 关于XPath更复杂的例子，新浪微博数据
weibo_url <- "http://s.weibo.com/weibo/R%25E8%25AF%25AD%25E8%25A8%2580?topnav=1&wvr=6&b=1"
pagetree <- htmlParse(weibo_url)
pagenode <- getNodeSet(pagetree, path = "//script")
pagescript <- sapply(pagenode, xmlValue)
write.table(pagescript, "pagescript.html")
weiboline <- pagescript[grep('\"pid\":\"pl', pagescript)]
weibojson <- gsub("\\)$", "", gsub("^.*STK.pageletM.view\\(", "", weiboline))  # 取json
weibolist <- fromJSON(json_str = weibojson)
weibopage <- htmlParse(weibolist[["html"]], asText = TRUE, encoding = "UTF-8")
weiboitem.con <- getNodeSet(weibopage, "//dd[@class = 'content']")
author.con <- getNodeSet(weiboitem.con[[1]], "p[@node-type = 'feed_list_content']/a")[[1]]

url <- "http://www.qpwa.com/index.jhtml"
jingdian <- htmlParse(url, encoding = "utf-8")
nodes <- getNodeSet(jingdian, "//div[@class = 'tg-floor-item-wrap']")
jingdian <- sapply(nodes, xmlValue)



# 12.2 中文文本处理 =====================================================

## 12.2.1 文本处理 ==================================

### 12.2.1.1 字符串的操作

#### 获取字符串长度
# nchar():获取字符串的长度，支持字符串向量操作， 和length有区别
fruit <- 'apple orange grape banana'
nchar(fruit)
length(fruit)

#### 字符串分割
# strsplit():把字符串按照某种分割形式进行划分，需设定分割符；
x <- strsplit(fruit, split = ' ')
x
str(x)

#### 字符串拼接
# paste():将多个字符串拼接起来，需设置分割符
fruitvec <- unlist(strsplit(fruit, split = ' '))
x <- paste(fruitvec, collapse = ',')
x
str(x)
# paste0():将多个字符串拼接起来
x = paste0(fruitvec, collapse = ';')
x
str(x)

#### 字符串截取
# substr():对给定的字符串取子集，设定开始和结束位置
x <- substr(fruit, 1, 5)  # 从1开始，包括5
x

#### stringr包和正则表达式(随后详解)
library(stringr)
strurl <- 'http://movie.douban.com/top250'
web <- readLines(strurl, encoding = 'UTF-8')
str(web)
movienum <- web[grep('<span class="title">', web) + 1]
str(movienum)
moviename <- str_extract(movienum, regex("(?<=&nbsp;).*(?=</span>)"))
head(moviename)

### 12.2.1.2 区域设置和字符编码 ------------
# 将区域设置成中文
Sys.setlocale('LC_ALL', 'Chinese')
# 查看目前设置的区域：
Sys.setlocale('LC_CTYPE')
# 编码问题；utf-8,GBK,encoding,iconv
x <- '我是中国人'
x
Encoding(x) <- 'utf-8'
x

### 12.2.1.3 tmcn包简介 ------------

## 12.2.3 中文分词 ============================








