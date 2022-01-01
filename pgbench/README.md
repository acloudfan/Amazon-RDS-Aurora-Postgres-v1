=======================
Check out documentation
=======================
https://www.postgresql.org/docs/current/pgbench.html


================
Run built in SQL
================

Part-1 Create and Initialize the TPC-B database
-----------------------------------------------

* Create a new database

psql -c "CREATE database pgbenchtest";

* Initialize the database and populate with data

pgbench -i pgbenchtest

* Checkout tables created by pgbench - copy paste the following on command line
psql -d pgbenchtest -c "\dt+;" 
psql -d pgbenchtest -c "SELECT count(*) AS cnt_accounts FROM pgbench_accounts ;" 
psql -d pgbenchtest -c "SELECT count(*) AS cnt_branches FROM pgbench_branches ;" 
psql -d pgbenchtest -c "SELECT count(*) AS cnt_history FROM pgbench_history ;" 
psql -d pgbenchtest -c "SELECT count(*) AS cnt_tellers FROM pgbench_tellers ;" 

* To clean up you may drop and recreate the pgbnechtest database 
psql -c "DROP DATABASE IF EXISTS pgbenchtest;"
psql -c "CREATE database pgbenchtest;"

* Initialize with additional data using the -f and -s options
  - Add 100 times the default data set -s 100
  pgbench -s 100 -i pgbenchtest


Part-2 Run the benchmarking test
--------------------------------
* Option -c used for specifying the number of DB connections
* Option -j used for threads (helpful on m/c with multiple cpu)
* Option -T used for amount of time
* Option -P used for printing status
* Option -b for specifying SQL mix; 
  Built in script names : tpcb-like, simple-update, select-only

pgbench -c 2 -T 15 -P 2 -b tpcb-like pgbenchtest 


==============
Run custom SQL
==============

1. Run a test against the labdb database in which we have 1 table
   * Run the test with 80% SELECTS and 20% INSERTS
   * Run the test for 30 seconds using the -T option
   * Run the test with 2 client connection using the -c option
   * Print the status every 5 seconds using the -P option
   * If -n not specified, you will see errors as pgbench will try to vacuum standard tables

pgbench -c 2 -P 5  -n -f "./pgbench/custom-select-script.sql"@80  -f "./pgbench/custom-insert-script.sql"@20 -T 30  labdb

2. Get SQL level performance using the -r option

3. Add the -d option to checkout the debug messages

4. Run the test against Read Replicas
   * Remember you can't run INSERT/UPDATE/DELETE against the Replica

pgbench -c 2 -P 5  -n -f "./pgbench/custom-select-script.sql"  -T 30 -h $PGREADEREP labdb

