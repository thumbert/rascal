# Test the VIX settlement date calculation.
#
#

require(RUnit)

source("lib/lib_vix_contract.R")  

cat("Running the VIX settlement date calculation tests\n")
checkEquals( settlementDate(as.Date("2013-01-01")), as.Date("2013-01-16") )   
checkEquals( settlementDate(as.Date("2013-02-01")), as.Date("2013-02-13") )   
checkEquals( settlementDate(as.Date("2013-03-01")), as.Date("2013-03-20") )   
checkEquals( settlementDate(as.Date("2013-04-01")), as.Date("2013-04-17") )   
checkEquals( settlementDate(as.Date("2013-05-01")), as.Date("2013-05-22") )   
checkEquals( settlementDate(as.Date("2013-06-01")), as.Date("2013-06-19") )   
checkEquals( settlementDate(as.Date("2013-07-01")), as.Date("2013-07-17") )   
checkEquals( settlementDate(as.Date("2013-08-01")), as.Date("2013-08-21") )   
checkEquals( settlementDate(as.Date("2013-12-01")), as.Date("2013-12-18") )   



