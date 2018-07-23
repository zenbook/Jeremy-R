
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
## 写入文件
writeLines(gpl)

## 文本的基本属性
## 字符数nchar()
nchar(gpl[1:10])
sum(nchar(gpl))
## 行数length()
length(gpl)

## 拆分字符串
## 用空格拆分
strsplit(gpl[4:5], " ")
## 用单词分隔来拆分
words <- unlist(strsplit(gpl, "\\W"))
words <- words[words != ""] # 去掉空格字符
length(words)
words[1:20]
## 出现频次最高的10个单词
tail(sort(table(tolower(words))), 10)
## 根据位置拆分：substr和substring，语法相同
## 取title之间的内容：hadley的姓名
hadley[12]
## 取出其姓名，开始字符位置12，结束字符位置25
substr(hadley[12], 12, 25)
substring(hadley[12], 12, 25)

## 拼接字符串 paste
## 默认用空格拼接
paste(1:3, 'a')
## 设置拼接符号
paste(1:3, 'a', sep = '-')
## 把一个向量中各元素拼接成一个字符串
paste(1:10, collapse = '~')
## paste(1:10, sep = '-')办不到上面的事儿
## 把两个向量的元素对应拼接，然后再拼接成一个字符串
paste(1:3, 'a', sep = '-', collapse = '+')
## sep返回的仍是一个向量，collapse返回的是一个字符串

## 生日歌
happy <- function() cat("Happy birthday to you!\n")
sing <- function(person){
  happy()
  happy()
  cat(paste("Happy birthday dear", person, "!\n"))
  happy()
}
sing("xiaoyuan")


## 4.2 正则表达式

## 提取title中间的文本
## 方法1：替换字符串<title>或者</title>为空字符串（即：删掉它们）
gsub("<title>|</title>", "", hadley[12])
## 方法2：搜索<title>，然后开始匹配任意字符，直到遇到</title>为止，
## 然后把匹配到的这一段字符提出
sub("<title>(.*)</title>", "\\1", hadley[12])
## 竖线|表示“或者”
## 单个.代表任意单个字符
## 星号*是一个表示匹配任意多次的修饰符
## .*一起表示匹配任意字符任意多次，默认会贪婪匹配
## grep这一组函数基本都有一个带g和不带g的版本，
## 比如gsub()和sub()，gregexpr()和regexpr()。
## 带g的会尽量贪婪操作，而不带的只操作一次
sub("<title>|</title>", "", hadley[12])
## 注意点号
gsub('.', '=', 'a.b.c')
gsub("\\.", "=", "a.b.c")
