# Global Database


1. Select a secondary region

2. Create the VPC in the secondary region using CloudFormation
Template: vpc/cluster-vpc-2-az.yml
Stack name: rdsa-vpc

3. Create the Bastion host in the secondary region using CloudFormation
Template: vpc/bastion-host.yml
Stack name: rdsa-bastion-host
PublicSubnetIds: <<Select 1 of the public subnets in rdsa vpc>>
VpcId: <<Select the rdsa vpc>>
Acknowledge the stack creation

* EC2/Bastion host info is available under the CloudFormation stack/resources

4. Log on to the Bastion host & setup scripts & project repo

* Download the setup script

curl https://raw.githubusercontent.com/acloudfan/Amazon-RDS-Aurora-Postgres-v1/master/bin/install/setup-bastion.sh --output setup-bastion-host.sh 

* Change mod of the file
chmod u+x ./setup-bastion-host.sh 

* Setup the environment
./setup-bastion-host.sh <<Provide AWS Region>>  

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
$  ./install/setup-host.sh   <<Sec region>>

7. 


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
