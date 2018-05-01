

# R和RStudio
install.packages('devtools')  # 通过devtools可安装非官方的R包
install.packages('swirl') # 教你用R

# 数据处理
install.packages('tidyverse') # 一个包就包含了很多包
install.packages('mice')  # 处理缺失数据
install.packages('lubridate') # 处理日期
install.packages('caret') # 应用广泛的数据处理包，必备
install.packages('VIM')   # 

install.packages('sqldf')  # sql query
install.packages('reshape2')
install.packages('xts')   #
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
install.packages('ggthemes')  # ggplot2的扩展包
install.packages('shiny')  # shiny
install.packages('shinydashboard')  # shinydashboard
install.packages('shinythemes')  # shinythemes
install.packages('plotly')   # 交互式图表
install.packages('wordcloud2')   # 新版词云
install.packages('rmarkdown') # 写文章/报告/可视化
install.packages('DT')  # 交互式报表
install.packages('highcharter')  # highchart for R
install.packages('dygraphs')  # 时间序列的可视化包
install.packages('crosstalk')  # 多图联动
install.packages('leaflet')  # 地图可视化
install.packages('GGally')
install.packages('htmltools')
library(devtools)


devtools::install_github('madlogos/recharts')  # madlogos的recharts，封装了百度echarts
devtools::install_github("rstudio/crosstalk")
install.packages('knitr')


install.packages('pROC')
devtools::install_github('yihui/xaringan')
devtools::install_github('jcheng5/bubbles')
devtools::install_github("jcheng5/d3scatter")
install.packages('treemap')  #
devtools::install_github('rstudio/shinyapps')
install.packages('rsconnect')  # 部署shinyapp时使用
install.packages('igraph')
install.packages('sysfonts')
install.packages('showtext')
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
