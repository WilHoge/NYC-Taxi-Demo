# NYC-Taxi-Demo

*Analyze NYC Taxi data with DashDB and R*

Answer the question “Are taxis harder to get when it is raining” using open data and analytics. A presentation (in German) showing the flow of the demo is available on slideshare: http://www.slideshare.net/WilfriedHoge/is-it-harder-to-find-a-taxi-when-it-is-raining

## Getting the data

The taxi data can be found here: http://www.andresmh.com/nyctaxitrips/

The weather data was not available for free but can be bought for example here: https://weatherspark.com/

## Uploading data to cloud

The data volume is quite big so uploading the data to a cloud storage is a good idea. We used Softlayer Object Store (http://www.softlayer.com/object-storage) but S3 is also a good choice.

To ease uploading the data we used the moveToCloud.pl script from DashDB. You can download it from there.

## Storing in a database

The data is highly structured and so a RDBMS is a good fit to hold the data. We have chosen DashDB (http://ibm.com/software/data/dashdb) to hold the data. DashDB is an in-memory database engine hosted on Bluemix (http://bluemix.net), IBM’s PaaS platform.

To use DashDB login into Bluemix and create a DashDB service. The free tier is sufficient for these tests.

You can load the data directly into DashDB from Softlayer or S3. 

The structure of the tables can be found in the create-tables.sql script

Some adjustments to the data and the definition of views to join the taxi data are defined in update_weather_trip.sql

## Analyzing with SQL

The script analysis.sql give some simple analysis on taxi data using SQL.

## Analyzing with R

To analyze with R a RStudio interface can be launched directly from DashDB. Go to Analytics->R Scripts to start RStudio

### Taxi + Weather 

The weather.R scripts uses the data in DashDB to analyze the taxi and weather data. 

### Shiny + Google Maps

The NYC-Map folder hosts a shiny script to visualize taxi trips on Google Maps. The scripts are based on samples from Fabio Veronesi.