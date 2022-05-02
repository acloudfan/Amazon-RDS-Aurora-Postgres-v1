======================================================
As of March 2021, 
Amazon Aurora Serverless v2 is still in preview
NOTE: Lessons will be updated within a few weeks of GA
======================================================




===========================
Create a serverless cluster
===========================
* Use console or CLI

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
* For 1st Reader set 
    - name = rdsa-postgresql-serverless-instance-2 
    - failover priority = 1
* For 2nd Reader set 
    - name = rdsa-postgresql-serverless-instance-3 
    - failover priority = 5


Part-3: Test using psql & pgbench
==================================

1. Setup host variables
=======================
* Create a Bastion host session & copy paste the instructions below
* You will need to do it in new session 

# Setup the endpoint information in environment variables
PGWRITEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `rdsa-postgresql-serverless`].Endpoint')
PGHOST=$PGWRITEREP

PGREADEREP=

2. Use psql to connect (optional)
=================================

3. Test-1: Run write load & observe capacity usage for the 3 nodes
==================================================================

pgbench -i --fillfactor=100 --scale=1000

4. Test-2: Run READ load & observe capacity usage for the 3 nodes
==================================================================

pgbench --progress-timestamp -M prepared -n -T 240 -P 5 -c 50 -j 50  -b select-only



