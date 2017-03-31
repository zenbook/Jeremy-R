
# load packages ----------------------------------------------------------------------
library('plotly')
library('dplyr')

## try coding below to see if plotly is correctly installed --------------------------
plot_ly(z = ~volcano)

# first case ggplotly() --------------------------------------------------------------
head(txhousing)
txh <- sample_n(txhousing, size = 400, replace = F)
p <- ggplot(txh, aes(x = date, y = median, group = city)) + 
  geom_line(alpha = 0.2)
subplot(
  p,
  ggplotly(p, tooltip = 'city'),
  ggplot(txh, aes(date, median)) + geom_bin2d(),
  ggplot(txh, aes(date, median)) + geom_hex(),
  nrows = 2, 
  shareX = TRUE, 
  shareY = TRUE,
  titleX = FALSE, 
  titleY = FALSE
)  

# second case plot_ly() --------------------------------------------------------------
tx <- group_by(txh, city)
p <- plot_ly(tx, x = ~date, y = ~median)
head(plotly_data(p))
add_lines(
  add_lines(p, alpha = 0.2, name = 'Texan cities',hoverinfo = 'none'),
  name = 'Houston', data = filter(tx, city == 'Houston')
)



allCities <- txhousing %>%
  group_by(city) %>%
  plot_ly(x = ~date, y = ~median) %>%
  add_lines(alpha = 0.2, name = "Texan Cities", hoverinfo = "none")

allCities %>%
  filter(city == "Houston") %>%
  add_lines(name = "Houston")



bonus_day %>% 
  filter(QUOTA_ID == 'CINFO') %>% 
  group_by(NAME) %>% 
  plot_ly(x = ~CREATE_DATE, y = ~ CUST_NUM) %>% 
  add_lines()


bonus_day$CREATE_DATE <- parse_date_time(bonus_day$CREATE_DATE, 
                                         orders = c('Ymd', 'mdy', 'dmY', 'ymd'))
bonus_day$CREATE_DATE <- as.Date(bonus_day$CREATE_DATE, format = "%Y-%m-%d")


bonus_day %>% 
  filter(QUOTA_ID == 'CINFO') %>% 
  group_by(CREATE_DATE, NAME) %>% 
  summarise(CUST_NUM = sum(CUST_NUM), BONUS_AMOUNT = sum(BONUS_AMOUNT)) %>% 
  arrange(NAME, CREATE_DATE) %>% 
  hchart('column', hcaes(x = CREATE_DATE, y = BONUS_AMOUNT, group = NAME))

bonus_day %>% 
  arrange(NAME, CREATE_DATE) %>% 
  hc_xAxis(categories = uniue(CREATE_DATE)) %>% 
  highchart() %>% 
  hc_add_theme(hc_theme_flat()) %>% 
  hc_add_series_labels_values(BONUS_AMOUNT)


  hchart(type = 'column', hcaes(x = CREATE_DATE, y = BONUS_AMOUNT, group = QUOTA_NAME)) %>% 
  
  hc_plotOptions(column = list(stacking = 'normal'))

p <- ggplot(bonus_day, aes(x = CREATE_DATE, y = BONUS_AMOUNT, group = NAME)) + 
  geom_line(aes(color = NAME))
ggplotly(p)











