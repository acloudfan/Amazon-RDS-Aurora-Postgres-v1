================================
Performance Insights Walkthrough
================================

1. Simulate the "idle in transaction"
-------------------------------------
* On PI : Enable the counter = DB Metrics ->  State -> idle_in_transaction_count
* Start 3 psql sessions
* In all 3 sessions copy/paste & run the following script

BEGIN;

* Now check out the PI Dashboard for the chart for idle_in_transaction_count

* To end the transaction in each session run the command

COMMIT;

2. Simulate the CPU wait
-------------------------
On PI : Enable the counter = OS Metrics -> cpuUtilization -> total
        Enable the counter = OS Metrics -> loadAverageMinute -> five
        Enable the counter = DB Metrics -> SQL -> tup_inserted

* Start 3 psql sessions
* In all 3 sessions copy/paste & run the following script

INSERT INTO test 
SELECT * 
FROM generate_series(1,9000000);

* Checkout the DB Load:
  - Pay attention to CPU Waits
  - Which other waits do you see

3. Simulate the lock events
---------------------------
On PI : Enable the counter = OS Metrics -> cpuUtilization -> total
* Start 3 psql sessions
* In all 3 sessions copy/paste & run the following script

DELETE FROM test
WHERE id > 50000;

* Checkout the DB Load:
  - Is CPU wait an issue in this run?
  - Which other waits do you see the mosyt?


===============================
Explain command : Query Planner
===============================
## Setup the test table & index
=> CREATE TABLE a (id INTEGER, text VARCHAR(10));
=> CREATE TABLE b (id INTEGER, text VARCHAR(10));

=> INSERT INTO a SELECT generate_series(1,100000), 'A';
=> INSERT INTO b SELECT generate_series(1,100000), 'B';

* Setup index on id column for table a
=> CREATE INDEX idx_a_id ON a(id);

## Try out explain

1. EXPLAIN select for specific id against both tables
-----------------------------------------------------

=> EXPLAIN SELECT * FROM a WHERE id=1;
=> EXPLAIN SELECT * FROM b WHERE id=1;

Which scan type was used?
Which query requires a filter?
What is the difference in the cost?

2. Checkout aggregate function
------------------------------

=> EXPLAIN SELECT min(id) FROM a;
=> EXPLAIN SELECT sum(id) FROM a;

* Limit = Aborts the underlying operations when the desired number of rows has been fetched.
* The index will not help with all aggregations e.g., sum(..) would require sequential scans
* To improve performance, consider using materialized views

3. Sorting using "ORDER BY"
---------------------------

=> EXPLAIN SELECT * FROM a ORDER BY id;
=> EXPLAIN SELECT * FROM b ORDER BY id;

Review the cost statistics for the plans

4. Grouping using "GROUP BY"
----------------------------
* Not all queries with GROUP BY take advantage of the index
=> EXPLAIN SELECT id, text FROM a GROUP BY id, text;
=> EXPLAIN SELECT id, text FROM b GROUP BY id, text;

* Here is an example of query that can take advantage of index
=> EXPLAIN SELECT id, count(id) FROM a GROUP BY id;

5. Join
-------
* There are multiple join algos - check out the one that is used by this statement

=> EXPLAIN SELECT a.text, b.text FROM a, b WHERE a.id=b.id;

6. Parallel scan
----------------
* Add a million rows ONLY to table b
=> INSERT INTO b SELECT generate_series(1,1000000), 'B';

=> EXPLAIN SELECT * FROM a WHERE id=1;
=> EXPLAIN SELECT * FROM b WHERE id=1;

* This time for b parallel workers will be used

* Gather is applied to merge the results fom parallel workers
* Maximum number of workers controlled by max_parallel_workers

=> SHOW max_parallel_workers;

## Cleanup
DROP TABLE a ;
DROP TABLE b ;

=======================
Isolation Levels
=======================
1. Dirty Reads
--------------
NOT Possible in Postgres

2. Nonrepeatble Reads are possible
----------------------------------
That is in the same transaction, SELECT is invoked twice and for each time the result is different as another transaction updated the result concurrently.

[Simulate phenomena]
Simulation assumes that test table does not have a row with id=1000

Session#1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM test ;

Session#2
BEGIN;
INSERT INTO test values(1000);
COMMIT;

Session#1
/** Has not ended the transaction with rollback/commit **/
/** It will see the new row !! **/
SELECT * FROM test ;

[Address issue]

* To avoid this scenario set the transaction level for session#1 to 
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

* In a separate transaction INSERT a new row with id=2000 and commit
* This time you won't see the new data in the uncommitted read transaction

3. Phantom Reads
----------------
A transaction rexecutes a query with the same WHERE clause and receieves a different result as another transaction running concurrently committed updates to the data.

[Simulate phenomena]
Session#1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM test WHERE id=1000;

Session#2
BEGIN;
UPDATE test SET id=1000;
COMMIT;

Session#1
/** Has not ended the transaction with rollback/commit **/
/** It will see the new row !! **/
SELECT * FROM test WHERE id=1000;

=======================
Extension: pg_freespace
=======================
* Please note the output of pg_freespace(...) is not accurate

* Create the extension
=> CREATE EXTENSION pg_freespacemap

* Truncate the test table & check free space for it
=> TRUNCATE TABLE test;
=> SELECT * FROM pg_freespace('test');

* Insert some data in test and check free space again
=> INSERT INTO test SELECT generate_series(1,1000);

* Get the count of pages created in the table
=> SELECT COUNT(*) FROM pg_freespace('test');

* Delete some rows
=> DELETE FROM test WHERE id > 1 AND id < 500;

* Check out the free space map
=> SELECT  * FROM pg_freespace('test');

Check free space ratio
----------------------
Query for checking the ratio of total pages to total 
free space available across the pages in the table

=> SELECT count(*) as npages, round(100 * avg(avail)/8192 ,2) as average_freespace_ratio FROM pg_freespace('test');

Drop the extension 
------------------

=> DROP EXTENSION pg_freespacemap

=======================
Vacuum command
=======================

1. Create pg_freespacemap extension
=> CREATE EXTENSION pg_freespacemap;

2. Simple vacuum
----------------
Checkout the working of the concurrent vacuum using the commands below
On per table basis - you will see number of dead rows, cleaned row versions ...
=> VACUUM VERBOSE;
=> VACUUM VERBOSE test;

3. Add & Delete some data 
-------------------------
=> INSERT INTO test SELECT generate_series(1,1000000);
=> CREATE INDEX IF NOT EXISTS idx_test ON test(id);

* Delete some rows
=> DELETE FROM test WHERE id > 1000 AND id < 600000;

4. Concurrent VACUUM
--------------------
* Check number of pages in table
=> SELECT COUNT(*) FROM pg_freespace('test');

=> VACUUM VERBOSE test;

* Run command & check number of pages again, you wont see any change
* As concurrent vacuum does not free the page space 
=> SELECT COUNT(*) FROM pg_freespace('test');

5. Full VACUUM
--------------
You will see a reduction in the number of pages after the full vacuum

=> DELETE FROM test WHERE id > 900000;
=> SELECT COUNT(*) FROM pg_freespace('test');
=> VACUUM (VERBOSE, FULL) test;
=> SELECT COUNT(*) FROM pg_freespace('test');

=======================
Sample complex query
=======================
* Without ANALYZE
=> EXPLAIN SELECT n.nspname, c.relname, count(*) AS buffers 
             FROM pg_buffercache b JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             JOIN pg_namespace n ON n.oid = c.relnamespace
             GROUP BY n.nspname, c.relname
             ORDER BY 3 DESC
             LIMIT 10;
* With ANALYZE
=> EXPLAIN (ANALYZE) SELECT n.nspname, c.relname, count(*) AS buffers 
             FROM pg_buffercache b JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             JOIN pg_namespace n ON n.oid = c.relnamespace
             GROUP BY n.nspname, c.relname
             ORDER BY 3 DESC
             LIMIT 10;







========================
pg_buffercache
========================
https://www.postgresql.org/docs/12/pgbuffercache.html

Steps to setup and try out the extension.

=> CREATE EXTENSION pg_buffer_cache
=> SELECT n.nspname, c.relname, count(*) AS buffers 
             FROM pg_buffercache b JOIN pg_class c
             ON b.relfilenode = pg_relation_filenode(c.oid) AND
                b.reldatabase IN (0, (SELECT oid FROM pg_database
                                      WHERE datname = current_database()))
             JOIN pg_namespace n ON n.oid = c.relnamespace
             GROUP BY n.nspname, c.relname
             ORDER BY 3 DESC
             LIMIT 10;
=> SELECT bufferid,
        CASE relforknumber
            WHEN 0 THEN 'main'
            WHEN 1 THEN 'fsm'
            WHEN 2 THEN 'vm'
        END relfork,
        relblocknumber,
        isdirty,
        usagecount,
        pinning_backends
        FROM pg_buffercache
        WHERE relfilenode = pg_relation_filenode('test'::regclass);





Initializing the pgbench
========================
1. Set up a test database
psql -c 'CREATE DATABASE pgbenchtest'

2. Initialize pgbnech tables
pgbench -i pgbenchtest

Running the test
================
https://www.postgresql.org/docs/11/pgbench.html

The following commands assume that a database with the name 'pgbenchtest' exists

* Initialize with 100x100,000 accounts, 100x1 branches, 100x10 tellers
pgbench -i -d --scale=100  pgbenchtest

* Run a test with 50 concurrent clients for specified duration of 120 seconds
pgbench -c 50 -j 2   -b  tpcb-like -M prepared   -T 120 -P 5  pgbenchtest

* Run a test with 100 concurrent clients to complete 1000 transactions each
pgbench -c 100 -j 2   -b  tpcb-like -M prepared   -t 1000 -P 5  pgbenchtest

* Run a test with 200 concurrent clients for 6 hours; report status every 30 minutes
pgbench -c 200  -b  tpcb-like -M prepared   -T 216000 -P 1800  pgbenchtest




pgbench-tool
============
1. Install gnuplot
sudo yum install gnuplot
https://riptutorial.com/gnuplot/example/11275/installation-or-setup

2. Clone repo
git clone https://github.com/acloudfan/pgbench-tools.git

3. Install nginx as app
sudo yum  update
sudo yum install nginx

Update listen port to 8080
sudo nano /etc/nginx/nginx.conf

3. Install nginx as a container
docker run -d -p 8082:80 --read-only -v $(pwd)/nginx-cache:/var/cache/nginx -v $(pwd)/nginx-pid:/var/run nginx

docker run -d -it --rm  --name nginx -p 8082:80 -v ~/nginx/html:/usr/share/nginx/html -v ~/nginx/nginx-cache:/var/cache/nginx -v ~/nginx/nginx-pid:/var/run  -v ~/nginx/nginx.conf:/etc/nginx/nginx.conf:ro  nginx

Python CGI for nginx
https://techexpert.tips/nginx/python-cgi-nginx/

4. Run the test using the script available in pgbench-tools (README.md)
setup the ./config 
Multiple vars to be updated with PG info
Report generated under /reports folder

5. Copy the generated webreport to /usr/share/nginx/html
All directories need to have 755 permission
All files need to have the 644 permission

Steup
=====
1. Create the database   'pgbenchtools'
2. Setup the relations
psql -f pgbench-tools/init/resultdb.sql -d pgbenchtools
3. Setup the pgbnech-tools/config
4. Create the testset
./bin/pgt/newset "db.t3.medium"
4. 