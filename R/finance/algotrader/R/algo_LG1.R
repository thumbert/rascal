# A simple long gamma strategy.  Long a call, short the stock.
# Rebalance by buying/selling stock only. 
# BUY/SELL stock when net delta is a fraction f of initial stock position.
#

# example 1: long gamma algo (inherits from Algo)
LG1 <- Algo$proto()

LG1$algoName         = "Long Gamma (long call, short stock) 1"
LG1$validSignalNames = c("NONE", "REBALANCE")

#####################################################################
# Required getter to extract the prices for a given barIndex
LG1$getPrices <- function(., currentBar){
  structure(as.numeric(.$hdata[currentBar,c("Close.stock", "Close.call")]),
            names=c("stock", "call"))
}

#####################################################################
# Register the signal functions.
#
LG1$signalFunctions  = c(".rebalanceFun")
LG1$signalPriority   = c(1)      # priority 0 is for signal "NONE"

# and the mapping between signal name and the quantity function. 
LG1$quantityFunctions <- structure(
   c(".qtyRebalanceFun"), names = c("REBALANCE")    
)


#####################################################################
# The quantity for this bar for a trading signal.
#
LG1$.qtyRebalanceFun <- function(., trader)
{
  netQty <- trader$prevQty["stock"] +
    trader$prevQty["call"]*.$hdata[trader$currentBar, "delta"]

  Qty <- trader$prevQty
  Qty["stock"] <- Qty["stock"] - netQty

  Qty
}
    

#####################################################################
# Buy signal: If currentBar "Close" is above the MA for the last
#    MA_WINDOW days, buy.
#
LG1$.rebalanceFun <- function(., trader)
{
  signal <- "NONE"

  q0Stock <- abs(trader$q0["stock"])      # q0Stock is negative
  netQty  <- trader$prevQty["stock"] +
    trader$prevQty["call"]*.$hdata[trader$currentBar, "delta"]

  if ((netQty >= .$FRACTION*q0Stock) | (netQty <= -.$FRACTION*q0Stock))
    signal <- "REBALANCE"    
    
  return( signal )
}

             
#####################################################################
# constructor method            
LG1$new <- function(., x, FRACTION = 0.20)
{  
  .$proto(
    FRACTION = FRACTION,     # when to rebalance
    hdata = x
  )
}


















# decided not to use a signal validation.  Can be incorporated into the
# signal itself.
## #########################################################################
## # Validate a trading signal based on some rules ... 
## # Value: boolean.  If TRUE the signal will held.
## #
