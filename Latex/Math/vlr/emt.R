



analyze <- function() {

    set.seed(1)
    n <- 100
    x <- 1.33 + rnorm(n, mean=0, sd=2)
    y <- 30*x + rnorm(n, mean=40, sd=5)
    x <- x + 5

    reg <- lm(y ~x)
    
    xM <- mean(x)
    yM <- mean(y)
    delta <- yM/xM
    x0 <- seq(0, 12, by=0.1)
    
    plot(x, y, col='blue', xlim = c(0, 10),
         ylim=c(0, 200),
         xlab='Gas price',
         ylab='EMT revenue, MM')
    lines(x0, x0*delta, col='black')
    lines(x0, coef(reg)[2]*x0 + coef(reg)[1], col='green')
    legend(0, 200,
           legend=c("data","AMP delta", 'financial delta',
                    '(E[Price], E[Revenue])'), bty="n",
           col=c('blue', 'black', "green", "red"),
           pch=c(1, NA, NA, 1),
           lty=c(NA, 1, 1, NA),
           text.col=c('blue', 'black', "green", "red"))

    points(xM, yM, pch=19, col='red')
    points(xM+1, delta*(xM+1), pch=19, col='purple', cex=2)
    points(xM+1, coef(reg)[2]*(xM+1) + coef(reg)[1], pch=19,
           col='darkgoldenrod', cex=2)


}
