# Acquire the historical data for analysis.
#
#
# .download_hist_vix_futures  
# .load_hist_vix_futures
# .make_continuous_contracts
#



##############################################################
# Download the historical VIX Futures price and volume for 
# a given month.  Unfortunately, CBOE updates the files daily,
# so even if a file is there, there is no guarantee that it's the
# most recent file.
#
# @param month, an R date (beginning of the month) representing
#    the contract date.  It can be in the future.
#
.download_hist_vix_futures <- function( month )
{
  month <- as.Date(month)
  cat("Working on month ", format(month))  
  url <- paste("http://cfe.cboe.com/Publish/ScheduledTask/MktData/datahouse/CFE_",
               toMonthCode(month), "_VX.csv", sep="")
  destfile <- paste("resources/raw/", basename(url), sep="")
  
  download.file(url, destfile)
}


##############################################################
# Load the archive from disk.
# @param month an R Date for a given contract, e.g. 2014-01-01.
#   If NULL return the whole archive.
# @param startDate noticed that data is weird for asOfDate < 2007-03-26.
# @return a data.frame with historical data.
#
#
.load_hist_vix_futures <- function(month=NULL, startDate=as.Date("2007-03-26"))
{
  if (is.null(month)) {  
    files <- list.files("resources/raw", pattern="CFE_.*_VX.csv",
                      full.names=TRUE)
  } else {
    files <- paste("resources/raw/CFE_", toMonthCode(month) ,"_VX.csv", sep="")
  } 

  DD <- ldply(files, function(filename) {
    cat("Reading file", filename, "\n")
    # file format changes in N13!
    month <- fromMonthCode(gsub(".*_(.*)_.*", "\\1", basename(filename)))
    if (month >= as.Date("2013-07-01")) {
      aux <- read.csv(filename, skip=1)  
    } else {
      aux <- read.csv(filename)
    }
    
    #browser()
    aux$asOfDate <- as.Date(aux$Trade.Date, format="%m/%d/%Y")
    aux$contractMonth <- as.Date(paste("1", substring(aux$Futures, 4, 9)),
                                          format="%d %b %y")
    aux$contract <- sapply(aux$contractMonth, toMonthCode)
    aux$Trade.Date <- aux$Futures <- NULL
    
    aux
  })

  if ( !is.null(startDate) )
    DD <- subset(DD, asOfDate >= startDate )
  
  DD[order(DD$contractMonth, DD$asOfDate), ]
}



##############################################################
# Construct the prompt futures curve, prompt+1 curve, etc. 
# @param DD the data.frame as returned by .load_hist_vix_futures,
#   needs at least asOfDate, contractMonth, Settle columns.
# @return a data.frame with the continuous futures 
#
.make_continuous_futures <- function( DD )
{
  # calculate the index offset
  idx <- mapply(function(asOfDate, contractMonth){
    match(contractMonth,
          seq(currentMonth(asOfDate), length.out=26, by="1 month")) - 1
  }, DD$asOfDate, DD$contractMonth)

  cfut <- dcast(cbind(DD, idx=paste("P+", idx, sep="")),
           asOfDate ~ idx, I, value.var="Settle", fill=NA_real_)
  #plot(res$asOfDate, res$`1`)

  cfut
}


##############################################################
##############################################################
# 
.test <- function()
{
  options(width=200)  
  require(plyr)
  require(reshape2)
  require(quantmod)
  require(lattice)
  
    
  setwd("~/Documents/repos/github/thumbert/rascal/R/finance/vix/")  
  source("lib/lib_vix_contract.R")  
  source("lib/lib_vix_data.R")  
  source("lib/lib_vix_analysis.R")  


  # download most recent data
  months <- seq(as.Date("2014-06-01"), as.Date("2015-06-01"),
                by="1 month")
  aux <- lapply(months, .download_hist_vix_futures)

  
  DD <- .load_hist_vix_futures()
  tail(DD)

  tail(subset(DD, contract == "K13"))
  subset(DD, asOfDate == as.Date("2014-02-25") )


  

  # make the plots of vix vs. futures
  getSymbols("VIX")
  
  months <- seq(as.Date("2014-01-01"), as.Date("2014-11-01"), by="1 month")
  lapply(months, function(month, DD, VIX) {
    .plot_vix_vs_futures(as.Date(month), DD, VIX, save=TRUE) }, DD, VIX)
  



  
  
}
