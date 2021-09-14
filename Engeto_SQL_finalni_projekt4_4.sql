# Vytvoreni vysledne tabulky
CREATE VIEW IF NOT EXISTS v_engeto_projekt_weather AS
	WITH base AS (
		SELECT 
			* 
		FROM v_engeto_projekt_weather1_3 
		),
	a AS (
		SELECT 
			*
		FROM v_engeto_projekt_weather2_3 epw
		),
	b AS (
		SELECT 
			*
		FROM v_engeto_projekt_weather3_3 epw
		),
	c AS (
		SELECT 
			country,
			capital_city_new
		FROM v_countries_new
		WHERE capital_city_new IS NOT NULL
		)
	SELECT
		c.country,
		base.`date`,
		base.AVGtemp,
		a.MAXgust,
		b.rain_hours
	FROM base
	JOIN a 
	ON base.city = a.city AND base.`date` = a.`date`
	JOIN b
	ON base.city = b.city AND base.`date` = b.`date`
	JOIN c
	ON c.capital_city_new = base.city
	
#uprava sloupce time
#SELECT * FROM weather w 

#SELECT 
#	CAST(REPLACE(`time`,':00',' ') AS INT)
#FROM weather w

# Seznam vsech view
SELECT * FROM v_engeto_projekt_casove_promene vepcp; base;
SELECT * FROM v_engeto_projekt_tests; t;
SELECT * FROM v_engeto_projekt_economie; e;
SELECT * FROM v_engeto_projekt_life_expectancy veple; le;
SELECT * FROM v_engeto_projekt_nabozenstvi; n;
SELECT * FROM v_engeto_projekt_weather; w;



#Finalni sestaveni vsech view do jedne tabulky

CREATE TABLE t_Daniel_Herzog_projekt_SQL_final AS
	WITH base AS (
		SELECT 
			*
		FROM v_engeto_projekt_casove_promene vepcp
		),
		e AS (
		SELECT *
		FROM v_engeto_projekt_economie vepe 
		),
		le AS (
		SELECT 
			*
		FROM v_engeto_projekt_life_expectancy veple 
		),
		t AS (
		SELECT
			*
		FROM v_engeto_projekt_tests vept 
		),
		n AS (
		SELECT
			*
		FROM v_engeto_projekt_nabozenstvi vepn 
		),
		w AS (
		SELECT 
			*
		FROM v_engeto_projekt_weather vepw 
		)
		SELECT 
			base.`date`,
			base.country_new,
			base.confirmed,
			t.tests_performed,
			base.day_of_week,
			base.season_of_a_year,
			e.median_age_2018,
			e.population_density,
			e.GDP_per_population,
			e.gini,
			e.mortaliy_under5,
			le.`difference 1965-2015`,
			n.Christianity AS 'christianity_percentage' ,
			n.Islam AS 'islam_percentage',
			n.`Unaffiliated Religions` AS 'unaffiliated_religions_percentage',
			n.Hinduism AS 'hinduism_percentage',
			n.Buddhism AS 'buddhism_percentage',
			n.`Folk Religions` AS 'folk_religions_percentage',
			n.`Other Religions` AS 'Other_religions_percentage',
			n.Judaism AS 'judaism_%',
			w.AVGtemp,
			w.MAXgust,
			w.rain_hours
		FROM base
		LEFT JOIN e
		ON base.country_new = e.country 
		LEFT JOIN t
		ON base.country_new = t.country AND base.`date` = t.`date`
		LEFT JOIN le
		ON base.country_new = le.country
		LEFT JOIN n
		ON base.country_new = n.country
		LEFT JOIN w
		ON base.country_new = w.country AND base.`date` = w.`date`