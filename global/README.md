# Global Database

=============================================================================================
Validate instance size in primary region
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-getting-started.html#aurora-global-database.configuration.requirements
=============================================================================================

* Global database instance MUST be of memory optimized class
* Min size = db.r5.large

1. Update the instance class for primary
----------------------------------------

* Log on to the bastion host 
* Modify the instance node-01 to use db.r5.large
* PS: If you have replicas then all instances must be updated

$  /bin/db/modify-db-cluster-instance.sh rdsa-postgresql-node-02 db.r5.large

2. Ensure RDS Aurora PostgreSQL is available in secondary region

============================
Prepare the secondary region
============================

1. In AWS management console, select a secondary region
-------------------------------------------------------

2. Create the VPC in the secondary region using CloudFormation
--------------------------------------------------------------
* Open up the CloudFormation consol
* 
Template: vpc/cluster-vpc-2-az.yml
Stack name: rdsa-vpc

3. Create the Bastion host in the secondary region using CloudFormation
-----------------------------------------------------------------------
Template: vpc/bastion-host.yml
Stack name: rdsa-bastion-host
PublicSubnetIds: <<Select 1 of the public subnets in rdsa vpc>>
VpcId: <<Select the rdsa vpc>>
Acknowledge the stack creation

4. Log on to the Bastion host & create the subnet group
-------------------------------------------------------
* EC2/Bastion host info is available under the CloudFormation stack/resources
* Get the subnet group list from the console or CLI
  CloudFormation stack >> rdsa-vpc >> Outputs >> PrivateSubnets

* Use the command below for getting the list
aws cloudformation describe-stacks --stack-name rdsa-vpc --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnets`].OutputValue | [0]' --output text

* Create the subnet group
aws rds create-db-subnet-group  \
    --db-subnet-group-name  rdsa-postgresql-db-subnet-group  \
    --db-subnet-group-description 'This is for setting up a test group'   \
    --subnet-ids  '["Private subnet-id-1","Private subnet-id-2"]'


=========================
Create the global cluster
=========================

1. Switch to PRIMARY region and open RDS console
------------------------------------------------

2. Create global DB
-------------------
* Select the existing cluster 
* Actions >> Add Region

Name=rdsa-postgresql-global
Region=<<Select the secondary region>>
DB Instance class=<<Select the instance e.g., db.r5.large>>
Availability & Durability=Don't create Replica

VPC=<<Select RDSA VPC>>
Subnet group=<<Select the subnet group created earlier>>
Public access=No

Security group=<<Select the rdsa-security-group-internal>>

Additional Config - Performance insights = Uncheck
Additional Config - Enhanced monitoring = Uncheck

3. Wait for the cluster in secondary region to be created
---------------------------------------------------------
* DO NOT proceed to next step till cluster is ready

===================
Test global cluster
===================

Why we can't use Bastion host in PRIMARY region?
------------------------------------------------
1. We will need connectivity between the Primary & Secondary VPC
2. Secondary cluster rdsa-Gsecurity-group-internal will need to allow host to connect

1. Logon to the bastion host in SECONDARY region
------------------------------------------------


2. Setup the bastion host environment
-------------------------------------
* Download the setup script

curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

* Change mod of the file
chmod u+x ./setup-bastion-host.sh 

* Setup the environment
./setup-bastion-host.sh <<Provide AWS SECONDARY Region>>  

NOTE: You will get an error (DBClusterNotFoundFault) : Ignore it as we will take care of it in next step

* Setup environment variables  STOP
$   source   ~/.bashrc

5. Create the Auora PG cluster in secondary region

* Create the security group

$ ./bin/db/create-security-group-internal.sh


Stack name = rdsa-security-group

* Create the DB cluster
$  ./bin/db/create-dbcluster-cf-stack.sh

    NOTE: MUST Wait for the cluster to get created

6. Re-run the setup script
$  ./bin/setup-env.sh   <<Sec region>>

7. Test the environment

=> psql

=======================
Join the global cluster
=======================

1. Open up RDS dashboard in PRIMARY region
------------------------------------------

* Select the cluster
* Actions >> Add AWS Region






========================
Create Global DB Cluster 
========================
Set the Region in console visible

# Create the primary cluster - Region 1 e.g., us-west-1
Use the CloudFormation template : global/primary-cluster.yml
Stack name: primary-rdsa-cluster

# Create the VPC in secondary region - Region 2 e.g., us-west-2
Use the CloudFormation template : vpc/secondary-vpc-sg.yml
Stack name: secondary-rdsa-postgres-cluster

# Go to the us-west-2 
Use console to add it as the region to Global database
Global cluster ID  : global-rdsa
Select the VPC: rdsa-vpc
Select the SG: rdsa-sg
Select the instance: db.t3.medium

Global cluster becomes available in all region in the console.

# Create the bastion hosts in the VPC
Use the CloudFormation template in both region
Template : vpc/bastion-host.yml
Stack name: rdsa-host

# Setup environment and tools on Bastion host
curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion.sh 

chmod u+x ./setup-bastion.sh 

./setup-bastion.sh us-west-1   global-rdsa-cluster-cluster-1

source ~/.bashrc

# To write against Primary
psql  -h $PGWRITEREP
CREATE TABLE global(id integer);

# To read from Secondary
psql -h $PGREADEREP

Checkout the lag
================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-monitoring.html

Describe Log Sequence Number or LSN

replication_lag_in_msec  vs    rpo_lag_in_msec


# Use psql on Primary

- Checkout lag
select * from aurora_global_db_status();

- Checkout instance status
select * from aurora_global_db_instance_status();


Planned | Managed Failover
==========================
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-disaster-recovery.managed-failover

1. Connect to the primary region (Region-1)
* execute the SQL Insert against primary cluster = SUCCESS

2. Carry out the controlled failover
* Checkout the console on which region is primary

3. In the previous Bastion | psql session  (Region-1)
* The session will break so launch psql
* execute the SQL Insert against primary cluster = FAILURE

4. Start the Bastion host in Region-2
* execute the SQL Insert against primary cluster = SUCCESS

Headless secondary cluster
==========================
# Writer instance in the primary cannot be deleted

# Delete the instance 
* Possible to delete from the console
* Delete the CloudFormation stack used to create the instance

Remove cluster
==============
* When DB cluster is removed from the Global DB it is promoted to a standalone cluster
    - A Reader takes over as a Writer

* Simply remove the cluster

Managed RPO
===========
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-set-rpo

SELECT * FROM aurora_global_db_status();

select * from aurora_global_db_instance_status();
