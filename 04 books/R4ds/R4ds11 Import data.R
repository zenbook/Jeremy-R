
# library packages ========================================================
library(tidyverse)
library(nycflights13)

# 11.2 Getting Started ====================================================

## readr package
## 1.read_csv(): reads comma delimited files
## 2.read_csv2(): reads semicolon separated files 
## 3.read_tsv(): reads tab delimited files
## 4.read_delim(): reads in files with any delimiter.
## 5.read_fwf(): reads fixed width files. 
## You can specify fields either by their widths with fwf_widths() 
## or their position with fwf_positions(). 
## 6.read_table() reads a common variation of fixed width files 
## where columns are separated by white space.
## 7.read_log() reads Apache style log files. 

write.csv(flights, 'flights.csv', row.names = FALSE)

## read_csv()
read_csv('flights.csv')

## read_csv(), 第一行是列名，每行一条记录
read_csv('a, b, c 
         1, 2, 3 
         4, 5, 6')
## 跳过开始的n行
read_csv('the first row is column name
         from the second row are the data point
         a, b, c
         1, 3, 7', 
         skip = 2)

## 注明备注行
read_csv('# this is the comment line
         a, b, c
         1, 3, 7', 
         comment = '#')

## read data without column names from the first row
## label the column names with X1 to Xn
read_csv('1, 2, 3\n 4, 6, 9', col_names = FALSE)

## read data without column names from the first row
## set column names with col_name = c()
read_csv('1, 2, 3\n 4, 6, 9', col_names = c('x', 'y', 'z'))

## read data with missing values
read_csv('1, 2, 3\n 4, 6, .', na = '.', col_names = FALSE)

## 用read_csv系列函数的理由是：
## 1.更快！
## 2.生成的数据集是tibble，不会把字符串转成因子；
## 3.基础的R函数跟操作系统和环境变量会有关系，而read_csv不会；

## exercise
read_delim('a|b|c
           1|2|3
           6|7|9', delim = '|')

read_csv("x,y\n1,'a,b'", quote = '\'')
read_delim("x,y\n1,'a,b'", delim = ',', quote = '\'')

read_csv("a,b\n1,2,3\n4,5,6") # 只读取了两列
## 解决方法：
read_csv("a,b\n1,2,3\n4,5,6", 
         col_names = c('a', 'b', 'c'), 
         skip = 1)
read_csv("a,b,c\n1,2\n1,2,3,4") # 只读取了三列
## 解决方法：
read_csv("a,b,c\n1,2\n1,2,3,4", 
         col_names = c('a', 'b', 'c', 'd'), 
         skip = 1)
read_csv("a,b\n\"1") # 没毛病
read_csv("a,b\n1,2\na,b") # 没毛病
read_csv("a;b\n1;3") # 作为一列来导入了
## 解决方法：
read_delim("a;b\n1;3", delim = ';')

# 11.3 Parsing a vector ===================================================

















































