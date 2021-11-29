-- Contains SQL for setting up a test environment

-- 1. Create a test database
DROP DATABASE IF EXISTS authtest ;
CREATE DATABASE authtest;

-- 2. Connect to the database
\c authtest

-- 3. Create schema 1
CREATE SCHEMA schema_1;
CREATE TABLE schema_1.test (id int);

-- 4. Create a role as a group; grant permissions
--    https://www.postgresql.org/docs/current/sql-grant.html
DROP ROLE group_role_1;
CREATE ROLE group_role_1;

GRANT CONNECT ON DATABASE authtest TO group_role_1;
GRANT USAGE ON SCHEMA schema_1 TO group_role_1;
GRANT SELECT ON ALL TABLES IN SCHEMA schema_1 TO group_role_1;

-- 5. create a user and add to group i.e., setup as member
--    Recall USER is an alias of ROLE
DROP USER user_role_1;
CREATE ROLE user_role_1 WITH LOGIN PASSWORD 'password' ;
GRANT group_role_1 TO  user_role_1;

\du user_role_1;

-- You may start a psql session with the new user, using the command:
-- PGPASSWORD=password psql -U user_role_1 -d authtest

-- 6. Try inserting a role in schema_1.test; it will error out
SET ROLE user_role_1;
SELECT current_user, session_user ;
INSERT INTO schema_1.test VALUES(1);

-- 7. Grant the role group_role_1 - CREATE on schema_1
SET role masteruser;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA schema_1 TO group_role_1;

-- 9. Try inserting as user_role_1
SET ROLE user_role_1;
INSERT INTO schema_1.test VALUES(2);
SELECT * FROM schema_1.test;

DELETE  FROM schema_1.test;

-- 10. Revoke the connect
-- REVOKE CONNECT ON DATABASE authtest FROM group_role_1;
-- PGPASSWORD=password psql -U user_role_1 -d authtest


-- Cleanup
SET ROLE masteruser;
DROP ROLE group_role_1;
DROP ROLE user_role_1;
DROP SCHEMA schema_1 CASCADE;
\c labdb
DROP DATABASE authtest;