# Cluster Maintenance

# Get the major versions available for upgrade
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.PostgreSQL.html

./bin/db/check-upgrade-version.sh  <<current PG version>>

Example: ./bin/db/check-upgrade-version.sh  10.11

=============================
# 1. Try out in place upgrade
=============================

1. Delete the existing Aurora Cluster
-------------------------------------
* Use the CloudFormation console or the utility script
./bin/db/delete-dbcluster-cf-stack.sh

2. Create a cluster with lower version
--------------------------------------
* Use the utility script
./bin/db/create-dbcluster-cf-stack.sh  db.t3.medium  <<PG version>>



3. [Optional] Create the replica
--------------------------------
* Use the same version as the node-01 otherwise creation will fail

./bin/db/create-replica.sh node-02 db.t3.medium  <<PG version>>

4. Check the upgrade target version
-----------------------------------
* Use the utility script
./bin/db/check-upgrade-version.sh  <<PG version of cluster>>

5. Upgrade the cluster
----------------------
https://docs.aws.amazon.com/cli/latest/reference/rds/modify-db-instance.html

* Use CLI to initiate the upgrade
aws rds modify-db-instnace --db-instance-identifier rdsa-postgresql-node-01  \
                            --engine-version   <<PG version>>
                            --apply-immediately

6. After upgrade
----------------
* No change in endpoint - you should be able to connect using psql
* Check the events log for the cluster and you will see the actions taken by Aurora




3. Reset the environment on bastion host
----------------------------------------
* SSH into bastion host
* Use the script
./bin/set-env.sh  <<Your AWS Region>>

* Log out and log back in

======================
# 2. Snapshot approach
======================

Please refer to the lessons in the section:
Backup and Restore.

Refer: backup/README.md

=========================================
# 4. Logical Replication - native pub/sub
=========================================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Replication.Logical.html
https://www.postgresql.org/docs/current/logical-replication.html

Part-1 Setup cluster parameter group
====================================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Replication.Logical.html

1. Setup a parameter custom group for [publisher]
-------------------------------------------------
* Publisher cluster requires certain params to be set
* Create using console or CLI
* Creation of DB group requires group-family e.g., aurora-postgresql12

* Log on to bastion host and setup the env variable
PG_ENGINE=aurora-postgresql<<REPLACE This with major version of existing cluster>>

* Run the command to create cluster parameter group
aws rds create-db-cluster-parameter-group  \
    --db-cluster-parameter-group-name rdsa-cluster-pg-publisher  \
    --db-parameter-group-family     "$PG_ENGINE"  \
    --description                   "This is for testing pglogical"

2. Set the publisher parameters
-------------------------------
* Parameters to be set
    - rds.logical_replication=1
    - max_worker_processes=10
    - max_wal_senders=15
    - max_replication_slots=5

aws rds modify-db-cluster-parameter-group \
    --db-cluster-parameter-group-name rdsa-cluster-pg-publisher \
    --parameters "ParameterName=rds.logical_replication,ParameterValue=1,ApplyMethod=pending-reboot" \
    "ParameterName=max_worker_processes,ParameterValue=10,ApplyMethod=pending-reboot" \
    "ParameterName=max_wal_senders,ParameterValue=15,ApplyMethod=pending-reboot" \
    "ParameterName=max_replication_slots,ParameterValue=5,ApplyMethod=pending-reboot" 

* Validate the parameters setup in console or CLI

3. Modify the existing cluster & reboot
---------------------------------------
* Update the cluster instances to use the cluster DB Parameter group

aws rds modify-db-cluster \
--db-cluster-identifier rdsa-postgresql-cluster \
--db-cluster-parameter-group-name rdsa-cluster-pg-publisher \
--no-apply-immediately

* Reboot the cluster
aws rds reboot-db-instance --db-instance-identifier  rdsa-postgresql-node-01

* After reboot
psql
=>  SELECT name, setting 
    FROM pg_settings 
	WHERE name in 
	('max_wal_senders', 'max_worker_processes', 'wal_level', 	 
        'max_replication_slots');

Part-2 Setup publisher
======================

1. Setup a test database
------------------------
* This is the database that will be replicated

psql  -c 'CREATE DATABASE to_replicate;'
psql -d to_replicate -c 'CREATE TABLE test(id int PRIMARY KEY);'


2. Setup publication on the publisher cluster
---------------------------------------------
https://www.postgresql.org/docs/current/sql-createpublication.html

* CREATE PUBLICATION adds a new publication into the current database
* Log on to bastion & run the commands

psql -d to_replicate -c  "CREATE PUBLICATION testpub FOR ALL TABLES;"

* Confirm the setup
psql -d to_replicate -c  "SELECT * FROM pg_catalog.pg_publication;"
psql -d to_replicate -c  "SELECT * FROM pg_catalog.pg_publication_tables;"



Part-3 Setup subscriber
=======================

1. Setup a new cluster
----------------------
* Use the console or CLI to create the cluster with latest version
* Use the existing VPC/Subnet Group/

    - Edition = Aurora PostgreSQL
    - Version = Select latest major version
    - Template = Dev/Test
    - Database cluster identifier = rdsa-postgresql-cluster-latest
    - User/password = masteruser/masteruserpw
    - Instance class= Burstable / db.t3.medium
    - VPC = rdsa-vpc
    - Security Group = rdsa-security-group-internal

2. Setup Bastion host environment for new cluster
-------------------------------------------------
* Setup the cluster endpoint env var
* If this step skipped [psql: error: could not translate host name "-d" to address: Name or service not known]

export PGWRITEREP_LATEST=$(aws rds describe-db-clusters --db-cluster-id rdsa-postgresql-cluster-latest --query 'DBClusters[0].Endpoint' --output text)
echo $PGWRITEREP_LATEST

* Setup the database and tables
psql  -h $PGWRITEREP_LATEST -d postgres -c 'CREATE DATABASE to_replicate;'
psql  -h $PGWRITEREP_LATEST -d to_replicate -c 'CREATE TABLE test(id int PRIMARY KEY);'



3. Setup the subscription on new cluster
----------------------------------------
https://www.postgresql.org/docs/current/sql-createsubscription.html

* Start a psql session
psql -h  $PGWRITEREP_LATEST -d to_replicate

* This command in psql will provide the endpoint for publisher
\! echo $PGWRITEREP

* Copy paste the endpoint to host below

CREATE SUBSCRIPTION to_replicate_sub CONNECTION 
   'host=<<Copy paste the publisher Endpoint >>  

    port=5432 dbname=to_replicate user=masteruser password=masteruserpw' 

   PUBLICATION testpub; 

4. Check the status
-------------------

-- Check the status of replication 
psql -h  $PGWRITEREP_LATEST -d to_replicate -c 'SELECT * FROM  pg_stat_subscription;'

-- Check the counts in tables
psql -h  $PGWRITEREP_LATEST -d to_replicate -c 'SELECT count(*) FROM test;'


Part-4 Test Replication
-----------------------

1. Insert rows on publisher & check on subscriber
-------------------------------------------------
* On the original cluster, insert some data

psql -d to_replicate -c 'INSERT INTO test VALUES(generate_series(1,10));'

psql -h $PGWRITEREP_LATEST -d to_replicate -c 'SELECT count(*) FROM test;'

* On the original cluster, delete some data

psql -d to_replicate -c 'DELETE FROM test WHERE id > 5;'

psql -h $PGWRITEREP_LATEST -d to_replicate -c 'SELECT * FROM test;'


Cleanup
=======



Check on publisher
==================
Check replication slot on publisher
psql  -d to_replicate -c 'SELECT * FROM pg_replication_slots;'

Delete replication slot on publisher
psql  -d to_replicate -c 'SELECT pg_drop_replication_slot(<<Slot name>>)';


=================
# 3. DMS approach
=================

Please refer to the lessons in the section:
Database Migration Service

Refer: migration/dms/README.md
