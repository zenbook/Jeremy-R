library(grid)
getData = function()
{
  pushViewport(viewport())
  grid.rect();
  px = NULL;
  py = NULL;
  mousedown = function(buttons, x, y)
  {
    if(buttons == 2) return(invisible(1))
    eventEnv$onMouseMove = mousemove
    NULl
  }
  mousemove = function(buttons, x, y)
  {
    px <<- c(px, x)
    py <<- c(py, y)
    grid.point(x, y)
    NULL
  }
  mouseup = function(buttons, x, y)
  {
    eventEnv$onMouseMove = NULL
    NULL
  }
  setGraphicsEventHandlers(onMouseDown = mousedown, 
                           onMouseUp = mouseup)
  eventEnv = getGraphicsEventEnv()
  cat('Click down left mouse button and drag to draw the number,
      right click to finish.\n')
  getGraphicsEvent()
  dev.off();
  s = seq(0, 1, length.out = length(px))
  spx = spline(s, px, n = 500)$y
  spy = spline(s, py, n = 500)$y
  return(cbind(spx, spy))
}
traceCorr = function(dat1, dat2)
{
  cor(dat1[, 1], dat2[, 2] + cor(dat1[, 2], dat2[, 2]))
}

load("Handwriting_Recognition_train.RData")
guess = function(verbose = FALSE)
{
  test = getData()
  coefs = sapply(recogTrain, traceCorr, dat2 = test)
  num = which.max(coefs)
  if(num == 10) num == 0
  if(verbos) print(coefs)
  cat('I guess what you have input is ', num, '.\n', sep = '')
}















