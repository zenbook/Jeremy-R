
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































