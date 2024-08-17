
CREATE OR REPLACE VIEW nevada_counties_pop_2010 AS
    SELECT geo_name,
         state_fips,
         county_fips,
         p0010001 AS pop_2010
    FROM us_counties_2010
    WHERE state_us_abbreviation = 'NV'
    ORDER BY county_fips;


CREATE OR REPLACE VIEW county_pop_change_2010_2000 AS
    SELECT  c2010.geo_name,
            c2010.state_us_abbreviation AS st,
            c2010.state_fips,
            c2010.county_fips,
            c2010.p0010001 AS pop_2010,
            c2000.p0010001 AS pop_2000,
            round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
                / c2000.p0010001 * 100, 1 ) AS pct_change_2010_2000
    FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
    ON c2010.state_fips = c2000.state_fips
        AND c2010.county_fips = c2000.county_fips
    ORDER BY c2010.state_fips, c2010.county_fips;


CREATE OR REPLACE VIEW employees_tax_dept AS
    SELECT  emp_id,
            first_name,
            last_name,
            dept_id
    FROM employees
    WHERE dept_id = 1
    ORDER BY emp_id
    WITH LOCAL CHECK OPTION;

