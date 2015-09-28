# Init
library(ggplot2)

#Connect to the database
conn=idaConnect("BLUDB","","")
idaInit(conn)

q <- ida.data.frame('taxisample1')

# Get data for "Weather per day"
weatherDataPerDay = idaQuery("select month_local as month,day_local as day, sum(PRECIPITATION_ONE_HOUR__MM_) as precipitation, avg(TEMPERATURE__C_) as temperatur from weather_nyc where month_local between 1 and 7 group by month_local,day_local order by month_local,day_local")
#weatherDataPerDay = idaQuery("select month_local as month,day_local as day, sum(PRECIPITATION_ONE_HOUR__MM_) as precipitation, avg(TEMPERATURE__C_) as temperatur from weather_nyc where month_local between 6 and 6 group by month_local,day_local order by month_local,day_local")

weatherDataPerDay$prec = as.integer(weatherDataPerDay$PRECIPITATION)
weatherDataPerDay$temp = as.integer(weatherDataPerDay$TEMPERATUR)

# rain per month
p = ggplot(weatherDataPerDay, aes(factor(MONTH),prec))
p + geom_boxplot() + ggtitle("rain per month")

# rain per month (better visibility)
p = ggplot(weatherDataPerDay, aes(factor(MONTH),prec))
p + geom_boxplot() + ggtitle("rain per month") + coord_cartesian(ylim=c(0,15))

# temp per month
p = ggplot(weatherDataPerDay, aes(factor(MONTH),temp))
p + geom_boxplot() + ggtitle("temp per month")

# temp+rain per day
weatherDataPerDay$day = as.Date(paste(2013,weatherDataPerDay$MONTH,weatherDataPerDay$DAY,sep="/"),"%Y/%m/%d")

p = ggplot(weatherDataPerDay, aes(x=day,y=prec))
p + geom_line() + ggtitle("rain per day")

p = ggplot(weatherDataPerDay, aes(x=day,y=temp))
p + geom_point(aes(size=prec,color=prec)) + geom_line() + ggtitle("temp/rain per day")

# Get data for "Taxi per Day"
taxiPerDay = idaQuery ('select "Month", "Day",sum("passenger count") as passengers, sum("trip distance") as tripdistance, sum("trip time in secs") as triptime, count(*) as trips from taxisample where "Month" < 8 group by "Month", "Day" order by "Month","Day"')
#taxiPerDay = idaQuery ('select "Month", "Day",sum("passenger count") as passengers, sum("trip distance") as tripdistance, sum("trip time in secs") as triptime from taxisample where "Month" = 6 group by "Month", "Day" order by "Month","Day"')

taxiPerDay$tripdistance = as.integer(taxiPerDay$TRIPDISTANCE)
taxiPerDay$trips = as.integer(taxiPerDay$TRIPS)
taxiPerDay$day = as.Date(paste(2013,taxiPerDay$Month,taxiPerDay$Day,sep="/"),"%Y/%m/%d")
taxiPerDay$weekday = weekdays(taxiPerDay$day)
taxiPerDay$prec = weatherDataPerDay$prec
taxiPerDay$temp = weatherDataPerDay$temp

# passengers per month
p = ggplot(taxiPerDay, aes(factor(Month),PASSENGERS))
p + geom_boxplot() + ggtitle("passengers per month")

# distance per month
p = ggplot(taxiPerDay, aes(factor(Month),tripdistance))
p + geom_boxplot() + ggtitle("distance per month")

summary(taxiPerDay)
cor(taxiPerDay[,c("tripdistance","PASSENGERS","trips", "TRIPTIME","prec", "temp")])

# an welchem Wochentag regnet es denn?
p = ggplot(taxiPerDay, aes(x=day,y=PASSENGERS,size=prec, color=weekday))
p + geom_point() + ggtitle("passengers per weekday") + ylim(30000,60000) + geom_smooth() + geom_rug(col="darkred",alpha=.1) 

# Nur Freitage anschauen!
cor(taxiPerDay[taxiPerDay$weekday=="Friday",c("tripdistance","PASSENGERS","TRIPTIME","trips", "prec", "temp")])

## samples bauen für "ohne Regen" und "mit Regen" für den Monat Mai (wie bei SQL)
RainYes = taxiPerDay[taxiPerDay$prec > 5 & taxiPerDay$weekday=="Friday",]
RainNo  = taxiPerDay[taxiPerDay$prec == 0 & taxiPerDay$weekday=="Friday",]

meanDistRainYes = mean(RainYes$tripdistance)
sdDistRainYes   = sd(RainYes$tripdistance)

meanDistRainNo = mean(RainNo$tripdistance)
sdDistRainNo   = sd(RainNo$tripdistance)

# Welch's T-Test für Distance
t = (meanDistRainNo-meanDistRainYes) / sqrt((sdDistRainNo^2/nrow(RainNo))+(sdDistRainYes^2/nrow(RainYes)))

meanTripsRainYes = mean(RainYes$trips)
sdTripsRainYes   = sd(RainYes$trips)

meanTripsRainNo = mean(RainNo$trips)
sdTripsRainNo   = sd(RainNo$trips)

# Welch's T-Test für Trips
t = (meanTripsRainNo-meanTripsRainYes) / sqrt((sdTripsRainNo^2/nrow(RainNo))+(sdTripsRainYes^2/nrow(RainYes)))
