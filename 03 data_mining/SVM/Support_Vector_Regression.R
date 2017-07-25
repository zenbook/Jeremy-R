
# library packages =====================================================
library(tidyverse)
library(e1071)

# prepare data =========================================================
data <- read.csv('regression.csv', header = TRUE)
ggplot(data, aes(X, Y)) + 
  geom_point() + 
  geom_smooth(method = 'loess')

# linear regression modeling ===========================================
## model
lm_model <- lm(Y ~ X, data)
attributes(lm_model)
## predict
lm_model$fitted.values
prediecty <- predict(lm_model, data)
## plot
plot(data, pch = 16)
abline(lm_model)
points(data$X, prediecty, col = 'blue', pch = 4)
## model performance
rmse <- function(error){
  sqrt(mean(error^2))
}
rmse(lm_model$residuals)
## 均方误差=5.70

# Support Vector Regression modeling ===================================
## model
svr_model <- svm(Y ~ X, data)
attributes(svr_model)

## predict
svr_model$fitted
prediecty2 <- predict(svr_model, data)

## plot
points(data$X, svr_model$fitted, col = 'red', pch = 4)

## model performance
rmse(svr_model$residuals)
## 均方误差只有3.16，明显好于线性模型


# tuning support vector regression model ===============================
## 调参，通过设置更合适的参数，得到更好的模型
## 在得到更好的模型时，要注意过拟合问题
## grid search
tune1 <- tune(svm, Y ~ X, data = data, 
              ranges = list(epsilon = seq(0, 1, 0.1), 
                            cost = 2^(2:9)))
attributes(tune1)
print(tune1)

## best model and its performance
tune1$best.performance
tune1$best.model
## best performance:9.107908 = MSE,
## RMSE = sqrt(MSE)
sqrt(tune1$best.performance)
## 均方误差3.02，比上一个模型更好

## use best model to predict
tune1$best.model$fitted
predicty3 <- predict(tune1$best.model, data)

## plot
plot(tune1)
## the darker the better

## change the range parameter of tune, make another tune
tune2 <- tune(svm, Y ~ X, data = data, 
              ranges = list(epsilon = seq(0, 0.3, 0.01), 
                            cost = 2^(2:9)))
## best model
tune2$best.model
tune2$best.performance
tune2$best.parameters
sqrt(tune2$best.performance)

## predict
tune2$best.model$fitted
predicty4 <- predict(tune2$best.model, data)

## plot
plot(tune2)
plot(data, pch = 16)
abline(lm_model)
points(data$X, tune2$best.model$fitted, col = 'red', pch = 4)














