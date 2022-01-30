
======================
pg_dump and pg_dumpall
Restore with psql
https://www.postgresql.org/docs/current/app-pgdump.html
======================

1. Drop and create the test table
---------------------------------
* Open a psql session and run the SQLs

-- Create a database buptest
CREATE DATABASE buptest;

-- Connect to buptest
\c  buptest

-- Create the table
CREATE TABLE test (id  int);

-- Insert some rows
INSERT INTO test
SELECT * FROM generate_series(1, 10);

-- Quit
\q

2. Take a SQL dump
------------------
* Run this on bash terminal

pg_dump buptest  >   buptest.dump.sql

3. Check out the content of the sql dump file
---------------------------------------------

* open the file in editor such as vi or nano
vi buptest.dump.sql

4. Recreate the test database
-----------------------------

* Drop and recreate the buptest database

-- Drop
psql -c "DROP DATABASE  buptest;"

-- Create 
psql -c "CREATE DATABASE buptest;"


4. Restore test database
------------------------

psql  -d buptest  < buptest.dump.sql

5. Checkout the data in the test table
--------------------------------------

psql -d  buptest

SELECT * FROM test;

======================================
pg_restore
Requires pg_dump file in custom format
https://www.postgresql.org/docs/current/app-pgrestore.html
======================================

1. Dump data in custom format
-----------------------------

* Dump in pgdump custom format
* Dump in a directory with -F d

pg_dump -F c   buptest  >   buptest.dump.custom

2. Drop and Recreate the test database
--------------------------------------

psql -c "DROP DATABASE buptest;"

psql -c "CREATE DATABASE buptest;"


3. Restore the database from dump
---------------------------------

pg_restore   -d buptest < buptest.dump.custom

4. Clean up
-----------

psql -c "DROP DATABASE buptest;"


==========
pg_dumpall
==========

1. Create SQL file with globals
-------------------------------
* Passwords cannot be read in RDS/Aurora so option is neccesary

pg_dumpall --no-role-passwords  --globals-only > globals.sql

* The generated file may be edited to add passwords/etc

2. Create user to be used with pg_dumpall
-----------------------------------------
* Requires a user that has appropriate access to read all datbases
CREATE ROLE user1  LOGIN PASSWORD 'user1';
GRANT rds_superuser TO user1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user1;

pg_dumpall --no-role-passwords   > dumpall.sql
