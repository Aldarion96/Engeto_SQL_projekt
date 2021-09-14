#	Vytah z tabulky countries 
CREATE VIEW IF NOT EXISTS v_engeto_projekt_economie AS
	WITH base AS (
		SELECT 
			country,
			median_age_2018,
			population_density,
			population
		FROM v_countries_new 
		WHERE country IS NOT NULL 
		AND median_age_2018 IS NOT NULL
		AND population_density IS NOT NULL
	),b AS (
		SELECT 
			country,
			MAX(`year`) AS last_record
		FROM economies e
		WHERE  e.`year` IS NOT NULL
				AND e.GDP IS NOT NULL
				AND e.gini IS NOT NULL
				AND e.mortaliy_under5 IS NOT NULL
		GROUP BY country
	)
#	Vytah z tabulky economies
		SELECT 
			base.country,
			base.median_age_2018,
			base.population_density,
			e.`year`,
			b.last_record,
			e.GDP / e.population AS GDP_per_population,
			e.gini,
			e.mortaliy_under5 
		FROM economies e
		JOIN base
		ON e.country = base.country 
		JOIN b
		ON base.country = b.country
		WHERE e.`year` = b.`last_record`
			AND e.GDP IS NOT NULL
			AND e.gini IS NOT NULL
			AND e.mortaliy_under5 IS NOT NULL
				
#	Vytah z tabulky religions
CREATE VIEW IF NOT EXISTS v_engeto_projekt_nabozenstvi_0 AS
WITH tp AS (
		SELECT 
			country,
			sum(population) AS population
		FROM religions r 
		WHERE `year` = 2020
		GROUP BY country
		) 
		SELECT
			r.`year`,
			r.country,
			r.religion,
			r.population AS belivers,
			tp.population,
			ROUND( (r.population / tp.population) * 100,2) AS 'percent',
			CASE
				WHEN `religion` = 'Christianity' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Christianity',
			CASE
				WHEN `religion` = 'Islam' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Islam',
			CASE
				WHEN `religion` = 'Unaffiliated Religions' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS `Unaffiliated Religions`,
			CASE
				WHEN `religion` = 'Hinduism' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Hinduism',
			CASE
				WHEN `religion` = 'Buddhism' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Buddhism',
			CASE
				WHEN `religion` = 'Folk Religions' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Folk Religions',
			CASE
				WHEN `religion` = 'Judaism' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Judaism',
			CASE
				WHEN `religion` = 'Other Religions' THEN ROUND( (r.population / tp.population) * 100,2) ELSE 0
				END AS 'Other Religions'
		FROM religions r
		JOIN tp
		ON r.country = tp.country
		WHERE `year` = 2020
		GROUP BY country, belivers
		
#	Odstraneni NULL hodnot z tabulky
CREATE VIEW IF NOT EXISTS v_engeto_projekt_nabozenstvi AS
	SELECT 
		country,
		sum(Christianity) AS Christianity ,
		sum(Islam) AS Islam,
		sum(`Unaffiliated Religions`) AS 'Unaffiliated Religions',
		sum(Hinduism) AS Hinduism,
		sum(Buddhism) AS Buddhism,
		sum(`Folk Religions`) AS 'Folk Religions',
		sum(Judaism) AS Judaism,
		sum(`Other Religions`) AS 'Other Religions'
	FROM v_engeto_projekt_nabozenstvi_0  
	GROUP BY country 
	
	
#	Rozdil life expentacy 1965 a 2015
CREATE VIEW IF NOT EXISTS v_engeto_projekt_life_expectancy AS 
WITH base AS (
	SELECT 
		country,
		`year`,
		life_expectancy AS life_expectancy_1965
	FROM life_expectancy le 
	WHERE `year` =1965
)
SELECT 
	base.country,
	#base.life_expectancy_1965,
	#life_expectancy AS life_expectancy_2015,
	le.life_expectancy - base.life_expectancy_1965 AS 'difference_1965-2015'
FROM base
JOIN life_expectancy AS le
ON base.country = le.country 
WHERE le.`year` =2015


