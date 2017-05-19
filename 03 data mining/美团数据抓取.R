library(XML)

giveNames = function(rootNode){
  names <- xpathSApply(rootNode,"//h3/a[@class='goods-name']",xmlValue)
  names
}

givesevices = function(rootNode){
  sevices <- xpathSApply(rootNode,"//h3/a[@class='goods-text']",xmlValue)
  sevices
}


giveprices = function(rootNode){
  prices <- xpathSApply(rootNode,"//div/span[@class='price']",xmlValue)
  prices
}


givemoney = function(rootNode){
  money <- xpathSApply(rootNode,"//div/span[@class='money']",xmlValue)
  money
}


giveplaces = function(rootNode){
  places <- xpathSApply(rootNode,"//a/span[@class='goods-place']",xmlValue)
  places
}


getmeituan = function(URL){
  Sys.sleep(runif(1,1,2))
  doc<-htmlParse(URL[1],encoding="UTF-8")
  rootNode<-xmlRoot(doc)
  data.frame(
    Names=giveNames(rootNode), #店名
    services=givesevices(rootNode), #服务
    prices=giveprices(rootNode),  #现价
    money=givemoney(rootNode),  #原价
    places=giveplaces(rootNode)  #地点
    
  )
}


URL = paste0("http://shenzhen.lashou.com/cate/meishi/page",1:5)

mainfunction = function(URL){
  data = rbind(
    getmeituan (URL[1]),
    getmeituan (URL[2]),
    getmeituan (URL[3]),
    getmeituan (URL[4]),
    getmeituan (URL[5])
  )
  
  
}
ll=mainfunction(URL)
write.table(ll,"result.txt",row.names=FALSE)
