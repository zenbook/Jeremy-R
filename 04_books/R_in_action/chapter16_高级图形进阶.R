
# ============================== library packages ==============================
library(lattice)
library(tibble)
library(tidyverse)

# ================================ 16.2 lattice ================================

tsinger <- as_tibble(singer)
histogram(~height | voice.part, data = tsinger)

barchart(height ~ voice.part, data = tsinger)
barchart(voice.part ~ height, data = tsinger)
bwplot(height ~ voice.part, data = tsinger)
bwplot(voice.part ~ height, data = tsinger)
xyplot(Sepal.Length ~ Sepal.Width, 
       data = iris, 
       col = "blue", 
       pch = c(3))

tsinger %>% 
  group_by(voice.part) %>% 
  summarise(hm = mean(height))

# lattice图形示例
tmtcars <- as_tibble(mtcars)
attach(tmtcars)
gear <- factor(tmtcars, 
               levels = c(3, 4, 5), 
               labels = c('3 gears', '4 gears', '5 gears'))
cyl <- factor(tmtcars, 
              levels = c(4, 6, 8), 
              labels = c('4 cylinders', '6 cylinders', '8 cylinders'))
densityplot(~ mpg)
densityplot(~ mpg | cyl, data = tmtcars)
bwplot(cyl ~ mpg | gear, data = tmtcars)
xyplot(mpg ~ wt | cyl * gear, data = tmtcars)
cloud(mpg ~ wt * qsec | cyl, data = tmtcars)
dotplot(cyl ~ mpg | gear, data = tmtcars)
splom(tmtcars[c(1, 3, 4, 5, 6)])
detach(tmtcars)

## 把图形保存到一个变量中
mygraph <- densityplot(~ height | voice.part, data = tsinger)
plot(mygraph)

## update图形
update(mygraph, 
       col = 'blue', 
       pch = 16, 
       cex = 0.8, 
       jitter = 0.05, 
       lwd = 2)




























