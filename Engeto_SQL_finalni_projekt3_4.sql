#	prùmìrná denní (nikoli noèní!) teplota
CREATE VIEW IF NOT EXISTS v_engeto_projekt_weather1_3 AS
	WITH base AS (
		SELECT
			city,
			CAST(REPLACE(`time`,':00',' ') AS INT) AS `time`,
			CAST(`date` AS date) AS `date`,
			CAST(REPLACE(`temp`,'°c',' ') AS INT) AS `temp`
		FROM weather w
		)
		SELECT 
			*,
			ROUND(AVG(temp),2) AS AVGtemp
		FROM  base
		WHERE CAST(REPLACE(`time`,':00',' ') AS INT) BETWEEN 6 AND 21
		AND city IS NOT NULL
		GROUP BY city, `date`

#maximální síla vìtru v nárazech bìhem dne
CREATE VIEW IF NOT EXISTS v_engeto_projekt_weather2_3 AS
	SELECT 
		city,
		CAST(`date` AS date) AS `date`,
		max(gust) AS MAXgust
	FROM weather w 
	WHERE city IS NOT NULL
	GROUP BY `date`,city


#poèet hodin v daném dni, kdy byly srážky nenulové
CREATE VIEW IF NOT EXISTS v_engeto_projekt_weather3_3 AS
	WITH base AS (
	SELECT DISTINCT 
		city,
		CAST(`date` AS date) AS `date`,
		CAST(REPLACE(`time`,':00',' ') AS INT) AS `time`,
		CASE 
			WHEN rain != '0.0 mm' THEN 3 ELSE 0
			END AS rain_3
	FROM weather w 
	WHERE city IS NOT NULL
	)
	SELECT  
		city,
		`date`,
		sum(rain_3) AS rain_hours
	FROM base
	GROUP BY city,`date`
