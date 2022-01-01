
\set test_value  random(1,1000)

BEGIN;
    INSERT INTO test VALUES(:test_value);
END;