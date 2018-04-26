# 说明：利用rPython包在R中调用Python

# 加载包
library(rPython)

# 调用Python函数
python.call('len', 1:3)

# 调用命令
python.exec('import pandas as pd')

python.exec("import numpy as np")

python.exec('import sys; print(sys.version)')

query_hive_sku = "/Users/yunshan/Downloads/test_python.py"
python.load(query_hive_sku)

system('which python')
