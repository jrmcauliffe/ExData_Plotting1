## Check to see if we already have archive in current directory
## if not, download and unpack

datafile <- "household_power_consumption.txt"

if (!file.exists(datafile)){
  tempfilename <- "archive.zip"
  
  ## Download zip file from web
  archive <- download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                           destfile=tempfilename, method="curl")
  ## un-pack archive
  unzip(tempfilename)
  
  ## Cleanup by removing temporary zip archive  
  file.remove(tempfilename)
}

## Because we are skipping header, read in the column names
header.names <- unname(unlist((read.table(datafile, nrows = 1, sep = ";")[1,])))

## Only read in the correct lines to save parsing / loading time & memory
data <- read.csv(datafile, sep = ";", skip = 66636, nrows = 2880, 
                 col.names = header.names)

## Convert Date and Time text to DateTime object
dt <- as.POSIXct(strptime(paste(data[,1], data[,2]), format = "%d/%m/%Y %H:%M:%S"))

## Drop separate Date and Time columns, then prepend new
data <- data.frame("DateTime" = dt, data[3:9])

## PLOTTING STARTS HERE

png(filename = "plot3.png", width = 480, height = 480)

## Create histogram like third example in README
plot(data$DateTime, data$Sub_metering_1,  type = "l", xlab = "", 
     ylab = "Energy sub metering")
## Plot additional 2 lines in different colours
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
## Add Legend
legend("topright", col = c("black","red","blue"), lty=c(1,1,1), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## Close PNG file device
dev.off()

