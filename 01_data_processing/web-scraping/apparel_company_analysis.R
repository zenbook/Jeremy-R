
# 加载包
library(tidyverse)

# 读入公司列表
apparel_company_list <- read.csv(file = './web-scraping/apparel_company_list_cfw.csv', 
                                 stringsAsFactors = FALSE,
                                 header = TRUE)

# 分析

str(apparel_company_list)

apparel_company_list %>% 
  group_by(province) %>% 
  summarise(com_num = n()) %>% 
  arrange(-com_num)

apparel_company_list %>% 
  group_by(nature) %>% 
  summarise(com_num = n()) %>% 
  arrange(-com_num)
