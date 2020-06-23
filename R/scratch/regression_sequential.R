## Explore how bad it is to do a sequential regression (first regress one
## variable, then the other) vs. doing the regression on both variables
## at once.
##
## Conclusion:  It's bad.  You shouldn't do it.  May be relatively OK for
## insample prediction, but out of sample can be really bad. 
##

test <- function() {
    set.seed(0)
    beta <- c(3000, -0.005, 5)
    N <- 2*365
    x1 <- 1:N
    x2 <- sin(2*pi*(1:N)/365)
    error <- rnorm(N, sd=3) 
    
    ## generate data
    fun <- function(t) {
        beta[1] + beta[2]*t + beta[3]*sin(2*pi*t/365) + rnorm(length(t), sd=3)
    }

    data <- fun(x1)

    ## first regression
    lm1 <- lm(data ~ x1)
    plot(x1, data)
    abline(lm1, col='blue')
    summary(lm1)
    
    
    ## second regression
    resid1 <- lm1$residuals
    lm2 <- lm(resid1 ~ x2)
    px2 <- predict(lm2)
    X11()
    plot(x1, resid1)
    points(x1, px2, col='blue')
    summary(lm2)

    


    ## both regressions together recovers the correct coefficients
    lm3 <- lm(data ~ x1 + x2)
    px3 <- predict(lm3)
    X11()
    plot(x1, data)
    points(x1, px3, col='blue')
    
## Coefficients:
## (Intercept)           x1           x2  
##      3.4217      -0.2135      10.0340  
    summary(lm3)   
  
    
    
    
    
    
}


main <- function() {
    test()
}
