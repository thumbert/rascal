#S:/All/Risk/Software/R/R-2.10.0/bin/Rcmd build --force --binary --no-vignette H:/user/R/Adrian/algotrader/current

Sys.setenv(tz="")
#source("H:/user/R/Adrian/algotrader/R/RLogger.R")
require(zoo); require(xts); require(reshape); require(proto)
require(quantmod); require(TTR)
require(algotrader)

##########################################################################
# example_TF1.R
#

ticker <- "ADSK"
x <- getSymbols(ticker, from='2005-01-01', auto.assign=FALSE)
colnames(x) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")

#barIndex <- seq(as.Date("2008-01-01"), Sys.Date(), by="1 day")
barIndex <- index(x)[index(x) >= as.Date("2008-01-01")]


source("H:/user/R/Adrian/algotrader/R/Algo.R")

source("H:/user/R/Adrian/algotrader/R/example_TF1.R")
algo2 <- TF1$new(x, MA_WINDOW=20)
algo2$validate()


q0 <- structure(0, names="stock")  #  quantity at barIndex[1]

source("H:/user/R/Adrian/algotrader/R/Trader.R")
trd <- Trader$new(barIndex, q0)

trd$trade(algo2)


# add some extra bars ...
algo2 <- TF1$new(xNew, MA_WINDOW=20)
algo2$validate()


trd$extend(newBars)
trd$trade(algo2)


PnL <- trd$getPnL()
Qty <- trd$getPositions()

windows()
plot(PnL$totalPnL, type="l", col="blue")

windows()
trd$plot()



##########################################################################
# example_LG1.R
#
# prepare the data ...

#source("prepare_MEE_data.RData")
load("h:/user/R/Adrian/algotrader/data/hdata_LG1.RData") # loads hdata

source("H:/user/R/Adrian/algotrader/R/example_LG1.R")
algo1 <- LG1$new(hdata, FRACTION=0.15)
algo1$validate()


barIndex <- index(na.omit(hdata))
q0 <- structure(c(-650, 1000), names=c("stock", "call"))

source("H:/user/R/Adrian/algotrader/R/Trader.R")
trd <- Trader$new(barIndex, q0, cash0=20000)

trd$trade(algo1)

trd$summary()

PnL <- trd$getPnL()
Qty <- trd$getPositions()

windows()
plot(PnL$MTM, type="l", col="blue")



ind <- names(trd$tradingSignal[which(trd$tradingSignal != "NONE")])
trd$PnL[ind]

MM  <- melt(trd$PnL)
MMM <- cast(MM, L1 ~ L2, I, fill=NA)
head(MMM, 25)






##########################################################################
# Donchian Channel Breakout
#
# 

ticker <- "ADSK"
x <- getSymbols(ticker, from='2005-01-01', auto.assign=FALSE)
colnames(x) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")

barIndex <- index(x)[index(x) >= as.Date("2008-01-01")]


#source("H:/user/R/Adrian/algotrader/R/example_donchianChannelBreakout.R")
source("C:/user/R/algotrader/R/example_donchianChannelBreakout.R")
algo <- DC1$new(x, CHANNEL_WINDOW=20, SHORT_MA=50, LONG_MA=200)
algo$validate()

algo$plot()

q0 <- structure(0, names="stock")  #  quantity at barIndex[1]

#source("H:/user/R/Adrian/algotrader/R/Trader.R")
source("C:/user/R/algotrader/R/Trader.R")
trd <- Trader$new(barIndex, q0)

trd$trade(algo)


trd$summary()

PnL <- trd$getPnL()
Qty <- trd$getPositions()

windows()
plot(PnL$MTM, type="l", col="blue")

windows()
trd$plot()





ind <- names(trd$tradingSignal[which(trd$tradingSignal != "NONE")])
trd$PnL[ind]

MM  <- melt(trd$PnL)
MMM <- cast(MM, L1 ~ L2, I, fill=NA)
head(MMM, 25)


algo$algoplot()

















##########################################################################
# High frequency ADSK
#
# 

load("H:/Temporary/Data/IB/ADSK.RData")
load("H:/Temporary/Data/IB/ES200909.RData")


chartSeries(ADSK)

source("H:/user/R/Adrian/findataweb/algos/1M_freq_1.R")
algo <- HF1M$new(ADSK)





plot(index(ADSK))



r <- ADSK$Volume/ES200909$Volume
r <- r[is.finite(r)]
windows(); plot(na.omit(r))



##########################################################################
# Trend Breaker
#
#

ticker <- "AAPL"
x <- getSymbols(ticker, from='2005-01-01', auto.assign=FALSE)
colnames(x) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")


source("H:/user/R/Adrian/findataweb/algos/trendBreaker1.R")
algo <- TB$new(x)
algo2$validate()


barIndex <- index(x)[index(x) >= as.Date("2008-01-01")]
q0 <- structure(0, names="stock")  #  quantity at barIndex[1]

source("H:/user/R/Adrian/algotrader/R/Trader.R")
trd <- Trader$new(barIndex, q0)

trd$trade(algo2)




























































































##########################################################################
##########################################################################

Qty <- unlist(lapply(trd$PnL, "[", "Qty"))
plot(trd$barIndex, Qty, type="l", col="blue")

algo$.buyFun(trd, currentBar)


a <- proto(x=1:3, mult=function(., f){.$x*f}, y=function(.) sum(.$x))
a$z <- a$mult(5)


           z=.$mult(5) )


# Examples of proto objects
a <- proto(mult=function(x, f){x*f}, another=function(.){.$z = log(.$x)}, 
  new = function(.,x){proto(x=x,
                      y=mult(x,3))})
a1 <- a$new(1:5)

# create a new variable in the env
a1.another()  # creates variable z!



# Inheritance in proto land
A <- proto(x=1, y=1, afun=function(x){x*2}, bfun=function(.,x){x*2})
A$afun(2)  # error!
A$bfun(2)  # works!
with(A, afun(2))  # 4
with(A, afun)(2)  # 4, works too  


#####################################################################
# class variables vs. Instance variables
Circle <- proto(
  noCircles = 0,                      # class variable
  radius    = numeric(),              # instance variable
  area = function(.){pi*.$radius^2},  # class method
  new  = function(., radius){
    .$noCircles <- .$noCircles + 1    # create a new Circle object
    .$proto(radius = radius)          # return the object
  })

c1 <- Circle$new(1)
c2 <- Circle$new(2)

c1$radius
c1$area()
c2$area()
Circle$noCircles







## x$r <- NA
## x$r[2:nrow(x)] <- (as.numeric(x$Close[2:nrow(x)]) -
##   as.numeric(x$Close[1:(nrow(x)-1)]))/as.numeric(x$Close[1:(nrow(x)-1)])

## plot(as.numeric(x$Volume), as.numeric(x$r), log="x")





require(zoo); require(FinDataWeb)
ticker <- "IBM"
ticker <- "ALTR"
hBars  <- downloadYahoo(ticker, startDate=Sys.Date()-5*365,
  what=c("Open", "High", "Low", "Close")) 
hBars <- zoo(hBars[,-(1:2)], hBars[,2])


#setwd("C:/Users/adrian/R/findataweb/")
#setwd("H:/user/R/Adrian/findataweb/")
setwd("C:/user/R/FinDataWeb/")

source("R/RLogger.R")
source("R/allGenerics.R")
source("R/ClassAlgo.R")

source("R/ClassAlgoTrendFollowing.R")
alg <- new(Class="AlgoTrendFollowing", name="trendAlgo",
           instrumentName="stock", MA_WINDOW=50)

source("R/ClassAlgoMeanReversion.R")
alg <- new(Class="AlgoMeanReversion", name="meanReversionAlgo",
  instrumentName="stock", MR_WINDOW=2*252)

registerAlgo(c("AlgoMeanReversion", "AlgoTrendFollowing"))

source("R/ClassTrader.R")
trd <- new(Class="Trader", traderName=ticker, hBars=hBars, algo=alg,
  barIndex=barIndex)

trade(trd)
trd@tradingSignal


generateSignal(trd)  # run the Algo on the trader
trd@tradingSignal

calcPerformance(trd)

plot(trd)










changeQuantity(trd)
trd@tradingSignal

.calcAvgP(trd)

plot(trd)







## buyFun(alg, trd@currentBar, trd@hBars, trd@hBarsOther)
## sellFun(alg, trd@currentBar, trd@hBars, trd@hBarsOther)

## getTradingDecision(trd)
## getCurrentBar(trd)

## validateSignal(trd)
