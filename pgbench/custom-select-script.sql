# This is a custom script for pgbench
\set test_value  random(1,1000)

BEGIN 
    SELECT COUNT(*) FROM test WHERE id = :test_value
END