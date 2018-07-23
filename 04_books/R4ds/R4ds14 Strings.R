
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

x <- str_wrap('hello, world!', width = 2)
writeLines(x)

str_trim(' hello, world! ')
str_trim(' hello, world! ', side = 'left')
str_trim(' hello, world! ', side = 'right')
str_trim(' hello, world! ', side = 'both')

# 14.3 Matching patterns with regular expressions ====================

## 14.3.1 Basic matches
## 字符串的匹配对大小写是敏感的
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

## 14.3.4 Repetition
## 希望查询到的字符串重复多少次？
## ?: 0 or 1
## +: 1 or more
## *: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, 'CC?')
str_view(x, 'CC+')
str_view(x, 'C[LX]+')

## 除了用?/+/*，还可以指定出现的次数
## {n} 正好n次
## {n,} 至少n次
## {,m} 至多m次
## {n,m}  n到m次之间
str_view(x, 'C{2}')
str_view(x, 'C{2,}')
str_view(x, 'C{3}')
str_view(x, 'C{1,4}')

## 这种匹配是很"贪心"的，返回的都是可匹配的最长的字符串
## 如果想返回最短的字符串，可以在正则表达式后再加一个"?"
str_view(x, 'C{1,3}')
str_view(x, 'C{1,3}?')
str_view(x, 'C[LX]+')
str_view(x, 'C[LX]+?')

x <- 'colour panels'
str_view(x, 'colou?r') # color or colour


## exercise
## 因此，?/+/*可以用数字范围来表示
## ?:{0,1}
## +:{1,}
## *:{0,}

## 14.3.5 Grouping and backreferences
str_view(fruit, '(..)\\1', match = TRUE)
str_view(fruit, '(.)\\1', match = TRUE)
str_view(fruit, '(.)\1\1', match = TRUE)

# 14.4 Tools =========================================================

# 14.4.1 Detect matches
x <- c("apple", "banana", "pear")
str_detect(x, 'e')
## words中有多少个单词是元音结尾的？
sum(str_detect(words, '[aeiou]$'))
## words中有多少比例的单词是元音结尾的？
mean(str_detect(words, '[aeiou]$'))
## 找出不含元音的单词
novowels_1 <- !str_detect(words, '[aeiou]')
novowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(novowels_1, novowels_2)
## 第一个方法更简单易懂，不要写太复杂的正则表达式，如果太复杂了，就拆开来。
words[str_detect(words, 'x$')]
str_subset(words, 'x$')
## 用filter筛选
df <- tibble(
  word = words, 
  i = seq_along(word)
)
df %>% 
  filter(str_detect(word, 'x$'))
## str_count(),有多少个匹配的
str_count(x, 'a')
## 一个单词中平均有多少个元音字母
mean(str_count(words, '[aeiou]'))
mean(str_length(words))
df %>% 
  mutate(
    word_len  = str_length(word),
    vowels = str_count(word, '[aeiou]'),
    consonants = str_count(word, '[^aeiou]')
  )
## 正则表达式匹配的内容不会重叠
str_detect('abababa', 'aba')
str_count('abababa', 'aba')
str_view_all('abababa', 'aba')

## exercise
str_subset(words, '^x|x$')
words[str_detect(words, '^x') | str_detect(words, 'x$')]
str_subset(words, '^[aeiou]' & '[^aeiou]$') # 还有问题
words[str_detect(words, '^[aeiou]') & str_detect(words, '[^aeiou]$')]
df %>% 
  mutate(
    vowels = str_count(word, '[aeiou]')
  ) %>% 
  arrange(-vowels)
df %>% 
  mutate(
    word_len = str_length(word),
    vowels = str_count(word, '[aeiou]'),
    vowel_p = vowels / word_len
  ) %>% 
  arrange(-vowel_p)

# 14.4.3 Extract matches

length(sentences)
head(sentences)
colors <- c('red', 'orange', 'yellow', 'green', 'blue', 'purple')
color_match <- str_c(colors, collapse = '|')
has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)





































