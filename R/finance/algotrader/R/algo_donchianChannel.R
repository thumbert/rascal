# A simple trend following algorithm, one instrument only.
#
# The Donchian Channel upper bound is the rolling N day high.  The 
# lower bound is the rolling N day low.
#
# 1. When price closes above the Donchian Channel, buy long and cover
#    short positions.
# 2. When price closes below the Donchian Channel, sell short and
#    liquidate long positions.
#
# Portfolio filter: 
# - Initiate long  trades only when the MA50 > MA200 
# - Initiate short trades only when the MA50 < MA200
#

# NOT IMPLEMENTED/TESTED YET!

DC1 <- Algo$proto()

DC1$algoName         = "Donchian Channel"
DC1$validSignalNames = c("NONE", "BUY", "SELL", "LIQUIDATE")

#####################################################################
# Required getter to extract the prices for a given barIndex
DC1$getPrices <- function(., barIndex){
  structure(as.numeric(.$hBars[barIndex,"Close"]), names="stock")
}

#####################################################################
# Register the signal functions.  All signal functions
# need to return a valid signal name.  For different bars, a signal
# function can return different signal names (say, at t=1 fun1 returns "BUY",
# at t=2 fun1 returns "NONE" or "SELL" or other valid signal).  The final
# decision is determined based on signal function priority. 
#
# Each signal has a priority.  Highest priority wins.
# liquidate should beat everybody
DC1$signalFunctions  = c(".buyFun", ".sellFun", ".liquidateFun")
DC1$signalPriority   = c(1, 1, 2)   # priority 0 is for signal "NONE"

# and the mapping between signal name and the quantity function. 
DC1$quantityFunctions <- structure(
   c(".qtyBuyFun", ".qtySellFun", ".qtyLiquidateFun"),
   names=c("BUY", "SELL", "LIQUIDATE")    
)


#####################################################################
# How to adjust the quantity for this bar, given a trading signal
#
DC1$.qtyBuyFun <- function(., trader){
  structure(1, names=names(trader$q0))    # position = +1
}
    
DC1$.qtySellFun <- function(., trader){
  structure(-1, names=names(trader$q0))    # position = -1
}

DC1$.qtyLiquidateFun <- function(., trader){
  structure(0, names=names(trader$q0))     # flatten the position
}



#####################################################################
# Buy signal: 
#
DC1$.buyFun <- function(., trader)
{
  signal <- "NONE"
  N <- which(index(.$hBars)==trader$currentBar)  
  if (length(N) > 0){
    cond1 <- as.numeric(.$hBars[N,"Close"]) >=
             as.numeric(.$hBars[N,"channel.up"])
    cond2 <- as.numeric(.$hBars[N,"short.ma"]) >
             as.numeric(.$hBars[N,"long.ma"])
  
    if (cond1 & cond2)
      signal <- "BUY"
  }
  
  return( signal )
}

DC1$.sellFun <- function(., trader)
{
  signal <- "NONE"
  N <- which(index(.$hBars)==trader$currentBar)
  if (length(N) > 0){
    cond1 <- as.numeric(.$hBars[N,"Close"]) <=
             as.numeric(.$hBars[N,"channel.down"])
    cond2 <- as.numeric(.$hBars[N,"short.ma"]) <
             as.numeric(.$hBars[N,"long.ma"])
  
    if (cond1 & cond2)
      signal <- "SELL"
  }
  
  return( signal )
}

DC1$.liquidateFun <- function(., trader)
{
  signal <- "NONE"
  N <- which(index(.$hBars)==trader$currentBar)
  if (length(N) > 0){
    cond1 <- as.numeric(.$hBars[N,"Close"]) <=
             as.numeric(.$hBars[N,"channel.down"])
    if (cond1 & trader$prevQty > 0)
      signal <- "LIQUIDATE"

    cond2 <- as.numeric(.$hBars[N,"Close"]) >=
             as.numeric(.$hBars[N,"channel.up"])
    if (cond2 & trader$prevQty < 0)
      signal <- "LIQUIDATE"
  }
  
  return( signal )
}

#####################################################################
# Plot method for this algo
#
DC1$plot <- function(., trader, ...)
{
  yrange <- range(.$hBars[,c("channel.up", "channel.down")], na.rm=TRUE)
  graphics::plot(index(.$hBars), .$hBars[,"Close"], ylim=yrange,
    type="l", ...)
  graphics::lines(index(.$hBars), .$hBars[,"channel.up"], col="gray")
  graphics::lines(index(.$hBars), .$hBars[,"channel.down"], col="gray")
  graphics::lines(index(.$hBars), .$hBars[,"short.ma"], col="red")
  graphics::lines(index(.$hBars), .$hBars[,"long.ma"], col="blue")
  
}
               
#####################################################################
# Make the other variables
DC1$.makeOtherVars <- function(., x, CHANNEL_WINDOW, SHORT_MA, LONG_MA)
{
  short.ma <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=SHORT_MA, mean, na.pad=TRUE, by.column=FALSE,
    align="right")
  x <- merge(x, short.ma)

  long.ma <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=LONG_MA, mean, na.pad=TRUE, by.column=FALSE,
    align="right")
  x <- merge(x, long.ma)
  
  channel.up <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=CHANNEL_WINDOW, max, na.pad=TRUE, by.column=FALSE,
    align="right")
  x <- merge(x, channel.up) 
  
  channel.down <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=CHANNEL_WINDOW, min, na.pad=TRUE, by.column=FALSE,
    align="right")
  x <- merge(x, channel.down) 

  return(x)
}

#####################################################################
# constructor method            
DC1$new <- function(., x, CHANNEL_WINDOW=20, SHORT_MA=50, LONG_MA=200)
{  
  if (!("Close" %in% colnames(x)))
    stop("Historical data for the instrument does not have a Close column!")
  
  .$proto(
    CHANNEL_WINDOW = CHANNEL_WINDOW, # how many bars to use for channel
    SHORT_MA = SHORT_MA,
    LONG_MA = LONG_MA,
    hBars = .$.makeOtherVars(x, CHANNEL_WINDOW, SHORT_MA, LONG_MA)
  )
}

#cat("The proto class object 'DC1' has been created in the .GlobEnv.\n")
#cat("Instantiate it with DC1.new()\n")

