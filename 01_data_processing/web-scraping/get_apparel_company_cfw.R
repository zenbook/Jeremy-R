
# 加载包 ================================================================
library(rvest)
library(plyr)
library(tidyverse)


# 设置参数 ==============================================================
## 1. page_num
## 2. base_url
page_num <- 1:513
base_url <- "http://www.cfw.cn/company/0-10-"

url <- "http://www.cfw.cn/company/0-10-1.html"
company_name <- url %>% 
  read_html(encoding = 'utf-8') %>% 
  html_nodes("div.cb_intro_tit") %>% 
  html_nodes('a') %>% 
  html_text()


# 编写get_apparel()函数 =================================================
## 传入参数：
### 1. page_num
get_apparel <- function(page_num){
  url <- paste(baseurl, page_num, '.html', sep = '')
  ## 解析公司信息
  ### 公司名称
  company_name <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes("div.cb_intro_tit") %>% 
    html_nodes('a') %>% 
    html_text()
  ### 公司地址
  company_location <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes("span.location") %>% 
    html_text()
  ### 公司规模
  company_size <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes("") %>% 
    html_text() %>% 
    str_replace_all("公司规模：", "")
  ### 公司性质
  company_nature <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    xml_nodes(xpath = "/html/body/div/div[2]/div/div/div/div[3]/div[1]/div[2]/div/div[2]/span[2]") %>% 
    str_replace_all("企业性质：", "") %>% 
    html_text()
  
  
  
  
  company_info <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes('div.company_block_clearfix') %>% 
    html_text()
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
