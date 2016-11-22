## Play with the rnoaa package
##
##

library(rnoaa)

out <- ncdc(datasetid = "GHCND", stationid = "GHCND:USW00014895",
            datatypeid = "PRCP",
            startdate = "2010-05-01", enddate = "2010-10-31", limit = 500)


