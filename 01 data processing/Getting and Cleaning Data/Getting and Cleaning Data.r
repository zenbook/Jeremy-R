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
## window系统下，如果url使用的https协议，则可能无法下载数据 
fileurl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileurl, destfile = './cameras.csv', method = 'curl')
list.files()

# read local files ----------------------------------------
## read.table()
cameras <- read.table(file = 'Baltimore_Fixed_Speed_Cameras.csv',
                      sep = ',',
                      header = TRUE)
head(cameras)
## read.csv()
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
fileurl <- "http://w3school.com.cn/example/xmle/simple.xml"
doc <- xmlTreeParse(fileurl, useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][1]
xmlSApply(rootNode, xmlValue)
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)

# case 2
fileurl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileurl, useInternal = TRUE)
scores <- xpathSApply(doc, "//li[@class='scores']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue) # 标签可能换了
scores
teams

# good doc about extract data from xml file
# https://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf



















