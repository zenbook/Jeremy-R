# 处理全国城市列表

## 读入数据
chinese_city_list <- read.table(file = './chinese_city_list', 
                                header = FALSE, 
                                sep = ',', 
                                stringsAsFactors = FALSE)

## 字段处理
chinese_city_list$full_name <- sub("\\{label:", '', chinese_city_list$V1)
chinese_city_list$name <- sub("name:", "", chinese_city_list$V2)
chinese_city_list$pinyin <- tolower(sub("pinyin:", "", chinese_city_list$V3))
chinese_city_list$zipcode <- sub("zip:", "", chinese_city_list$V4)
chinese_city_list$zipcode <- sub("\\}", "", chinese_city_list$zipcode)

## 结果
chinese_city_list <- chinese_city_list[, 6:9]

## 写出csv文件
write.csv(chinese_city_list, 
          file = "./chinese_city_list.csv",
          row.names = FALSE)
