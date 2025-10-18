# install.packages("quantmod")
library(quantmod)   

.yahooJsonURL <-
function(symbol, from, to, interval)
{
  u <- paste0("https://query2.finance.yahoo.com/v8/finance/chart/",
              symbol,
              sprintf("?period1=%.0f&period2=%.0f&interval=%s", from, to, interval))
  return(u)
}

.dateToUNIX <- function(Date) {
  posixct <- as.POSIXct(as.Date(Date, origin = "1970-01-01"))
  trunc(as.numeric(posixct))
}


.yahooJsonURL("QQQ", 
               from = .dateToUNIX("2012-01-01"), 
               to = .dateToUNIX("2025-10-15"), 
               interval = "1d")


laudau <- function(t, a, b, m, tc) {
  return(a + b * (1-t/tc)^m)
}

getSymbols("QQQ", from = "2012-01-01", to = "2025-10-15")
prices <- Cl(QQQ)
model <- lm(log(prices) ~ as.numeric(index(prices)))
plot(as.Date((index(prices))), as.numeric(prices), main = "QQQ Closing Prices", log="y", 
    xlab = "Date", ylab = "Price (log scale)")
lines(as.Date((index(prices))), exp(predict(model)), col = "red", lwd = 2)  # Estimated crash



plot(as.numeric(index(prices)), log(prices), type = "l", main = "QQQ Closing Prices", 
    xlab = "Date", ylab = "log(Price)")
y <- laudau(as.numeric(index(prices)), a = 7.5, b = -4.95, m = 0.25, tc = 21500)
lines(as.numeric(index(prices)), y, col = "red")
abline(lm(log(prices) ~ as.numeric(index(prices))), col = "blue", lty = 2)  # Estimated crash date




# Sornette's model for financial crashes
# prices(t) = A + B*(tc - t)^m + C*(tc - t)^m * cos(ω * log(tc - t) + φ)
# where A, B, C, m, ω, φ, and tc are parameters to be estimated
tc <- as.numeric(index(prices)[length(prices)]) + 30
model0 <- nls(log(prices) ~ a + b * (tc - as.numeric(index(prices)))^m,
             start = list(a = 6.5, b = -2.95, m = 0.25, tc = 20500),
             control = nls.control(maxiter = 1000000, tol = 1e-1))

            #  algorithm = "port",
            #  lower = c(0, -Inf, 0, as.numeric(index(prices)[length(prices)])),
            #  upper = c(Inf, 0, 1, as.numeric(index(prices)[length(prices)]) + 5*365))


model <- nls(prices ~ a + b * (tc - as.numeric(index(prices)))^m + c * (tc - as.numeric(index(prices)))^m * cos(omega * log(tc - as.numeric(index(prices))) + phi),
             start = list(a = 100, b = 0.0001, c = 0.0001, m = 1, omega = 1, phi = 0, tc = tc),
             control = nls.control(maxiter = 100, tol = 1e-6))




