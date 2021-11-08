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

4. Check the output of pgbench

5. Checkout the Performance Metrics for the database metrics

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

6. Insert the rows
pgbench -n -d -c 50 -T 120 -f pagila-insert-1.sql pagila > /tmp/pagila-insert-1.log

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
IO:BufFileRead  IO:BufFileWrite
-----------------------------------------

Part-1 Run a SELECT load on film table
------
$ pgbench -n -d -c 15per -T 60 -f pagila-select-order.sql pagila > /tmp/pagila-select-order.log

Performance Insights:
1. Enable counter metrics for temp files
2. Look for the wait events BufRead and BufWrites

Part-2 CLUSTER the film table to reduce CPU
------
1. Create an index on the fil table for the description field
=> psql -d pagila
=> CREATE INDEX idx_film_description ON film (description);

2. Cluster the table

=> CLUSTER VERBOSE film USING idx_film_description;

3. Run the test again & observe the change in CPU/BufRead/BufWrite 

$ pgbench -n -d -c 15per -T 60 -f pagila-select-order.sql pagila > /tmp/pagila-select-order-cluster.log


Cleanup
-------
1. Drop the index
$ psql -d pagila -c "DROP INDEX idx_film_description"

2. Truncate the film table
$ psql -d pagila -c "TRUNCATE TABLE film CASCADE" 

3. Populate the film table with new data
$ pgbench -n -d -c 50 -T 120 -f pagila-insert-50.sql pagila > /tmp/pagila-insert-50.log

------------------------------------------------
LWLock:buffer_content
------------------------------------------------
Heavy load of commit volume on Update can cause the buffer_content wait.

pgbench -n -d -c 50 -T 120 -f pagila-insert-1.sql pagila > /tmp/pagila-insert-1.log

-------------------------------------------------
Lock:transactionid
-------------------------------------------------
Update the row in film table i.e., update on a single film_id.

pgbench -n -d -c 10 -T 60 -f pagila-update-common-id.sql pagila > /tmp/pagila-update-common-id.log

--------------------------------------------------
Timeout
--------------------------------------------------

pgbench -n -d -c 50 -T 60 -f pagila-sleep-select.sql pagila > /tmp/pagila-sleep-select.log

pgbench -n -d -c 1 -T 5 -f pagila-sleep.sql@1 -f pagila-lock-table.sql@9 pagila > /tmp/pagila-sleep-lock.log

--------------------------------------------------
Client:ClientRead, Client:ClientWrite waits
--------------------------------------------------
Must have above a million rows to see the effect

pgbench -n -d -c 1 -T 60 -f pagila-select.sql pagila > /tmp/pagila-select.log

================================
Reader-Writer Lock : Simulation
================================
You need a Reader and a Writer for this test

Session-1   Against the Writer
---------
$ psql
=> BEGIN;
=> LOCK TABLE test;

Session-2   Against the Reader
---------
$ psql -h $PGREADEREP
=> SELECT * FROM test;

The above command will lead to blocking of the SELECT on the reader. The lock timeout will not occur as the 

Session-3  Against the Reader
---------
In this session we will set the lock_timeout and then use the NOWAIT option, so the session is not blocked.

$ psql -h $PGREADEREP
=> SHOW  lock_timeout
=> SET   lock_timeout=3
=> SELECT * FROM test  NOWAIT;



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



