
--- SQL
create or replace function percent_change(
        new_value numeric,
        old_value numeric,
        decimal_places integer DEFAULT 1)
returns numeric AS 
'SELECT round(
        ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

SELECT percent_change(110, 108, 2);

--- PL/pgSQL-based functions

CREATE OR REPLACE FUNCTION update_personal_days()
RETURNS void AS $$
BEGIN
    UPDATE teachers
    SET personal_days =
        CASE WHEN (now() - hire_date) BETWEEN '5 years'::interval
                                      AND '10 years'::interval THEN 4
             WHEN (now() - hire_date) > '10 years'::interval THEN 5
             ELSE 3
        END;
   RAISE NOTICE 'personal_days updated!';
END;
  $$ LANGUAGE plpgsql;

--- Python (plpythonu)

CREATE EXTENSION plpythonu;

CREATE OR REPLACE FUNCTION trim_county(input_string text)
RETURNS text AS $$
    import re
    cleaned = re.sub(r' County', '', input_string)
    return cleaned
$$ LANGUAGE plpythonu;

