
# chapter 04 文本数据

## 保存文本数据时，用utf8编码

## 4.1 基本操作

## 读入一个文本文件，可以读入本地文件，也可以读入网页
## 读入R软件的许可证文件（GPL）
gpl = readLines(file.path(R.home(), 'COPYING'))
## 查看前6行
head(gpl)
## 读入hadley的主页
hadley = readLines('http://hadley.nz/')
head(hadley)
## readLines的妹妹：readline
## readline的结果由用户输入
x = readline('Answer yes or no:')

writeLines(gpl)









