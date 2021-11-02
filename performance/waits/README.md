===================
Pagila setup steps
===================
1. Setup up database pagilla
Change directory under under the eproject root.
$ cd performance/waits
$ chmod u+x ./setup-test-database.sh
$ ./setup-test-database.sh

2. Insert data into the film table in pagila database
The data will be inserted into the film table using the user function. Pgbench will repeatedly call the function by simulating 50 clients.

$ pgbench -n -d -c 50 -T 120 -f pagila-insert-1.sql pagila > /tmp/pagila-insert-1.log

3. Check the count of rows in the film table

$ psql -d pagila -c "SELECT COUNT(*) FROM film"

4. Check th eoutput of pgbench

4. Checkout the Performance Metrics for the database metrics

====================
set-test-database.sh
====================
Utility script for the database setup.
Please check out the Pagila schema to understand the sqls.

1. Create a new database for testing
psql -c "DROP DATABASE IF EXISTS pagila "
psql -c "create database pagila"

2. Setup the extension in the database
psql -c "create extension pg_stat_statements"

3. Create the tables, indexes etc
psql -f pagila-schema.sql  -d pagila

4. Populate the database with some test data
* Populate just the table : actor, category
psql -d pagila -f pagila-category-actor.sql  

5. Create functions that will be used from pgbench
psql -d pagila -f pagila-functions.sql



================
Simulations
================

-----------------------------------------
IO:XactSync
-----------------------------------------
Run update statements against Pagila to update the film description. The update is carried out by a user function.

Part-1  Run an update load with a batch size 1
------
pgbench -n -d -c 50 -T 60 -f pagila-update-1.sql pagila > /tmp/pagila-update-1.log

Part-2  Run an update load with a batch size 50
------
pgbench -n -d -c 50 -T 60 -f pagila-update-50.sql pagila > /tmp/pagila-update-50.log




-----------------------------------------
IO:BufReadWait  IO:BufWriteWait
-----------------------------------------
pgbench -n -d -c 2 -T 60 -f pagila-select-order.sql pagila > /tmp/pagila-select-order.log

Performance Insights:
1. Enable counter metrics for temp files
2. Look for the wait events BufRead and BufWrites

Fix the problem:
1. Create an index on the description field

pgbench -n -d -c 50 -T 60 -f pagila-insert-50.sql pagila > /tmp/pagila-insert-50.log

pgbench -n -d -c 100 -T 60 -f pagila-insert-1.sql pagila > /tmp/pagila-insert-c100-1.log

Update load:

pgbench -n -d -c 50 -T 60 -f pagila-update-1.sql pagila > /tmp/pagila-update-1.log
pgbench -n -d -c 50 -T 60 -f pagila-update-50.sql pagila > /tmp/pagila-update-50.log

Update common film_id:

pgbench -n -d -c 50 -T 60 -f pagila-update-common_id.sql pagila > /tmp/pagila-update-common_id.log

Timeout

pgbench -n -d -c 50 -T 60 -f pagila-sleep-select.sql pagila > /tmp/pagila-sleep-select.log

Mix Select & Update
pgbench -n -d -c 10 -T 60 -f pagila-sleep-select.sql@2 -f pagila-update-1.sql@49 -f pagila-insert-1.sql@49    pagila > /tmp/pagila-temp.log

Select ORDER By
Causes a lot of Buf waits, ClientWrite waits
pgbench -n -d -c 50 -T 120 -f pagila-select-order.sql pagila > /tmp/pagila-select-order.log

Select ORDER By with LIMIT
Causes a lot of Buf waits, but reduces the number of ClientWrite
pgbench -n -d -c 10 -T 60 -f pagila-select-order-with-limit.sql pagila > /tmp/pagila-select-ordert.log




* Create a test table
CREATE TABLE wait_test (i1 int, i2 int, i3 int);

INSERT INTO wait_test VALUES(0,1);
INSERT INTO wait_test VALUES(1,2);


* Session#1
SELECT pg_backend_pid();
BEGIN;
LOCK TABLE wait_test;

Session# 2
\d pg_stat_activity;
select pid, usename, wait_event_type, wait_event, query from pg_stat_activity;

Session# 1
COMMIT;

Session# 2
select pid, usename, wait_event_type, wait_event, query from pg_stat_activity;


---
Vacuum test - didn't work ???

* Session#2 
\d pg_stat_all_tables;

* Check last_vacuum
SELECT last_vacuum, last_autovacuum, last_autoanalyze, vacuum_count from pg_stat_all_tables where pg_stat_all_tables.relname='wait_test';

* Session# 1
DELETE FROM wait_test;



