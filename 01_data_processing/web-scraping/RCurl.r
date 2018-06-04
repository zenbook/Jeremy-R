
library(XML)
library(RCurl)

url <-"http://brand.efu.com.cn/list-1-9-52-0-440000-0-1.html"  

url %>% 
  getURL() %>% 
  htmlParse() %>% 
  getNodeSet('/html/body/div[1]/div[7]/div/div/div[2]/div[7]/ul/li[2]/span[1]/i[2]')




