==================================================================================
As of April 2022 - Serverless V2 is GA
NOTE: Lessons in course will be updated and made available by 3rd week of May 2022
==================================================================================


===========================
Create a serverless cluster
===========================
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