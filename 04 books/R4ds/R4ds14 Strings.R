
# library packages ===================================================
library(tidyverse)
library(stringr)

# 14.2 string basics =================================================

## 用""或''，建议用""
string1 <- "this is a string"
string2 <- 'this is alse a string'

## 转义字符\
string1 <- "\""
string1 <- '\''
string1 <- '\\'
string1 <- 'what\'s your name?'
string1 <- "what's your name?"

## writeLines()
writeLines(string1)

## 各种quotes
## \n 换行
## \t TAB
## 可通过?"'"来查询quote的列表

## string length
str_length(c('a', 'this is R4ds', NA))

## combining strings
str_c('x', 'y')
str_c('x', 'y', sep = '-')
## 对NA值进行处理：str_replace_na()
x <- c('abc', NA)
str_c('|-', x, '-|')
str_c('|-', str_replace_na(x), '-|')
## str_c是向量处理，不同向量不同长度时，以长度更长的向量为准
str_c('prefix', c('a', 'b', 'c'), 'suffix', sep = '-')
## 可以根据if条件的结果来决定是否合并某个字符
name <- 'Jeremy'
time <- 'morning'
birthday <- FALSE
str_c('Good ', 
      time, 
      ',', 
      name, 
      if(birthday)'and Happy Birthday To You', 
      '!')
## 把一个字符串向量合并为一个字符串
str_c(c('a', 'b', 'c'), collapse = ',')

## 14.2.3 subsetting strings
x <- c('Apple', 'Banana', 'Pear')
## 从左开始截取
str_sub(x, 1, 3)
## 从末尾开始截取
str_sub(x, -3, -1)
## 如果设定的截取字符串长度多于字符串原有的字符串长度，也没关系
str_sub('aa', 1, 5)
## 还可以用str_sub()来设定字符串相应位置的字符(赋值)
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

## 14.2.4 locales
## 土耳其的i有两个
str_to_upper(c('i', 'ı'))
str_to_upper(c('i', 'ı'), locale = 'tr')
## 字符串排序的规则跟locale也有关系
x <- c('apple', 'eggplant', 'banana')
str_sort(x)
str_sort(x, locale = 'en')
str_sort(x, locale = 'haw')
str_order(x)
str_order(x, locale = 'haw')

## 14.2.5 exercise
paste('x', 'y')
paste('x', 'y', sep = ',')
paste0('x', 'y')
paste0('x', 'y')
paste('x', NA, sep = '-')
paste0('x', NA)
str_c('x', NA)

str_c('x', 'y', 'z', sep = '-')
str_c(c('x', 'y', 'z'), collapse = '-')

x <- 'R for data science'
str_sub(x, (str_length(x) + 1)/2, (str_length(x) + 1)/2)

str_wrap()

str_trim(' hello, world! ')
str_trim(' hello, world! ', side = 'left')
str_trim(' hello, world! ', side = 'right')
str_trim(' hello, world! ', side = 'both')

# 14.3 Matching patterns with regular expressions ====================

## 14.3.1 Basic matches
x <- c("apple", "banana", "pear")
str_view(x, 'an')
## .代表任何字符串
str_view(x, '.a.')
## 如果.确实想表示为点，怎么写正则表达式呢？
dot <- "\\."
writeLines(dot)
str_view(c('abc', 'a.c', 'def'), dot)
x <- 'a\\b'
writeLines(x)
str_view(x, '\\\\')

## 14.3.2 Anchors
## ^ to match the start of the string.
## $ to match the end of the string.
x <- c("apple", "banana", "pear")
str_view(x, '^a')
str_view(x, 'a$')

x <- c("apple pie", "apple", "apple cake")
str_view(x, 'apple')
str_view(x, '^apple$')

## exercise
str_view('radh$^$asdf', '\\$\\^\\$')
words
str_view(words, '^y', match = TRUE)
str_view(words, 'x$', match = TRUE)

## 14.3.3 Character classes and alternatives
## \d: matches any digit.
## \s: matches any whitespace (e.g. space, tab, newline).
## [abc]: matches a, b, or c.
## [^abc]: matches anything except a, b, or c.

abc|d..f
abc|xyz
str_view(c('gray', 'grey'), 'gr(e|a)y')






































