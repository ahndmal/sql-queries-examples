
/*
    CASE WHEN condition THEN result
        WHEN another_condition THEN result
        ELSE result
    END
*/

SELECT max_temp,
    CASE WHEN max_temp >= 90 THEN 'Hot'
         WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
         WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
         WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
         WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
         ELSE 'Inhumane'
    END AS temperature_group
FROM temperature_readings;

-- Using CASE in a CTE

WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
        CASE WHEN max_temp >= 90 THEN 'Hot'
             WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
             WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
             WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
             WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
             ELSE 'Inhumane'
        END
FROM temperature_readings)

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, count(*) DESC;

