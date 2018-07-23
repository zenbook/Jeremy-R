library(ggmap)


murder <- subset(crime, offense == "murder")


qmplot(lon, lat, data = murder, colour = I('red'), size = I(3), darken = .3)

qmplot(long, lat, data = )
