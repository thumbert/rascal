data("cars")
model <- lm(dist ~ speed, data = cars)
new <- data.frame(speed = seq(3, 27, 1))
ci <- predict(model, new, interval="confidence", level=0.99)

plot(cars$speed, cars$dist)
abline(model, col="blue")
## these are the confidence intervals of the regression slope
lines(new$speed, ci[,"lwr"], col="gray")
lines(new$speed, ci[,"upr"], col="gray")

mse <- sd(model$residuals)
## assuming the residuals are normal, 95% CI of the observations 
## should fall between  
lines(new$speed, ci[,"fit"] - 1.65*mse, col="green")
lines(new$speed, ci[,"fit"] + 1.65*mse, col="green")






