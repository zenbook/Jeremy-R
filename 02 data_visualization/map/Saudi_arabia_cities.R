# load pacckages =============================================================
library('leaflet')
library('magrittr')
library('sp')
library('maps')
library('htmltools')

# load data ==================================================================

saudi_arabia_cities <- read.csv('./Saudi_arabia_city_longitude_latitude.csv', 
                                sep = ',')
saudi_arabia_cities$receipt_rate <- rnorm(158, 0.7, 0.1)


# plot maps ==================================================================
leaflet(saudi_arabia_cities) %>% 
  addTiles() %>% 
  addCircleMarkers(color = ~ifelse(receipt_rate >= 0.8, 'green', 'red'))
  













