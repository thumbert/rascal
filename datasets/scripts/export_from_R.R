# Export some common data sets from R to csv for other tools
#
#
#

#############################################################
#
export_csv <- function()
{
  fname <- "../csv/quakes.csv"
  write.csv(quakes, file=fname, row.names=FALSE)

  fname <- "../csv/seatacWeather.csv"
  write.csv(SeatacWeather, file=fname, row.names=FALSE)
}


#############################################################
#
export_json <- function()
{
  data(Oats, package="MEMSS")  
  fname <- "../json/oats.json"
  writeLines(df2json(Oats), con=file(fname))


  
}

#############################################################
#############################################################
#
require(lattice)
require(latticeExtra)
require(MEMSS)  # I had to install again a liblapack dev package
require(df2json)

setwd("/home/adrian/Documents/findataweb/datasets/scripts/")

export_csv()

export_json()
