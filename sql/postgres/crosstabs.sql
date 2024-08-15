
CREATE EXTENSION tablefunc;

SELECT *
 FROM crosstab('SELECT 
    office,
   flavor,
    xcount(*)
FROM ice_cream_survey
GROUP BY office, flavor
ORDER BY office',
 'SELECT flavor
    FROM ice_cream_survey
    GROUP BY flavor
    ORDER BY flavor')
    AS (office varchar(20),
        chocolate bigint,
        strawberry bigint,
        vanilla bigint);