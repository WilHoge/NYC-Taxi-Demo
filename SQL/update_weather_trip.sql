alter table weather_nyc add column timestamp varchar(13);
update weather_nyc set timestamp=substr(char(year_local),1,4)||'-'||substr(digits(month_local),9,2)||'-'||substr(digits(day_local),9,2)||'-'||substr(digits(hour_local),9,2);
update weather_nyc set Precipitation_One_Hour__mm_=0 where Precipitation_One_Hour__mm_ is null
select int(Precipitation_One_Hour__mm_),count(*) from weather_nyc group by int(Precipitation_One_Hour__mm_)
update weather_nyc set SNOW_DEPTH__CM_=0 where SNOW_DEPTH__CM_ is null
select int(SNOW_DEPTH__CM_),count(*) from weather_nyc group by int(SNOW_DEPTH__CM_)

rename table trip_data_small to trip_data;
select * from trip_data t, weather_nyc w where substr(t.pickup_datetime,1,13)=w.timestamp;

rename table trip_fare_small to trip_fare;
select * from trip_fare t, weather_nyc w where substr(t.pickup_datetime,1,13)=w.timestamp;

create view taxi (	medallion, license, vendor, "rate code", "tstore and fwd flag", "pickup datetime", 
					"dropoff datetime", "passenger count", "trip time in secs", "trip distance",
					"pickup longitude", "pickup latitude", "dropoff longitude", "dropoff latitude",
					"payment type", "fare amount", surcharge, "mta tax", "tip amount", "tolls amount", "total amount",
					"Year", "Month", "Day", "Hour", "Cavok Reported","Cloud Ceiling (m)",
					"Cloud Cover Fraction", "Cloud Cover Fraction 1", "Cloud Cover Fraction 2", "Cloud Cover Fraction 3", "Cloud Cover Fraction 4", "Cloud Cover Fraction 5",
					"Cloud Cover Fraction 6", "Cloud Height (m) 1", "Cloud Height (m) 2", "Cloud Height (m) 3", "Cloud Height (m) 4", "Cloud Height (m) 5",
					"Cloud Height (m) 6", "Dew Point (C)", "Humidity Fraction", "Precipitation One Hour (mm)", "Pressure Altimeter (mbar)", "Pressure Sea Level (mbar)",
					"Pressure Station (mbar)", "Snow Depth (cm)", "Temperature (C)", "Visibility (km)", "Weather Code 1", "Weather Code 1/ Description",
					"Weather Code 2", "Weather Code 2/ Description", "Weather Code 3", "Weather Code 3/ Description", "Weather Code 4", "Weather Code 4/ Description",
					"Weather Code 5", "Weather Code 5/ Description", "Weather Code 6", "Weather Code 6/ Description", "Weather Code Most Severe / Icon Code",
					"Weather Code Most Severe", "Weather Code Most Severe / Description", "Wind Direction (degrees)", "Wind Gust (m/s)", "Wind Speed (m/s)") 
	as 
	select 
					t.medallion, t.hack_license, t.vendor_id, t.rate_code, t.store_and_fwd_flag, t.pickup_datetime, 
					t.dropoff_datetime, t.passenger_count, t.trip_time_in_secs, t.trip_distance,
					t.pickup_longitude, t.pickup_latitude, t.dropoff_longitude, t.dropoff_latitude,
					f.payment_type, f.fare_amount, f.surcharge, f.mta_tax, f.tip_amount, f.tolls_amount, f.total_amount,
					YEAR_LOCAL, MONTH_LOCAL,DAY_LOCAL,HOUR_LOCAL, CAVOK_REPORTED,CLOUD_CEILING__M_,CLOUD_COVER_FRACTION,CLOUD_COVER_FRACTION_1, 					CLOUD_COVER_FRACTION_2,CLOUD_COVER_FRACTION_3,CLOUD_COVER_FRACTION_4,CLOUD_COVER_FRACTION_5,CLOUD_COVER_FRACTION_6, 					CLOUD_HEIGHT__M__1,CLOUD_HEIGHT__M__2,CLOUD_HEIGHT__M__3,CLOUD_HEIGHT__M__4,CLOUD_HEIGHT__M__5,CLOUD_HEIGHT__M__6,
					DEW_POINT__C_,HUMIDITY_FRACTION,PRECIPITATION_ONE_HOUR__MM_,PRESSURE_ALTIMETER__MBAR_,PRESSURE_SEA_LEVEL__MBAR_,
					PRESSURE_STATION__MBAR_,SNOW_DEPTH__CM_,TEMPERATURE__C_,VISIBILITY__KM_,WEATHER_CODE_1,WEATHER_CODE_1__DESCRIPTION,
					WEATHER_CODE_2,WEATHER_CODE_2__DESCRIPTION,WEATHER_CODE_3,WEATHER_CODE_3__DESCRIPTION,WEATHER_CODE_4,WEATHER_CODE_4__DESCRIPTION,
					WEATHER_CODE_5,WEATHER_CODE_5__DESCRIPTION,WEATHER_CODE_6,WEATHER_CODE_6__DESCRIPTION,WEATHER_CODE_MOST_SEVERE___ICON_CODE,
					WEATHER_CODE_MOST_SEVERE,WEATHER_CODE_MOST_SEVERE___DESCRIPTION,WIND_DIRECTION__DEGREES_,WIND_GUST__M_S_,WIND_SPEED__M_S_ 
	from trip_data t, trip_fare f, weather_nyc w where substr(t.pickup_datetime,1,13)=w.timestamp and t.pickup_datetime=f.pickup_datetime and t.medallion=f.medallion;

create view taxisample (	medallion, license, vendor, "rate code", "tstore and fwd flag", "pickup datetime", 
					"dropoff datetime", "passenger count", "trip time in secs", "trip distance",
					"pickup longitude", "pickup latitude", "dropoff longitude", "dropoff latitude",
					"payment type", "fare amount", surcharge, "mta tax", "tip amount", "tolls amount", "total amount",
					"Year", "Month", "Day", "Hour", "Cavok Reported","Cloud Ceiling (m)",
					"Cloud Cover Fraction", "Cloud Cover Fraction 1", "Cloud Cover Fraction 2", "Cloud Cover Fraction 3", "Cloud Cover Fraction 4", "Cloud Cover Fraction 5",
					"Cloud Cover Fraction 6", "Cloud Height (m) 1", "Cloud Height (m) 2", "Cloud Height (m) 3", "Cloud Height (m) 4", "Cloud Height (m) 5",
					"Cloud Height (m) 6", "Dew Point (C)", "Humidity Fraction", "Precipitation One Hour (mm)", "Pressure Altimeter (mbar)", "Pressure Sea Level (mbar)",
					"Pressure Station (mbar)", "Snow Depth (cm)", "Temperature (C)", "Visibility (km)", "Weather Code 1", "Weather Code 1/ Description",
					"Weather Code 2", "Weather Code 2/ Description", "Weather Code 3", "Weather Code 3/ Description", "Weather Code 4", "Weather Code 4/ Description",
					"Weather Code 5", "Weather Code 5/ Description", "Weather Code 6", "Weather Code 6/ Description", "Weather Code Most Severe / Icon Code",
					"Weather Code Most Severe", "Weather Code Most Severe / Description", "Wind Direction (degrees)", "Wind Gust (m/s)", "Wind Speed (m/s)") 
	as 
	select 
					t.medallion, t.hack_license, t.vendor_id, t.rate_code, t.store_and_fwd_flag, t.pickup_datetime, 
					t.dropoff_datetime, t.passenger_count, t.trip_time_in_secs, t.trip_distance,
					t.pickup_longitude, t.pickup_latitude, t.dropoff_longitude, t.dropoff_latitude,
					f.payment_type, f.fare_amount, f.surcharge, f.mta_tax, f.tip_amount, f.tolls_amount, f.total_amount,
					YEAR_LOCAL, MONTH_LOCAL,DAY_LOCAL,HOUR_LOCAL, CAVOK_REPORTED,CLOUD_CEILING__M_,CLOUD_COVER_FRACTION,CLOUD_COVER_FRACTION_1, 					CLOUD_COVER_FRACTION_2,CLOUD_COVER_FRACTION_3,CLOUD_COVER_FRACTION_4,CLOUD_COVER_FRACTION_5,CLOUD_COVER_FRACTION_6, 					CLOUD_HEIGHT__M__1,CLOUD_HEIGHT__M__2,CLOUD_HEIGHT__M__3,CLOUD_HEIGHT__M__4,CLOUD_HEIGHT__M__5,CLOUD_HEIGHT__M__6,
					DEW_POINT__C_,HUMIDITY_FRACTION,PRECIPITATION_ONE_HOUR__MM_,PRESSURE_ALTIMETER__MBAR_,PRESSURE_SEA_LEVEL__MBAR_,
					PRESSURE_STATION__MBAR_,SNOW_DEPTH__CM_,TEMPERATURE__C_,VISIBILITY__KM_,WEATHER_CODE_1,WEATHER_CODE_1__DESCRIPTION,
					WEATHER_CODE_2,WEATHER_CODE_2__DESCRIPTION,WEATHER_CODE_3,WEATHER_CODE_3__DESCRIPTION,WEATHER_CODE_4,WEATHER_CODE_4__DESCRIPTION,
					WEATHER_CODE_5,WEATHER_CODE_5__DESCRIPTION,WEATHER_CODE_6,WEATHER_CODE_6__DESCRIPTION,WEATHER_CODE_MOST_SEVERE___ICON_CODE,
					WEATHER_CODE_MOST_SEVERE,WEATHER_CODE_MOST_SEVERE___DESCRIPTION,WIND_DIRECTION__DEGREES_,WIND_GUST__M_S_,WIND_SPEED__M_S_ 
	from trip_data t TABLESAMPLE BERNOULLI(5), trip_fare f, weather_nyc w where substr(t.pickup_datetime,1,13)=w.timestamp and t.pickup_datetime=f.pickup_datetime and t.medallion=f.medallion;

select count(*) from taxi TABLESAMPLE BERNOULLI(5) where "Day" = 1;
select count(*),"Day" from taxi where substr(medallion,1,1) ='A' group by "Day";
select count(*),"Day" from taxisample  group by "Day";