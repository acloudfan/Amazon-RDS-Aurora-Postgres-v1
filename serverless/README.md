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
    - Capacity type = Serverless
    - Version = 10.14

Settings:
    - DB Cluster Identifier = rdsa-postgresql-serverless
    - User = masteruser
    - Password = masteruserpw

Capacity settings:
    - Minimum = 2 ACU
    - Maximum = 8 ACU

Connectivity:
    - VPC = rdsa-vpc
    - Subnet group = rdsa-postgresql-db-subnet-group
    - VPC SG = rdsa-security-group-internal

    Additional configuration:
        - Data API = Check it off

Additional configuration:
    - Initial DB = labdb
    - Deletion protection = Uncheck

Part-2 : Test cluster using Data API & psql
===========================================

1. Use Console Data API
-----------------------
* On left navigation panel in console select 'Query Editor'
* Select the serverless database and try out queries

2. Use Bastion host & psql
--------------------------
* Create a Bastion host session

# Setup the endpoint information in environment variables
PGWRITEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `rdsa-postgresql-serverless`].Endpoint')
PGHOST=$PGWRITEREP

# Start psql - interactions will be same as provisioned cluster
\dn