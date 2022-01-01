=======================
Check out documentation
=======================
https://www.postgresql.org/docs/current/pgbench.html

==============
Run custom SQL
==============

1. Run a test against the labdb database in which we have 1 table
   * Run the test for 30 seconds

pgbench -c 2  -d  -f "./pgbench/custom-select-script.sql"@100 -T 30

2. Get SQL level performance using the -r option

3. Use the script files to run the test script

