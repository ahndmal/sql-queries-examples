-- https://www.postgresql.org/docs/current/static/app-pgdump.html
-- https://www.postgresql.org/docs/current/static/app-pgrestore.html


SELECT pg_size_pretty(
    pg_total_relation_size('db_name')
);

-- pg_stat_all_tables

SELECT  relname,
        last_vacuum,
        last_autovacuum,
        vacuum_count,
        autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- vacuum free space

VACUUM db_name;

VACUUM FULL  db_name;

-- show config file location on server

SHOW config_file;

-- pg_ctl

pg_ctl reload -D '/var/lib/postgresql/data/postgresql.conf'

-- pg_dump
pg_dump -d db_name -U user_name -Fc > db_name_backup.sql

-- To limit the backup to one or more tables

pg_dump -t 'train_rides' -d analysis -U user_name -Fc > train_backup.sql

-- restore

pg_restore -C -d postgres -U user_name analysis_backup.sql


