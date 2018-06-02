
# 网页信息说明 ==========================================================
# http://brand.efu.com.cn/list-0-0-0-0-0-0-1.html
## list-0-0-0-0-0-0-1：不限所有的分组，即所有品牌，最后的数字1代表页码；
## 第一位编码：一级分类：0-不限，1-服装，2-服装面料，3-服装辅料，4-服饰，5-家纺，6-机械设备，8-服务机构
## c(1,2,3,4,5,6,8)
level_id1 <- 1
level_name1 <- '服装'
## 第二位编码：二级分类：服装下的二级分类是：
## 9-女装，10-男装，11-童装，12-内衣，13-休闲装，14-运动装，15-皮革皮草，16-针织毛衫，17-羽绒服，18-鞋业，19-职业装
level_id2 <- 9:19
level_name2 <- c('女装','男装','童装','内衣','休闲装','运动装','皮革皮草','针织毛衫','羽绒服','鞋业','职业装')
## 第三位编码：未知
## 第四位编码：0-所有品牌，3-名品（奢侈品牌）
## 第五位编码：省份编码
## 第六位编码：城市编码
province_id <- c(440000,330000,110000,310000,320000,350000,370000,130000,410000,210000,120000,510000,
                 340000,420000,500000,430000,810000,710000,820000,650000,540000,150000,630000,640000,
                 620000,610000,530000,520000,450000,360000,220000,140000,230000,460000)
province_name <- c('广东','浙江','北京','上海','江苏','福建','山东','河北','河南','辽宁','天津',
                   '四川','安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古',
                   '青海','宁夏','甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')

# 加载包 ================================================================
library(rvest)
library(tidyverse)

# 1. 方法1 不编写函数 ===================================================
## 设置参数
baseurl <- 'http://brand.efu.com.cn/list-1-10-0-0-0-0-'
page <- 1
url <- paste(baseurl, page, '.html', sep = '')

## 解析公司信息
apparel_company <- url %>% 
  read_html(encoding = 'utf-8') %>% 
  html_nodes('div.lstPa') %>% 
  html_text() %>% 
  str_replace_all('\uFEFF', '') %>% 
  str_replace_all("\r\n", "") %>% 
  str_replace_all(' ', '') %>% 
  str_replace('口碑关注\t所属企业：', '\t') %>% 
  str_replace('品牌简介：\t【详情】', '\t') %>% 
  str_replace('所在地区：', '') %>% 
  str_replace('联系电话：', '\t') %>% 
  str_replace('在线留言', '') %>% 
  str_split('\t')

## 转成dataframe
apparel_company <- unlist(apparel_company) %>% 
  matrix(ncol = 5, byrow = TRUE) %>% 
  data.frame(stringsAsFactors = FALSE)

## 重命名列名称
names(apparel_company) <- c('brand', 'company', 'description', 'address', 'telephone')

View(apparel_company)

# 2. 方法2 编写get_apparel()函数 =========================================
## 传入参数：
### 1. level_id1
### 2. level_id2
### 3. province_id
### 4. page_id
get_apparel <- function(page){
  baseurl <- 'http://brand.efu.com.cn/list-1-10-0-0-0-0-'
  url <- paste(baseurl, page, '.html', sep = '')
  ## 解析公司信息
  apparel_company <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes('div.lstPa') %>% 
    html_text() %>% 
    str_replace_all('\uFEFF', '') %>% 
    str_replace_all("\r\n", "") %>% 
    str_replace_all(' ', '') %>% 
    str_replace('口碑关注\t所属企业：', '\t') %>% 
    str_replace('品牌简介：\t【详情】', '\t') %>% 
    str_replace('所在地区：', '') %>% 
    str_replace('联系电话：', '\t') %>% 
    str_replace('在线留言', '') %>% 
    str_split('\t')
  ## 转成dataframe
  apparel_company <- unlist(apparel_company) %>% 
    matrix(ncol = 5, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  ## 重命名列名称
  names(apparel_company) <- c('brand', 'company', 'description', 'address', 'telephone')
  ## 返回数据
  return(apparel_company)
}
apparel_company <- get_apparel(2)
View(apparel_company)

# 3. 方法3 写循环，批量爬取 ==============================================
## 传入一串页码，批量爬取所有男装数据
pages <- 1:86
baseurl <- 'http://brand.efu.com.cn/list-1-10-0-0-0-0-'
## 创建一个空数据框
apparel_company <- data.frame(t(rep(NA,5)))[-1,]
names(apparel_company) <- c('brand', 'company', 'description', 'address', 'telephone')
## 循环，爬取公司信息
for (i in pages){
  url <- paste(baseurl, pages[i], '.html', sep = '')
  ### 解析公司信息
  company <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes('div.lstPa') %>% 
    html_text() %>% 
    str_replace_all('\uFEFF', '') %>% 
    str_replace_all("\r\n", "") %>% 
    str_replace_all(' ', '') %>% 
    str_replace('口碑关注\t所属企业：', '\t') %>% 
    str_replace('品牌简介：\t【详情】', '\t') %>% 
    str_replace('所在地区：', '') %>% 
    str_replace('联系电话：', '\t') %>% 
    str_replace('在线留言', '') %>% 
    str_split('\t')
  ## 转成dataframe
  company <- unlist(company) %>% 
    matrix(ncol = 5, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  ### 重命名列名称
  names(company) <- c('brand', 'company', 'description', 'address', 'telephone')
  ## 返回数据
  apparel_company <- rbind(apparel_company, company)
}

str(apparel_company)

# 4. 方法4 利用get_apparel()函数和循环 ==================================
for (i in pages){
  company <- get_apparel(pages[i])
  apparel_company <- rbind(apparel_company, company)
}





