=======================
Check out documentation
=======================
https://www.postgresql.org/docs/current/pgbench.html

==============
Run custom SQL
==============

1. Run a test against the labdb database in which we have 1 table
   * Run the test for 30 seconds

pgbench -d "SELECT * FROM test"@80  -d "INSERT INTO test VALUES(100)"@20  -t 30

2. Get SQL level performance using the -r option

3. Use the script files to run the test script

