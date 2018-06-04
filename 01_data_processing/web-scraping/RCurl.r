
library(XML)
library(RCurl)

url <-"http://brand.efu.com.cn/list-1-9-52-0-440000-0-1.html"  
web <-getURL(url)  

doc <- htmlParse(web, encoding = 'gbk')
doc
