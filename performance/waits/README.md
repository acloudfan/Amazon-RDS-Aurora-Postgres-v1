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



