
# 加载包 ================================================================
library(rvest)
library(plyr)
library(tidyverse)

# 设置参数 ==============================================================
## 1. page_num
## 2. base_url
page_num <- 92:514
com_num <- 1:10
base_url <- "http://www.cfw.cn/company/0-10-"
# url <- "http://www.cfw.cn/company/0-10-2.html"

# # 编写get_apparel_intro()函数 ===========================================
# ## 传入参数:i
# get_apparel_intro <- function(i){
#   xpath <- paste("/html/body/div/div[2]/div/div/div/div[3]/div[", 
#                    com_num[i], 
#                    "]/div[2]/p", 
#                    sep = "")
#   company_intro <- url %>% 
#     read_html(encoding = 'utf-8') %>% 
#     xml_nodes(xpath = xpath) %>% 
#     html_text()
#   ## 返回数据
#   return(company_intro)
# }

# 编写get_apparel()函数 =================================================
## 传入参数：
### 1. page_num
get_apparel <- function(page_num){
  url <- paste(base_url, page_num, '.html', sep = '')
  ## 解析公司信息
  ### 公司名称
  company_name <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes("div.cb_intro_tit a") %>% 
    html_text() %>% 
    unlist() %>% 
    matrix(ncol = 1, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  colnames(company_name) <- "company_name"
  ### 公司地址和规模性质等
  company_lacation_size <- url %>% 
    read_html(encoding = 'utf-8') %>% 
    html_nodes("div.cb_intro_tit span") %>% 
    html_text() %>% 
    str_replace_all("公司规模：", "") %>% 
    str_replace_all("企业性质：", "") %>% 
    str_replace_all("所属行业：", "") %>% 
    str_replace_all("省", "") %>% 
    unlist() %>% 
    matrix(ncol = 4, byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  colnames(company_lacation_size) <- c("location", "size", "nature", "business")
  ## 合并得到需要的数据框
  company_info <- cbind(company_name, company_lacation_size)
  ## 返回数据
  return(company_info)
}


# 利用get_apparel()函数，循环爬取公司信息 =================================

## 创建一个空数据框
apparel_company_list <- data.frame(t(rep(NA,6)))[-1,]
names(apparel_company_list) <- c('company_name', 'location', "size", "nature", "business", "page_num")

for (i in 1:length(page_num)){
  company_info <- get_apparel(page_num[i])
  company_info$page_num <- i
  apparel_company_list <- rbind(apparel_company_list, company_info)
  # 设置休息时间5秒
  Sys.sleep(5)
}


"爬取成功！"

### 写出到csv文件中
write.csv(apparel_company_list, 
          file = './apparel_company_list_cfw.csv',
          row.names = FALSE)

"导出成功！"
