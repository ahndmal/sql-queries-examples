WITH us_median AS
  (SELECT percentile_cont(.5)
WITHIN GROUP (ORDER BY p0010001) AS us_median_pop
FROM us_counties_2010)
SELECT geo_name,
    state_us_abbreviation AS st,
    p0010001 AS total_pop,
    us_median_pop,
    p0010001 - us_median_pop AS diff_from_median
  FROM us_counties_2010 CROSS JOIN us_median
  WHERE (p0010001 - us_median_pop)
    BETWEEN -1000 AND 1000;

/*
 So why use a CTE? One reason is that by using a CTE, you can pre-
stage subsets of data to feed into a larger query for more complex analysis.
Also, you can reuse each table defined in a CTE in multiple places in the
main query, which means you don’t have to repeat the SELECT query each
time. Another commonly cited advantage is that the code is more readable
than if you performed the same operation with subqueries.
 */
WITH large_counties (geo_name, st, p0010001)
         AS
         (SELECT geo_name, state_us_abbreviation, p0010001
          FROM us_counties_2000
          WHERE p0010001 >= 100000)
SELECT st, count(*)
FROM large_counties
GROUP BY st
ORDER BY count(*) DESC;

-- OR

SELECT state_us_abbreviation, count(*)
FROM us_counties_2000
WHERE p0010001 >= 100000
GROUP BY state_us_abbreviation
ORDER BY count(*) DESC;
