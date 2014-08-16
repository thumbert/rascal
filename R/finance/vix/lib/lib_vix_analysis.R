# Analyze various aspects of the VIX index.
#
# .analysis_vix
# .plot_vix_vs_future
#

##################################################################
#
#
.analysis_vix <- function()
{
   # you don't get to pull the most recent days ...  
   getSymbols(c("SPY", "VIX"))

   #source("../../downloadYahoo.R")
   #VIX <- downloadYahoo("VIX", endDate=Sys.Date()-3)
   
   summary(VIX$VIX.Adjusted)
   hist( VIX$VIX.Adjusted, col="wheat", breaks=30 )


   VIX$diff.vix <- diff(VIX$VIX.Adjusted)
   head(VIX)
   
   SPY$diff.spy <- diff(SPY$SPY.Close)
   head(SPY)

   # plot the vix
   aux <- data.frame(date=index(VIX), vix=as.numeric(VIX$VIX.Close))
   xyplot(vix ~ date, data=aux, type=c("g", "l"))
   # plot the spy
   aux <- data.frame(date=index(SPY), spy=as.numeric(SPY$SPY.Close))
   xyplot(spy ~ date, data=aux, type=c("g", "l"))
   
   
   # look at the correlation between changes in SPY and VIX 
   aux <- merge(VIX[,"diff.vix"], SPY[,"diff.spy"])
   aux <- cbind(date=index(aux), as.data.frame(aux))
   plot(aux$diff.vix, aux$diff.spy, col="blue")
   # too much emphasis on the extremes, so compress the extremes

   
   plot(tanh(0.25*aux$diff.vix), tanh(0.25*aux$diff.spy),
        col=rgb(0,0,1,0.25), pch=19)
   lines(c(-1,1), c(1,-1), col="black", lwd=1)
   # this looks right and shows how well correlated the changes are
   # the plot is very symmetric, but there is some asymmetry in the
   # corners.  Do a loess on it, see if you pick something.


   bux <- data.frame(x=tanh(0.25*aux$diff.vix),
                     y=tanh(0.25*aux$diff.spy),
                     date=aux$date)
   xyplot(y ~ x, data=bux,
     xlab="Scaled daily changes VIX",
     ylab="Scaled daily changes SPY",
     panel = function(...) {
       panel.grid(h=-1, v=-1)
       panel.xyplot(..., pch=19, col=rgb(0,0,1,0.25))
       panel.lines(c(-1,1), c(1,-1), col="black")
       panel.loess(..., col="red")
     })
   # so there is a bias as shown by the red loess line.
   # large increases in vix are higher than spy drops for big moves 
   # large drops in vix are not matched by same increases in spy
   # look at the residuals relative to the diagonal line 
   # maybe not now.


   # VIX drives the Futures.  How much so?  How much more does the 
   # prompt Futures move vs. prompt+3. 
   cfut <- .make_continuous_futures( DD )[, c("asOfDate",
      "P+1", "P+2", "P+3", "P+4", "P+5")]
   aux <- merge(
       data.frame(asOfDate=index(VIX), vix=as.numeric(VIX$VIX.Close)),
       cfut)
   aux <- melt(aux, id=1)
   xyplot(value ~ asOfDate, data=aux, groups=aux$variable,
          type=c("g", "l"),
          auto.key=list(space="top", points=FALSE, lines=TRUE,
            columns=6))
   
   


}


##############################################################
# Compare the vix to the futures.  See how the Futures premium
# converges to zero as the expiration approaches. 
# @param month an R Date representing the contract month you
#    are interested in, e.g. 2014-01-01
# @param DD is the data.frame as returned by .load_hist_vix_futures()
# @param VIX is the xts object returned by getSymbols("VIX")
# @param save a boolean.  Files are saved in the out folder. 
#
.plot_vix_vs_futures <- function(month, DD, VIX, save=TRUE)
{
   this.contract <- toMonthCode(month)
   vix <- data.frame(asOfDate=index(VIX), Settle=as.numeric(VIX$VIX.Close),
                 contract="VIX")
   fut <- subset(DD, contract == this.contract)[,c("asOfDate",
                         "Settle", "contract")]
   fut <- subset(fut, Settle > 0)  # you have some bad data sometimes
   aux <- rbind(subset(vix, asOfDate >= min(fut$asOfDate) &
                            asOfDate <= max(fut$asOfDate)), fut)
   if (save)
     svg(paste("out/vix_vs_", this.contract, ".svg", sep=""),
         width=6, height=4)
   
   print(xyplot(Settle ~ asOfDate, data=aux, groups=contract,
          type=c("g", "l"),
          xlab="",
          auto.key=list(space="top", points=FALSE, lines=TRUE,
            columns=2)))
   
   if (save)
     dev.off()

   invisible()
}
