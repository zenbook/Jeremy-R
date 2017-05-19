
# 1.加载包
require("RCurl")
require("XML")
setwd("F:\\百度云同步盘\\Data Science\\MY\\赣州房价分析")

# 2.先读取单个页面
## （1）伪装报头
myheader=c(
  "User-Agent"="Mozilla/5.0(Windows;U;Windows NT 5.1;zh-CN;rv:1.9.1.6",
  "Accept"="text/htmal,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
  "Accept-Language"="en-us",
  "Connection"="keep-alive",
  "Accept-Charset"="GB2312,utf-8;q=0.7,*;q=0.7"
)
## （2）获取页面代码
url <- c("http://newhouse.ganzhou.fang.com/house/s/")
temp <- getURL(url, httpheader=myheader, encoding="GBK")
temp <- htmlParse(temp)  #解析网页
getNodeSet(temp, '//div[contains(@class,"goods")]')

//div[@class=\"clearfix"]

#地址
getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="goods-place"]//text()')
#团购名字
getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-name"]//text()')
#团购介绍
getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-text"]//text()')
#团购价
getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="price"]/text()')
#原价
getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="money"]/del/text()')
#已售
getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="number"]/i/text()')



fang1 <- getURI(url, encoding = "gbk")
fang2 <- htmlParse(fang1)
fang3 <- getNodeSet(fang2, '//div[@class=\"clearfix"]')
fang4 <- sapply(fang3, xmlValue) 
fang5 <- unlist(fang4)
fang6 <- as.data.frame(fang5)




#组装成function

table<-function(temp){
  k<-htmlParse(temp)
  address<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="goods-place"]//text()'),xmlValue)
  name<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-name"]//text()'),xmlValue)
  text<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-text"]//text()'),xmlValue)
  price<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="price"]/text()'),xmlValue)
  money<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="money"]/del/text()'),xmlValue)
  sold<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="number"]/i/text()'),xmlValue)
  tablea<-data.frame(name,text,address,price,money,sold)
}

#总共10页内容，生成urllist

urllist<-0
page<-1:10
urllist[page]<-paste0("http://hangzhou.lashou.com/cate/xiuxianyule/page",page,seq="") #用paste0中间就不会有空格了
urllist

#测试读取1个页面的内容

data1<-table(temp)

head(data1)

#循环读取全部页面

for (url in urllist){
  temp<-getURL(url,httpheader=myheader,encoding="UTF-8")
  data2<-table(temp)
  data1<-rbind(data1,data2)
}

## Error in data.frame(name, text, address, price, money, sold) : 
##  arguments imply differing number of rows: 60, 39
## Called from: top level 
#执行循环时报错了，经检查发现，有些团购中的没有【已售sold】这个一数据的，导致数据框拼合的时候出错。
#但是我又不晓得怎么让数据框自动填充NA，所以只好把【已售sold】这个字段先去掉了=_=

table<-function(temp){
  k<-htmlParse(temp)
  address<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="goods-place"]//text()'),xmlValue)
  name<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-name"]//text()'),xmlValue)
  text<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//a[@class="goods-text"]//text()'),xmlValue)
  price<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="price"]/text()'),xmlValue)
  money<-sapply(getNodeSet(k,'//div[contains(@class,"goods")]//span[@class="money"]/del/text()'),xmlValue)
  tablea<-data.frame(name,text,address,price,money)
}



data1<-table(temp)

for (url in urllist){
  temp<-getURL(url,httpheader=myheader,encoding="UTF-8")
  data2<-table(temp)
  data1<-rbind(data1,data2)
}
#还是有报错，目测是【地址address】有缺失，唉，拉手太不靠谱了，地址都缺还玩什么呢？难怪做不好，呼...

#导出团购信息文件
write.csv(data1,"tuangou.csv")


























