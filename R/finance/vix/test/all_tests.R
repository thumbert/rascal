# Rscript test/all_tests.R
#
# Run all the tests 
#

options(width=200)  
require(RUnit)

source("lib/lib_vix_contract.R")  
source("lib/lib_vix_data.R")  
source("lib/lib_vix_analysis.R")  


# here come the tests
source("test/test.vix_settlementDate.R")
