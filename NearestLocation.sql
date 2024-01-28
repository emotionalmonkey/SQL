/*
Description: Get the nearest location from each branch. Alternatively, use the CTE function and get a minimum distance from it.
Table Structure
--------------
Location:
LocationId (int)  NOT NULL - Unique identifier for the location
LocationName (varchar(50)) NOT NULL - Location Name
Latitude (double) NOT NULL - Latitude of the location
Longitude (double) NOT NULL - Longitude of the location 

Branch:	
BranchId (int)  NOT NULL - Unique identifier for the branch
BranchName (varchar(50))  NOT NULL - Name of the branch
Latitude (double) NOT NULL - Latitude of the branch
Longitude (double) NOT NULL - Longitude of the branch
*/
SELECT 
	LocationId,
  LocationName,
  BranchName,
  Location_Branch_Distance
FROM
	(
	SELECT 		
		l.LocationId,
    l.LocationName,
		b.BranchName,
		ROUND(ST_DISTANCE_SPHERE(POINT(b.Longitude, b.Latitude), POINT(l.Longitude, l.Latitude)) / 1609.344, 2) AS Location_Branch_Distance, -- Distance in miles
		ROW_NUMBER() OVER (PARTITION BY LocationId ORDER BY ST_DISTANCE_SPHERE(POINT(b.Longitude, b.Latitude), POINT(l.Longitude, l.Latitude))) AS Nearest
	FROM
		crm.Location l	
	CROSS JOIN crm.Branch b	
	) x	
WHERE Nearest = 1
;
