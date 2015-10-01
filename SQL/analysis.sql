-- Anzahl der Fahrten im Mai 2013

select count(*) from taxi where substr("pickup datetime",1,7) = '2013-05';

-- Durchschnittliche Rate, Entfernung, Trinkgeld, Passagiere

select 
	count(*) as "Anzahl Fahrten", 
	avg("fare amount") as "Rate",
	avg("trip distance") as "Entfernung",
	avg(decimal("tip amount")) as "Trinkgeld",
	avg(decimal("passenger count") as "Passagiere"
from taxi 
where substr("pickup datetime",1,7) = '2013-05';

-- Vergleich mit/ohne Regen

select 
	count(*) as "Anzahl Fahrten", 
	avg("fare amount") as "Rate",
	avg("trip distance") as "Entfernung",
	avg(decimal("tip amount")) as "Trinkgeld",
	avg(decimal("passenger count")) as "Passagiere",
	case when ("Precipitation One Hour (mm)">0) then 1 else 0 end as "Regen"
from taxi 
where substr("pickup datetime",1,7) = '2013-05'
group by case when ("Precipitation One Hour (mm)">0) then 1 else 0 end ;
