===============
Utility Scripts
===============

create-custom-db-cluster-pg.sh
------------------------------
Creates the Cluster Parameter group
Gets the Aurora version from the DB cluster to create parameter group-family

Usage:  ./bin/bash/create-custom-db-cluster-pg.sh  <Name>  '<Description>'

delete-custom-db-cluster-pg.sh
------------------------------
Deletes the custom DB cluster parameter group

Usage:  ./bin/bash/delete-custom-db-cluster-pg.sh  <Name>

create-custom-db-pg.sh
----------------------
Creates the Parameter group
Gets the Aurora version from the DB cluster to create parameter group-family

Usage:  ./bin/bash/create-custom-db-pg.sh  <Name>  '<Description>'

delete-custom-db-cluster-pg.sh
------------------------------
Deletes the custom DB  parameter group

Usage:  ./bin/bash/delete-custom-db-pg.sh  <Name>

set-parameter-value
-------------------
Sets a single parameter value in the named Parameter Group
PS: If you want to set multipel parameters use the AWS CLI

./bin/db/set-parameter-value  <PG Name> <Parameter Name> <Parameter Value>


==========================================
Exercise: Setup logging for SQL statements
==========================================

1. Create a custom Parameter Group
----------------------------------
Use AWS CLI or Console or Utility script

Set the parameters appropriately:

aws rds create-db-parameter-group    \
    --db-parameter-group-name       rdsa-test  \
    --db-parameter-group-family     aurora-postgresql13  \
    --description                   "this is for testing sql logging"

2. Modify the Writer instance
-----------------------------
Use AWS CLI or Console

* Select the instance
* Modify the instance to replace the PG 
* Reboot the instance

3. Set the 
