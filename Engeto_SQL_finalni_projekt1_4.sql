#	Vytvoreni view s upravenymi nazvy pro Cr a Prahu
CREATE VIEW v_covid19_basic_differences_new AS
	SELECT 
		*,	
		IF (country='Czechia', 'Czech Republic',`country`)AS country_new
	FROM covid19_basic_differences cbd 
	
CREATE VIEW v_countries_new AS
	SELECT 
		*,
		IF (capital_city= 'Praha', 'Prague',`capital_city`) AS capital_city_new
	FROM countries;
	
#	Vytvoreni view s casovymi promenymi
CREATE VIEW IF NOT EXISTS v_engeto_projekt_casove_promene AS
SELECT 
	date,
	YEAR(date) AS `year_temp`,
	country_new,
	confirmed,
	CASE WHEN weekday(`date`) BETWEEN 0 AND 4 
		THEN 'workday'
		ELSE 'weekend'
		END AS day_of_week,
	CASE WHEN month(date) IN (12, 1, 2) 
			THEN 'winter'
     	 WHEN month(date) IN (3, 4, 5) 
     	 	THEN 'spring'
     	 WHEN month(date) IN (6, 7, 8) 
     	 	THEN 'summer'
     	 WHEN month(date) IN (9, 10, 11) 
     	 	THEN 'autumn'
 	END AS season_of_a_year
FROM v_covid19_basic_differences_new cbd 
WHERE confirmed IS NOT NULL;


#	Vytvoreni view s daty a pocty testovanych
CREATE VIEW IF NOT EXISTS v_engeto_projekt_tests AS
	SELECT 
		country,
		`date`,
		tests_performed 
	FROM covid19_tests ct
	WHERE entity = 'tests performed (incl. non-PCR)' OR 
	entity = 'tests performed' AND 
	tests_performed IS NOT NULL 