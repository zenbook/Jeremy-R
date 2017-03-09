# 1. load multiple packages once
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, library, character.only = TRUE)
}
packages <- c("ggplot2", "RJDBC", "recharts", "dplyr", "shiny", "shinydashboard", "DT", "leaflet", "sqldf", "tidyr")
ipak(packages)


