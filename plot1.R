dataFile <- "./data/household_power_consumption.txt"

## Get the file ready
getFile <- function() {
  if (!file.exists(dataFile)) {     # Get the data if locally absent
    zipFile <- "./data/exdata-data-household_power_consumption.zip"
    if (!file.exists(zipFile)) {    # Get the zip file if locally absent
      if (!file.exists("data")) {   # Create the data subdirectory if it doesn't exist yet
        dir.create("data")
      }
      fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileUrl, destfile = zipFile)
      dateDownload <- date()
      print(dateDownload)
      ## [1] "Thu Jun 05 13:38:17 2014"
    }
    unzip(zipFile, exdir = "data")
  }

}

## Load and tidy up the data in memory
readData <- function () {
  library(data.table)
  DT <- fread(dataFile, na.strings="?", select=c("Date","Time","Global_active_power")) # Load 3 columns
  DT <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007", ]                            # Keep 2 days
  DT[, datetime:=as.POSIXct(strptime(paste(Date,Time), "%d/%m/%Y %H:%M:%S"))]          # Convert time
  DT[, Global_active_power:=as.numeric(Global_active_power)]                           # and num strings
}

## Plot
getFile()
readData()
png("plot1.png", width = 480, height = 480)
hist(DT$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()
