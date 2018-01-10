
# 方法1 =========================================================================
# 失败

#loading libraries
library("DBI")
library("rJava")
library("RJDBC")

#init of the classpath (works with hadoop 2.6 on CDH 5.4 installation)
cp <-  c("E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/hive_metastore.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/hive_service.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/HiveJDBC4.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/libfb303-0.9.0.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/libthrift-0.9.0.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/log4j-1.2.14.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/ql.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/slf4j-api-1.5.8.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/slf4j-log4j12-1.5.8.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/TCLIServiceClient.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/hadoop-common-0.23.9.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/httpclient-4.2.5.jar", 
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/httpcore-osgi-4.2.5.jar",
       "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/hive-jdbc-0.13.1.jar")
.jinit(classpath=cp)

#initialisation de la connexion
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", 
            "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/hive-jdbc-1.1.1.jar", 
            identifier.quote="`")
conn <- dbConnect(drv, "jdbc:hive2://169.44.23.139:25002/zydb", "neo", "@MYway2016")

#working with the connexion
show_databases <- dbGetQuery(conn, "show databases")
show_databases


# 方法2 =========================================================================
# 失败

# loading libraries
library("DBI")
library("rJava")
library("RJDBC")

cp <- dir("E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006", 
          full.names = TRUE)
.jinit(classpath = cp)

username <- 'neo'
password <- '@MYway2016'

options(java.parameters = "-Xmx8g")
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", 
            "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/HiveJDBC4.jar")



# 方法3 =========================================================================
# 失败

# Load required libraries. The `tibble` package is optional. It makes data frames
# look nicer when they are printed to the screen.
library(rJava)
library(RJDBC)
library(tibble)

# Set Java options, specifically the class path for where the Hadoop and Hive jar
# files are located on your machine. Your folder structure may vary.
options(java.parameters = "-Xmx8g")
hadoop_jars_dir <- c("E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006")
clpath <- c()
for (d in hadoop_jars_dir) {
  clpath <- c(clpath, list.files(d, pattern = "jar", full.names = TRUE))
}
.jinit(classpath = clpath)
.jaddClassPath(clpath)

# Set up variables for later use.
# Set the `hive_url` and `sql_query` as necessary for your connection.
hive_jdbc_jar <- "E:/jollycorp/impala client/Cloudera_HiveJDBC4_2.5.4.1006/HiveJDBC4.jar"
hive_driver <- "org.apache.hive.jdbc.HiveDriver"
hive_url <- "jdbc:hive2://169.44.23.139:25002/zydb"
sql_query <- "SELECT * FROM zydb.dw_order_sub_order_fact limit 10"

# Create in instance of our Hive driver.
drv <- JDBC(hive_driver, 
            hive_jdbc_jar)

# Connect, query, and disconnect.
conn <- dbConnect(drv, hive_url)
rs <- dbSendQuery(conn, sql_query)
df <- dbFetch(rs, n = -1)
dbClearResult(rs)
dbDisconnect(conn)

# Clean up and show output.
df <- as_tibble(df)
print(df)




