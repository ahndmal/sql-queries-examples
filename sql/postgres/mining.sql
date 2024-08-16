
SELECT upper('hello'),
       lower('Hello7'),
       initcap('at the end of day'),
       char_length(' lorem ipsum '),
       length(' lorem '),
       position(', ' in 'Tan, Bella'),
       trim('s' from 'socks'),
       trim(trailing 's' from 'socks'),
       char_length(trim(' Pat ')),
       ltrim('hello', 'e'),
       rtrim('hello', 'e');

/*
The length() function can return a different value than char_length() when used
with multibyte encodings, such as character sets covering the Chinese, Japanese, or
Korean languages.
*/

SELECT left('703-555-1212', 3),   --703
       right('703-555-1212', 8),  -- 555-1212
       replace('bat', 'b', 'c');

SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{4}');


