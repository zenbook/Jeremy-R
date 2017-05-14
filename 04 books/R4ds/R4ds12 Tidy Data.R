
# library packages ========================================================
library(tidyverse)

# 12.2 Tidy data ==========================================================
# what's tidy data?
# Each variable must have its own column.
# Each observation must have its own row.
# Each value must have its own cell.
table1
table2
table3
table4a
table4b

table1 %>% 
  mutate(rate = cases / population * 10000)

table1 %>% 
  count(year, wt = cases)

ggplot(table1) + 
  geom_bar(aes(year, cases, fill = country), 
           stat = 'identity', 
           position = 'dodge')

# 12.3 spreading and gathering

























