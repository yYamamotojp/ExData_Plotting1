load.power.df <- function() {
    
    # download
    download.file(paste0('https://d396qusza40orc.cloudfront.net/'
                         ,'exdata%2Fdata%2Fhousehold_power_consumption.zip')
                  , method='curl'
                  , destfile='raw-power-data.zip')
    unzip('raw-power-data.zip')
    
    
    # read household power consumption
    col.classes = c(rep('character', 2), rep('numeric', 7))
    power.df <- read.table("household_power_consumption.txt"
                           , header=TRUE
                           , sep=';'
                           , na.strings='?'
                           , colClasses=col.classes)
    
    # Convert dates and times
    power.df$Date <- dmy(power.df$Date)
    power.df$Time <- hms(power.df$Time)
    
    # get specific data by datetime
    power.df <- subset(power.df
                       , year(Date) == 2007
                       & month(Date) == 2
                       & (day(Date) == 1 | day(Date) ==2))
    
    # combine date and time
    power.df$date.time <- power.df$Date + power.df$Time
    
    return(power.df)    
}

# load dataframe
power.df <- load.power.df()

# open device
Sys.setlocale("LC_TIME", "en_US")
png(filename="plot1.png")

# create figure
hist(power.df$Global_active_power
     , col='red'
     , main='Global Active Power'
     , xlab='Global Active (kilowatts)'
     )

# close device
dev.off()