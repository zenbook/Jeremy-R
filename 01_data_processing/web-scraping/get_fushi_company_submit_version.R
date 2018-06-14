
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
level_id1 <- 4
level_name1 <- '服饰'
level_id2 <- 27:35
level_name2 <- c('珠宝首饰','腕表眼镜','时尚饰品','箱包','皮具','围巾丝巾','领带领结','袜子','帽子手套')
## 省份信息
province_id <- c('440000','330000','110000','310000','320000','350000','370000','130000','410000','210000',
                 '120000','510000','340000','420000','500000','430000','810000','710000','820000','650000',
                 '540000','150000','630000','640000','620000','610000','530000','520000','450000','360000',
                 '220000','140000','230000','460000')
province_name <- c('广东','浙江','北京','上海','江苏','福建','山东','河北','河南','辽宁','天津','四川',
                   '安徽','湖北','重庆','湖南','香港','台湾','澳门','新疆','西藏','内蒙古','青海','宁夏',
                   '甘肃','陕西','云南','贵州','广西','江西','吉林','山西','黑龙江','海南')
## 页码设置最多为10
page_num <- 1:10

# 编写get_apparel()函数 =================================================
## 传入参数：
### 1. level_id1
### 2. level_id2
### 4. province_id
### 5. page_num
get_apparel <- function(level_id1, level_id2, province_id, page_num){
  baseurl <- 'http://brand.efu.com.cn/list'
  url <- paste(baseurl, level_id1, level_id2, 0, 0, province_id, 0, page_num, sep = '-')
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

## 创建一个空数据框
apparel_company_list <- data.frame(t(rep(NA,14)))[-1,]
names(apparel_company_list) <- c('brand_name', 'company_name', 'company_intro', 'address', 'telephone', 
                                 'level_id1', 'level_name1', 'level_id2', 'level_name2', 'level_id3', 
                                 'level_name3', 'province_id', 'province_name', 'page_num')

for (i in 1:length(level_id2)){
  for (j in 1:length(province_id)) {
    for (k in page_num){
      company_info <- get_apparel(level_id1, level_id2[i], province_id[j], page_num[k])
      ## 判断数据框是否为空，如果为空，字段值也为空
      if (!empty(company_info)){
        ## 加上分类和省份
        company_info$level_id1 <- level_id1
        company_info$level_name1 <- level_name1
        company_info$level_id2 <- level_id2[i]
        company_info$level_name2 <- level_name2[i]
        company_info$level_id3 <- ""
        company_info$level_name3 <- ""
        company_info$province_id <- province_id[j]
        company_info$province_name <- province_name[j]
        company_info$page_num <- page_num[k]
      }
      apparel_company_list <- rbind(apparel_company_list, company_info)
    }
  }
}

"服饰类：爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './fushi_company_list.csv',
          row.names = FALSE)

"服饰类：导出成功！"

