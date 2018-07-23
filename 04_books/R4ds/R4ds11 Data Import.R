
# library packages ========================================================
library(tidyverse)
library(nycflights13)
library(hms)
library(feather)

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

str(parse_logical(c('TRUE', 'FALSE', 'FALSE')))
str(parse_integer(c('1', '2', '3')))
str(parse_date(c('2017-01-02', '2017-12-15')))

parse_integer(c('1', '3', '.', '123'), na = '.')

x <- parse_integer(c('1', '123', 'ab', '.45'))
x
problems(x)

parse_logical()
parse_integer()
parse_double()
parse_number()
parse_character()
parse_factor()
parse_date()
parse_datetime()
parse_time()

## 11.3.1 Numbers  =========================

## problem 1:不同国家表示小数点的方式都不一样，有用.的，也有用,的：
parse_double('1.23')
parse_double('1,23')
parse_double('1,23', locale = locale(decimal_mark = ','))

## problem 2:真实业务中数据的表示通常都带有单位或者其他符号：比如'%':
parse_number('$2000')
parse_number('95.8%')
parse_number('it costs $123')

## problem 3:不同国家表示较大数字使用的分隔符不同，',', '.','''
parse_number('123,456,789')
parse_number('123.456.789', locale = locale(grouping_mark = '.'))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

## 11.3.2 Strings  =========================

## string is complicated because of the encoding
charToRaw('wong')
## always use utf-8

## if vector don't use utf-8, then specify the encoding:
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"  # 您好

parse_character(x1, locale = locale(encoding = 'Latin1'))
parse_character(x2, locale = locale(encoding = 'Shift-JIS'))

## 如果不知道vector的encoding,则可以猜一下：
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

## 11.3.3 Factors ==========================
fruit = c('apple', 'banana')
parse_factor(c('apple', 'banana', 'bananana'), levels = fruit)

## 如果level比较多，还不如先保留为文本，生成之后再把该列转换为factor

## 11.3.4 Dates, date-times, and times ====

## parse_datetime()
## date are organised from biggest to smallest: year, month, day, hour, minute, second.
## https://en.wikipedia.org/wiki/ISO_8601
parse_datetime('2012-12-12 0320')
## 如果没有时分秒，默认为零时零分零秒
parse_datetime('2012-12-12')

## parse_date(): yyyy-mm-dd
parse_date('2012-01-01')

## parse_time
parse_time('01:10')
parse_time('01:10 am')
parse_time('01:10 pm')
parse_time('20:10:10')

# Year
# %Y (4 digits).
# %y (2 digits); 00-69 -> 2000-2069, 70-99 -> 1970-1999.
# Month
# %m (2 digits).
# %b (abbreviated name, like “Jan”).
# %B (full name, “January”).
# Day
# %d (2 digits).
# %e (optional leading space).
# Time
# %H 0-23 hour.
# %I 0-12, must be used with %p.
# %p AM/PM indicator.
# %M minutes.
# %S integer seconds.
# %OS real seconds.
# %Z Time zone (as name, e.g. America/Chicago). Beware of abbreviations: 
# if you’re American, note that “EST” is a Canadian time zone that does not have daylight sav
# ings time. It is not Eastern Standard Time! We’ll come back to this time zones.
# %z (as offset from UTC, e.g. +0800).
# Non-digits
# %. skips one non-digit character.
# %* skips any number of non-digits.

## 如果日期可以有多种转换结果，设置希望转换的格式
parse_date('01/02/05')
parse_date('01/02/05', '%m/%d/%y')
parse_date('01/02/05', '%d/%m/%y')
parse_date('01/02/05', '%y/%m/%d')

## 如果月份使用了别的语言的简写，则设置语言：
parse_date('1 janvier 2015', '%d %B %Y', locale = locale('fr'))

## 11.3.5 Exercise =========================

## 1
locale(encoding = 'UTF-8',   # 编码
       decimal_mark = '',   # 小数点标记符号
       grouping_mark = ',')   # 较大数据的分割符号：123,456,789

## 2
x <- '1,456.789'
## what if I set decimal_mark = ','
parse_number(x, locale = locale(decimal_mark = ','))
## what if I set decimal_mark and grouping_mard to be the same character?
parse_number(x, locale = locale(decimal_mark = ',', 
                                grouping_mark = ','))
## what if I set grouping_mark = '.'
parse_number(x, locale = locale(grouping_mark = '.'))

## 3
parse_date('2015-12-01', locale = locale(date_format = '%Y-%m-%d'))
parse_date('2015-12-01', locale = locale(time_format = '%H:%M:%S'))

## 7
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, '%B %d, %Y')
parse_date(d2, '%Y-%b-%d')
parse_date(d3, '%d-%b-%Y')
parse_date(d4, '%B %d (%Y)')
parse_date(d5, '%m/%d/%y')
parse_time(t1, '%H%M')
parse_time(t2)

# 11.4 parsing a file  ====================================================

## How readr automatically guesses the type of each column.
## How to override the default specification.

## 11.4.1 strategy  =========================

## 读取数据集的前1000行，根据这1000行来判断每列的数据格式

guess_parser('2010-01-01')
guess_parser('12:40')
guess_parser('FALSE')
guess_parser('123')
guess_parser('1.23')
guess_parser('123,456,789')
str(parse_guess('2013-01-01'))

# how guess_parser guess?
# logical: contains only “F”, “T”, “FALSE”, or “TRUE”.
# integer: contains only numeric characters (and -).
# double: contains only valid doubles (including numbers like 4.5e-5).
# number: contains valid doubles with the grouping mark inside.
# time: matches the default time_format.
# date: matches the default date_format.
# date-time: any ISO8601 date.
# 如果上面的规则都不符合，则guess_parser返回字符串

## 11.4.2 problems  =========================

## 可能的问题：
## 1.前1000行的数据比较特殊，不足以完全代表该列的字段类型；
## 2.前1000行都是NA，则无论1000行后是什么数据类型，guess_parser都会认为是字符串；

challenge <- read_csv(readr_example('challenge.csv'))
problems(challenge)

challenge <- read_csv(
  readr_example('challenge.csv'), 
  col_types = cols(
    x = col_integer(), 
    y = col_character()
  )
)

## x列不是integer,而应该转换为double
challenge <- read_csv(
  readr_example('challenge.csv'), 
  col_types = cols(
    x = col_double(), 
    y = col_character()
  )
)
head(challenge)
## 没报错了，但是我们看看y列的最后几行数据点：
tail(challenge)
## 哦噢，怎么是日期格式的？
## 因此我们猜测y列应该是日期格式的：
challenge <- read_csv(
  readr_example('challenge.csv'), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
challenge

## 对于每一个parse_*，有一个相应的col_*，用来设置列的格式
## 建议导入数据的时候，用col_types = cols()来设置每列的格式

## 11.4.3 other strategies ==================

## 1.读入多一些数据
challenge <- read_csv(
  readr_example('challenge.csv'), 
  guess_max = 1001
)
challenge

## 2.把所有列都当做字符串导入
challenge <- read_csv(
  readr_example('challenge.csv'), 
  col_types = cols(.default = col_character())
)
challenge
## 然后用type_convert()把字符串做转换
df <- tribble(
  ~x, ~y,
  '1', '1.23',
  '3', '4.35',
  '6', '7.21'
)
df
type_convert(df)

## 3.当读取非常大的文件时，设置n_max()

## 4.read_lines(), read_file()

# 11.5 Writing to a file ==================================================
## write_csv(), write_tsv(), write_excel_csv()

write_csv(x = challenge, 
          path = 'challenge.csv', 
          na = 'NA', 
          append = FALSE)
## 注意：当写入到csv中后，数据类型就丢失了：
read_csv('challenge.csv')
## 可以发现：x/y的类型都变了

write_tsv(x = challenge, 
          path = 'challenge.csv')
read_tsv('challenge.csv')

## 貌似只能导出xls的excel文件
write_excel_csv(challenge, 'challenge.xls')

## 以上导出的方法都把数据原来的格式丢失了，有没有保留数据格式的方法呢？
## 当然有啦，而且还不止一个：

## 1.write_rds,read_rds
write_rds(challenge, 'challenge.rds')
read_rds('challenge.rds')

## 2.feather package write.feather() read_feather()
write_feather(challenge, 'challenge.feather')
read_feather('challenge.feather')

# 11.6 Other types of data ================================================

# https://cran.r-project.org/doc/manuals/r-release/R-data.html
# https://jennybc.github.io/purrr-tutorial/

