# loading packages
library(DT)

# basic usage
datatable(head(iris))

# edit class argument
datatable(head(iris), class = 'cell-border stripe')

# edit style argument
# "default", "bootstrap", "bootstrap4", "foundation", "jqueryui", "material", "semanticui", "uikit"
datatable(iris, style = 'default')

# rownames 默认显示行名
datatable(iris, rownames = FALSE)
datatable(head(iris, 26), rownames = LETTERS)

# colnames 可自定义
datatable(iris, colnames = c(head(LETTERS, 5)))
datatable(iris, colnames = c('中文', '中', '我', '哈哈', 'e')) # 可以用中文字符
datatable(iris, colnames = c('ID' = 1))

# buttons
datatable(iris[1:50,], extensions = 'Buttons', 
          options = list(pageLenth = 10, lengthMenu = c(10, 20, 30, 50), 
                         dom = 'frtipB', buttons = c('copy', 'print', 'excel')))



















