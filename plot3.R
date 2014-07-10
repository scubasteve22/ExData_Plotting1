# Code to complete the first peer assignment - plot3 - 10/07/14

#Set the location of the data to use
fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#Set the name of the zip file we wish to extract
myzip = "exdata_data_household_power_consumption.zip"

#If data file has not yet been downloaded then fetch it otherwise move on
if (!file.exists(myzip)) {
    download.file(fileurl, destfile=myzip,method="curl")
    unzip(myzip)
       
    }

#Read the unzipped text file into a set here
housedata <- read.table("household_power_consumption.txt", sep=";", dec=".", header = TRUE)

#Only keep what we need (was going to leverage SQL add on but no time)
housedatakeep <- subset(housedata, housedata$Date == "1/2/2007" | housedata$Date == "2/2/2007")

#Added a new column to create a datetime field not necessary for the specific plot but useful later
housedatakeep$NewCol <- do.call(paste, c(housedatakeep[c("Date", "Time")], sep = " "))

#Formatting the frame to ensure correct types for plotting
houseformat<-data.frame(DateTime=strptime(housedatakeep$NewCol, format="%d/%m/%Y %H:%M:%S"), 
                        Active=as.numeric(as.character(housedatakeep$Global_active_power, dec=".")),
                        Reactive=as.numeric(as.character(housedatakeep$Global_reactive_power, dec=".")),
                        Voltage=as.numeric(as.character(housedatakeep$Voltage, dec=".")),
                        Intensity=as.numeric(as.character(housedatakeep$Global_intensity, dec=".")),
                        Sub1=as.numeric(as.character(housedatakeep$Sub_metering_1, dec=".")),
                        Sub2=as.numeric(as.character(housedatakeep$Sub_metering_2, dec=".")),
                        Sub3=as.numeric(as.character(housedatakeep$Sub_metering_3, dec="."))
)


#Establish the file name and specific size for .png format
png(filename = "plot3.png", width = 480, height = 480)

##Create the plot and set the format as line and define the labels
plot(houseformat$DateTime, houseformat$Sub1, type = "l", xlab="", ylab="Energy sub metering")

#Next introduce the extra points for Sub2 and Sub3, using the colour option to differentiate
points(houseformat$DateTime, houseformat$Sub2, type = "l", col = "red")
points(houseformat$DateTime, houseformat$Sub3, type = "l", col = "blue")

#Finally add the legend for clarity
legend("topright", col = c("black", "red", "blue"), lty= "solid", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3") )
#Close off process
dev.off()