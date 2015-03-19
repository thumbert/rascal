# Prepare MEE data for the example_LG1 algo
#
#
#
require(FinDataWeb)
require(RQuantLib)
require(xts)

load("H:/Temporary/Data/IB/MEE.RData")
load("H:/Temporary/Data/IB/MEEGD.RData")

hdata <- xts(cbind(MEE, MEEGD))

# get the implied vol, so I can calculate delta 
din <- data.frame(type="CALL", price=as.numeric(hdata$Close.MEEGD),
  S=as.numeric(hdata$Close.MEE), 
  Tex=as.numeric((ISOdatetime(2009,07,19,16,0,0) - index(hdata))/365),
  K=20, r=0.0016, index=index(hdata))
din <- na.omit(din)

IV <- impliedvol(din)

options <- NULL
options$calculate <- "DELTA"
res <- greeksEU(IV$S, IV$IVol, IV$Tex, IV$K, IV$r, IV$type, options)

res   <- xts(data.frame(IVol=res$sigma, delta=res$DELTA), din$index)
hdata <- cbind(hdata, res) 

colnames(hdata) <- gsub("MEE$",   "stock", colnames(hdata))
colnames(hdata) <- gsub("MEEGD$", "call", colnames(hdata))


save(list=c("hdata"),
     file="h:/user/R/Adrian/algotrader/data/hdata_LG1.RData")

##########################################################################

## EuropeanOptionImpliedVolatility("call", 5.70, 24.45,
##   strike=20, dividendYield=0, riskFreeRate=0.0016, maturity=0.10719,
##   volatility=1)
