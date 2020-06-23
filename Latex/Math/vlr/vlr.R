## Mock VLR
##
## See http://www1.up.poznan.pl/cb48/prezentacje/Oliveira.pdf
## for the pdf of the product of two normally distributed rv
## 

deltaHedging <- function() {
    p <- seq(0, 10, by=0.1)
    V <- 2*p^2
    delta  <- mean(V)/mean(p)

    plot(p, V, col='blue',
         xlab='Price',
         ylab='Value')
    lines(p, delta*p)
    abline(v=5, col='gray')

    portfolio <- V - delta*p
    plot(p, portfolio, type='l', xlab='Price')
    abline(v=5, col='gray')    
}




analyze <- function() {
    library(MASS)
    library(moments)
    library(xtable)
    set.seed(0)

    tariff <- 70
    fwdPrice <- 28
    wnLoad <- 600
    load <- rnorm(n=1000, mean=wnLoad, sd=0.05*600)
    epsilonP <- rnorm(n=1000, mean=0, sd=0.3)

    alpha <- (fwdPrice-24)/(wnLoad-500)
    beta <- fwdPrice - wnLoad*alpha
    a <- 1/alpha; b <- -beta/alpha

    price0 <- alpha*load + beta ## simple linear model    
    plot(price0, load)
    lines(21:35, a*(21:35) + b)

    ## quadratic tail
    price2 <- 0.04*load + 4 + 0.02*(1+sign(load-650))*(load-650)^2
    
    price2Fun <- function(load) {
        0.04*load + 4 + 0.02*(1+sign(load-650))*(load-650)^2
    }
    plot(500:700, price2Fun(500:700),
         ylab = 'Price, $/MWh', type='l', col='blue')
    lines(load, price0, col='red')
    
    
    vlrFun <- function(load, price, tariff, wnLoad) { ## unit
       (tariff - price) * (load/wnLoad - 1)
    }
    deltaVlr <- function(price, tariff, wnLoad) { ## unit
        (tariff + mean(price) - 2*price)*a/wnLoad
    }
        
    meanVlr <- -mean(load*price0)/mean(load) + mean(price0)
    meanVlr  # in $/MWh
    ## == -cov(load,price)/mean(load)
    ## == -cor(load,price)*sd(price)*sd(load)/mean(load)
    
    ## with tariff == mean price
    vlr0 <- vlrFun(load, price0, mean(price0), mean(load))
    print(summary(vlr0))
    xtable(t(as.matrix(summary(vlr0))))
    plot(hist(vlr0))
    plot(price0, vlr0, ylab='VLR, $/MWh', main='Tariff = mean(price)')
    

    ## with real tariff
    vlr1 <- vlrFun(load, price0, tariff, mean(load))
    print(summary(vlr1))
    plot(hist(vlr1))
    skewness(vlr1)
    kurtosis(vlr1)
    pStar <- (tariff + fwdPrice)/2
    maxVlr <- 
    print(paste('Price that makes Delta_VLR = 0 is:', pStar))
    plot(price0, vlr1,
         xlab='Price, $/MWh',  ylab='VLR, $/MWh',
        )
    lines(21:35, vlrFun(a*(21:35)+b, 21:35, tariff, mean(load)), col='blue')
    deltaVlr(fwdPrice, tariff, mean(load))
    
    
    
    
    ## with higher prices for higher loads
    vlr2 <- vlrFun(load, price2, tariff, mean(load))
    summary(vlr2)

    ## set the right working directory!
    pdf('img/vlr_vs_price.pdf')
    loadR <- 500:695 
    plot(price2Fun(loadR), vlrFun(loadR, price2Fun(loadR), tariff, mean(load)),
         main='',
         #log='x',
         type='l', col='blue', 
         xlab='Price, $/MWh',  ylab='VLR, $/MWh',
         ylim=c(-8,7)
         )
    points(price2Fun(load),
           vlrFun(load, price2Fun(load), tariff, mean(load)), col='blue')
    points(price0, vlrFun(load, price0, tariff, mean(load)), col='black')
    lines(price2Fun(loadR), vlrFun(loadR, price2Fun(loadR), tariff, mean(load)),
          col='blue')
    abline(h=0, col='gray')
    legend(75,7, legend=c("Linear model","Quadratic tail"), bty="n",
	     col=c('black', "blue"), lty=1, text.col=c('black', "blue"))
    dev.off()


    #################################################################
    ## stochastic model for price
    price3 <- price2 * exp(epsilonP)

    plot(load, price3)
    lines(500:700, price2Fun(500:700), col='blue')
    
    
    vlr3 <- vlrFun(load, price3, tariff, mean(load))
    summary(vlr3)

    loadS <-sort(load)
    ind <- order(load)
    plot(price3[ind], vlrFun(loadS, price3[ind], tariff, mean(load)),
         log='x')
    
    


    

}
