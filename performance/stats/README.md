=========================
PostgreSQL Stat Collector
=========================
https://www.postgresql.org/docs/12/monitoring-stats.html

====================================================================
Config parameters for stats
Checkout cluster parameter group for parameters with prefix : track_
=====================================================================
You may control the tracking by setting these confg parameters.
Heavy stats activity may have an impact on performance.

track_activities
track_activity_query_size
track_commit_timestamp
track_counts
track_functions
track_io_timing

Checkout the setup
------------------

=> SHOW  track_activities;

=================================================
(Part 1 & 2) Hands on with Functions & Parameters 
=================================================

1. Start a psql Session (#1)
----------------------------
=> SHOW track_counts;
=> SHOW track_functions;

=> \d  pg_stat_activity

2. Get the pid for the backend process & begin a transaction
------------------------------------------------------------

=> SELECT get_backend_pid()
=> BEGIN;

=> SELECT * FROM test;

3. Start another psql session (#2)
----------------------------------

$ psql

4. Get the activity for session#1 in session #2
-----------------------------------------------
=> SELECT pg_stat_get_activity(PID for session#1)

===================================
(Part 3) Hands on with static views
===================================

1. In psql Session#1 get the details of pg_stat_user_tables
-----------------------------------------------------------

=> \d pg_stat_user_tables

2. Get the current value for tuple counters for the test tables
---------------------------------------------------------------

=> \x
=> SELECT seq_scan, n_tup_ins, idx_scan FROM pg_stat_user_tables WHERE relname = 'test';

3. Run a query against table and check the counts again
-------------------------------------------------------
=> SELECT * FROM test;
=> SELECT seq_scan, n_tup_ins, idx_scan FROM pg_stat_user_tables WHERE relname = 'test';

4. Set the track_count=OFF 
--------------------------
=> SET track_counts=OFF;

5. Repeat step 3 ; no change in counts
--------------------------------------
=> SELECT * FROM test;
=> SELECT seq_scan, n_tup_ins, idx_scan FROM pg_stat_user_tables WHERE relname = 'test';

6. Set the tracking for count ON
--------------------------------
=> SET track_counts=ON;

==================================
Hands on with dynamic views
===========================
1. In psql Session#1 get the details of pg_stat_user_tables
-----------------------------------------------------------

=> \d pg_stat_activity

2. In psql Session#2 start a transaction
----------------------------------------

=> SELECT pg_backend_pid();
=> BEGIN;
=> SELECT * FROM test;

3. In Session#1 
---------------
=> \x
=> SELECT * FROM pg_stat_activity WHERE pid=<<Pid of Session#2>>


============================================================
Extension: pg_stat_statements
https://www.postgresql.org/docs/12/pgstatstatements.html
============================================================
1. \dx 
2. CREATE EXTENSION pg_stat_statements;
3. \d pg_stat_statements

Hands on with pg_stat_statements
================================
Part-1  Create database & extension
------
1. Create DB 
=> CREATE database  teststatements;
=> \c  teststatements
=> CREATE EXTENSION pg_stat_statements;

2. Checkout the parameters for extension
=> SHOW pg_stat_statements.max;
=> SHOW pg_stat_statements.track;

Part-2   Get the stats for queries against specific table
------
1. Create the benchmark tables
$ pgbench -i -s 100 teststatements

2. Get stats for a specific table from the pg_stat_statements view
$ psql -d teststatements
psql=> \x
psql=> SELECT * FROM pg_stat_statements WHERE query LIKE '%pgbench%';

3. Reset the stats
psql=> SELECT pg_stat_statements_reset();

4. Run a query a couple of times to see the change in stats
psql=> SELECT * FROM pg_stat_statements WHERE query LIKE '%pgbench%';

5. Checkout queries run by background processes
psql=> SELECT * FROM pg_stat_statements ;

Part-3   Checkout the top 5 slowest queries 
------
1. Run a load test against the database
$ pgbench   -c 10  -T 60 -P 3 teststatements

2. Checkout the top 5 slowest (by mean_time) query/commands
$ psql -d teststatements
psql=> SELECT query, calls, mean_time, rows
        FROM pg_stat_statements 
        WHERE query LIKE '%SELECT%pgbench%' 
              OR query LIKE '%INSERT%pgbench%' 
              OR query LIKE '%UPDATE%pgbench%'
        ORDER BY mean_time DESC LIMIT 5;

Exercise#1   Checkout the top 5 frequently run queries
----------

psql=> SELECT query, calls, mean_time, rows
        FROM pg_stat_statements 
        WHERE query LIKE '%SELECT%pgbench%' 
              OR query LIKE '%INSERT%pgbench%' 
              OR query LIKE '%UPDATE%pgbench%'
        ORDER BY calls  DESC LIMIT 5;

Exercise#2   Checkout the top 5 queries with lowest blk_hit ratio
----------
psql=> SELECT query, calls, mean_time, rows, 
                100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) 
                AS hit_percent
          FROM pg_stat_statements 
          WHERE query LIKE '%SELECT%pgbench%' 
              OR query LIKE '%INSERT%pgbench%' 
              OR query LIKE '%UPDATE%pgbench%'
          ORDER BY hit_percent ASC LIMIT 5;


Clean up
--------
$ psql -c "DROP DATABASE teststatements"


===============================================================================
pg_stat_activity
Understanding the Wait Events
===============================================================================

Refresher  Check out the pg_stat_activity view
---------
1. Get the PID
psql#1=> select pg_backend_pid();

2. Get the current state of connection
psql#1=> \x
psql#1=> SELECT * FROM pg_stat_activity WHERE pid=<<Process pid>>

Part-1  Start an explicit transaction and check the wait_event_type
------
Launch 2nd psql session
1. Get the PID
psql#1=> select pg_backend_pid();

2. Start a transaction in session#1
psql#1=> BEGIN;

3. In session#2 check the wait event for session#1
psql#2=> SELECT * FROM pg_stat_activity WHERE pid=<<Process pid session#1>>

4. End the transaction in session#1
psql#2=> COMMIT;

Part-2  Lock a table and check out the state
------
Launch a 3rd psql session

1. In session#2 start a transaction
psql#2=> BEGIN;
psql#2=> LOCK TABLE test;

2. In session#1 start a transaction
psql#1=> BEGIN;
psql#1=> LOCK TABLE test;

3. In session#3 check the wait event for session#1
psql#3=> \x
psql#3=> SELECT * FROM pg_stat_activity WHERE pid=<<Process pid session#1>>

Part-3 Check out different locks on DB server
------

1. Create a test database & setup pgbench db tables
$ psql -c "CREATE DATABASE testactivity"
$ pgbench -i -s 100 testactivity

2.Run pgbench load
$ pgbench   -c 50  -T 300 -P 3 teststatements

3. Check out locks and wait states
In a 2nd SSH session start psql

psql#2=> SELECT   wait_event_type, state, count(*) 
       FROM     pg_stat_activity 
       GROUP BY wait_event_type, state;

===============================================================================
pg_locks
===============================================================================
SELECT pid, locktype, relation, mode, granted 
FROM pg_locks 
WHERE (relation = (select relid from pg_stat_user_tables where relname = 'test') OR relation is null);

SELECT locktype,count(*)  FROM pg_locks GROUP BY locktype;

SELECT * FROM pg_locks WHERE locktype='tuple';

===============================================================================
Using the stats queries
===============================================================================
** Find commmonly accessed tables and their use of indexes:

SELECT relname,seq_tup_read,idx_tup_fetch,cast(idx_tup_fetch AS numeric) / (idx_tup_fetch + seq_tup_read) AS idx_tup_pct FROM pg_stat_user_tables WHERE (idx_tup_fetch + seq_tup_read)>0 ORDER BY idx_tup_pct;

Returns output like:

       relname        | seq_tup_read | idx_tup_fetch |      idx_tup_pct       
----------------------+--------------+---------------+------------------------
 schema_migrations    |          817 |             0 | 0.00000000000000000000
 user_device_photos   |          349 |             0 | 0.00000000000000000000
 albums               |       530701 |           379 | 0.00071364012954733750
 facebook_oauths      |        15250 |            36 | 0.00235509616642679576
 
 
Analysis: For each row, because "idx_tup_pct" is low than it means that essentially no indexes are being used. In the case of "facebook_oauths"
 it turns out we are commonly running a query like "SELECT * FROM facebook_oauths WHERE fb_user_id = X" and it turns out there isnt an index on "fb_user_id"
 

** Find the INSERT/UPDATE/DELETE statistics for tables:

SELECT relname,cast(n_tup_ins AS numeric) / (n_tup_ins + n_tup_upd + n_tup_del) AS ins_pct,cast(n_tup_upd AS numeric) / (n_tup_ins + n_tup_upd + n_tup_del) AS upd_pct, cast(n_tup_del AS numeric) / (n_tup_ins
+ n_tup_upd + n_tup_del) AS del_pct 
FROM pg_stat_user_tables 
WHERE (n_tup_ins + n_tup_upd + n_tup_del) > 0
ORDER BY relname;


================================================================================

** Table I/O

SELECT relname,cast(heap_blks_hit as numeric) / (heap_blks_hit + heap_blks_read) AS hit_pct,
heap_blks_hit,heap_blks_read 
FROM pg_statio_user_tables WHERE (heap_blks_hit + heap_blks_read)>0 ORDER BY hit_pct;

'heap_blks_hit' = the number of blocks that were satisfied from the page cache
'heap_blks_read' = the number of blocks that had to hit disk/IO layer for reads

When 'heap_blks_hit' is significantly greater than 'heap_blks_read' than it means we have a well-cached DB and most of the queries can be satisfied from the cache

================================================================================

** Table & Index sizes

SELECT
    t.tablename,
    indexname,
    c.reltuples::integer AS num_rows,
    pg_size_pretty(pg_relation_size(quote_ident(t.tablename)::text)) AS table_size,
    pg_size_pretty(pg_relation_size(quote_ident(indexrelname)::text)) AS index_size,
    CASE WHEN x.is_unique = 1  THEN 'Y'
       ELSE 'N'
    END AS UNIQUE,
    idx_scan AS number_of_scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM pg_tables t
LEFT OUTER JOIN pg_class c ON t.tablename=c.relname
LEFT OUTER JOIN
       (SELECT indrelid,
           max(CAST(indisunique AS integer)) AS is_unique
       FROM pg_index
       GROUP BY indrelid) x
       ON c.oid = x.indrelid
LEFT OUTER JOIN
    ( SELECT c.relname AS ctablename, ipg.relname AS indexname, x.indnatts AS number_of_columns, idx_scan, idx_tup_read, idx_tup_fetch,indexrelname FROM pg_index x
           JOIN pg_class c ON c.oid = x.indrelid
           JOIN pg_class ipg ON ipg.oid = x.indexrelid
           JOIN pg_stat_all_indexes psai ON x.indexrelid = psai.indexrelid )
    AS foo
    ON t.tablename = foo.ctablename
WHERE t.schemaname='public'
ORDER BY pg_relation_size(quote_ident(indexrelname)::text) desc;


================================================================================

** Index Health

SELECT indexrelname,cast(idx_tup_read AS numeric) / idx_scan AS avg_tuples,idx_scan,idx_tup_read FROM pg_stat_user_indexes WHERE idx_scan > 0;

** Index Size

SELECT
  schemaname,
  relname,
  indexrelname,
  idx_scan,
 pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size
FROM
  pg_stat_user_indexes i
  JOIN pg_index USING (indexrelid)
WHERE
  indisunique IS false
ORDER BY idx_scan,relname;


** Index I/O - Same idea as Table I/O above

SELECT indexrelname,cast(idx_blks_hit as numeric) / (idx_blks_hit + idx_blks_read) AS hit_pct,
idx_blks_hit,idx_blks_read FROM pg_statio_user_indexes WHERE 
(idx_blks_hit + idx_blks_read)>0 ORDER BY hit_pct;


** Show sizes & usage of indexes that are not used very often:
NOTE: we define 'usage' by # of times used, in this case we use '200' - change accordingly

SELECT idstat.relname AS table_name, indexrelname AS index_name, idstat.idx_scan AS times_used,
pg_size_pretty(pg_relation_size(tabstat.relid)) AS table_size, pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
n_tup_upd + n_tup_ins + n_tup_del as num_writes, indexdef AS definition
FROM pg_stat_user_indexes AS idstat JOIN pg_indexes ON indexrelname = indexname
JOIN pg_stat_user_tables AS tabstat ON idstat.relname = tabstat.relname
WHERE idstat.idx_scan < 200 AND indexdef !~* 'unique'
ORDER BY idstat.relname, indexrelname;


===================
Cheatsheet for psql
https://karloespiritu.github.io/cheatsheets/postgresql/
===================