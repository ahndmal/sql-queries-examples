

SELECT
        regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
        regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
        regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
        regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
    AS city
FROM crime_reports;

SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports;

SELECT regexp_replace('05/12/2018', '\d{4}', '2017');
SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');
SELECT regexp_split_to_array('Phil Mike Tony Steve', ',');

UPDATE crime_reports
SET date_1u     =
        (
            (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
                || ' ' ||
            (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1]
                || ' US/Eastern'
            )::timestamptz,
    date_2      =
        CASE
            WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
                AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
                THEN
                ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
                     || ' ' ||
                 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
                    || ' US/Eastern'
                    )::timestamptz
            WHEN | (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
                AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
                THEN
                ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
                     || ' ' ||
                 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
                    || ' US/Eastern'
                    )::timestamptz
            ELSE NULL
            END,
    street      = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
    city        = (regexp_match(original_text,
                                '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
    crime_type  = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
    description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
    case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];

    