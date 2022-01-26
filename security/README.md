# Security related tasks


==================================
Client - Validate RDS Certificate
==================================
Check out the instructions in tls/README.md

==============
Enforce SSL
==============

1. By default psql uses SSL/TLS
-------------------------------
$ psql

2. Disable the SSL mode for PG and try again
---------------------------------------------
export PGSSLMODE=disable
$ psql

* No issues with the connection

3. Create a 'DB Cluster Parameter' Group
----------------------------------------
* Use the console to create the parameter group
* Name = ssl-force-test-group
* Type = DB Cluster Parameter Group; select the righ Aurora PG version
* Edit the parameter rds.force_ssl=1

4. Modify test cluster to use the new PG
----------------------------------------
Modify the cluster to use the cluster PG - ssl-test-cluster-pg

5. Disable the SSL mode for PG and try again
export PGSSLMODE=disable
$ psql

* This time there will be an error

6. Enable SSL Mode and try again
---------------------------------
$ unset   PGSSLMODE
$ psql

7. Cleanup
----------
* Modify the instance to use the default Cluster Parameter Group
* Delete the Cluster parameter group created in this exercise

============================
Roles, Users, Grant & Revoke
============================

psql 
----
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


Create role as group
--------------------
* Create a role that will be used as a group for roles & users of labdb 
CREATE ROLE labdb_access;


