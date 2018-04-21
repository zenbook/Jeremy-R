liandai<-function(order,item,volume,amount){
  require(dplyr)
  df<-data.frame(order,item,volume,amount)
  jr<-df%>%
    group_by(order)%>%
    mutate(连带销量=sum(volume),连带销额=sum(amount),客流量=1)%>%
    group_by(item)%>%
    summarize(连带销量=sum(连带销量),连带销额=sum(连带销额),客流量=sum(客流量))%>%
    mutate(连带率=连带销量/客流量,客流量=NULL)
  return(jr)
}
# 把函数程序脚本放到f盘某个文件夹下，使用时只要加载一下这个函数即可
source("f:/myfunction/myfunction.R")
# 计算商品连带指标，用dat变量接收结果
dat<-liandai(data$order,data$item,data$volume,data$amount)