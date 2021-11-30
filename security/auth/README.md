=========================
psql for Roles management
=========================
\du                                   List roles
\drds                                 List per database role setting
\l+                                   Check access priveleges

* Provides name of the current user
SELECT current_user, session_user 

* Switch role
SET ROLE <<some-existing-role>>    

* Checkout role details 
SELECT * FROM pg_roles where rolname=<<<role name>>;   

* Access granted on tables
SELECT * FROM information_schema.role_table_grants ;  

* Prints the grants on per table basis
SELECT grantee AS user, CONCAT(table_schema, '.', table_name) AS table, 
    CASE 
        WHEN COUNT(privilege_type) = 7 THEN 'ALL'
        ELSE ARRAY_TO_STRING(ARRAY_AGG(privilege_type), ', ')
    END AS grants
FROM information_schema.role_table_grants
GROUP BY table_name, table_schema, grantee;

===================
Try out group roles
===================
* Use the commands/statements in file test-roles.sql to learn commands for managing roles