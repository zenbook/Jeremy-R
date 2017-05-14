
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

# 12.3 spreading and gathering ============================================

## 12.3.1 gathering
table4a %>% 
  gather(`1999`, `2000`, key = 'year', value = 'cases')

table4b %>% 
  gather(`1999`, `2000`, key = 'year', value = 'population')

tidy4a <- table4a %>% 
  gather(-country, key = 'year', value = 'cases')

tidy4b <- table4b %>% 
  gather(-country, key = 'year', value = 'population')

left_join(tidy4a, tidy4b)

## 12.3.2 spreading
## spread正是gather的逆操作
spread(table2, key = type, value = count)


















