#
#
#   currentMonth
# expirationDate  -- get the expiration date of the Futures contract
#   nextMonth
#   prevMonth
#   toMonthCode
#   fromMonthCode
#


######################################################################
# Get the beginning of the month
# @param asOfDate an R Date
# @return an R Date, a beginning of the month
#
currentMonth <- function(asOfDate=Sys.Date())
{
  as.Date(paste(format(asOfDate, "%Y-%m-01")))  
}
nextMonth <- function( fromDate=Sys.Date() )
{
  bom <- as.Date(format(fromDate, "%Y-%m-01"))
  seq(bom, by="1 month", length.out=2)[2]
}
prevMonth <- function( fromDate=Sys.Date() )
{
  bom <- as.Date(format(fromDate, "%Y-%m-01"))
  seq(bom, by="-1 month", length.out=2)[2]
}


######################################################################
# Get the settlement date of the Futures contract.
# http://cfe.cboe.com/Products/Spec_VIX.aspx.
# Last trading date = Final Settlement Date - 1.
# "Final Settlement Date" = The Wednesday that is
# thirty days prior to the third Friday of the calendar month
# immediately following the month in which the contract expires
# 
# @param contractMonth an R Date
# @return an R Date, the expiration data
#
settlementDate <- function(contractMonth=currentMonth())
{
  month <- nextMonth(contractMonth)
  wd <- weekdays( month )
  daysToFirstFri <- switch(wd, "Saturday" = 6, "Sunday" = 5, "Monday" = 4,
    "Tuesday" = 3, "Wednesday" = 2, "Thursday" = 1, "Friday" = 0)

  fri3th <- month + daysToFirstFri + 14  # should be a Friday
  
  fri3th - 30
}


######################################################################
# Convert a month to a month code, e.g. Jan2014 to F14
# @param month, an R date beginning of the month
# @return a string
#
toMonthCode <- function(month)
{
  m <- as.numeric(format(month, "%m"))
  letter <- switch(m,
      "F", "G", "H", "J",
      "K", "M", "N", "Q",
      "U", "V", "X", "Z")
    
  return(paste(letter, format(month, "%y"), sep="")) 
}

######################################################################
# Convert a monthCode to a month, e.g. F14 to 2014-01-01
# @param monthCode, a string, e.g. "F14"
# @return an R Date
#
fromMonthCode <- function(monthCode)
{
  conv <- 1:12
  names(conv) <- c("F", "G", "H", "J", "K", "M", "N", "Q",
      "U", "V", "X", "Z")
  
  return( as.Date(paste("1", conv[substring(monthCode, 1, 1)],
                        substring(monthCode, 2, 3)), format="%d %m %y") )
}
