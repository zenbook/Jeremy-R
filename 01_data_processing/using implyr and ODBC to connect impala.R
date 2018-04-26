
# 方法一：通过RImpala包连接impala ==================================================
# 结果：失败


# 方法二：通过JDBC连接impala =====================================================
# 结果：失败


# 方法三：通过RJDBC + implyr包连接impala =========================================
# 结果：失败


# 方法四：通过ODBC + implyr连接impala =============================================
# 结果：成功

# 0.下载和安装ODBC驱动，配置ODBC数据源
# 参考链接：
# http://note.youdao.com/noteshare?id=809d01b3dd696b8a1604c0928bfeaea4&sub=21CC6F7526F64302BDA9CC92E98E498B

# 1.连impala
library(implyr)
library(odbc)
drv <- odbc::odbc()
impala <- src_impala(
  drv = drv,
  driver = "Cloudera ODBC Driver for Impala",
  dsn = 'jolly_impala_64'
)

# 2.玩数据

# 2.1 用dplyr玩数据

# 查看都有哪些表
src_tbls(impala)

# 把表转成tbl_lazy变量
woi_tbl <- tbl(impala, "who_order_info")
class(woi_tbl)
head(woi_tbl)
# 指定数据库in_schema("database name", "data table name")
dosof_tbl <- tbl(impala, in_schema("zydb", "dw_order_sub_order_fact"))
class(dosof_tbl)
head(dosof_tbl)
View(head(dosof_tbl))

# 以上操作，实际上并没有把impala数据库中的表load到本地，但是我们可以用dplyr的诸多操作了
# implyr supports the dplyr verbs filter(), arrange(), select(), rename(), distinct(), 
# mutate(), transmute(), and summarise(). 
# It supports grouped operations with the group_by() function.

test_data1 <- dosof_tbl %>% 
  filter(order_status %in% c(1, 3) | is_shiped == 1) %>% 
  select(country_name, goods_number, goods_amount) %>% 
  group_by(country_name) %>% 
  summarise(goods_num = sum(goods_number), goods_amt = sum(goods_amount)) %>% 
  filter(goods_num >= mean(goods_num)) %>% 
  arrange(-goods_amt) %>% 
  transform(goods_num = as.integer(goods_num)) %>% 
  # as.data.frame()
  collect()

head(test_data1)
summary(test_data1)
class(test_data1)
str(test_data1)
View(test_data1)

# 注意：
# 1.如果要把结果保存成data frame.则在最后加上collect(),否则无法使用一些函数，比如绘图函数ggplot2
#   也可以用as.data.frame()
# https://stackoverflow.com/questions/40937384/how-visualize-tbl-sql-data-using-ggplot2
# 2.arrange()放在所有动作的后面，collect()的前面
# 3.小写，不要用大写
# 4.有时候需要转换时数据格式，用R的as.数据类型转换函数即可
# 5.可以使用window函数
# https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html
# 6.也可以使用join和set
# https://cran.r-project.org/web/packages/dplyr/vignettes/two-table.html

ggplot(test_data1, aes(goods_num, goods_amt)) + 
  geom_point()


# 2.2 用sql玩数据

# 查询数据并保存到R session中，data.frame
test_data2 <- dbGetQuery(
  impala,
  "select country_name
  ,sum(goods_number) as goods_num
  ,sum(goods_amount) as goods_amt
  from zydb.dw_order_sub_order_fact
  where order_status in (1, 3)
  and is_shiped = 1
  group by country_name
  order by goods_num desc"
)
test_data2$goods_num <- as.integer(test_data2$goods_num)
class(test_data2)
str(test_data2)
head(test_data2)


# 查询数据，不保存为data.frame，仍保留为lazy tbl格式
# 由于不是保存到Rsession中，所以不能使用一些函数，比如ggplot
test_data3 <- tbl(impala, 
                  sql("select country_name
                      ,sum(goods_number) as goods_num
                      ,sum(goods_amount) as goods_amt
                      from zydb.dw_order_sub_order_fact
                      where order_status in (1, 3)
                      and is_shiped = 1
                      group by country_name
                      order by goods_num desc"))
class(test_data3)
str(test_data3)
summary(test_data3)

# 用完之后，关闭连接
dbDisconnect(impala)



# 方法五：通过RODBC连接 ============================================================
# 结果：成功

# 0.下载和安装ODBC驱动，配置ODBC数据源
# 参考链接：
# http://note.youdao.com/noteshare?id=809d01b3dd696b8a1604c0928bfeaea4&sub=21CC6F7526F64302BDA9CC92E98E498B

# 1.连impala
library(RODBC)
library(tidyverse)
conn <- odbcConnect("jolly_impala_64")

# 2.玩数据
test_data1 <- sqlQuery(conn, 
                       "select country_name
                       ,sum(goods_number) as goods_num
                       ,sum(goods_amount) as goods_amt
                       from zydb.dw_order_sub_order_fact
                       group by country_name
                       order by goods_num desc")
class(test_data1)
head(test_data1)
ggplot(test_data1, aes(x = goods_num)) + 
  geom()

