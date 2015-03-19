# Trader class
#

Trader <- proto()

#####################################################################
# Extend a given trader with some extra bars
#
Trader$extend <- function(., newBars)
{
  if (min(newBars) < max(.$barIndex))
    stop("Cannot extend Trader.  Some newBars are overlapping with barIndex!")
  
  .$currentBar    <- newBars[1]  # start from the first new bar
  .$currentIndex  <- length(.$barIndex) + 1
  .$.startAtInd   <- .$currentIndex  # modified only by .$new and .$extend 
  .$barIndex      <- c(.$barIndex, newBars)
  .$tradingSignal <- c(.$tradingSignal, structure(rep("NONE",
    length=length(newBars)), names=as.character(newBars)))
  .$PnL <- c(.$PnL, structure(rep(list(NULL), length(newBars)),
      names=as.character(newBars)))
}


#####################################################################
# Decide what to do in currentBar, and update tradingSignals for the 
# currentBar. 
#
Trader$trade <- function(., algo)
{
  if (.$.startAtInd == 1){  # if start from the beginning
    .$currentBar  <- as.character(.$barIndex[1])  
    .$prevSignal  <- NULL     # previous signal != "NONE"
    .$prevQty     <- .$q0     # initialize
    .$prevAvgP    <- algo$getPrices(.$currentBar)
    .$prevCash    <- .$cash0
  } else {   # else the trader was extended
    rLog("Restart trading at", as.character(.$startAtBar))
  }

  # order the algo signal functions by priority
  functions <- paste("algo$", algo$signalFunctions, "(.)", sep="")
  functions <- functions[order(algo$signalPriority, decreasing=TRUE)]
  
  # loop over bars
  for (i in .$.startAtInd:length(.$barIndex))    
  {
    .$currentBar   <- as.character(.$barIndex[i])
    .$currentIndex <- i   # define it for convenience     
    rLog("Working on bar:", .$currentBar)

    # loop over signal functions 
    for (f in 1:length(functions)){
      thisSignal <- eval(parse(text=functions[f]))
    
      if (thisSignal!="NONE"){   # stop when you have a non-null signal
        rLog("SIGNAL:", paste(thisSignal))
        .$tradingSignal[.$currentBar] <- thisSignal
        break
      }
    }

    if (.$tradingSignal[.$currentBar]=="NONE")
    {
      # copy previous position,AvgPrice to this bar
      .$PnL[[i]]$Qty         <- .$prevQty
      .$PnL[[i]]$instrument  <- names(.$prevQty)
      .$PnL[[i]]$AvgP        <- .$prevAvgP
      .$PnL[[i]]$price <- algo$getPrices(.$barIndex[.$currentIndex])
      .$PnL[[i]]$realizedPnL <- structure(rep(0,
         length(.$prevQty)), names=names(.$prevQty))
      .$PnL[[i]]$unrealizedPnL <- (.$PnL[[i]]$price - .$prevAvgP)*.$prevQty
      .$PnL[[i]]$cash <- .$prevCash
      next
    }

    rLog("Adjust portfolio positions ...")
    .$.adjustPositions(algo)

    rLog("Calculate average price and PnL ...")
    .$.calcPnL(algo)

    # prepare for next bar
    .$prevSignal <- .$tradingSignal[.$currentBar]
    .$prevQty    <- .$PnL[[.$currentBar]]$Qty
    .$prevAvgP   <- .$PnL[[.$currentBar]]$AvgP
    .$prevCash   <- .$PnL[[.$currentBar]]$cash
    # if I get out of some instruments I have to remove them here
    
  } # end of loop over bars

  # get the unique instruments
  aux <- lapply(.$PnL, "[[", "Qty")
  .$uInstruments <- unique(unlist(lapply(aux, function(x)names(x))))
  
  invisible()
}

#####################################################################
# Adjust the positions by instruments based on the trading rules to 
# the tradingSignal list.  Called from trade method.
# i - is the index of the bar we're at.
#
Trader$.adjustPositions <- function(., algo)
{
  thisSignal <- .$tradingSignal[.$currentBar]

  if (!(thisSignal %in% names(algo$quantityFunctions)))
    stop("Cannot find signal name ", thisSignal, "among your algo ",
         "changeQty names!")

  # eval the signal function
  functionName <- algo$quantityFunctions[thisSignal]
  QQ <- eval(parse(text=paste("algo$", functionName, "(.)")))

  .$PnL[[.$currentBar]]$Qty   <- QQ
  .$PnL[[.$currentBar]]$instrument <- names(QQ)

  invisible()
}


#####################################################################
# Add the AvgP by instruments to the tradingSignal list.
# Called from trade.
# 
#
Trader$.calcPnL <- function(., algo)
{
  Qty <- .$PnL[[.$currentBar]]$Qty
  # current Qty has the same or more elements that .$prevQty
  prevQty <- prevAvgP <- realizedPnL <-
    structure(rep(0, length(Qty)), names=names(Qty))
  prevQty[names(.$prevQty)]   <- .$prevQty   # fill new positions with 0's
  prevAvgP[names(.$prevAvgP)] <- .$prevAvgP  # fill old AvgP with 0's
  
  # get prices in current bar
  prices <- algo$getPrices(.$barIndex[.$currentIndex])
  prices <- prices[names(Qty)]  # I can have more prices 

  prevAvgV <- structure(rep(0, length(Qty)), names=names(Qty))
  prevAvgV[names(.$prevQty)] <- .$prevAvgP*.$prevQty
  
  AvgPNew <- (prevAvgV + prices*(Qty-prevQty))/Qty
  AvgPNew[!is.finite(AvgPNew)] <- 0   # if some Qty == 0

  # if you cross 0 with your trade 
  i <- (prevQty>0 & Qty<0) | (prevQty>0 & Qty<0)
  AvgPNew[i] <- prices[i]
  
#  if (.$currentBar > "2009-05-29 09:00:00") browser()
  dq  <- Qty - prevQty
  # If you sell a long position 
  i <- which(dq<0 & prevQty>0)
  if (length(i)>0)  
    realizedPnL[i] <- (prevQty[i]-pmax(Qty[i],0))*(prices[i]-prevAvgP[i]) 

  # If you cover a short position
  i <- which(dq>0 & prevQty<0)  
  if (length(i)>0)  
    realizedPnL[i] <- (prevQty[i]-pmin(Qty[i],0))*(prices[i]-prevAvgP[i])
  
  .$PnL[[.$currentBar]]$price <- prices   # transaction price
  .$PnL[[.$currentBar]]$AvgP  <- AvgPNew  # average price of position
  .$PnL[[.$currentBar]]$realizedPnL   <- realizedPnL
  .$PnL[[.$currentBar]]$unrealizedPnL <- (prices - AvgPNew)*Qty - realizedPnL
  .$PnL[[.$currentBar]]$cash <- .$prevCash + sum(realizedPnL) - sum(dq*prices)
  
  invisible()  
}

#####################################################################
# a getter for the PnL
#
Trader$getPnL <- function(.)
{
  PnL <- xts(matrix(0, ncol=4, nrow=length(.$barIndex)), barIndex)
  colnames(PnL) <- c("unrealizedPnL", "realizedPnL", "totalPnL", "MTM")
  PnL[,1] <- unlist(lapply(lapply(.$PnL, "[[", "unrealizedPnL"), sum))
  PnL[,2] <- unlist(lapply(lapply(.$PnL, "[[", "realizedPnL"), sum))
  PnL[,3] <- PnL[,1] + PnL[,2]
  
  PQ <- unlist(lapply(.$PnL, function(x){sum(x$price*x$Qty)}))
  PnL[,4] <- PQ + unlist(lapply(.$PnL, "[[", "cash"))
  
  PnL
}

#####################################################################
# a getter for the positions
# Fix it when you have multiple instruments!!!
Trader$getPositions <- function(., instrument)
{
  QL <- lapply(.$PnL, "[[", "Qty")
  
  QQ <- xts(matrix(0, ncol=length(.$uInstruments),
                   nrow=length(.$barIndex)), .$barIndex)
  colnames(QQ) <- .$uInstruments
  for (i in seq_along(.$uInstruments))
    QQ[,i] <- unlist(lapply(QL, "[[", .$uInstruments[i]))

  QQ
}

#####################################################################
# Define a plot method for the trader.  If you want to plot the  
# PnL or the quantity, use the getters
#
Trader$plot <- function(., colors, ...)
{
  # only for 1 instrument for now ... 
  if (length(.$uInstruments)>1){
    cat("Only traders with one instrument are implemented now.\n")
    return()
  }

  # collect the prices
  prices <- as.numeric(lapply(.$PnL, "[[", "price"))

  uSignals <- sort(toupper(unique(.$tradingSignal)))
  if (missing(colors)){
    uCols <- rep("black", length(uSignals))
    uCols[grep("^B", uSignals)] <- "green3"
    uCols[grep("^S", uSignals)] <- "red"
    names(uCols) <- uSignals
    cols <- uCols[.$tradingSignal]
  }
  ind <- which(.$tradingSignal == "NONE")  # remove these signals

  layout(matrix(1:2, 2, 1), widths=1, heights=c(3,1))
  par(mar=c(2,4,1,1))
  graphics::plot(.$barIndex, prices, type="l")
  points(.$barIndex[-ind], prices[-ind], col=cols[-ind], pch=20)
  LL <- uCols[-which(names(uCols)=="NONE")]
  legend("topleft", legend=names(LL), col=LL, text.col=LL, pch=20)

  Qty <- .$getPositions()
  graphics::plot(index(Qty), Qty[,1], main="", ylab="position", type="l")
  abline(h=0, col="gray")
  
  invisible()
}

#####################################################################
# Trade and performance summary
#
Trader$summary <- function(.)
{
  TS <- .$tradingSignal
  TS <- TS[which(TS!="NONE")]

  cat("\nTrader summary:\n")
  cat("From ", as.character(.$barIndex[1]), " to ",
      as.character(.$barIndex[length(.$barIndex)]), " (using ",
      length(.$barIndex), " periods)\n", sep="")
  cat("Total number of trades:", length(TS), "\n")
  TT <- table(TS, deparse.level=0)
  for (t in 1:length(TT))
    cat("Number of ", names(TT)[t], " trades: ", TT[t], "\n", sep="")
  

    
  invisible()
}

#####################################################################
# Constructor
#
Trader$new <- function(., barIndex, q0, cash0=0)
{                               
  if (missing(q0))
    stop("Please supply initial quantity, as a named vector.")
  if (is.null(names(q0)))
    stop("Please give initial quantity names attribute.")
    
  .$proto(                         # from Trader trait
    .startAtInd   = 1,      
    currentBar    = barIndex[1],   # start at first bar
    currentIndex  = 1,             # start at 1      
    barIndex      = barIndex,      # where do you want to trade at
    q0            = q0,            # initial quantity
    cash0         = cash0,         # initial cash amount 
    tradingSignal = structure(rep("NONE", length=length(barIndex)),
      names=as.character(barIndex)),      
    PnL = structure(rep(list(NULL), length(barIndex)),
      names=as.character(barIndex)),
    prevQty      = NULL,        # hold previous Qty
    prevSignal   = NULL,        # hold previous != "NONE" signal
    uInstruments = character(), # hold the unique instrument names
    class = "Trader")

}

#cat("The proto class object 'Trader' has been created in the .GlobEnv.\n")
#cat("Instantiate it with Trader.new()\n")





















    
      
##     # should you keep the trading signal?
##     rLog("Validate signal ...")
## #    browser()
## #    if (exists("signalValidation", ))
##     validatedSignal <- .$algo$signalValidation(.)
##     .$tradingSignal[as.character(.$currentBar)] <- validatedSignal
   
        
##     rLog("Adjust portfolio positions ...")
##     .$tradingSignal <- .adjustPositions(.Object, currentBar)

##     rLog("Calculate average price ...")
##     prices <- unlist(lapply(.$hBars, function(x, currentBar){
##         x[currentBar,"Close"]}, currentBar))
##     .$tradingSignal <- .calcAvgP(.$tradingSignal, currentBar,
##                                          prices)

##     rLog("Calculate PnL ...")
##     .$tradingSignal <- .calcPnL(.$tradingSignal, currentBar)
      


    # calculate pre signal variables if any  ???!!! what is this?
    # .Object <- definePreSignalVars(.$algo)(., currentBar)
    
## #####################################################################
## #  Not sure of if I should have this sleeper function here ...
## #
## Trader$.calcPnL <- function(.)
## {
##   ind <- which(names(TS) == as.character(currentBar))
  
##   PnL  <- rep(0, nrow(TS[[1]]))

##   if (ind > 1){   
##     qNew <- TS[[ind]]$quantity
##     qOld <- TS[[ind-1]]$quantity
##     pNew <- TS[[ind]]$price
##     pOld <- TS[[ind-1]]$AvgP
              
##     dq <- qNew-qOld

##     for (i in seq_along(qOld)){ # loop over the instruments
##       if (dq[i]<0 & qOld[i]>0)  # go from x -> -y, sell a long
##         PnL[i] <- PnL[i] + (qOld[i]-max(qNew[i],0))*(pNew[i]-pOld[i])
##       if (dq[i]>0 & qOld[i]<0)  # go from -x -> y, cover a short  
##         PnL[i] <- PnL[i] + (qOld[i]-min(qNew[i],0))*(pNew[i]-pOld[i])
##     }
##   }
  
##   TS[[ind]]$PnL <- PnL

##   return(TS)
## }

