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

Settings:
    - DB Cluster Identifier = rdsa-postgresql-serverless
    - User = masteruser
    - Password = masteruserpw

Instance configuration:
    - DB Instance Class = Serverless

Capacity settings:
    - Minimum = 0.5 ACU
    - Maximum = 1 ACU

Availability & Durability:
    - Don't create an Aurora replica

Connectivity:
    - VPC = rdsa-vpc
    - Subnet group = rdsa-postgresql-db-subnet-group
    - VPC SG = rdsa-security-group-internal

    Additional configuration:
        - Data API = Check it off

Additional configuration:
    - Initial DB = pgbench
    - Deletion protection = Uncheck

Part-2 : Add 2 Readers
======================


Part-3: (Optional) Test using psql
==================================

1. Use Bastion host & psql
--------------------------
* Create a Bastion host session

# Setup the endpoint information in environment variables
PGWRITEREP=$(aws rds describe-db-clusters --output text \
                        --query 'DBClusters[?DBClusterIdentifier == `rdsa-postgresql-serverless`].Endpoint')
PGHOST=$PGWRITEREP

# Start psql - interactions will be same as provisioned cluster
\dn