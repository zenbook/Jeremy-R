
# chapter 02 安装和配置

# 1.安装

## 1.1 最新版下载地址：http://cran.r-project.org/bin/windows/base/release.htm

## 1.2 安装时的注意事项：

### 1.2.1 不要安装到program file里面，另建一个文件夹，如C:/Software；
### 1.2.2 不要保留版本号，如：去掉R-3.4.4中的“-3.4.4”，结果是：C:/Software/R；
### 1.2.3 安装路径不要带中文；
### 1.2.4 设置环境变量PATH:C:/Software/R/bin，且安装新版本R后，不需要更新；

## 1.3 R附加包

### 1.3.1 R自带包：C:\Software\R\library
### 1.3.2 附加包不要安装到上面的目录里，设置安装到新的目录中
### 1.3.3 用户目录：
#### 查看当前用户目录：
normalizePath('~')
# C:\Users\dakongyi\Documents
#### 列出当前用户目录下的所有文件，以.开头的都是隐藏文件
list.files('~', all.files = TRUE)
#### 建议把附加包安装到用户目录下，新建一个文件夹命名为R，设置为附加包的安装目录

## 1.4 配置文件

### 1.4.1 .Renviron文件
#### 编辑文件，如果文件不存在，它会被自动创建
file.edit('~/.Renviron')
#### 在.Renviron文件中添加下方代码：将当前用户目录下的R文件夹作为附加包的安装路径
R_LIBS_USER="~/R"

### 1.4.2 .Rprofile文件
#### 编辑文件
file.edit('~/.Rprofile')
#### 设置安装镜像地址
options(repos = c(CRAN = "https://mirrors.tongji.edu.cn/CRAN/"))

### 1.4.3 环境变量
#### 把C:\Software\R\bin添加到环境变量中，以便命令行直接调用R
#### 配置好之后，还可以在命令行中直接执行R文件
#### R -f test.R
#### Rscript test.R

### 1.4.4 windows的Rconsole文件
#### 查询文件的路径
file.path(R.home('etc'), 'Rconsole')
#### 设置字体：font = TT DejaVu Sans Mono
#### 设置语言：language = en


