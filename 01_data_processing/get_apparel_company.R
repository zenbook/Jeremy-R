
# 网页信息说明 ==========================================================
# http://brand_name.efu.com.cn/list-0-0-0-0-0-0-1.html
## list-0-0-0-0-0-0-1：不限所有的分组，即所有品牌，最后的数字1代表页码；
## 第一位编码：一级分类
### 0-不限，1-服装，2-服装面料，3-服装辅料，4-服饰，5-家纺，6-机械设备，8-服务机构
## c(1,2,3,4,5,6,8)
level_id1 <- 1
level_name1 <- '服装'
## 第二位编码：二级分类
## 服装下的二级分类是：
## 9-女装，10-男装，11-童装，12-内衣，13-休闲装，14-运动装，15-皮革皮草，16-针织毛衫，17-羽绒服，18-鞋业，19-职业装
level_id2 <- 9:19
level_name2 <- c('女装','男装','童装','内衣','休闲装','运动装','皮革皮草','针织毛衫','羽绒服','鞋业','职业装')
## 第三位编码：三级分类：
## 女装
level_id3 <- c(52,53,54,55,56,57,81,82,83)
level_name3 <- c('少淑女装','时尚女装','孕妇装','女裤','婚纱礼服','唐装旗袍','韩版女装','折扣女装','欧美女装')
## 男装：58-正装，59-商务休闲，84-商务装
level_id3 <- c(58, 59, 84)
level_name3 <- c('正装', '商务休闲', '商务装')
## 童装
level_id3 <- c(60,61,62,63,64,85,86,87)
level_name3 <- c('婴幼装','童装4-12岁','少年装13-17岁','童鞋','婴幼用品','时尚童装','韩版童装','亲子装')
## 第四位编码：0-所有品牌，3-名品（奢侈品牌）
## 第五位编码：省份编码
## 第六位编码：城市编码
province_id <- c('440000','330000','110000','310000','320000','350000','370000','130000','410000','210000','120000','510000'
                 ,'340000','420000','500000','430000','810000','710000','820000','650000','540000','150000','630000','640000'
                 ,'620000','610000','530000','520000','450000','360000','220000','140000','230000','460000')
province_name <- c('广东','浙江','北京','上海','江苏','福建','山东','河北','河南','辽宁','天津','四川',
                   '安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古','青海','宁夏',
                   '甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')

# 加载包 ================================================================
library(rvest)
library(tidyverse)
library(plyr)

# 设置参数 ==============================================================
## 1. level_id1
## 2. level_id2
## 3. level_id3
## 4. province_id
## 5. page_num
level_id1 <- 1
level_name1 <- '服装'
level_id2 <- 9:19
level_name2 <- c('女装','男装','童装','内衣','休闲装','运动装','皮革皮草','针织毛衫','羽绒服','鞋业','职业装')
### 女装的三级分类id和名称
level_id3_9 <- c(52,53,54,55,56,57,81,82,83)
level_name3_9 <- c('少淑女装','时尚女装','孕妇装','女裤','婚纱礼服','唐装旗袍','韩版女装','折扣女装','欧美女装')
### 男装的三级分类id和名称
level_id3_10 <- c(58, 59, 84)
level_name3_10 <- c('正装', '商务休闲', '商务装')
### 童装的三级分类id和名称
level_id3_11 <- c(60,61,62,63,64,85,86,87)
level_name3_11 <- c('婴幼装','童装4-12岁','少年装13-17岁','童鞋','婴幼用品','时尚童装','韩版童装','亲子装')
### 内衣的三级分类id和名称
level_id3_12 <- c(65,66,67,68,69,70,71)
level_name3_12 <- c('女士内衣','男士内衣','保暖内衣','塑身美体','家居服','泳装','情趣内衣')
### 休闲装的三级分类id和名称
level_id3_13 <- c(72,73,74,88)
level_name3_13 <- c('潮牌','休闲装','牛仔装','户外服装')
### 运动装的三级分类id和名称
level_id3_14 <- c(75,76)
level_name3_14 <- c('运动装','户外运动')
### 皮革皮草的三级分类id和名称
level_id3_15 <- c(89, 90)
level_name3_15 <- c('皮衣', '皮草')
### 针织毛衫的三级分类id和名称
level_id3_16 <- 0
level_name3_16 <- '针织毛衫'
### 羽绒服的三级分类id和名称
level_id3_17 <- 0
level_name3_17 <- '羽绒服'
### 鞋业的三级分类id和名称
level_id3_18 <- c(77,78,79)
level_name3_18 <- c('男鞋','女鞋','休闲鞋')
### 职业装的三级分类id和名称
level_id3_19 <- 0
level_name3_19 <- '职业装'
## 省份信息
province_id <- c(440000,330000,110000,310000,320000,350000,370000,130000,410000,210000,120000,510000,
                 340000,420000,500000,430000,810000,710000,820000,650000,540000,150000,630000,640000,
                 620000,610000,530000,520000,450000,360000,220000,140000,230000,460000)
province_name <- c('广东','浙江','北京','上海','江苏','福建','山东','河北','河南','辽宁','天津','四川',
                   '安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古','青海','宁夏',
                   '甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')
## 页码设置最多为50，应该够用了
page_num <- c(1:50)

## 创建一个空数据框
company_dataset <- data.frame(t(rep(NA,13)))[-1,]
names(company_dataset) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone', 'level_id1', 'level_name1', 
                            'level_id2', 'level_name2', 'level_id3', 'level_name3', 'province_id', 'province_name')

# 1. 方法1 不编写函数 ===================================================

baseurl <- 'http://brand.efu.com.cn/list'
url <- paste(baseurl, level_id1, level_id2[2], level_id3[1], 0, province_id[1], 0, page_num[100], sep = '-')
url <- paste(url, '.html', sep = '')

## 解析公司信息
company_info <- url %>% 
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
## 判断list是否为空，如果不为空，则转换为数据框
if (length(company_info) >= 1){
  ## 转成dataframe
  company_info <- unlist(company_info) %>% 
    matrix(ncol = 5, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
} else {
  company_info <- data.frame(t(rep(NA,5)))[-1,]
}
## 重命名列名称
names(company_info) <- c('brand_name', 'company_info', 'company_intro', 'address', 'telephone')
## 判断数据框是否为空，如果为空，字段值也为空
if (empty(company_info)){
  ## 加上分类和省份
  company_info$level_id1 <- NA
  company_info$level_name1 <- NA
  company_info$level_id2 <- NA
  company_info$level_name2 <- NA
  company_info$level_id3 <- NA
  company_info$level_name3 <- NA
  company_info$province_id <- NA
  company_info$province_name <- NA
} else {
  ## 加上分类和省份
  company_info$level_id1 <- level_id1
  company_info$level_name1 <- level_name1
  company_info$level_id2 <- level_id2[2]
  company_info$level_name2 <- level_name2[2]
  company_info$level_id3 <- level_id3[1]
  company_info$level_name3 <- level_name3[1]
  company_info$province_id <- province_id[1]
  company_info$province_name <- province_name[1]
}
## 把爬取的数据汇总到数据框中
company_dataset <- rbind(company_dataset, company_info)
## 查看数据
View(company_dataset)

# 2. 方法2 编写get_apparel()函数 =========================================
## 传入参数：
### 1. level_id1
### 2. level_id2
### 3. level_id3
### 4. province_id
### 5. page_num
get_apparel <- function(level_id1, level_id2, level_id3, province_id, page_num){
  baseurl <- 'http://brand.efu.com.cn/list'
  url <- paste(baseurl, level_id1, level_id2, level_id3, 0, province_id, 0, page_num, sep = '-')
  url <- paste(url, '.html', sep = '')
  ## 解析公司信息
  company_info <- url %>% 
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
  ## 判断list是否为空，如果不为空，则转换为数据框，如果为空，转换成空数据框
  if (length(company_info) >= 1){
    company_info <- unlist(company_info) %>% 
      matrix(ncol = 5, byrow = TRUE) %>% 
      data.frame(stringsAsFactors = FALSE)
    ## 重命名列名称
    names(company_info) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone')
  } else {
    ## 为空时，直接生成13列的数据框
    company_info <- data.frame(t(rep(NA,13)))[-1,]
    ## 重命名列名称
    names(company_info) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone', 'level_id1', 'level_name1', 
                             'level_id2', 'level_name2', 'level_id3', 'level_name3', 'province_id', 'province_name')
  }
  ## 返回数据
  return(company_info)
}
## 利用函数爬取数据
company_info <- get_apparel(1, 10, 58, 440000, 200)
## 判断数据框是否为空，如果为空，字段值也为空
if (!empty(company_info)){
  ## 加上分类和省份
  company_info$level_id1 <- level_id1
  company_info$level_name1 <- level_name1
  company_info$level_id2 <- level_id2[2]
  company_info$level_name2 <- level_name2[2]
  company_info$level_id3 <- level_id3[1]
  company_info$level_name3 <- level_name3[1]
  company_info$province_id <- province_id[1]
  company_info$province_name <- province_name[1]
}
## rbind
company_dataset <- rbind(company_dataset, company_info)
## 查看数据
View(company_dataset)

# 3. 方法3 写循环，批量爬取 ==============================================
## 传入一串页码，批量爬取所有男装数据
pages <- 1:86
baseurl <- 'http://brand.efu.com.cn/list-1-10-0-0-0-0-'
## 创建一个空数据框
company_dataset <- data.frame(t(rep(NA,5)))[-1,]
names(company_dataset) <- c('brand_name', 'company_info', 'company_intro', 'address', 'telephone')
## 循环，爬取公司信息
for (i in pages){
  url <- paste(baseurl, pages[i], '.html', sep = '')
  ### 解析公司信息
  company_info <- url %>% 
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
  company_info <- unlist(company_info) %>% 
    matrix(ncol = 5, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  ### 重命名列名称
  names(company_info) <- c('brand_name', 'company_info', 'company_intro', 'address', 'telephone')
  ## 返回数据
  company_dataset <- rbind(company_dataset, company_info)
}

str(company_dataset)

# 4. 方法4 利用get_apparel()函数和循环 ==================================

## 循环爬取男装公司
for (i in 1:length(level_id3)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[2], level_id3[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[2]
        company_info$level_name2 <- level_name2[2]
        company_info$level_id3 <- level_id3[i]
        company_info$level_name3 <- level_name3[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
      }
      company_dataset <- rbind(company_dataset, company_info)
    }
  }
}


str(company_dataset)
View(company_dataset)


# 5. 先爬取每个三级分类下的页数 ==========================================


url <- 'http://brand.efu.com.cn/list-1-9-52-0-110000-0-1.html'
## 复制xpath
## /html/body/div[1]/div[7]/div/div/div[2]/div[7]

pagenum <- url %>% 
  read_html(encoding = 'utf-8') %>% 
  html_nodes(xpath = "/html/body/div[1]/div[7]/div/div/div[2]/div[7]") %>% 
  html_text()
page_num


## 编写函数get_pagenum()获取三级分类各省份的页数
get_pagenum <- function(level_id1, level_id2, level_id3, province_id, page_num){
  baseurl <- 'http://brand.efu.com.cn/list'
  url <- paste(baseurl, level_id1, level_id2, level_id3, 0, province_id, 0, 1, sep = '-')
  url <- paste(url, '.html', sep = '')
  ## 获取页数
  page_num <- url %>% 
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
}

## 循环爬取男装三级分类下各省份的页数
for (i in 1:length(level_id3_9)){
  for (j in 1:length(province_id)) {
    
  }
}

# 6. 方法5 利用get_apparel()函数、循环，传入上面获取的页数 ===============




