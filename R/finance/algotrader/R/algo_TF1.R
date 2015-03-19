# A simple trend following algorithm, one instrument only
# BUY  when stock is above MA for all the past MA_WINDOW days
# SELL when stock is below MA for all the past MA_WINDOW days
#

# example 1: trend following algo (inherits from Algo)
TF1 <- Algo$proto()

TF1$algoName         = "TrendFollowing1"
TF1$validSignalNames = c("NONE", "BUY", "SELL")

#####################################################################
# Required getter to extract the prices for a given barIndex
TF1$getPrices <- function(., barIndex){
  structure(as.numeric(.$hBars$x[barIndex,"Close"]), names="stock")
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
TF1$signalFunctions  = c(".buyFun", ".sellFun")
TF1$signalPriority   = c(1, 1)      # priority 0 is for signal "NONE"

# and the mapping between signal name and the quantity function. 
TF1$quantityFunctions <- structure(
   c(".qtyBuyFun", ".qtySellFun"), names = c("BUY", "SELL")    
)


#####################################################################
# How to adjust the quantity for this bar, given a trading signal
TF1$.qtyBuyFun <- function(., trader){
  trader$prevQty+1     # add +1 to the position
}
    
TF1$.qtySellFun <- function(., trader){
  trader$prevQty-1     # substract +1 from the position
}


#####################################################################
# Buy signal: If currentBar "Close" is above the MA for the last
#    MA_WINDOW days, buy.
#
TF1$.buyFun <- function(., trader)
{
  signal <- "NONE"
  N <- which(index(.$hBars$x)==trader$currentBar)  
  if (length(N) > 0){
    # if you stay above the MA for the last MA_WINDOW days
    cond <- as.numeric(.$hBars$x[(N-.$MA_WINDOW):N,"Close"]) >
      as.numeric(.$hBars$xOther[(N-.$MA_WINDOW):N, "MA"])
  
    if (all(cond))
      signal <- "BUY"
  }
  
  return( signal )
}

TF1$.sellFun <- function(., trader)
{
  signal <- "NONE"
  N <- which(index(.$hBars$x)==trader$currentBar)
  if (length(N) > 0){
    # if you stay below the MA for the last MA_WINDOW days
    cond <- as.numeric(.$hBars$x[(N-.$MA_WINDOW):N,"Close"]) <
      as.numeric(.$hBars$xOther[(N-.$MA_WINDOW):N, "MA"])

    if (all(cond))
      signal <- "SELL"
  }
  
  return( signal )
}


TF1$signalValidation <- function(.)
{
  # do nothing for now ... 
  validatedSignal <- .$tradingSignal[as.character(.$currentBar)]

##   if (signal != "LIQUIDATE"){
##     if (.$tradingSignal[i-1] == signal)  # don't repeat previous signal
##       validatedSignal <- "NONE"
##   } 
  
  return( validatedSignal )
}



             
#####################################################################
# Make the other variables
TF1$.makeOtherVars <- function(x, MA_WINDOW)
{
  hBarsOther <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=MA_WINDOW, mean, na.pad=TRUE, by.column=FALSE,
    align="right")
  dim(hBarsOther) <- c(length(hBarsOther),1)
  colnames(hBarsOther) <- "MA"

  aux <- rollapply(x[,grep("Close", colnames(x)), drop=FALSE],
    width=MA_WINDOW, sd, na.pad=TRUE, by.column=FALSE,
    align="right")
  dim(aux) <- c(length(aux),1)
  colnames(aux) <- "sd"

  hBarsOther <- cbind(hBarsOther, aux)
  
  return(hBarsOther)
}

#####################################################################
# constructor method            
TF1$new <- function(., x, MA_WINDOW = 20)
{  
  if (!("Close" %in% colnames(x)))
    stop("Historical data for the instrument does not have a Close column!")
  
  .$proto(
    MA_WINDOW = 20,     # how many bars to use for the MovingAverage
    hBars = list(x=x, xOther=.makeOtherVars(x, MA_WINDOW))
  )
}

#cat("The proto class object 'TF1' has been created in the .GlobEnv.\n")
#cat("Instantiate it with TF1.new()\n")
















# decided not to use a signal validation.  Can be incorporated into the
# signal itself.
## #########################################################################
## # Validate a trading signal based on some rules ... 
## # Value: boolean.  If TRUE the signal will held.
## #
