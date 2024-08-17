# SQL queries examples

```bash
psql -d db_name -U user_name

psql -d db_name -U user_name -h example.com

psql -d db_name -U postgres -f file.sql

createdb -U postgres -e box_office

database_name

\c database_name user

\pset pager

\a \f , \pset footer

\o 'C:/YourDirectory/query_output.csv'

shp2pgsql -I -s SRID -W encoding shapefile_name table_name | psql -d database -U user
```

https://www.postgresql.org/docs/current/static/app-psql.html

```
   Command           |   Displays                                                                                          |
---------------------+-----------------------------------------------------------------------------------------------------+--
 \?                  | Commands available within psql, such as \dt to list tables.
 \? options          | Options for use with the psql command, such as -U to specify a username.
 \? variables        | Variables for use with psql, such as VERSION for the current psql version.
 \h                  | List of SQL commands. Add a command name to see detailed help for it (for example, \h INSERT).
 \x                  | Set the detailed view for tables data results.
 \c db_name user     | Connect to db with other user
 \pset pager         | Set pager ON/OFF
 \d [pattern]        | Columns, data types, plus other information on objects
 \di [pattern]       | Indexes and their associated tables
 \dt [pattern]       | Tables and the account that owns them
 \du [pattern]       | User accounts and their attributes
 \dv [pattern]       | Views and the account that owns them
 \dx [pattern]       | Installed extensions
 \dt+                | list all tables in the database and their size
 \dt+ us*            | show only tables whose names begin with 'us'
```

 
