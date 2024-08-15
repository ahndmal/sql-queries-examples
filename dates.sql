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
