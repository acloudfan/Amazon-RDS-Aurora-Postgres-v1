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



=====================
Cross Account Cloning
=====================
https://aws.amazon.com/about-aws/whats-new/2019/07/amazon_aurora_supportscloningacrossawsaccounts-/

https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Clone.html#Aurora.Managing.Clone.Cross-Account


Cloning limitation
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Clone.html#Aurora.Managing.Clone.Limitations

1. Create a CMK
* Add the other account's root as the user

2. Setup the VPC
* CF for VPC
* Setup the subnet group

3. Create the DB Cluster

4. Go to RAM and setup a share with the specified account
* Sharing can also be initiated from the RDS console

5. Other account receives the invite and it needs to be accepted

6. In the account#2 the shared DB will appear in the list of database
Role = "Shared from account #111111111111"
* Select it and create a clone
* Creates an instance
* Setup the encryption 
    - new CMK
    - Default RDS key
    - Use the CMK shared by Account#1


https://medium.com/@pratheekhegde/lamda-function-for-automated-manual-rds-snapshots-d84e1d002019