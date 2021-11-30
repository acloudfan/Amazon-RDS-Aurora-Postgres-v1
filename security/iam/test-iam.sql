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
