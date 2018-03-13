# R连接Mysql数据库

# 加载包
library(RODBC)

# 建立数据库连接
conn = odbcConnect('sakila', 
                   uid = 'root', 
                   pwd = 'root')
# sqlFetch,获取表的所有记录
actor = sqlFetch(conn, 'actor')
actor

# 提交sql查询
actor10 = sqlQuery(conn, 
                   'SELECT * FROM actor LIMIT 10;')
actor10

# 关闭连接
close(conn)
