-- MATH
SELECT 11.0 / 6;
SELECT CAST(11 AS numeric(3, 1)) / 6;
SELECT 3 ^ 4;
SELECT |/ 10;
SELECT sqrt(10);
SELECT ||/ 10;
SELECT 4 !;

----------- us_countries_2019
select *
from us_countries_2019;

SELECT sum(area_water)           AS "County Water Sum",
       round(avg(area_water), 0) AS "County Water Average"
FROM us_countries_2019;

-- Finding the Median with Percentile Functions

SELECT sum(area_land)                    AS "County Sum",
       round(avg(area_land), 0)          AS "County Average",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY area_land) AS "County Median"
FROM us_countries_2019;

SELECT percentile_cont(array [.25,.5,.75])
       WITHIN GROUP (ORDER BY area_land) AS "quartiles"
FROM us_countries_2019;

SELECT unnest(
                       percentile_cont(array [.25,.5,.75])
                       WITHIN GROUP (ORDER BY area_land)
       ) AS "quartiles"
FROM us_countries_2019;

SELECT sum(area_land)                    AS "County Sum",
       round(AVG(area_land), 0)          AS "County Average",
       median(area_land)                 AS "County Median",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY area_land) AS "50th Percentile"
FROM us_countries_2019;

SELECT mode() WITHIN GROUP (ORDER BY area_land)
FROM us_countries_2019;

---------------------------------------------------------------------

CREATE TABLE percent_change
(
    department varchar(20),
    spend_2014 numeric(10, 2),
    spend_2017 numeric(10, 2)
);

INSERT INTO percent_change
VALUES ('Building', 250000, 289000),
       ('Assessor', 178556, 179500),
       ('Library', 87777, 90001),
       ('Clerk', 451980, 650000),
       ('Police', 250000, 223000),
       ('Recreation', 199000, 195000);

SELECT department,
       spend_2014,
       spend_2017,
       round((spend_2017 - spend_2014) /
             spend_2014 * 100, 1) AS "pct_change"
FROM percent_change;

---------------------------------------------------------------------

create table STATION
(
    ID     integer,
    CITY   varchar(21),
    STATE  varchar(2),
    LAT_N  integer,
    LONG_W integer
);

select *
from station;

SELECT count(CITY) - (select count(distinct CITY) from STATION)
from STATION;

insert into station (id, city, state, lat_n, long_w)
values (3, 'Munich', 'MN', 123123, 234523);

---------------------------------------------------------------------

CREATE TABLE percentile_test
(
    numbers integer
);
INSERT INTO percentile_test (numbers)
VALUES (1),
       (2),
       (3),
       (4),
       (5),
       (6);

SELECT percentile_cont(.5)
       WITHIN GROUP (ORDER BY numbers),
       percentile_disc(.5)
       WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

----------------------------------------------------

CREATE TABLE departments
(
    dept_id bigserial,
    dept    varchar(100),
    city    varchar(100),
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees
(
    emp_id     bigserial,
    first_name varchar(100),
    last_name  varchar(100),
    salary     integer,
    dept_id    integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id),
    CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

INSERT INTO departments (dept, city)
VALUES ('Tax', 'Atlanta'),
       ('IT', 'Boston');

INSERT INTO employees (first_name, last_name, salary, dept_id)
VALUES ('Nancy', 'Jones', 62500, 1),
       ('Lee', 'Smith', 59300, 1),
       ('Soo', 'Nguyen', 83000, 2),
       ('Janet', 'King', 95000, 2);

--------------------------

CREATE TABLE schools_left
(
    id          integer
        CONSTRAINT left_id_key PRIMARY KEY,
    left_school varchar(30)
);

CREATE TABLE schools_right
(
    id           integer
        CONSTRAINT right_id_key PRIMARY KEY,
    right_school varchar(30)
);

INSERT INTO schools_left (id, left_school)
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School'),
       (5, 'Washington Middle School'),
       (6, 'Jefferson High School');

INSERT INTO schools_right (id, right_school)
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School'),
       (3, 'Morrison Elementary'),
       (4, 'Chase Magnet Academy'),
       (6, 'Jefferson High School');

SELECT *
FROM schools_left
         JOIN schools_right
              ON schools_left.id = schools_right.id;

select *
from schools_left
         LEFT JOIN schools_right
                   ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left
         RIGHT JOIN schools_right
                    ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left
         FULL OUTER JOIN schools_right
                         ON schools_left.id = schools_right.id;

SELECT *
FROM schools_left
         CROSS JOIN schools_right;

SELECT *
FROM schools_left
         LEFT JOIN schools_right
                   ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL;

SELECT schools_left.id,
       schools_left.left_school,
       schools_right.right_school
FROM schools_left
         LEFT JOIN schools_right
                   ON schools_left.id = schools_right.id;

--------------

CREATE TABLE us_counties_2000
(
    geo_name              varchar(90),
    state_us_abbreviation varchar(2),
    state_fips            varchar(2),
    county_fips           varchar(3),
    p0010001              integer,
    p0010002              integer,
    p0010003              integer,
    p0010004              integer,
    p0010005              integer,
    p0010006              integer,
    p0010007              integer,
    p0010008              integer,
    p0010009              integer,
    p0010010              integer,
    p0020002              integer,
    p0020003              integer
);

COPY us_counties_2000
    FROM 'C:\YourDirectory\us_counties_2000.csv'
    WITH (FORMAT CSV, HEADER);

SELECT c2010.geo_name,
       c2010.state_us_abbreviation          AS state,
       c2010.p0010001                       AS pop_2010,
       c2000.p0010001                       AS pop_2000,
       c2010.p0010001 - c2000.p0010001      AS raw_change,
       round((CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001)
                 / c2000.p0010001 * 100, 1) AS pct_change
FROM us_counties_2000 c2010
         INNER JOIN us_counties_2000 c2000
                    ON c2010.state_fips = c2000.state_fips
                        AND c2010.county_fips = c2000.county_fips
                        AND c2010.p0010001 <> c2000.p0010001
ORDER BY pct_change DESC;

CREATE TABLE registrations
(
    registration_id   varchar(10),
    registration_date date,
    license_id        varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE,
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

CREATE TABLE check_constraint_example
(
    user_id   bigserial,
    user_role varchar(50),
    salary    integer,
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK (user_role IN ('Admin', 'Staff')),
    CONSTRAINT check_salary_not_zero CHECK (salary > 0)
);

select *
from check_constraint_example;

-----------------

SELECT date_part('year', '2019-12-01 18:37:12 EST'::timestamptz)          AS "year",
       date_part('month', '2019-12-01 18:37:12 EST'::timestamptz)         AS "month",
       date_part('day', '2019-12-01 18:37:12 EST'::timestamptz)           AS "day",
       date_part('hour', '2019-12-01 18:37:12 EST'::timestamptz)          AS "hour",
       date_part('minute', '2019-12-01 18:37:12 EST'::timestamptz)        AS "minute",
       date_part('seconds', '2019-12-01 18:37:12 EST'::timestamptz)       AS "seconds",
       date_part('timezone_hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "tz",
       date_part('week', '2019-12-01 18:37:12 EST'::timestamptz)          AS "week",
       date_part('quarter', '2019-12-01 18:37:12 EST'::timestamptz)       AS "quarter",
       date_part('epoch', '2019-12-01 18:37:12 EST'::timestamptz)         AS "epoch";

select extract('year' from '2019-12-01 18:37:12 EST'::timestamptz);

SELECT make_date(2018, 2, 22);
SELECT make_time(18, 4, 30.3);
SELECT make_timestamptz(2018, 2, 22, 18, 4, 30.3, 'Europe/Lisbon');

CREATE TABLE current_time_example
(
    time_id               bigserial,
    current_timestamp_col timestamp with time zone,
    clock_timestamp_col   timestamp with time zone
);

INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
    (SELECT current_timestamp,
            clock_timestamp()
     FROM generate_series(1, 1000));

SELECT *
FROM current_time_example;

SHOW timezone;

-- Calculations with Dates and Times

SELECT '9/30/1929'::date - '9/27/1929'::date;

SELECT '9/30/1929'::date + '5 years'::interval;

CREATE TABLE nyc_yellow_taxi_trips_2016_06_01
(
    trip_id               bigserial PRIMARY KEY,
    vendor_id             varchar(1)               NOT NULL,
    tpep_pickup_datetime  timestamp with time zone NOT NULL,
    tpep_dropoff_datetime timestamp with time zone NOT NULL,
    passenger_count       integer                  NOT NULL,
    trip_distance         numeric(8, 2)            NOT NULL,
    pickup_longitude      numeric(18, 15)          NOT NULL,
    pickup_latitude       numeric(18, 15)          NOT NULL,
    rate_code_id          varchar(2)               NOT NULL,
    store_and_fwd_flag    varchar(1)               NOT NULL,
    dropoff_longitude     numeric(18, 15)          NOT NULL,
    dropoff_latitude      numeric(18, 15)          NOT NULL,
    payment_type          varchar(1)               NOT NULL,
    fare_amount           numeric(9, 2)            NOT NULL,
    extra                 numeric(9, 2)            NOT NULL,
    mta_tax               numeric(5, 2)            NOT NULL,
    tip_amount            numeric(9, 2)            NOT NULL,
    tolls_amount          numeric(9, 2)            NOT NULL,
    improvement_surcharge numeric(9, 2)            NOT NULL,
    total_amount          numeric(9, 2)            NOT NULL
);

select *
from nyc_yellow_taxi_trips_2016_06_01;

SET timezone TO 'US/Eastern';

SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
       count(*)
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY count(*);

SELECT geo_name,
       state_us_abbreviation   AS st,
       p0010001                AS total_pop,
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2000) AS us_median
FROM us_counties_2000;

--- CTE
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

