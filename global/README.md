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

$  ./bin/db/modify-db-cluster-instance.sh rdsa-postgresql-node-01 db.r5.large

* You may check  the status of the instance
$  aws rds describe-db-instances  --db-instance-identifier  rdsa-postgresql-node-01 --query 'DBInstances[0].DBInstanceStatus'

2. Ensure RDS Aurora PostgreSQL is available in secondary region

$ ./bin/db/dbcluster.sh

============================
Prepare the SECONDARY region
============================

1. In AWS management console, select a secondary region
-------------------------------------------------------

2. Create the VPC in the secondary region using CloudFormation
--------------------------------------------------------------
* Open up the CloudFormation console
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

4. Log on to the Bastion host & setup env
-----------------------------------------
* EC2/Bastion host info is available under the CloudFormation stack/resources
* Get the subnet group list from the console or CLI
  CloudFormation stack >> rdsa-vpc >> Outputs >> PrivateSubnets

* Session Manager Login
$  sudo su - ec2-user

* Download setup script
curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

* Change mod of the file
$ chmod u+x ./setup-bastion-host.sh 

* Setup the environment
$ ./setup-bastion-host.sh <<Provide AWS  Region>>  

* Log out and log back in

5. Setup the subet group
------------------------
* Use the command below for getting the list
aws cloudformation describe-stacks --stack-name rdsa-vpc --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnets`].OutputValue | [0]' --output text

* Create the subnet group
aws rds create-db-subnet-group  \
    --db-subnet-group-name  rdsa-postgresql-db-subnet-group  \
    --db-subnet-group-description 'This is for setting up a test group'   \
    --subnet-ids  '["Private subnet-id-1","Private subnet-id-2"]'

6. Create the security group
----------------------------
* You may do it using the CloudFormation console
* YML = basic-cluster/postgres-cluster.yml
  Stack name = security-group.yml

* Or on Bastion host use the script:
$ ./bin/db/create-security-group-internal.sh


=========================
Create the global cluster
=========================

1. Switch to PRIMARY region and open RDS console
------------------------------------------------

2. Create global DB
-------------------
* Select the existing cluster 
* Actions >> Add AWS Region

Name=rdsa-postgresql-global
Region=<<Select the secondary region>>
DB Instance class=<<Select the instance e.g., db.r5.large>>

VPC=<<Select RDSA VPC>>
Subnet group=<<Select the subnet group created earlier>>

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
2. Secondary cluster rdsa-security-group-internal will need to allow host to connect

1. Logon to the bastion host in SECONDARY region
------------------------------------------------


2. Setup the bastion host environment
-------------------------------------

* Setup the environment
./bin/install/setup-bastion-host.sh <<Provide AWS SECONDARY Region>>  rdsa-postgresql-global-cluster-1

* Log out and Log back int 
$   source   ~/.bashrc

3. Test the environment
-----------------------

* For SECONDARY cluster Cluster EP is NOT available
  So next command will throw error

$ psql  - $PGWRITEREP

* Use Reader EP to connect

$ psql  -h $PGREADEREP

* Checkout the 'Standby" state
=> SHOW transaction_read_only; -- This is On as the instances are in STANDBY mode

* Run some SQL

=> SELECT * from test;    

* (Optional) Run INSERT SQL against the primary and run SELECT against

===================
Failover & Failback
===================

1. Select the global cluster in RDS console
-------------------------------------------

2. Initiate failover
--------------------

Actions >> Failover over 

* Select the region & continue

=> SHOW transaction_read_only;

* Try psql in SECONDARY
=> INSERT INTO test VALUES(101010); -- This will be successful

3. Failback to primary
----------------------
* Select the global cluster

Actions >> Failover over 


============
Try headless
============

1. Delete the instance in secondary cluster
-------------------------------------------
* Select the instance
* Actions >> Delete

2. [Optional] Create an instance & try SQL
------------------------------------------

=======================================
Promote secondary as standalone cluster
=======================================
* Primary cluster cannot be removed from global DB

1. Promote the secondary
------------------------

* Select the PRIMARY cluster
* Actions >> Remove from Global cluster

2. Checkout the secondary cluster
---------------------------------
* To test create an instance for the cluster
* Test it out

$ psql

=> SHOW  transaction_read_only;

==================================
Remove Primary from global cluster
==================================
* Select the secondary cluster
* Actions >> Remove from Global cluster 


===================
Cleanup - Secondary
===================

1. Delete instance under the secondary cluster
----------------------------------------------
* If you don't have any instance, go to next step
* Select the instance
* Actions >> Delete

2. Delete the secondary cluster
-------------------------------
* Select cluster (headless)
* Actions >> Delete

3. Delete the Subnet group
--------------------------
* You may do it with console or CLI

aws rds delete-db-subnet-group  \
    --db-subnet-group-name  rdsa-postgresql-db-subnet-group

4. Delete the security group
----------------------------
./bin/db/delete-security-group-internal.sh

5. Delete the Bastion host
--------------------------
./bin/host/delete-host-cf-stack.sh

6. Delete the VPC
-----------------
* Open up the CloudFormation console 
* Select the VPC stack >> Delete

=================
Cleanup - Primary
=================

1. Promote cluster in primary
-----------------------------
* Select the secondary cluster
* Actions >> Remove from Global cluster 

2. Scale down the instance
--------------------------
$  ./bin/db/modify-db-cluster-instance.sh rdsa-postgresql-node-01 db.t3.medium

* You may check  the status of the instance

$  aws rds describe-db-instances  --db-instance-identifier  rdsa-postgresql-node-01 --query 'DBInstances[0].DBInstanceStatus'

3. Delete the global cluster
----------------------------
* Select the global db cluster
* Actions >> Delete

4. (optional) Stop the DB Cluster
---------------------------------
$   ./bin/db/dbcluster.sh stop

5. (optional) Stop the bastion host
-----------------------------------
$   ./bin/host/stop-host.sh



=======================
CloudWatch - Monitoring
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-monitoring.html
=======================

1. Open CloudWatch console
--------------------------
Metrics >> Search for "AuroraGlobalDBProgressLag"
Add it to graph for the secondary region

2. Create a batch with large # of txn and commit
------------------------------------------------
* Simulate a batch

BEGIN;
INSERT INTO test SELECT FROM generate_series(1,1000000);
COMMIT;

* Simulate a uniform write load

pgbench -i -s 1000 pgbenchtest

3. Check out the bump in CloudWatch metric after the commit
-----------------------------------------------------------
* The bump is due to amount of data replicated to secondary after the commit

4. Make calls to utility functions during the load run to observe changes
-------------------------------------------------------------------------
* Checkout the cluster status

SELECT *
FROM aurora_global_db_status();

* Checkout the instance status

SELECT server_id, session_id, aws_region, durable_lsn, highest_lsn_rcvd, oldest_read_view_lsn, visibility_lag_in_msec  
FROM aurora_global_db_instance_status();






Managed RPO
===========
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-set-rpo

SELECT * FROM aurora_global_db_status();

select * from aurora_global_db_instance_status();
