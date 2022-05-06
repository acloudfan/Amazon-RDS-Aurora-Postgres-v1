==================================================================================
As of April 2022 - Serverless V2 is GA
NOTE: Lessons in course will be updated and made available by 3rd week of May 2022
==================================================================================


=========================================
Convert existing cluster to serverless v2
=========================================

Prepare
=======
* Minimum version needed for Serverless v2 is 13.6
* Either upgrade the existing rdsa-postgresql-cluster to v13.6
* OR delete the CloudFormation stack (rdsa-postgreql) and recreate with v13.6

Part-1 Create a Mixed configuration cluster
===========================================

1. Add Serverless v2 instance
-----------------------------
* Select the cluster
* Action > Add reader

2. Setup serverless reader parameters
-------------------------------------
- DB Instance identifier = rdsa-postgresql-serverless-1
- Instance Configuration
    - Select 'Serverless v2'
    - Capacity range Minmum=2, Maximum=8
- Additional Configuration
    - Uncheck 'Enable Performance Insights'
- Click on 'Add Reader'

Part-2 Convert from Mixed to all serverless instances
=====================================================

1. Delete the provisioned instance
----------------------------------
* Select the provisioned instance
* Action > Delete
* Confirm and continue

2. Add another serverless instance
----------------------------------
- DB Instance identifier = rdsa-postgresql-serverless-2
- NOTE: You won't need to specify the capacity

3. Connect from the Bastion host
--------------------------------
- You may connect from the host 
- No change in behavior
- A load run will cause the instances to scale up/down

Cleanup
-------
We will use the cluster with this setup in the next hands on lecture


* Stop the cluster

NOTE: If you plan to take a longer break then

* DELETE all the serverless instances in the cluster
* Delete the CloudFormation stack (rdsa-postgresql)


====================================
Capacity management in Serverless v2
====================================
* You will learn how Aurora manages Serverless V2 instance capacity
* Cluster Capacity Range = 2 to 8 ACU
* Prepare pgbench database
$ psql -c 'CREATE DATABASE pgbench'
$ pgbench -d pgbench -i --fillfactor=100 --scale=500

Part-1 All Serverless V2 instances
==================================
Writer = Serverless V2 instance
Reader-1 = Serverless V2 instance, Failover priority=1
Reader-2 = Serverless V2 instance, Failover priority=5

Observations-1
==============
* For Minimum capacity <= 1 ACU
* With no load all instances running HOT, close to 100% CPU usage

Test-1
------
* Run updates against the Writer
* Observe the Max ServerlessDatabaseCapacity & DBInstance

# Simple update run
# 500 connections, No vacuum, updates for 5 minutes
pgbench -c 500  -T 300 -P 2 -b simple-update  -n pgbench

Test-2
------
* Run selects against the Writer

# All select run 
# 1000 connections, No vacuum, updates for 5 minutes
pgbench -c 1000  -T 300 -P 2 -b select-only  -n pgbench

Part-2 Mixed configuration cluster
==================================
Writer = Provisioned instance
Reader-1 = Serverless V2 instance, Failover priority=1
Reader-2 = Serverless V2 instance, Failover priority=5

======================================
Connection management in Serverless v2
======================================

Error
-----
- In low minimum setup, Once in a while received an error indicating connection starvation

pgbench: error: connection to database "pgbench" failed: FATAL:  remaining connection slots are reserved for non-replication superuser connections




=====================================
Replication behavior in Serverless v2
=====================================


====================================
Failure recovery - CCM not available
====================================


=======================================
Create a serverless cluster (Ground up)
=======================================
* Use console or CLI
* Dependency on elements of the CloudFormation stacks
    - VPC
    - Bastion Host
    - Security Group
    - PostgreSQL stack
        * Delete the Database as we won't use it
        * We will use the subnet group

Part-1 : Use console to create cluster
======================================

Engine:
    - Engine = Amazon Aurora
    - Edition = PostgreSQL-compatible
    - Click 'Show Filters
        - Select 'Show versions that support Serverless v2'
    - Version = 13.6

Templates:
    - Select Dev/Test

Settings:
    - DB Cluster Identifier = rdsa-postgresql-serverless
    - User = masteruser
    - Password = masteruserpw

Instance configuration:
    - DB Instance Class = Serverless

Capacity settings:
    - Minimum = 2 ACU
    - Maximum = 8 ACU

Availability & Durability:
    - Don't create an Aurora replica

Connectivity:
    - VPC = rdsa-vpc
    - Subnet group = rdsa-postgresql-db-subnet-group
    - Public access = No
    - VPC SG = rdsa-security-group-internal

Additional configuration:
    - Initial DB = pgbench
    - Deletion protection = Uncheck

Part-2 : Add 2 Readers
======================

1. Instance#2 Creation
----------------------
* For 1st Reader set 
    - identifier = rdsa-postgresql-serverless-instance-2 
    - instance configuration = serverless v2
    - failover priority = 1
    - Uncheck Performance Insights

2. Instance#3 Creation
----------------------
* For 2nd Reader set 
    - identifier = rdsa-postgresql-serverless-instance-3 
    - instance configuration = serverless v2
    - failover priority = 5
    - Uncheck Performance Insights

<<Wait for the instance creation to complete>>

3. Set the failover priorities
------------------------------
* Instance#2 has a default failover priority = 1
* Instance#3 priority to be changed to 5

- Select the Instance#3 and click on <Modify>
- Scroll down to 'Additional configuration' section
    - Failover priority = tier-5
- Click on 'Continue'
- Select 'Apply Immediately'
- Click on "Modify.." button

<<Wait for the instance modification to complete>>

Part-3: Test using psql & pgbench
==================================

1. Setup host variables
-----------------------
* Create a Bastion host session & copy paste the instructions below
* You will need to do it in new session 

# Setup the endpoint information in environment variables
PGWRITEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `rdsa-postgresql-serverless`].Endpoint')
PGHOST=$PGWRITEREP

PGREADEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `rdsa-postgresql-serverless`].ReaderEndpoint')

2. Use psql to connect (optional)
---------------------------------

psql -d pgbench

3. Open CloudWatch
------------------
* Click on 'All metrics' in left nav panel
* In Browse - Click on 'RDS'
* In search box type ServerlessDatabaseCapacity
* Click on 'RDS>Per-Database Metrics' & select the 3 instances in the cluster
    - You should see the capacity usage graph for the 3 instances

<<Wait for the capacity for the 3 instances to be stabilized at 2 ACU>>

4. Test-1: Run write load & observe capacity usage for the 3 nodes
------------------------------------------------------------------

pgbench -d pgbench -i --fillfactor=100 --scale=500

5. Test-2: Run READ load & observe capacity usage for the 3 nodes
-----------------------------------------------------------------

pgbench -d pgbench  --progress-timestamp -M prepared -n -T 240 -P 5 -c 50 -j 50  -b select-only

Cleanup
=======
* Delete ALL the Serverless instances
* Delete the PostgreSQL stack



====================================
Create a Mixed Configuration Cluster
====================================


Cleanup
=======
* Stop the Bastion Host (or delete)
* Delete the VPC stack (if you don't need it anymore)










===

# Setup the endpoint information in environment variables
PGWRITEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `mixed-serverless`].Endpoint')
PGHOST=$PGWRITEREP

PGREADEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `mixed-serverless`].ReaderEndpoint')