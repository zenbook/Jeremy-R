# chapter 1 

# 寻求帮助
?mean
help("mean")
??test
help.start()

# 安装包
## 从cran直接安装
install.packages("knitr")
## 用源码安装
install.packages("Rweibo", repos = "http://R-Forge.R-project.org", type = "source")
## 从github上安装R包
require("devtools")
install_github("lijian13/rinds")

# 保存项目中重要的中间对象，用save：
save(x, file = "x.rda")   #后缀名用rda的原因是可以用data函数直接使用这个数据
# 加载保存的中间对象
load("x.rda")
data(x)

# 书籍主页：http://jianl.org/cn/book/rinds.html