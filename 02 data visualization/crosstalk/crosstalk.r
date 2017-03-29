
# loading packages ---------------------------------------------------------------------------
library('crosstalk')
library('leaflet')
library('DT')
library('plotly')

# Wrap data frame in SharedData --------------------------------------------------------------
data("quakes")
sd <- SharedData$new(quakes[sample(nrow(quakes), 100),])

# Create a filter input ----------------------------------------------------------------------
filter_slider("mag", "Magnitude", sd, column=~mag, step=0.1, width=250)

# Use SharedData like a dataframe with Crosstalk-enabled widgets -----------------------------
bscols(
  leaflet(sd) %>% addTiles() %>% addMarkers(),
  datatable(sd, extensions="Scroller", style="bootstrap", class="compact", width="100%",
            options=list(deferRender=TRUE, scrollY=300, scroller=TRUE))
)


shared_iris <- SharedData$new(iris)
bscols(
  d3scatter(shared_iris, ~Petal.Length, ~Petal.Width, ~Species, width="100%", height=300),
  d3scatter(shared_iris, ~Sepal.Length, ~Sepal.Width, ~Species, width="100%", height=300)
)











