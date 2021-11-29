==============
psql for Roles
==============
\du                                   List roles
\drds                                 List per database role setting
\l+                                   Check access priveleges
SELECT current_user, session_user     Provides name of the current user
SET ROLE <<some-existing-role>>       Switch role 
SELECT * FROM pg_roles where rolname='user_role_1';   Checkout role details 
SELECT * FROM information_schema.role_table_grants ;  Access granted

* Prints the grants on per table basis
SELECT grantee AS user, CONCAT(table_schema, '.', table_name) AS table, 
    CASE 
        WHEN COUNT(privilege_type) = 7 THEN 'ALL'
        ELSE ARRAY_TO_STRING(ARRAY_AGG(privilege_type), ', ')
    END AS grants
FROM information_schema.role_table_grants
GROUP BY table_name, table_schema, grantee;