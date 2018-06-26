
# 加载包 ================================================================
library(rvest)
library(plyr)
library(tidyverse)

# url %>% 
#   read_html(encoding = 'GBK') %>% 
#   html_nodes("div.brand") %>% 
#   html_text() %>% 
#   str_replace_all("\r\n                    \r\n", "\t") %>% 
#   str_replace_all(" ", "") %>% 
#   str_replace_all("\r\n行业类别：", "") %>%
#   str_replace_all("\r\n人气：", "\t") %>%
#   str_replace_all("地区：", "\t") %>%
#   str_replace_all("\r\n", "\t") %>% 
#   str_split("\t")
#   
# url %>% 
#   read_html(encoding = 'GBK') %>% 
#   html_nodes("div.brand") %>% 


# 设置参数 ==============================================================
base_url <- "http://www.chinasspp.com/brand"
level_id <- c("%E6%9C%8D%E8%A3%85%E5%93%81%E7%89%8C", 
              "%E9%9E%8B%E4%B8%9A%E5%93%81%E7%89%8C", 
              "%E7%9A%AE%E5%85%B7%E7%AE%B1%E5%8C%85", 
              "%E6%AF%8D%E5%A9%B4", 
              "%E9%85%8D%E9%A5%B0", 
              "%E5%AE%B6%E7%BA%BA%E5%AE%B6%E9%A5%B0")
level_name <- c("服装品牌","鞋业品牌","皮具箱包","母婴","配饰","家纺家饰")
level_page <- c(898, 94, 71, 149, 113, 46)

# url <- paste(base_url, level_id[1], 898, "", sep = '/')

## url <- paste(base_url, level_id[1], level_page[1], "", sep = '/')

# 编写get_apparel()函数 =================================================
## 传入参数：
### 1. level_id
### 2. level_page

get_apparel <- function(level_id, level_page){
  
  ## url
  url <- paste(base_url, level_id, level_page, "", sep = '/')
  
  ## 二级三级分类
  level_23 <- url %>% 
    read_html(encoding = 'GBK') %>% 
    html_nodes("p.first span") %>% 
    html_text() %>% 
    str_replace_all("行业类别：", "") %>% 
    str_replace_all(" - ", "\t") %>% 
    str_split("\t")
  ### 判断list是否为空，如果不为空，则转换为数据框，如果为空，转换成空数据框
  if (length(level_23) >= 1){
    level_23 <- unlist(level_23) %>% 
      matrix(ncol = 2, byrow = TRUE) %>% 
      data.frame(stringsAsFactors = FALSE)
    ## 重命名列名称
    names(level_23) <- c('level_name_2', 'level_name_3')
  } else {
    ## 为空时，直接生成2列的数据框
    level_23 <- data.frame(t(rep(NA,2)))[-1,]
    ## 重命名列名称
    names(level_23) <- c('level_name_2', 'level_name_3')
  }
  
  ## 品牌名称
  brand_name <- url %>% 
    read_html(encoding = 'GBK') %>% 
    html_nodes("p.first a") %>% 
    html_text()
  brand_name <- unlist(brand_name) %>% 
    matrix(ncol = 1, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  names(brand_name) <- 'brand_name'
  
  ## 公司名称
  company_name <- data.frame(t(rep(NA,1)))[-1,]
  for (i in 2:21) {
    xpath <- paste('//*[@id="container"]/div[1]/div[', 
                   i, 
                   "]/p[1]/text()")
    company <- url %>% 
      read_html(encoding = 'GBK') %>% 
      xml_nodes(xpath = xpath) %>% 
      html_text() %>% 
      str_replace_all("\r\n", "") %>% 
      str_replace_all(" ", "")
    company <- company[3]
    company_name <- rbind(company_name, company)
  }
  company_name <- data.frame(company_name)
  company_name <- company_name %>% 
    filter(!is.na(company_name))
  
  ## 公司介绍
  company_intro <- data.frame(t(rep(NA,1)))[-1,]
  for (i in 2:21) {
    xpath <- paste('//*[@id="container"]/div[1]/div[', 
                   i, 
                   "]/p[2]/text()")
    company <- url %>% 
      read_html(encoding = 'GBK') %>% 
      xml_nodes(xpath = xpath) %>% 
      html_text()
    company_intro <- rbind(company_intro, company)
  }
  company_intro <- data.frame(company_intro)
  
  ## 公司地区和人气
  company_addr <- url %>% 
    read_html(encoding = 'GBK') %>% 
    html_nodes("p.last") %>% 
    html_text() %>% 
    str_replace_all("人气：", "") %>% 
    str_replace_all("地区：", "\t") %>% 
    str_split("\t")
  ### 判断list是否为空，如果不为空，则转换为数据框，如果为空，转换成空数据框
  if (length(company_addr) >= 1){
    company_addr <- unlist(company_addr) %>% 
      matrix(ncol = 2, byrow = TRUE) %>% 
      data.frame(stringsAsFactors = FALSE)
    ## 重命名列名称
    names(company_addr) <- c('renqi', 'address')
  } else {
    ## 为空时，直接生成2列的数据框
    company_addr <- data.frame(t(rep(NA,2)))[-1,]
    ## 重命名列名称
    names(company_addr) <- c('renqi', 'address')
  }
  
  ## 合并成data.frame
  company_info <- cbind(level_23, brand_name, company_name, company_intro, company_addr)
  
  ## 返回数据
  return(company_info)
}


# 利用get_apparel()函数，循环爬取数据 ===================================

## 创建一个空数据框
apparel_company_list <- data.frame(t(rep(NA,8)))[-1,]
names(apparel_company_list) <- c('level_name_2', 'level_name_3', 'brand_name', 'company_name', 'company_intro', 
                                 'renqi', 'address', 'page_num')

## 循环爬取数据
for (i in 1:length(level_id)){
  for (j in 234:level_page[i]) {
    
    ## 爬数据
    company_info <- get_apparel(level_id[i], j)
    company_info$page_num <- j
    apparel_company_list <- rbind(apparel_company_list, company_info)
    
    ## 每页休息5秒钟
    Sys.sleep(5)
  }
}

"爬取成功！"

# 写出到csv文件中 ========================================================
write.csv(apparel_company_list, 
          file = './apparel_company_list_sspp.csv',
          row.names = FALSE)

"导出成功！"

str(apparel_company_list)

max(apparel_company_list$page_num)

