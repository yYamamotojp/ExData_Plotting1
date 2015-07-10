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
png(filename="plot3.png")

# create figure
# line 1
plot(power.df$date.time
     ,power.df$Sub_metering_1
     , ylab="Energy sub metering"
     , xlab=""
     , type="l")

# line 2
lines(power.df$date.time
     , power.df$Sub_metering_2
     , col="red")

# line 3
lines(power.df$date.time
     , power.df$Sub_metering_3
     , col="blue")

# add legend
legends = c("Sub_metering_1"
            , "Sub_metering_2"
            , "Sub_metering_3")

legend('topright'
       , legend=legends
       , col=c("black", "red", "blue")
       , lty="solid")

# close device
dev.off()