

# R和RStudio
install.packages('devtools')  # 安装非官方的R包
install.packages('rattle', dep = T)  # 可交互的数据挖掘界面
install.packages("rstudioapi")
devtools::install_github("rstudio/rstudioapi")
install.packages('swirl')

# 数据处理
install.packages('dplyr')
install.packages('xlsx')
install.packages('VIM')   #
install.packages('mice')  #
install.packages('sqldf')  # sql query
install.packages('reshape2')
install.packages('openxlsx')
install.packages('xts')   #
install.packages('caret')
install.packages('RCurl')
install.packages('RANN')
install.packages('datalegreyar')
install.packages('seriation')
install.packages('feather')




# 连接数据库
install.packages('RODBC')   # ODBC方式连接数据库，更适合windows系统
install.packages('RJDBC')   # JDBC方式连接数据库，更适合Linux系统
install.packages('RMySQL')  # 连接MySQL数据库的包
install.packages('ROracle') # 连接Oracle数据库的包

# 描述性统计/可视化/报告
install.packages('ggplot2')
install.packages('shiny')
install.packages('shinydashboard')
install.packages('shinythemes')
install.packages('wordcloud2')   # 新版词云
install.packages('rmarkdown') # 写文章/报告/可视化
install.packages('DT')  # 可交互的表格(排序/筛选/分页)
install.packages('plotly')   # ggplotly
devtools::install_github('yihui/recharts')  # 谢益辉修改的recharts，封装了百度echarts
install.packages('knitr')
install.packages('pROC')
devtools::install_github('yihui/xaringan')
install.packages('highcharter')
devtools::install_github('jcheng5/bubbles')
devtools::install_github("jcheng5/d3scatter")
devtools::install_github("rstudio/crosstalk")
install.packages('treemap')  #
devtools::install_github('rstudio/shinyapps')
install.packages('rsconnect')  # 部署shinyapp时使用
devtools::install_github('rstudio/leaflet')
install.packages('igraph')
install.packages('dygraphs')
install.packages('sysfonts')
install.packages('showtext')
install.packages('ggthemes')
install.packages('Cairo')  #
install.packages("visNetwork")
install.packages('ggstance')
install.packages('lvplot')
install.packages('ggbeeswarm')

# can have new features in developpement version
devtools::install_github("datastorm-open/visNetwork")
install.packages(
  'printr',
  type = 'source',
  repos = c('http://yihui.name/xran', 'http://cran.rstudio.com')
)
install.packages('openair')  #????ͼ
install.packages('googleVis')  #google visualization api



# 数据挖掘算法包
install.packages('C50')        # 决策树
install.packages('randomForest')     # 随机森林
install.packages('rpart')   #
install.packages('nnet')      #
install.packages('e1071')    #
install.packages("pbapply")
install.packages("RcppProgress")


install.packages('tseries')       #ʱ??????
devtools::install_github('dmlc/xgboost', subdir = 'R-package')
install.packages('sjmisc')      #?߼??ع????????Ŷȼ???



install.packages('tree')     #CART????????
install.packages('arules')    #??��????apriori()??Ӧ?İ?arules
install.packages('forecast')   #ʱ?????е?Ԥ????
install.packages('rpart.plot')   #????????ͼ
install.packages('party')    #????????
install.packages('jiebaR')   #?ִ?
install.packages('Rweibo', repos = 'http://R-Forge.R-project.org', type = 'source')
install.packages('fastcluster')   #???ٲ??ξ???
install.packages('proxy')   #???ҵȼ????????İ?
install.packages('fpc')   #?Զ?̽?????ѵľ?????
install.packages('kohonen')   #????֯ӳ??SOM
install.packages('mlbench')
install.packages('TTR')   #quantmod??��?İ?
install.packages('Defaults')   #quantmod??��?İ?
install.packages('nlstools')
install.packages('adabag')
install_github('lijian13/tmcn')


# 其他
devtools::install_github('lijian13/rinds')    # <数据科学中的R语言>书籍的示例包

install.packages('RGtk2')  #

install.packages('fortunes')   # R???ǻ???¼
install.packages('formatR')  # R?????Զ????Ű?
install.packages('MSG')  # л?????顶?ִ?ͳ??ͼ?Ρ??İ?

install.packages('networkD3')
install.packages('threejs')
install.packages('datasets')

devtools::install_github('Stiivi/bubbles')
devtools::install_github('hadley/shinySignals')
install.packages('SnowballC')
install.packages('DiagrammeR')
install.packages('magrittr')
install.packages('d3heatmap')
install.packages('scales')

devtools::install_github('lchiffon/REmap')
install.packages('maps')
install.packages('mapdata')
#devtools::install_github('timelyportfolio/d3treeR')
devtools::install_github('badbye/baidumap')
install.packages('maptools')
install.packages('ggmap')

install.packages('rgdal')
install.packages('ggplot2movies')
install.packages('dygraphs')
devtools::install_github('XD-DENG/ECharts2Shiny')
devtools::install_github('skardhamar/rga')

????
install.packages('gcookbook')
install.packages('UsingR')
install.packages('manipulate')
