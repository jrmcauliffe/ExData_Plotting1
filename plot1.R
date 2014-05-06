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

## Coerce into correct classes
data.classes = classes <- c("Date","character","numeric","numeric","numeric","numeric"
                            ,"numeric","numeric","numeric")

## Because we are skipping header, read in the column names
header.names <- unname(unlist((read.table(datafile, nrows = 1, sep = ";")[1,])))

## Only read in the correct lines to save parsing / loading time & memory
data <- read.csv(datafile, sep = ";", skip = 66636, nrows = 2880, 
                 colClasses = data.classes, col.names = header.names)

## PLOTTING STARTS HERE

png(filename = "plot1.png", width = 480, height = 480)

## Create histogram like first example in README
hist(data$Global_active_power, main = "Global Active Power", col = "red",
     xlab = "Global Active Power (kilowatts)")

## Close PNG file device
dev.off()

