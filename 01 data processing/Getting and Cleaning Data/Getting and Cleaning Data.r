# this note is based on the cource from courera
# https://www.coursera.org/learn/data-cleaning/home/welcome
library('rstudioapi')
# 将当前文件所在的目录设置为工作目录
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# week 01  -------------------------------------------------------------------------
# about working directory
setwd("./data")
setwd("../")
setwd("C:/Users/dakongyi")
getwd()

# download file from web ----------------------------------
## download.file()
download.file(url = ,  # url
              destfile = ,  # 下载的文件保存的路径和文件名称
              method = ,  # 下载文件的方法:internal,wininet,libcurl,wget,curl
              quiet = FALSE,  # 是否不显示下载进度和相关信息
              mode = 'w', # 写文件的模式
              cacheOK = TRUE, 
              extra = getOption('download.file.extra')
              )
## window系统下，如果url使用的https协议，则可能无法下载数据 
fileurl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileurl, destfile = './cameras.csv', method = 'curl')
list.files()

# read local files ----------------------------------------
## read.table()
## function structure
read.table(file = ,  # 需读取的文件名称(可包括路径)
           header = FALSE,  # 文件是否包含表头
           sep = ,  # 文件使用的分隔符
           quote = ,  
           dec = ,
           numerals = c('allow.loss', 'warn.loss', 'no.loss'),
           row.names = ,
           col.names = ,
           as.is = !stringsAsFactors,
           na.strings = "NA",
           colClasses = NA,
           nrows = -1,
           skip = 0,
           check.names = TRUE,
           fill = !blank.lines.skip,
           strip.white = FALSE,
           blank.lines.skip = TRUE,
           comment.char = "#",
           allowEscapes = FALSE,
           flush = FALSE,
           stringsAsFactors = default.stringsAsFactors(),
           fileEncoding = "",
           encoding = "unkonwn",
           text = ,
           skipNul = FALSE
           )
cameras <- read.table(file = 'Baltimore_Fixed_Speed_Cameras.csv',
                      sep = ',',
                      header = TRUE)
head(cameras)
## read.csv()
## function structure
read.csv(file = ,
         header = ,
         sep = ",",
         quote = "\"",
         dec = ".",
         fill = TRUE,
         comment.char = "")
cameras <- read.csv(file = 'Baltimore_Fixed_Speed_Cameras.csv',
                    header = TRUE)
head(cameras)

# read xlsx file ------------------------------------------
## load library
library("xlsx")
## function structure
read.xlsx(file = ,  # xlsx文件名称(包括路径)
          sheetIndex = ,  # 需读取的sheet页序号
          sheetName = ,  # 需读取的sheet页名称
          rowIndex = ,  # 需读取的行号
          startRow = ,  # 开始读取的行号(当不设置rowIndex时，此项可设置)
          endRow = ,  # 最后读取的行号(当不设置rowIndex时，此项可设置)
          colIndex = ,  # 需读取的列号
          as.data.frame = ,  # 是否保存为dataframe,默认为TRUE
          header = ,  # 是否有表头,默认为TRUE,如果设置为FALSE,则第一行为第一个样本
          colClasses = ,  # 一个向量，设置每列的数据类型
          keepFormulas = ,  # 单元格中的公式是否保存为文本
          encoding = ,  # 设置读取的文本的编码格式
          stringsAsFactors = )  # 文本是否转成因子

cameras <- read.xlsx(file = "Baltimore_Fixed_Speed_Cameras.xlsx",
                     sheetIndex = 1,
                     header = TRUE)
head(cameras)
colindexs <- c(2:3)
rowindexs <- c(1:5)
read.xlsx(file = "Baltimore_Fixed_Speed_Cameras.xlsx",
          sheetIndex = 1,
          colIndex = colindexs,
          rowIndex = rowindexs)

# read xml file -------------------------------------------
library('XML')
# case 1
## xml file from w3school.com.cn, breakfast menu
fileurl <- "http://w3school.com.cn/example/xmle/simple.xml"
doc <- xmlTreeParse(fileurl, useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[1]  # 第一个node的标签+内容
rootNode[[1]]  # 第一个node的内容(food + name + ...)
rootNode[[1]][1]  # 第一个food node下的第一个标签(name)和内容
rootNode[[1]][[1]]  # 第一个food node下的第一个标签(name)的内容
rootNode[[1]][[1]][1]  # name下的标签名和内容
rootNode[[1]][[1]][[1]]  # name:Belgian Waffles 
xmlSApply(rootNode, xmlValue) 
name <- xpathSApply(rootNode, "//name", xmlValue)
price <- xpathSApply(rootNode, "//price", xmlValue)
description <- xpathSApply(rootNode, "//description", xmlValue)
calories <- xpathSApply(rootNode, "//calories", xmlValue)
breakfast <- data.frame(name, 
                        price, 
                        description, 
                        calories)
# case 2
# 这个案例有些问题，标签可能换了
fileurl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileurl, useInternal = TRUE)
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue) 
scores
teams

# good doc about extract data from xml file
# https://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

# read data from JSON -------------------------------------
library('jsonlite')
## read data from json
jsondata <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsondata)
names(jsondata$owner)
jsondata$owner$login
## write data frame to json file
myjson <- toJSON(iris, pretty = TRUE)
cat(myjson)
## convert back to json
iris2 <- fromJSON(myjson)
head(iris2)

# data.table ----------------------------------------------
library('data.table')
# data table继承自data frame
## create data table just like data frame
df <- data.frame(a = rnorm(6), 
                 b = runif(6, 1, 10),
                 c = letters[1:6])  
df
class(df)
dt <- data.table(a = rnorm(6),
                 b = runif(6, 1, 10),
                 c = letters[1:6])
dt
class(dt)
# 查看内存中所有的tables
tables()
# subseeting rows and columns
dt[2,]
dt[dt$a < 0,]
dt[, 1]
dt[, 2:3]
dt[, c(2, 3)]
# adding new columns
dt[, w:= a^2 * 10]
dt
# week 02  -------------------------------------------------------------------------















