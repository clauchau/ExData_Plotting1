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
  DT <- fread(dataFile, na.strings="?", select=c("Date","Time",
                        "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) # Load 5 columns
  DT <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007", ]                    # Keep 2 days
  DT[, datetime:=as.POSIXct(strptime(paste(Date,Time), "%d/%m/%Y %H:%M:%S"))]  # Convert time
  DT[, Sub_metering_1:=as.numeric(Sub_metering_1)]                             # and num strings
  DT[, Sub_metering_2:=as.numeric(Sub_metering_2)]
  DT[, Sub_metering_3:=as.numeric(Sub_metering_3)]
}

## Plot (with English locales)
getFile()
readData()
lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
png("plot3.png", width = 480, height = 480)
plot(DT$datetime, DT$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "", main = "")
lines(DT$datetime, DT$Sub_metering_1, col = "black")
lines(DT$datetime, DT$Sub_metering_2, col = "red")
lines(DT$datetime, DT$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
Sys.setlocale("LC_TIME", lct)