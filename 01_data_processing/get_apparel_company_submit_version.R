
# 加载包 ================================================================
library(rvest)
library(plyr)
library(tidyverse)


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
province_id <- c('440000','330000','110000','310000','320000','350000','370000','130000','410000','210000',
                 '120000','510000','340000','420000','500000','430000','810000','710000','820000','650000',
                 '540000','150000','630000','640000','620000','610000','530000','520000','450000','360000',
                 '220000','140000','230000','460000')
province_name <- c('广东','浙江','北京','上海','江苏','福建','山东','河北','河南','辽宁','天津','四川',
                   '安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古','青海','宁夏',
                   '甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')
## 省份信息-广东和浙江
province_id_1 <- c('440000','330000')
province_name_1 <- c('广东','浙江')
## 省份信息-非广东和浙江
province_id_2 <- c('110000','310000','320000','350000','370000','130000','410000','210000','120000','510000',
                   '340000','420000','500000','430000','810000','710000','820000','650000','540000','150000',
                   '630000','640000','620000','610000','530000','520000','450000','360000','220000','140000',
                   '230000','460000')
province_name_2 <- c('北京','上海','江苏','福建','山东','河北','河南','辽宁','天津','四川',
                   '安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古','青海','宁夏',
                   '甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')


## 页码设置最多为44，应该够用了，目前最多页数的是广东女装中的时尚女装，44页
page_num_1 <- 1:44
page_num_2 <- 1:15

# 编写get_apparel()函数 =================================================
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
    str_replace_all('\uFEFF', "") %>% 
    str_replace_all("\r\n", "") %>% 
    str_replace_all(' ', '') %>% 
    str_replace('口碑关注\t所属企业：', '\t') %>% 
    str_replace('品牌简介：\t【详情】', '\t') %>% 
    str_replace('所在地区：', '') %>% 
    str_replace('联系电话：', '\t') %>% 
    str_replace('在线留言', '') %>% 
    str_replace('\t\t', '\t') %>% 
    str_split('\t')
  ## 判断list是否为空，如果不为空，则转换为数据框，如果为空，转换成空数据框
  if (length(company_info) >= 1){
    company_info <- unlist(company_info) %>% 
      matrix(ncol = 5, byrow = TRUE) %>% 
      data.frame(stringsAsFactors = FALSE)
    ## 重命名列名称
    names(company_info) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone')
  } else {
    ## 为空时，直接生成14列的数据框
    company_info <- data.frame(t(rep(NA,14)))[-1,]
    ## 重命名列名称
    names(company_info) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone', 
                             'level_id1', 'level_name1', 'level_id2', 'level_name2', 'level_id3', 
                             'level_name3', 'province_id', 'province_name', 'page_num')
  }
  ## 返回数据
  return(company_info)
}


# 利用get_apparel()函数，编写循环语句 ===================================

## 循环爬取女装公司： ===================================================
### level_id2 = level_id2[1]
### level_name2 = level_name2[1]
### level_id3 = level_id3_9
### level_name3 = level_name3_9

### 女装1：广东和浙江
### page_num_1
### province_id_1
### province_name_1

## 创建一个空数据框
apparel_company_list <- data.frame(t(rep(NA,14)))[-1,]
names(apparel_company_list) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone', 
                                 'level_id1', 'level_name1', 'level_id2', 'level_name2', 'level_id3', 
                                 'level_name3', 'province_id', 'province_name', 'page_num')

for (i in 1:length(level_id3_9)){
  for (j in 1:length(province_id_1)) {
    for (k in page_num_1){
      company_info <- get_apparel(level_id1, level_id2[1], level_id3_9[i], province_id_1[j], page_num_1[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[1]
        company_info$level_name2 <- level_name2[1]
        company_info$level_id3 <- level_id3_9[i]
        company_info$level_name3 <- level_name3_9[i]
        company_info$province_id <- province_id_1[j]
        company_info$province_name <- province_name_1[j]
        company_info$page_num <- page_num_1[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"女装1-广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"女装1-广东浙江：导出成功！"

### 女装2：非广东和浙江
### page_num_2
### province_id_2
### province_name_2

for (i in 1:length(level_id3_9)){
  for (j in 1:length(province_id_2)) {
    for (k in page_num_2){
      company_info <- get_apparel(level_id1, level_id2[1], level_id3_9[i], province_id_2[j], page_num_2[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[1]
        company_info$level_name2 <- level_name2[1]
        company_info$level_id3 <- level_id3_9[i]
        company_info$level_name3 <- level_name3_9[i]
        company_info$province_id <- province_id_2[j]
        company_info$province_name <- province_name_2[j]
        company_info$page_num <- page_num_2[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"女装2-非广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"女装2-非广东浙江：导出成功！"

## 循环爬取男装公司： ===================================================
### level_id2 = level_id2[2]
### level_name2 = level_name2[2]
### level_id3 = level_id3_10
### level_name3 = level_name3_10

### 男装1：广东和浙江
### page_num_1
### province_id_1
### province_name_1

for (i in 1:length(level_id3_10)){
  for (j in 1:length(province_id_1)) {
    for (k in page_num_1){
      company_info <- get_apparel(level_id1, level_id2[2], level_id3_10[i], province_id_1[j], page_num_1[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[2]
        company_info$level_name2 <- level_name2[2]
        company_info$level_id3 <- level_id3_10[i]
        company_info$level_name3 <- level_name3_10[i]
        company_info$province_id <- province_id_1[j]
        company_info$province_name <- province_name_1[j]
        company_info$page_num <- page_num_1[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"男装1-广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"男装1-广东浙江：导出成功！"

### 男装2：非广东和浙江
### page_num_2
### province_id_2
### province_name_2

for (i in 1:length(level_id3_10)){
  for (j in 1:length(province_id_2)) {
    for (k in page_num_2){
      company_info <- get_apparel(level_id1, level_id2[2], level_id3_10[i], province_id_2[j], page_num_2[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[2]
        company_info$level_name2 <- level_name2[2]
        company_info$level_id3 <- level_id3_10[i]
        company_info$level_name3 <- level_name3_10[i]
        company_info$province_id <- province_id_2[j]
        company_info$province_name <- province_name_2[j]
        company_info$page_num <- page_num_2[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"男装2-非广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"男装2-非广东浙江：导出成功！"


## 循环爬取童装公司： ===================================================
### level_id2 = level_id2[3]
### level_name2 = level_name2[3]
### level_id3 = level_id3_11
### level_name3 = level_name3_11

### 童装1：广东和浙江
### page_num_1
### province_id_1
### province_name_1

for (i in 1:length(level_id3_11)){
  for (j in 1:length(province_id_1)) {
    for (k in page_num_1){
      company_info <- get_apparel(level_id1, level_id2[3], level_id3_11[i], province_id_1[j], page_num_1[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[3]
        company_info$level_name2 <- level_name2[3]
        company_info$level_id3 <- level_id3_11[i]
        company_info$level_name3 <- level_name3_11[i]
        company_info$province_id <- province_id_1[j]
        company_info$province_name <- province_name_1[j]
        company_info$page_num <- page_num_1[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"童装1-广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"童装1-广东浙江：导出成功！"

### 童装2：非广东和浙江
### page_num_2
### province_id_2
### province_name_2

for (i in 1:length(level_id3_11)){
  for (j in 1:length(province_id_2)) {
    for (k in page_num_2){
      company_info <- get_apparel(level_id1, level_id2[3], level_id3_11[i], province_id_2[j], page_num_2[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[3]
        company_info$level_name2 <- level_name2[3]
        company_info$level_id3 <- level_id3_11[i]
        company_info$level_name3 <- level_name3_11[i]
        company_info$province_id <- province_id_2[j]
        company_info$province_name <- province_name_2[j]
        company_info$page_num <- page_num_2[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"童装2-非广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"童装2-非广东浙江：导出成功！"

## 循环爬取内衣公司： ===================================================
### level_id2 = level_id2[4]
### level_name2 = level_name2[4]
### level_id3 = level_id3_12
### level_name3 = level_name3_12

### 内衣1：广东和浙江
### page_num_1
### province_id_1
### province_name_1

for (i in 1:length(level_id3_12)){
  for (j in 1:length(province_id_1)) {
    for (k in page_num_1){
      company_info <- get_apparel(level_id1, level_id2[4], level_id3_12[i], province_id_1[j], page_num_1[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[4]
        company_info$level_name2 <- level_name2[4]
        company_info$level_id3 <- level_id3_12[i]
        company_info$level_name3 <- level_name3_12[i]
        company_info$province_id <- province_id_1[j]
        company_info$province_name <- province_name_1[j]
        company_info$page_num <- page_num_1[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"内衣1-广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"内衣1-广东浙江：导出成功！"

### 内衣2：非广东和浙江
### page_num_2
### province_id_2
### province_name_2

for (i in 1:length(level_id3_12)){
  for (j in 1:length(province_id_2)) {
    for (k in page_num_2){
      company_info <- get_apparel(level_id1, level_id2[4], level_id3_12[i], province_id_2[j], page_num_2[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[4]
        company_info$level_name2 <- level_name2[4]
        company_info$level_id3 <- level_id3_12[i]
        company_info$level_name3 <- level_name3_12[i]
        company_info$province_id <- province_id_2[j]
        company_info$province_name <- province_name_2[j]
        company_info$page_num <- page_num_2[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"内衣2-非广东浙江：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"内衣2-非广东浙江：导出成功！"

## 后续品类的页数较少，重置页面
page_num <- 1:10

## 循环爬取休闲装公司： ===================================================
### level_id2 = level_id2[5]
### level_name2 = level_name2[5]
### level_id3 = level_id3_13
### level_name3 = level_name3_13
for (i in 1:length(level_id3_13)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[5], level_id3_13[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[5]
        company_info$level_name2 <- level_name2[5]
        company_info$level_id3 <- level_id3_13[i]
        company_info$level_name3 <- level_name3_13[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"休闲装：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"休闲装：导出成功！"

## 循环爬取运动装公司： ===================================================
### level_id2 = level_id2[6]
### level_name2 = level_name2[6]
### level_id3 = level_id3_14
### level_name3 = level_name3_14
for (i in 1:length(level_id3_14)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[6], level_id3_14[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[6]
        company_info$level_name2 <- level_name2[6]
        company_info$level_id3 <- level_id3_14[i]
        company_info$level_name3 <- level_name3_14[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"运动装：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"运动装：导出成功！"

## 循环爬取皮革皮草公司： ===================================================
### level_id2 = level_id2[7]
### level_name2 = level_name2[7]
### level_id3 = level_id3_15
### level_name3 = level_name3_15
for (i in 1:length(level_id3_15)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[7], level_id3_15[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[7]
        company_info$level_name2 <- level_name2[7]
        company_info$level_id3 <- level_id3_15[i]
        company_info$level_name3 <- level_name3_15[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"皮革皮草：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"皮革皮草：导出成功！"

## 循环爬取针织毛衫公司： ===================================================
### level_id2 = level_id2[8]
### level_name2 = level_name2[8]
### level_id3 = level_id3_16
### level_name3 = level_name3_16
for (i in 1:length(level_id3_16)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[8], level_id3_16[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[8]
        company_info$level_name2 <- level_name2[8]
        company_info$level_id3 <- level_id3_16[i]
        company_info$level_name3 <- level_name3_16[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"针织毛衫：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"针织毛衫：导出成功！"

## 循环爬取羽绒服公司： ===================================================
### level_id2 = level_id2[9]
### level_name2 = level_name2[9]
### level_id3 = level_id3_17
### level_name3 = level_name3_17
for (i in 1:length(level_id3_17)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[9], level_id3_17[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[9]
        company_info$level_name2 <- level_name2[9]
        company_info$level_id3 <- level_id3_17[i]
        company_info$level_name3 <- level_name3_17[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"羽绒服：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"羽绒服：导出成功！"

## 循环爬取鞋业公司： ===================================================
### level_id2 = level_id2[10]
### level_name2 = level_name2[10]
### level_id3 = level_id3_18
### level_name3 = level_name3_18
for (i in 1:length(level_id3_18)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[10], level_id3_18[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[10]
        company_info$level_name2 <- level_name2[10]
        company_info$level_id3 <- level_id3_18[i]
        company_info$level_name3 <- level_name3_18[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"鞋业：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"鞋业：导出成功！"

## 循环爬取职业装公司： ===================================================
### level_id2 = level_id2[11]
### level_name2 = level_name2[11]
### level_id3 = level_id3_19
### level_name3 = level_name3_19
for (i in 1:length(level_id3_19)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[11], level_id3_19[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[11]
        company_info$level_name2 <- level_name2[11]
        company_info$level_id3 <- level_id3_19[i]
        company_info$level_name3 <- level_name3_19[i]
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"职业装：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list.csv',
          row.names = FALSE)

"职业装：导出成功！"

"全部服装类目导出成功！！！"
