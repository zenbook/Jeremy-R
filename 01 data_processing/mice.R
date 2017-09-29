# library packages ===========================================================
library(mice)

# explore dataset ============================================================
head(nhanes)
str(nhanes)
## missing values
md.pattern(nhanes)
