select count(*)
from new_york_addresses;

select *
from new_york_addresses
where id < 100;

------ explain analyze

EXPLAIN ANALYZE
SELECT *
FROM new_york_addresses
WHERE street = 'BROADWAY';

EXPLAIN ANALYZE
SELECT *
FROM new_york_addresses
WHERE street = '52 STREET';

EXPLAIN ANALYZE
SELECT *
FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';

CREATE INDEX street_idx ON new_york_addresses (street);

CREATE TABLE pls_fy2014_pupld14a
(
    stabr     varchar(2)     NOT NULL,
    fscskey   varchar(6)
        CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid     varchar(20)    NOT NULL,
    libname   varchar(100)   NOT NULL,
    obereg    varchar(2)     NOT NULL,
    rstatus   integer        NOT NULL,
    statstru  varchar(2)     NOT NULL,
    statname  varchar(2)     NOT NULL,
    stataddr  varchar(2)     NOT NULL,
    longitud  numeric(10, 7) NOT NULL,
    latitude  numeric(10, 7) NOT NULL,
    fipsst    varchar(2)     NOT NULL,
    fipsco    varchar(3)     NOT NULL,
    address   varchar(35)    NOT NULL,
    city      varchar(20)    NOT NULL,
    zip       varchar(5)     NOT NULL,
    zip4      varchar(4)     NOT NULL,
    cnty      varchar(20)    NOT NULL,
    phone     varchar(10)    NOT NULL,
    c_relatn  varchar(2)     NOT NULL,
    c_legbas  varchar(2)     NOT NULL,
    c_admin   varchar(2)     NOT NULL,
    geocode   varchar(3)     NOT NULL,
    lsabound  varchar(1)     NOT NULL,
    startdat  varchar(10),
    enddate   varchar(10),
    popu_lsa  integer        NOT NULL,
    centlib   integer        NOT NULL,
    branlib   integer        NOT NULL,
    bkmob     integer        NOT NULL,
    master    numeric(8, 2)  NOT NULL,
    libraria  numeric(8, 2)  NOT NULL,
    totstaff  numeric(8, 2)  NOT NULL,
    locgvt    integer        NOT NULL,
    stgvt     integer        NOT NULL,
    fedgvt    integer        NOT NULL,
    totincm   integer        NOT NULL,
    salaries  integer,
    benefit   integer,
    staffexp  integer,
    prmatexp  integer        NOT NULL,
    elmatexp  integer        NOT NULL,
    totexpco  integer        NOT NULL,
    totopexp  integer        NOT NULL,
    lcap_rev  integer        NOT NULL,
    scap_rev  integer        NOT NULL,
    fcap_rev  integer        NOT NULL,
    cap_rev   integer        NOT NULL,
    capital   integer        NOT NULL,
    bkvol     integer        NOT NULL,
    ebook     integer        NOT NULL,
    audio_ph  integer        NOT NULL,
    audio_dl  float          NOT NULL,
    video_ph  integer        NOT NULL,
    video_dl  float          NOT NULL,
    databases integer        NOT NULL,
    subscrip  integer        NOT NULL,
    hrs_open  integer        NOT NULL,
    visits    integer        NOT NULL,
    referenc  integer        NOT NULL,
    regbor    integer        NOT NULL,
    totcir    integer        NOT NULL,
    kidcircl  integer        NOT NULL,
    elmatcir  integer        NOT NULL,
    loanto    integer        NOT NULL,
    loanfm    integer        NOT NULL,
    totpro    integer        NOT NULL,
    totatten  integer        NOT NULL,
    gpterms   integer        NOT NULL,
    pitusr    integer        NOT NULL,
    wifisess  integer        NOT NULL,
    yr_sub    integer        NOT NULL
);

CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visits2014_idx ON pls_fy2014_pupld14a (visits);

select count(*)
from pls_fy2014_pupld14a;

select *
from pls_fy2014_pupld14a;

SELECT stabr
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY stabr;

SELECT city, stabr
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY city, stabr;

SELECT stabr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY count(*) DESC;

SELECT pls14.stabr,
       sum(pls14.visits)                 AS visits_2014,
       sum(pls09.visits)                 AS visits_2009,
       round((CAST(sum(pls14.visits) AS decimal(10, 1)) - sum(pls09.visits)) /
             sum(pls09.visits) * 100, 2) AS pct_change
FROM pls_fy2014_pupld14a pls14
         JOIN pls_fy2009_pupld09a pls09
              ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0
  AND pls09.visits >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;

SELECT pls14.stabr,
       sum(pls14.visits)                 AS visits_2014,
       sum(pls09.visits)                 AS visits_2009,
       round((CAST(sum(pls14.visits) AS decimal(10, 1)) - sum(pls09.visits)) /
             sum(pls09.visits) * 100, 2) AS pct_change
FROM pls_fy2014_pupld14a pls14
         JOIN pls_fy2009_pupld09a pls09
              ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0
  AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000
ORDER BY pct_change DESC;

--------------------

CREATE TABLE meat_poultry_egg_inspect
(
    est_number varchar(50)
        CONSTRAINT est_number_key PRIMARY KEY,
    company    varchar(100),
    street     varchar(100),
    city       varchar(30),
    st         varchar(2),
    zip        varchar(5),
    phone      varchar(14),
    grant_date date,
    activities text,
    dbas       text
);

SELECT count(*)
FROM meat_poultry_egg_inspect;

SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st
ORDER BY st;

SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;

CREATE TABLE state_regions
(
    st     varchar(2)
        CONSTRAINT st_key PRIMARY KEY,
    region varchar(20) NOT NULL
);

select *
from state_regions;

START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

ROLLBACK;

CREATE TABLE acs_2011_2015_stats
(
    geoid                varchar(14)
        CONSTRAINT geoid_key PRIMARY KEY,
    county               varchar(50)   NOT NULL,
    st                   varchar(20)   NOT NULL,
    pct_travel_60_min    numeric(5, 3) NOT NULL,
    pct_bachelors_higher numeric(5, 3) NOT NULL,
    pct_masters_higher   numeric(5, 3) NOT NULL,
    median_hh_income     integer,
    CHECK (pct_masters_higher <= pct_bachelors_higher)
);

select *
from acs_2011_2015_stats;

SELECT corr(median_hh_income, pct_bachelors_higher)
           AS bachelors_income_r
FROM acs_2011_2015_stats;

SELECT round(
               corr(median_hh_income, pct_bachelors_higher)::numeric, 2
       ) AS bachelors_income_r,
       round(
               corr(pct_travel_60_min, median_hh_income)::numeric, 2
       ) AS income_travel_r,
       round(
               corr(pct_travel_60_min, pct_bachelors_higher)::numeric, 2
       ) AS bachelors_travel_r
FROM acs_2011_2015_stats;

SELECT round(
               regr_slope(median_hh_income, pct_bachelors_higher)::numeric, 2
       ) AS slope,
       round(
               regr_intercept(median_hh_income, pct_bachelors_higher)::numeric, 2
       ) AS y_intercept
FROM acs_2011_2015_stats;


CREATE TABLE widget_companies
(
    id            bigserial,
    company       varchar(30) NOT NULL,
    widget_output integer     NOT NULL
);

INSERT INTO widget_companies (company, widget_output)
VALUES ('Morse Widgets', 125000),
       ('Springfield Widget Masters', 143000),
       ('Best Widgets', 196000),
       ('Acme Inc.', 133000),
       ('District Widget Inc.', 201000),
       ('Clarke Amalgamated', 620000),
       ('Stavesacre Industries', 244000),
       ('Bowers Widget Emporium', 201000);

SELECT company,
       widget_output,
       rank() OVER (ORDER BY widget_output DESC),
       dense_rank() OVER (ORDER BY widget_output DESC)
FROM widget_companies;

CREATE TABLE fbi_crime_data_2015 (
    st varchar(20),
    city varchar(50),
    population integer,
    violent_crime integer,
    property_crime integer,
    burglary integer,
    larceny_theft integer,
    motor_vehicle_theft integer,
    CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

SELECT * FROM fbi_crime_data_2015
ORDER BY population DESC;

SELECT
    city,
    st,
    population,
    property_crime,
    round(
        (property_crime::numeric / population) * 1000, 1
        ) AS pc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::numeric / population) DESC;









