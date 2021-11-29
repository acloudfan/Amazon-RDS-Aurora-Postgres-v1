-- Contains SQL for setting up a test environment

DROP DATABASE IF EXISTS authtest ;

-- 1. Create a test database
CREATE DATABASE authtest;

-- 2. Connect to the database
\c authtest

-- 3. Create schema 1
CREATE SCHEMA schema_1;
CREATE TABLE schema_1.test (id int);

-- 4. Create schema 2
CREATE SCHEMA schema_2;
CREATE TABLE schema_2.test (id int);

-- 5. Create a role as a group; grant permissions
--    https://www.postgresql.org/docs/current/sql-grant.html
DROP ROLE group_role_1;

CREATE ROLE group_role_1;
GRANT CONNECT ON DATABASE authtest TO group_role_1;
GRANT USAGE ON SCHEMA schema_1 TO group_role_1;
GRANT SELECT ON ALL TABLES IN SCHEMA schema_1 TO group_role_1;

-- 6. create a user and add to group
DROP USER user_role_1;
CREATE USER user_role_1 WITH LOGIN PASSWORD 'password' ;
GRANT group_role_1 TO  user_role_1;
\du user_role_1;

-- You may start a psql session with the new user, using the command:
-- PGPASSWORD=password psql -U user_role_1 -d authtest

-- 7. Try inserting a role in schema_1.test; it will error out
SET ROLE user_role_1;
INSERT INTO schema_1.test VALUES(1);

-- 8. Grant the role group_role_1 - CREATE on schema_1
SET role masteruser;
GRANT USAGE, CREATE ON SCHEMA schema_1 TO group_role_1;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA schema_1 TO group_role_1;

-- 9. Try inserting a role as user_role_1
SET ROLE user_role_1;
INSERT INTO schema_1.test VALUES(2);
SELECT * FROM schema_1.test;
DELETE  FROM schema_1.test;

-- 10. Revoke the connect
REVOKE CONNECT ON DATABASE authtest FROM group_role_1;
-- PGPASSWORD=password psql -U user_role_1 -d authtest
