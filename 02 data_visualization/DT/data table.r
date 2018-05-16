
# 以下内容来自网站：
# https://rstudio.github.io/DT/


# loading packages
library(DT)
library(tidyr)
library(dplyr)

# 1.结构 -----------------------------------------------------------------------------------------------------------------
datatable(
  data, 
  class = "display", 
  style = "default", 
  rownames, 
  colnames, 
  container, 
  caption = NULL, 
  filter = c("none", "bottom", "top"),
  callback = JS("return table;"),  
  escape = TRUE,
  options = list(), 
  width = NULL, 
  height = NULL, 
  elementId = NULL, 
  fillContainer = getOption("DT.fillContainer", NULL), 
  autoHideNavigation = getOption("DT.autoHideNavigation", NULL), 
  selection = c("multiple", "single", "none"), 
  extensions = list(), 
  plugins = NULL
)

datatable(head(iris))

# 2.CSS class ------------------------------------------------------------------------------------------------------------
## 取值枚举：https://datatables.net/manual/styling/classes
## display 默认 集合了stripe,hover,row-border,order-column
datatable(head(iris, 30), class = 'display') 
## cell-border 单元格边框
datatable(head(iris, 30), class = 'cell-border')
## compact 超级简洁版式
datatable(head(iris, 30), class = 'compact')
## hover 很简洁，但是鼠标移入某行后，改行背景填充
datatable(head(iris, 30), class =  'hover')
## nowrap 和compact差不多简洁
datatable(head(iris, 30), class = 'nowrap')
## order-column 高亮排序的列
datatable(head(iris, 30), class = 'order-column')
## row-border 每行上下边框线
datatable(head(iris, 30), class = 'row-border')
## stripe 奇偶行不同背景色
datatable(head(iris, 30), class = 'stripe')

# 3.表格样式style -------------------------------------------------------------------------------------------------------
## "default", "bootstrap", "bootstrap4", "foundation", "jqueryui", "material", "semanticui", "uikit"
## 默认用default,其他的都需要自定义才够美观
datatable(head(iris, 30), style = 'default')

# 4.rownames 行名 默认显示 ----------------------------------------------------------------------------------------------
## 不显示行名
datatable(head(iris, 30), rownames = FALSE) 
## 自定义行名
datatable(head(iris), rownames = head(letters))
datatable(head(iris), rownames = c('a1', 'a2', 'a3', 'a4', 'a5', 'a6'))
datatable(head(iris, 26), rownames = LETTERS)

# 5.colnames 列名 可自定义 ----------------------------------------------------------------------------------------------
## 设置除行名列以外其他所有列的列名 
datatable(head(iris, 30), colnames = head(LETTERS, 5)) 
## 设置所有列的列名，包括行名所在列
datatable(head(iris, 30), colnames = head(LETTERS, 6))
## 如果自定义的列名数量少于实际的列名，则表格会有问题
datatable(head(iris, 30), colnames = head(LETTERS, 4))
## 设置某一列的字段名，'新列名' = 列号，比如：1，代表第几列
datatable(head(iris, 30), colnames = c('ID' = 1)) 
## 设置某一列的字段名，'新列'名 = '旧列名'
datatable(head(iris, 30), colnames = c('BETTER NAME' = 'Sepal.Length'))

# 6.table container -----------------------------------------------------------------------------------------------------
## 自定义container1，合并单元格
sketch1 <- htmltools::withTags(
  table(
    class = 'display',
    thead(
      tr(
        th(rowspan = 2, 'Species'),
        th(colspan = 2, 'Sepal'),
        th(colspan = 2, 'Petal')
      ),
      tr(
        lapply(rep(c('Length', 'Width'), 2), th)
      )
    )
  )
)
datatable(iris[1:30, c(5, 1:4)], container = sketch1, rownames = FALSE)
## 自定义container，在表格底部添加字段
sketch2 <- htmltools::withTags(
  table(
    tableHeader(iris),
    tableFooter(iris)
  )
)
datatable(head(iris, 30), container = sketch2, rownames = FALSE)

# 7.caption 表格说明/标题 ---------------------------------------------------------------------------------------------
## 简单标题，纯文本
datatable(head(iris, 30), caption = 'Table 1: iris的前30条记录')
## 格式较为灵活的标题，使用htmltools::tags$caption()
datatable(
  head(iris, 30),
  caption = htmltools::tags$caption(
    style = 'caption-side:top; text-align:center; font-size:1.3em;font-family:sans-serif;',
    'Table 2: ', htmltools::strong('iris的前30条记录')
  )
)

# 8.filter 每一列的筛选框 ---------------------------------------------------------------------------------------------
## filter = c('none'不开启,'top'顶部开启,'bottom'底部开启)
## filter默认是不开启的，开启方法如下：
datatable(iris[c(1:10, 60:70, 110:120),], filter = 'top') 

# 9.callback 用的不多 -------------------------------------------------------------------------------------------------

# 10.escape 用的不多 --------------------------------------------------------------------------------------------------

# 11.options() 有多自定义的设置，熟练掌握 -----------------------------------------------------------------------------
## datatable官方网站：https://datatables.net/reference/option/
datatable(head(iris, 20), 
          options = list(
            initComplete = JS(
              "function(settings, json) {",
              "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
              "}")
            )
          )

## 11.1 默认设置 -------------------------------------------------
### a.按第一列排序；
### b.排序列没有高亮(字段名右边的升降序三角按钮)
### c.数字格式的列排在右边；文本格式的列排在左边

## 11.2 初始化设置 -----------------------------------------------
### 列居中，居左，居右；每页显示数据条数；数据条数的筛选数字
datatable(
  head(iris, 30),
  options = list(
    columnDefs = list(list(className = 'dt-center', targets = 1:5)), # 第6列居中，不能用列名来设置
    pageLength =  5, # 设置每页显示数据条数
    lengthMenu = c(5, 10, 15, 20) # 设置数据条数的筛选数字
  )
)

## 11.3 全局设置：让所有的datatable都引用的设置项 ----------------
options(
  DT.options = list(
    pageLength = 10, 
    lengthMenu = c(10, 20, 30, 50), 
    language = list(search = '搜索:')
  )
)
datatable(head(iris, 30), extensions = 'Buttons')

## 11.4 设置排序列 order = list() ---------------------------------
datatable(
  iris[c(1:10, 60:70, 110:120),c(5, 1:4)], 
  options = list(
    order = list(list(1, 'asc'), list(2, 'desc'))
  )
)

## 11.5 dom元素 ---------------------------------------------------
### dom元素包括：
### l:默认左上角,lengthMenu;  
### f:默认右上角,search框； 
### i:默认左下角,当前页/页数和数据条数
### p:默认右下角,page,第一页/前一页/页码/后一页/最后一页
### t:中间的表格,表格高度宽度变化后会有相应的垂直水平滚动条
### r:中间的表格,表格高度宽度变化后不会有相应的垂直水平滚动条
### B:按钮,如"copy","print","excel"等,需设置extensions = 'Buttons'
### dom = '以上的组合'
#### 只显示表格
datatable(head(iris, 30), options = list(dom = 't'))
#### 显示表格和查询框
datatable(head(iris), options = list(dom = 'ft'))

## 11.6 callbacks in options --------------------------------------
datatable(head(iris, 20), options = list(
  initComplete = JS(
    "function(settings, json) {", 
    "$(this.api().table().header()).css({'background-color':'#000', 'color':'#fff'})",
    "}"
  )
))

## 11.7 高亮筛选内容 ----------------------------------------------
datatable(
  iris[c(1:10, 60:70, 110:120), c(5, 1:4)], 
  options = list(searchHighlight = TRUE), 
  filter = 'top'
)

## 11.8 列中数字格式 ----------------------------------------------
### 准备数据
m <- cbind(matrix(rnorm(60, 1e5, 1e6), 20), runif(20), rnorm(20, 100))
m[, 1:3] <- round(m[, 1:3])
m[, 4:5] <- round(m[, 4:5], 7)
colnames(m) <- head(LETTERS, 5)
### 生成表格
datatable(m) %>% 
  formatCurrency(c(1, 3), currency = '￥', digits = 0) %>% # 货币格式 formatCurrency()有几个参数可以使用
  formatPercentage(4, 2) %>% # 百分比格式 
  formatRound(5,2)

## 11.9 单元格格式 formatStyle() ----------------------------------
### 一列中每个单元格的格式都相同
datatable(head(iris, 30)) %>% 
  formatStyle(1, fontWeight = 'bold', color = 'red', backgroundColor = 'orange')
### 一列中根据单元格的值显示不同的格式
#### 准备
m <- data.frame(m)
m$month <- rep(c('1月', '2月', '3月', '4月'), each = 5)
M <- datatable(m[, c(6, 1:5)]) %>% 
  formatCurrency(c(2, 4), currency = '￥', digits = 0) %>% 
  formatPercentage(5, 2) %>% 
  formatRound(6, 2)
#### 设置格式(找好的配色方案)
M %>% 
  # 文本，不同的文本不同的填充色styleEqual()
  formatStyle(
    'month', 
    backgroundColor = styleEqual(
      unique(m$month), c('lightblue', 'lightgreen', 'lightpink', 'gray') 
    )
  ) %>% 
  # 数值，分两段，是否粗体styleInterval()
  formatStyle(
    c('A','C'), 
    fontWeight = styleInterval(0, c('normal', 'bold'))
  ) %>% 
  # 数值，分三段，字体颜色和背景色styleInterval()
  formatStyle(
    'B', 
    color = styleInterval(c(0, 1e6), c('white', 'blue', 'red')),  # 字体颜色
    backgroundColor = styleInterval(c(0, 1e6), c('gray', 'yellow', 'lightgreen')) # 背景色
  ) %>% 
  # 数值，条形图缩略图styleColorBar()
  formatStyle(
    'D',
    background = styleColorBar(m$D, 'orange')
  )
### 一列中根据单元格的值显示不同的格式(网页案例原型)
datatable(iris) %>% 
  formatStyle('Sepal.Length', fontWeight = styleInterval(5, c('normal', 'bold'))) %>%
  formatStyle(
    'Sepal.Width',
    color = styleInterval(c(3.4, 3.8), c('white', 'blue', 'red')),
    backgroundColor = styleInterval(3.4, c('gray', 'yellow'))
  ) %>%
  formatStyle(
    'Petal.Length',
    background = styleColorBar(iris$Petal.Length, 'steelblue'),
    backgroundSize = '100% 90%',
    backgroundRepeat = 'no-repeat',
    backgroundPosition = 'center'
  ) %>%
  formatStyle(
    'Species',
    transform = 'rotateX(45deg) rotateY(20deg) rotateZ(30deg)',
    backgroundColor = styleEqual(
      unique(iris$Species), c('lightblue', 'lightgreen', 'lightpink')
    )
  )

# 12. extension ----------------------------------------------------------------------------------------------------------
## 12.1 buttons
### 展示复制/打印/导出excel三个按钮
datatable(
  head(iris, 50), 
  extensions = 'Buttons', 
  options = list(
    pageLength = 10, 
    lengthMenu = c(10, 20, 30, 50), 
    dom = 'Bftrlp',
    buttons = c('copy', 'print', 'excel')
  )
)
### 展示复制/打印/下载三个按钮，其中下载按钮中有csv/excel/pdf三种格式
datatable(
  head(iris, 50), 
  extensions = 'Buttons', 
  options = list(
    pageLength = 10, 
    lengthMenu = c(10, 20, 30, 50), 
    dom = 'Bftrlp', 
    buttons = list(
      'copy', 
      'print',
      list(
        extend = 'collection',
        buttons = c('csv', 'excel', 'pdf'),
        text = 'Download'
      )
    )
  )
)
### 展示"colvis"按钮，让用户自定义可见列
datatable(
  head(iris, 30),
  extensions = 'Buttons',
  options = list(
    dom = 'Bftrlp', 
    buttons = list('colvis')
  )
)
#### 自定义可供用户选择的可见列
datatable(
  head(iris, 30),
  extensions = 'Buttons',
  options = list(
    dom = 'Bftrlp', 
    buttons = list(
      list(extend = 'colvis', columns = c(3, 4, 5))
    )
  )
)

## 12.2 colReorder 手动更改列的顺序 ----------------------
datatable(
  head(iris, 30), 
  extensions = 'ColReorder', 
  options = list(colReorder = TRUE)
)
## 12.3 Fixed Columns ------------------------------------
### 简单版本
m <- as.data.frame(matrix(round(rnorm(100), 5), 5))
datatable(
  m,
  extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = TRUE
  )
)
### 设置固定的列
datatable(
  m,
  extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = list(leftColumns = 2, rightColumns = 1)
  )
)

## 12.4 FixedHeader ---------------------------------------
datatable(
  iris,
  extensions = 'FixedHeader',
  options = list(
    pageLength = 50, 
    fixedHeader = TRUE
  )
)

## 12.5 Scroller ------------------------------------------
m = matrix(runif(1000 * 4), ncol = 4, dimnames = list(NULL, letters[1:4]))
m = cbind(id = seq_len(nrow(m)), round(m, 2))
datatable(
  m, 
  extensions = 'Scroller', 
  options = list(
    deferRender = TRUE,
    scrollY = 200, 
    scroller = TRUE
  )
)

# 13 把表格保存为html文件 --------------------------------------------------------------------------------------
x = datatable(head(iris, 30))
saveWidget(x, 'iris-table.html')

# 14 在shinyAPP中操作数据 --------------------------------------------------------------------------------------

# 后期学习
